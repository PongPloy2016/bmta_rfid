package com.example.zebra123

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.util.Log
import com.zebra.rfid.api3.*
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import java.text.SimpleDateFormat
import java.util.*
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors

class ZebraRfid(
    private val context: Context,
    private var sink: EventSink?
) : BroadcastReceiver(), ZebraDevice, RfidEventsListener {

    private val handler: Handler = Handler(Looper.getMainLooper())
    private var reader: RFIDReader? = null
    private var isDWRegistered = false
    private var mode = ZebraDevice.Modes.mixed

    // holds a list of tags read
    private val tags = HashMap<String, TagInfo>()

    // holds a list of epc's to track
    private val tracking = ArrayList<String>()

    @Synchronized
private fun configureReader() {
    if (isReaderConnected) {
        try {
            Log.d(Zebra123Plugin.getTagName(context), "ConfigureReader()")

            setEvents()
            setMode(mode)
            setTriggers(
                START_TRIGGER_TYPE.START_TRIGGER_TYPE_IMMEDIATE,
                STOP_TRIGGER_TYPE.STOP_TRIGGER_TYPE_IMMEDIATE
            )

            reader?.let { safeReader ->
                val powerLevel = safeReader.ReaderCapabilities.transmitPowerLevelValues.size - 1
                setPowerLevel(powerLevel)

                safeReader.Config.setBeeperVolume(BEEPER_VOLUME.HIGH_BEEP)
                setAntennaConfig()
                safeReader.Actions.PreFilters.deleteAll()
            }

        } catch (e: Exception) {
            Log.e(Zebra123Plugin.getTagName(context), "Error configuring reader. Error: ${e.message}")
        }
    }
}
    private fun createProfile() {
        val packageName = Zebra123Plugin.getPackageName(context)
        val profileName = Zebra123Plugin.getProfileName(context)
        val actionName = Zebra123Plugin.getActionName(context)
        Log.i(
            Zebra123Plugin.getTagName(context),
            "Creating Datawedge profile $profileName for package $packageName with Intent action $actionName"
        )

        // Send DataWedge intent with extra to create profile
        ZebraDataWedge.send(context, "com.symbol.datawedge.api.CREATE_PROFILE", profileName)

        // Configure created profile to apply to this app
        val profileConfig = Bundle().apply {
            putString("PROFILE_NAME", profileName)
            putString("PROFILE_ENABLED", "true")
            putString("CONFIG_MODE", "UPDATE")
        }

        // Configure RFID plugin
        val rfidConfig = Bundle().apply {
            putString("PLUGIN_NAME", "RFID")
            putString("RESET_CONFIG", "true")
            putBundle("PARAM_LIST", Bundle().apply {
                putString("rfid_input_enabled", "false")
            })
        }
        profileConfig.putBundle("PLUGIN_CONFIG", rfidConfig)
        ZebraDataWedge.send(context, "com.symbol.datawedge.api.SET_CONFIG", profileConfig)

        // Configure intent output
        val intentConfig = Bundle().apply {
            putString("PLUGIN_NAME", "INTENT")
            putString("RESET_CONFIG", "true")
            putBundle("PARAM_LIST", Bundle().apply {
                putString("intent_output_enabled", "true")
                putString("intent_action", actionName)
                putString("intent_delivery", "2")
            })
        }
        profileConfig.putBundle("PLUGIN_CONFIG", intentConfig)
        ZebraDataWedge.send(context, "com.symbol.datawedge.api.SET_CONFIG", profileConfig)

        // Associate the profile with this app
        val appConfig = Bundle().apply {
            putString("PACKAGE_NAME", packageName)
            putStringArray("ACTIVITY_LIST", arrayOf("*"))
        }
        profileConfig.putParcelableArray("APP_LIST", arrayOf(appConfig))
        ZebraDataWedge.send(context, "com.symbol.datawedge.api.SET_CONFIG", profileConfig)
    }

    private fun setRegulatoryConfig() {
        try {
            reader?.let {
              context?.let {
    Log.e(Zebra123Plugin.getTagName(it), "Setting region")
} ?: Log.e("Zebra123Plugin", "Context is null while setting region")

                val regulatoryConfig = it.Config.regulatoryConfig
                val regionInfo = it.ReaderCapabilities.SupportedRegions.getRegionInfo(1)
                regulatoryConfig.region = regionInfo.regionCode
                regulatoryConfig.setIsHoppingOn(regionInfo.isHoppingConfigurable) 
                regulatoryConfig.setEnabledChannels(regionInfo.supportedChannels)
                it.Config.regulatoryConfig = regulatoryConfig
            }
        } catch (e: Exception) {
            Log.e(Zebra123Plugin.getTagName(context), "Error setting region. Error: ${e.message}")
        }
    }

    private fun setPowerLevel(level: Int) {
        try {
            reader?.let {
                val config = it.Config.Antennas.getAntennaRfConfig(1)
                config.setTransmitPowerIndex(level)
                config.setrfModeTableIndex(0) 
                config.tari = 0
                it.Config.Antennas.setAntennaRfConfig(1, config)
            }
        } catch (e: Exception) {
            Log.e(Zebra123Plugin.getTagName(context), "Error setting power level. Error: ${e.message}")
        }
    }

    private fun setEvents() {
        try {
            reader?.let {
                it.Events.addEventsListener(this)
                it.Events.setHandheldEvent(true)
                it.Events.setTagReadEvent(true)
                it.Events.setAttachTagDataWithReadEvent(true)
                it.Config.setUniqueTagReport(false) 
            }
        } catch (e: Exception) {
            Log.e(Zebra123Plugin.getTagName(context), "Error in setEvents(). Error: ${e.message}")
        }
    }

    private fun setMode(mode: ENUM_TRIGGER_MODE) {
        try {
            reader?.Config?.setTriggerMode(mode, true)
        } catch (e: Exception) {
            Log.e(Zebra123Plugin.getTagName(context), e.message ?: "Unknown error")
        }
    }

    override fun setMode(mode: ZebraDevice.Modes?) {
        mode?.let {
            this.mode = it
            when (it) {
                ZebraDevice.Modes.barcode -> setMode(ENUM_TRIGGER_MODE.BARCODE_MODE)
                ZebraDevice.Modes.rfid -> setMode(ENUM_TRIGGER_MODE.RFID_MODE)
                ZebraDevice.Modes.mixed -> setMode(ENUM_TRIGGER_MODE.BARCODE_MODE)
            }
        }
    }

    private fun setTriggers(start: START_TRIGGER_TYPE, stop: STOP_TRIGGER_TYPE) {
        try {
            reader?.let {
                val triggerInfo = TriggerInfo().apply {
                    StartTrigger.setTriggerType(start)
                    StopTrigger.setTriggerType(stop)
                }
                it.Config.setStartTrigger(triggerInfo.StartTrigger)
                it.Config.setStopTrigger(triggerInfo.StopTrigger)
                it.Config.setBatchMode(BATCH_MODE.ENABLE)  
            }
        } catch (e: Exception) {
            Log.e(Zebra123Plugin.getTagName(context), e.message ?: "Unknown error")
        }
    }

    private fun setAntennaConfig() {
        try {
            reader?.let {
                val singulationControl = it.Config.Antennas.getSingulationControl(1).apply {
                    session = SESSION.SESSION_S0
                    Action.inventoryState = INVENTORY_STATE.INVENTORY_STATE_A
                    Action.slFlag = SL_FLAG.SL_ALL
                }
                it.Config.Antennas.setSingulationControl(1, singulationControl)
            }
        } catch (e: Exception) {
            Log.e(Zebra123Plugin.getTagName(context), e.message ?: "Unknown error")
        }
    }

    @Volatile
    private var connectionTask: AsyncTasks? = null

    init {
        createProfile()
        connectDatawedge()
    }

    override fun connect() {
        try {
            Log.i(Zebra123Plugin.getTagName(context), "Connecting to RFID reader")

            connectionTask?.shutdown()
            connectionTask = null

            connectionTask = object : AsyncTasks() {
                override fun doInBackground() {
                    try {
                        if (reader == null) {
                            val readers = Readers(context, ENUM_TRANSPORT.ALL)
                             if (readers.GetAvailableRFIDReaderList().size > 0) {
                                reader = readers.GetAvailableRFIDReaderList().get(0).rfidReader
                                //setRegulatoryConfig()
                            } else {
                                Log.e(
                                    Zebra123Plugin.getTagName(context),
                                    "No connectable rfid devices found"
                                )
                            }
                        }

                        reader?.connect()
                        configureReader()
                    } catch (e: Exception) {
                        Log.d(Zebra123Plugin.getTagName(context), e.toString())
                    }
                }

                override fun onPostExecute() {
                    val map = HashMap<String, Any>().apply {
                        put("status", ZebraDevice.ZebraConnectionStatus.connected.toString())
                    }
                    sendEvent(ZebraDevice.Events.connectionStatus, map)
                }
            }.apply { execute() }
        } catch (e: Exception) {
            Log.e(
                Zebra123Plugin.getTagName(context),
                "Error connecting to RFID reader. Error is $e"
            )
        }
    }

    private fun connectDatawedge() {
        try {
            if (isDWRegistered) disconnectDatawedge()

            val filter = IntentFilter().apply {
                addAction(Zebra123Plugin.getActionName(context))
                addCategory(Intent.CATEGORY_DEFAULT)
            }
            context.registerReceiver(this, filter)
            isDWRegistered = true
        } catch (e: Exception) {
            isDWRegistered = false
            Log.e(
                Zebra123Plugin.getTagName(context),
                "Error connecting to datawedge. Error is $e"
            )
        }
    }

    private fun disconnectDatawedge() {
        try {
            if (isDWRegistered) {
                context.unregisterReceiver(this)
                isDWRegistered = false
            }
        } catch (e: Exception) {
            isDWRegistered = false
            Log.e(
                Zebra123Plugin.getTagName(context),
                "Error disconnecting datawedge. Error is $e"
            )
        }
    }

    override fun disconnect() {
        try {
            Log.i(Zebra123Plugin.getTagName(context), "Disconnecting from RFID reader")
            reader?.Events?.removeEventsListener(this)

            val map = HashMap<String, Any>().apply {
                put("status", ZebraDevice.ZebraConnectionStatus.disconnected.toString())
            }
            sendEvent(ZebraDevice.Events.connectionStatus, map)
        } catch (e: Exception) {
            Log.e(
                Zebra123Plugin.getTagName(context),
                "Error disconnecting from RFID reader. Error is $e"
            )
        }
    }

    override fun scan(request: ZebraDevice.Requests?) {
        when (request) {
            ZebraDevice.Requests.start -> startScanning()
            ZebraDevice.Requests.stop -> stopScanning()
            else -> {}
        }
    }

    override fun track(request: ZebraDevice.Requests?, tags: ArrayList<String?>?) {
        when (request) {
            ZebraDevice.Requests.start -> tags?.let { startTracking(it.filterNotNull()) }
            ZebraDevice.Requests.stop -> stopTracking()
            else -> {}
        }
    }

    override fun dispose() {
        context.unregisterReceiver(this)
    }

    private val isReaderConnected: Boolean
        get() = reader?.isConnected ?: false.also {
            Log.d(
                Zebra123Plugin.getTagName(context),
                if (reader == null) "Reader is null" else "Reader is not connected"
            )
        }

    override fun eventReadNotify(event: RfidReadEvents) {
        try {
            val tag = event.readEventData.tagData
            if (tag.opCode == null || tag.opCode == ACCESS_OPERATION_CODE.ACCESS_OPERATION_READ) {
                val data = TagInfo().apply {
                    epc = tag.tagID
                    antenna = tag.antennaID
                    rssi = tag.peakRSSI
                    status = tag.opStatus
                    size = tag.tagIDAllocatedSize
                    lockData = tag.permaLockData
                    if (tag.isContainsLocationInfo) {
                        distance = tag.LocationInfo.relativeDistance
                    }
                    memoryBankData = tag.memoryBankData
                }

                if (tracking.isNotEmpty()) {
                    if (tracking.contains(data.epc)) {
                        val notify = !tags.containsKey(data.epc) || tags[data.epc]?.rssi != data.rssi
                        tags.put(data.epc ?: "",data) 
                        if (notify) reportTags()
                    }
                } else {
                   tags.put(data.epc ?: "",data) 
                }
            }
        } catch (e: Exception) {
            Log.e(
                Zebra123Plugin.getTagName(context),
                "Error reading tag data. Error is $e"
            )
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == Zebra123Plugin.getActionName(context)) {
            try {
                val barcode = intent.getStringExtra("com.symbol.datawedge.data_string")
                val format = intent.getStringExtra("com.symbol.datawedge.label_type")
                val seen = System.currentTimeMillis()
                val date = SimpleDateFormat("dd/MM/yyyy HH:mm:ss.SSS").format(Date(seen)).toString()

                val tag = HashMap<String, Any?>().apply {
                    put("barcode", barcode)
                    put("format", format)
                    put("seen", date)
                }

                Log.d(
                    Zebra123Plugin.getTagName(context),
                    "${ZebraDevice.Events.readBarcode}: $tag"
                )

                if (mode == ZebraDevice.Modes.mixed || mode == ZebraDevice.Modes.barcode) {
                    sendEvent(ZebraDevice.Events.readBarcode, tag)
                }
            } catch (e: Exception) {
                Log.e(
                    Zebra123Plugin.getTagName(context),
                    "Error deserializing json object${e.message}"
                )
                sendEvent(ZebraDevice.Events.error, ZebraDevice.toError("onReceive()", e))
            }
        }
    }

    override fun eventStatusNotify(event: RfidStatusEvents) {
        Log.d(Zebra123Plugin.getTagName(context), "eventStatusNotify()")

        when (event.StatusEventData.statusEventType) {
            STATUS_EVENT_TYPE.HANDHELD_TRIGGER_EVENT -> {
                when (event.StatusEventData.HandheldTriggerEventData.handheldEvent) {
                    HANDHELD_TRIGGER_EVENT_TYPE.HANDHELD_TRIGGER_PRESSED -> {
                        Log.d(Zebra123Plugin.getTagName(context), "TRIGGER DOWN")
                        object : AsyncTasks() {
                            override fun doInBackground() {
                                startScanning()
                            }
                        }.execute()
                    }
                    HANDHELD_TRIGGER_EVENT_TYPE.HANDHELD_TRIGGER_RELEASED -> {
                        Log.d(Zebra123Plugin.getTagName(context), "TRIGGER UP")
                        object : AsyncTasks() {
                            override fun doInBackground() {
                                stopScanning()
                            }
                        }.execute()
                    }
                    else -> {}
                }
            }
            else -> {}
        }
    }

    @Synchronized
    private fun reportTags() {
        try {
            if (tags.isNotEmpty()) {
                val data = ArrayList<HashMap<String, Any>>().apply {
                    tags.values.forEach { add(transitionEntity(it)) }
                }
                tags.clear()

                val hashMap = HashMap<String, Any>().apply {
                    put("tags", data)
                }

                if (mode == ZebraDevice.Modes.rfid || mode == ZebraDevice.Modes.mixed) {
                    sendEvent(ZebraDevice.Events.readRfid, hashMap)
                }
            }
        } catch (e: Exception) {
            Log.e(Zebra123Plugin.getTagName(context), "Error in reportTags()")
        }
    }

    @Synchronized
    private fun startScanning() {
        try {
            tracking.clear()

            reader?.let {
                if (mode == ZebraDevice.Modes.mixed || mode == ZebraDevice.Modes.rfid) {
                    Log.d(Zebra123Plugin.getTagName(context), "START SCANNNING")
                    it.Actions.Inventory.stop()
                    it.Actions.Inventory.perform()
                }

                if (mode == ZebraDevice.Modes.mixed || mode == ZebraDevice.Modes.barcode) {
                    Log.d(Zebra123Plugin.getTagName(context), "START READING")
                    ZebraDataWedge.send(
                        context,
                        "com.symbol.datawedge.api.SOFT_SCAN_TRIGGER",
                        "START_SCANNING"
                    )
                }
                    val hashMap = hashMapOf<String, Any>( )

                sendEvent(ZebraDevice.Events.startRead,hashMap)
            }
        } catch (e: Exception) {
            Log.e(Zebra123Plugin.getTagName(context), "Error in startInventory()")
            stopScanning()
        }
    }

    @Synchronized
    private fun stopScanning() {
        if (!isReaderConnected) return

        try {
            reader?.let {
                if (mode == ZebraDevice.Modes.mixed || mode == ZebraDevice.Modes.rfid) {
                    Log.d(
                        Zebra123Plugin.getTagName(context),
                        "STOP SCANNING. Found ${tags.size} tags"
                    )

                    val hashMap = hashMapOf<String, Any>( )
                    sendEvent(ZebraDevice.Events.stopRead,hashMap)
                    it.Actions.Inventory.stop()
                }

                if (mode == ZebraDevice.Modes.mixed || mode == ZebraDevice.Modes.barcode) {
                    Log.d(Zebra123Plugin.getTagName(context), "STOP READING")
                    ZebraDataWedge.send(
                        context,
                        "com.symbol.datawedge.api.SOFT_SCAN_TRIGGER",
                        "STOP_SCANNING"
                    )
                }

                reportTags()
            }
        } catch (e: Exception) {
            Log.e(Zebra123Plugin.getTagName(context), "Error in stopInventory()")
        }
    }

    @Synchronized
    private fun startTracking(tags: List<String>) {
        try {
            tracking.clear()

            if (mode == ZebraDevice.Modes.barcode) return

            reader?.let {
                Log.d(Zebra123Plugin.getTagName(context), "STARTING TRACKING")

                 val hashMap = hashMapOf<String, Any>()


                sendEvent(ZebraDevice.Events.startRead, hashMap)
                tracking.addAll(tags)
                it.Actions.Inventory.stop()
                it.Actions.Inventory.perform()
            }
        } catch (e: Exception) {
            Log.e(Zebra123Plugin.getTagName(context), "Error in startTracking()")
            stopTracking()
        }
    }

    @Synchronized
    private fun stopTracking() {
        tracking.clear()
        if (!isReaderConnected) return

        try {
            reader?.let {
                Log.d(
                    Zebra123Plugin.getTagName(context),
                    "STOPPING TRACKING. Found ${tags.size} tags"
                )

                       val hashMap = hashMapOf<String, Any>( )

                sendEvent(ZebraDevice.Events.stopRead, hashMap)
                it.Actions.Inventory.stop()
            }
        } catch (e: Exception) {
            Log.e(Zebra123Plugin.getTagName(context), "Error in stopTracking()")
        }
    }

    private fun setAntennaPower(power: Int) {
        Log.d(Zebra123Plugin.getTagName(context), "setAntennaPower $power")
        try {
            reader?.let {
                val config = it.Config.Antennas.getAntennaRfConfig(1)
                config.setTransmitPowerIndex(power)
                config.setrfModeTableIndex(0)
                config.tari = 0
                it.Config.Antennas.setAntennaRfConfig(1, config)
            }
        } catch (e: Exception) {
            Log.e(Zebra123Plugin.getTagName(context), "Error setting antenna power: ${e.message}")
        }
    }

    private fun setSingulation(session: SESSION, state: INVENTORY_STATE) {
        Log.d(Zebra123Plugin.getTagName(context), "setSingulation $session")
        try {
            reader?.let {
                val singulationControl = it.Config.Antennas.getSingulationControl(1).apply {
                    this.session = session
                      Action.inventoryState = state
                    Action.slFlag = SL_FLAG.SL_ALL
                }
                it.Config.Antennas.setSingulationControl(1, singulationControl)
            }
        } catch (e: Exception) {
            Log.e(Zebra123Plugin.getTagName(context), "Error setting singulation: ${e.message}")
        }
    }

    private fun setDPO(bEnable: Boolean) {
        Log.d(Zebra123Plugin.getTagName(context), "setDPO $bEnable")
        try {
            reader?.Config?.setDPOState(
                if (bEnable) DYNAMIC_POWER_OPTIMIZATION.ENABLE 
                else DYNAMIC_POWER_OPTIMIZATION.DISABLE
            )
        } catch (e: Exception) {
            Log.e(Zebra123Plugin.getTagName(context), "Error setting DPO: ${e.message}")
        }
    }

    private fun setAccessOperationConfiguration() {
        setAntennaPower(240)
        if (reader?.hostName?.contains("RFD8500") == true) setDPO(false)
        try {
            reader?.Config?.setAccessOperationWaitTimeout(1000)
        } catch (e: Exception) {
            Log.e(Zebra123Plugin.getTagName(context), "Error setting access operation: ${e.message}")
        }
    }

    override fun write(
        epc: String?,
        newEpc: String?,
        password: String?,
        newPassword: String?,
        data: String?
    ) {
        val safeEpc = epc ?: return
        val safePassword = password?.takeIf { it.isNotBlank() } ?: "0"
        var currentEpc = safeEpc
        var currentPassword = safePassword
        var currentData = data
        var ok = true

        if (epc != newEpc && !newEpc.isNullOrBlank()) {
            writeTag(currentEpc, safePassword, MEMORY_BANK.MEMORY_BANK_EPC, newEpc!!, 2)?.let { e ->
                ok = false
                Log.e(
                    Zebra123Plugin.getTagName(context),
                    "Error writing tag epc: ${e.message}"
                )
                sendEvent(
                    ZebraDevice.Events.writeFail,
                    ZebraDevice.toError("Error writing tag epc", e)
                )
            } ?: run { currentEpc = newEpc }
        }

        if (!currentData.isNullOrBlank()) {
            writeTag(currentEpc, safePassword, MEMORY_BANK.MEMORY_BANK_USER, currentData!!, 0)?.let { e ->
                ok = false
                Log.e(
                    Zebra123Plugin.getTagName(context),
                    "Error writing tag data: ${e.message}"
                )
                sendEvent(
                    ZebraDevice.Events.writeFail,
                    ZebraDevice.toError("Error writing tag data", e)
                )
            } ?: run { currentData = "" }
        }

        if (safePassword != newPassword && !newPassword.isNullOrBlank()) {
            writeTag(currentEpc, safePassword, MEMORY_BANK.MEMORY_BANK_RESERVED, newPassword!!, 2)?.let { e ->
                ok = false
                Log.e(
                    Zebra123Plugin.getTagName(context),
                    "Error writing tag password: ${e.message}"
                )
                sendEvent(
                    ZebraDevice.Events.writeFail,
                    ZebraDevice.toError("Error writing tag password", e)
                )
            } ?: run { currentPassword = newPassword }
        }

        if (ok) {
            val hashMap = HashMap<String, Any>().apply {
                put("tag", TagInfo().apply {
                    this.epc = currentEpc
                    memoryBankData = currentData
                    this.password = currentPassword
                })
            }
            sendEvent(ZebraDevice.Events.writeSuccess, hashMap)
        }
    }

   private fun writeTag(
    sourceEPC: String,
    password: String,
    memoryBank: MEMORY_BANK,
    targetData: String,
    offset: Int
): Exception? {
    return try {
        Log.i(Zebra123Plugin.getTagName(context), "Writing RFID tag")

        val tagId = sourceEPC
        val tagAccess = TagAccess()
        val writeAccessParams = tagAccess.WriteAccessParams().apply {
            accessPassword = password.toLong(16)
            this.memoryBank = memoryBank
            this.offset = offset
             writeData = targetData.encodeToByteArray()
            writeRetries = 3
            writeDataLength = targetData.length / 4
        }

        // 5th parameter: prefilter flag = true
        // 6th parameter: use TID filter if writing to EPC
        val useTIDfilter = memoryBank == MEMORY_BANK.MEMORY_BANK_EPC
        reader?.Actions?.TagAccess?.writeWait(tagId, writeAccessParams, null, null, true, useTIDfilter)

        null
    } catch (e: Exception) {
        Log.e(Zebra123Plugin.getTagName(context), "Error during writeTag(). Error: ${e.message}")
        e
    }
}

    private fun sendEvent(event: ZebraDevice.Events, map: Map<*, *>) {
        sink?.let { eventSink ->
            handler.post {
                try {
                    val eventMap = HashMap(map).apply {
                        put("eventSource", INTERFACE.toString())
                        put("eventName", event.toString())
                    }
                    eventSink.success(eventMap)
                } catch (e: Exception) {
                    Log.e(
                        Zebra123Plugin.getTagName(context),
                        "Error sending notification to flutter. Error: ${e.message}"
                    )
                }
            }
        } ?: Log.e(
            Zebra123Plugin.getTagName(context),
            "Can't send notification to flutter. Sink is null"
        )
    }

    private class TagInfo {
        var epc: String? = null
        var antenna: Short = 0
        var rssi: Short = 0
        var status: ACCESS_OPERATION_STATUS? = null
        var distance: Short = 0
        var memoryBankData: String? = null
        var lockData: String? = null
        var size: Int = 0
        var seen: String
        var password: String? = null

        init {
            seen = SimpleDateFormat("dd/MM/yyyy HH:mm:ss.SSS").format(Date()).toString()
        }
    }

    abstract inner class AsyncTasks {
        private val executor: ExecutorService = Executors.newSingleThreadExecutor()

        open fun onPreExecute() {}
        abstract fun doInBackground()
        open fun onPostExecute() {}

        fun execute() {
            onPreExecute()
            executor.execute {
                doInBackground()
                handler.post { onPostExecute() }
            }
        }

        fun shutdown() {
            executor.shutdown()
        }
    }

    companion object {
        private val INTERFACE = ZebraDevice.Interfaces.rfidapi3

        fun isSupported(context: Context): Boolean {
    return try {
        val readers = Readers(context, ENUM_TRANSPORT.ALL)
        readers.GetAvailableRFIDReaderList().size > 0
    } catch (e: Exception) {
        Log.d(Zebra123Plugin.getTagName(context), "Reader does not support RFID")
        false
    }
}

        fun transitionEntity(onClass: Any): HashMap<String, Any> {
            return HashMap<String, Any>().apply {
                onClass.javaClass.declaredFields.forEach { field ->
                    field.isAccessible = true
                    try {
                        put(field.name, field.get(onClass))
                    } catch (e: IllegalAccessException) {
                        Log.e("TransitionEntity", "Error accessing field ${field.name}", e)
                    }
                }
            }
        }
    }
}