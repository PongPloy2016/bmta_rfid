// package com.example.zebra123

// import android.content.BroadcastReceiver
// import android.content.Context
// import android.content.Intent
// import android.content.IntentFilter
// import android.os.Bundle
// import android.os.Parcelable
// import android.util.Log
// import io.flutter.plugin.common.EventChannel
// import io.flutter.plugin.common.EventChannel.EventSink
// import java.text.SimpleDateFormat
// import java.util.*
// import kotlin.collections.HashMap

// class ZebraDataWedge(private val context: Context, sink: EventSink?) :
//     BroadcastReceiver(), ZebraDevice{
//     private var sink: EventSink? = null

//     init {
//         this.sink = sink
//         this.createProfile()
//     }

//     override fun onReceive(context: Context, intent: Intent) {
//         val actionSource: String? = intent.action
//         val actionTarget: String = Zebra123Plugin.getActionName(context)
//         if (actionSource == actionTarget) {
//             try {
//                 val barcode: String? = intent.getStringExtra("com.symbol.datawedge.data_string")
//                 val format: String? = intent.getStringExtra("com.symbol.datawedge.label_type")
//                 val seen = System.currentTimeMillis()
//                 val date = SimpleDateFormat("dd/MM/yyyy HH:mm:ss.SSS")
//                     .format(Date(seen)).toString()

//                 if (barcode == null || format == null) {
//                     Log.e(
//                         Zebra123Plugin.getTagName(context),
//                         "Barcode or format is null"
//                     )
//                     return
//                 }

//                 // create a map of simple objects
//                 val tag = HashMap<String, Any?>()
//                 tag["barcode"] = barcode
//                 tag["format"] = format
//                 tag["seen"] = date

//                 // duplicate reads within 1 second are ignored
//                 if (barcode == barcodeLast && kotlin.math.abs((seen - seenLast).toDouble()) < 1000) {
//                     Log.e(
//                         Zebra123Plugin.getTagName(context),
//                         "Duplicate barcode read within 1 second. Skipping."
//                     )
//                     return
//                 }
//                 barcodeLast = barcode
//                 seenLast = seen

//                 // notify listener
//                 Log.d(
//                     Zebra123Plugin.getTagName(context),
//                     "${ZebraDevice.Events.readBarcode}: $tag"
//                 )

//                 sendEvent(ZebraDevice.Events.readBarcode, tag)
//             } catch (e: Exception) {
//                 Log.e(
//                     Zebra123Plugin.getTagName(context),
//                     "Error deserializing json object ${e.message}"
//                 )
//                 sendEvent(ZebraDevice.Events.error, ZebraDevice.toError("onReceive()", e))
//             }
//         }
//     }

//     override fun connect() {
//         try {
//             val filter = IntentFilter()
//             filter.addAction(Zebra123Plugin.getActionName(context))
//             filter.addCategory(Intent.CATEGORY_DEFAULT)

//             context.registerReceiver(this, filter)

//             val map = HashMap<String, Any>()
//             map["status"] = ZebraDevice.ZebraConnectionStatus.connected.toString()

//             // notify device
//             sendEvent(ZebraDevice.Events.connectionStatus, map)
//         } catch (e: Exception) {
//             Log.e(
//                 Zebra123Plugin.getTagName(context),
//                 "Error connecting to device ${e.message}"
//             )
//             sendEvent(ZebraDevice.Events.error, ZebraDevice.toError("connect()", e))
//         }
//     }

//     override fun disconnect() {
//         try {
//             context.unregisterReceiver(this)

//             val map = HashMap<String, Any>()
//             map["status"] = ZebraDevice.ZebraConnectionStatus.disconnected.toString()

//             // notify device
//             sendEvent(ZebraDevice.Events.connectionStatus, map)
//         } catch (e: Exception) {
//             Log.e(
//                 Zebra123Plugin.getTagName(context),
//                 "Error disconnecting from device ${e.message}"
//             )
//             sendEvent(ZebraDevice.Events.error, ZebraDevice.toError("disconnect()", e))
//         }
//     }

//     override fun dispose() {
//         try {
//             context.unregisterReceiver(this)
//         } catch (e: Exception) {
//             Log.e(
//                 Zebra123Plugin.getTagName(context),
//                 "Error during dispose(). ${e.message}"
//             )
//         }
//     }

//     override fun scan(request: ZebraDevice.Requests?) {
//         // set the scanner to start or stop scanning

//          Log.e(
//                 Zebra123Plugin.getTagName(context),
//                 "scan"
//             )

//         send(
//             context,
//             "com.symbol.datawedge.api.SOFT_SCAN_TRIGGER",
//             if (request == ZebraDevice.Requests.start) "START_SCANNING" else "STOP_SCANNING"
//         )
//     }

//     override fun setMode(mode: ZebraDevice.Modes?) {
//         val exception = Exception("setMode Not implemented XXXX ")
//         sendEvent(ZebraDevice.Events.error, ZebraDevice.toError("Error calling mode()", exception))
//     }

   


//     override fun track(request: ZebraDevice.Requests?, tags: ArrayList<String?>?) {
//         val exception = Exception("track Not implemented")
//         sendEvent(ZebraDevice.Events.error, ZebraDevice.toError("Error calling track()", exception))
//     }

//     override fun write(
//         epc: String?,
//         newEpc: String?,
//         password: String?,
//         newPassword: String?,
//         data: String?
//     ) {
//         val exception = Exception("write Not implemented")
//         sendEvent(ZebraDevice.Events.error, ZebraDevice.toError("Error calling write()", exception))
//     }

//     private fun createProfile() {
//         try {
//             val packageName: String = Zebra123Plugin.getPackageName(context)
//             val profileName: String = Zebra123Plugin.getProfileName(context)
//             val actionName: String = Zebra123Plugin.getActionName(context)

//             Log.i(
//                 Zebra123Plugin.getTagName(context),
//                 "Creating Datawedge profile $profileName for package $packageName with Intent action $actionName"
//             )

//             // create the profile if it doesnt exist
//             send(context, "com.symbol.datawedge.api.CREATE_PROFILE", packageName)

//             val dwProfile = Bundle()
//             dwProfile.putString("PROFILE_NAME", profileName)
//             dwProfile.putString("PROFILE_ENABLED", "true")
//             dwProfile.putString("CONFIG_MODE", "UPDATE")

//             val appConfig = Bundle()
//             appConfig.putString("PACKAGE_NAME", packageName)
//             appConfig.putStringArray("ACTIVITY_LIST", arrayOf("*"))
//             dwProfile.putParcelableArray(
//                 "APP_LIST",
//                 arrayOf(appConfig)
//             )

//             val plugins = ArrayList<Bundle>()

//             val intentPluginProperties = Bundle()
//             intentPluginProperties.putString("intent_output_enabled", "true")
//             intentPluginProperties.putString("intent_action", actionName)
//             intentPluginProperties.putString("intent_delivery", "2")

//             val intentPlugin = Bundle()
//             intentPlugin.putString("PLUGIN_NAME", "INTENT")
//             intentPlugin.putString("RESET_CONFIG", "true")
//             intentPlugin.putBundle("PARAM_LIST", intentPluginProperties)
//             plugins.add(intentPlugin)

//             val barcodePluginProperties = Bundle()
//             barcodePluginProperties.putString("scanner_input_enabled", "true")
//             barcodePluginProperties.putString("scanner_selection", "auto")
//             val barcodePlugin = Bundle()
//             barcodePlugin.putString("PLUGIN_NAME", "BARCODE")
//             barcodePlugin.putString("RESET_CONFIG", "true")
//             barcodePlugin.putBundle("PARAM_LIST", barcodePluginProperties)
//             plugins.add(barcodePlugin)

//             val rfidPluginProperties = Bundle()
//             rfidPluginProperties.putString("rfid_input_enabled", "true")
//             rfidPluginProperties.putString("rfid_beeper_enable", "true")
//             rfidPluginProperties.putString("rfid_led_enable", "true")
//             rfidPluginProperties.putString("rfid_antenna_transmit_power", "30")
//             rfidPluginProperties.putString("rfid_memory_bank", "0")
//             rfidPluginProperties.putString("rfid_session", "1")
//             rfidPluginProperties.putString("rfid_trigger_mode", "0")
//             rfidPluginProperties.putString("rfid_filter_duplicate_tags", "true")
//             rfidPluginProperties.putString("rfid_hardware_trigger_enabled", "true")
//             rfidPluginProperties.putString("rfid_tag_read_duration", "1000")
//             rfidPluginProperties.putString("rfid_link_profile", "0")
//             rfidPluginProperties.putString("rfid_pre_filter_enable", "false")
//             rfidPluginProperties.putString("rfid_post_filter_enable", "false")

//             val rfidPlugin = Bundle()
//             rfidPlugin.putString("PLUGIN_NAME", "RFID")
//             rfidPlugin.putString("RESET_CONFIG", "true")
//             rfidPlugin.putBundle("PARAM_LIST", rfidPluginProperties)
//             plugins.add(rfidPlugin)

//             val keystrokePluginProperties = Bundle()
//             keystrokePluginProperties.putString("keystroke_output_enabled", "false")

//             val keystrokePlugin = Bundle()
//             keystrokePlugin.putString("PLUGIN_NAME", "KEYSTROKE")
//             keystrokePlugin.putString("RESET_CONFIG", "true")
//             keystrokePlugin.putBundle("PARAM_LIST", keystrokePluginProperties)
//             plugins.add(keystrokePlugin)
//             dwProfile.putParcelableArrayList("PLUGIN_CONFIG", plugins)
//             send(context, "com.symbol.datawedge.api.SET_CONFIG", dwProfile)
//         } catch (e: Exception) {
//             Log.e(
//                 Zebra123Plugin.getTagName(context),
//                 "Error creating profile ${e.message}"
//             )
//         }
//     }

//     private fun sendEvent(event: ZebraDevice.Events, map: Map<*, *>) {
//         sink?.let { eventSink ->
//             try {
//                 val eventMap = HashMap(map)
//                 eventMap["eventSource"] = INTERFACE.toString()
//                 eventMap["eventName"] = event.toString()
//                 eventSink.success(eventMap)
//             } catch (e: Exception) {
//                 Log.e(
//                     Zebra123Plugin.getTagName(context),
//                     "Error sending notification to flutter. Error: ${e.message}"
//                 )
//             }
//         } ?: run {
//             Log.e(
//                 Zebra123Plugin.getTagName(context),
//                 "Can't send notification to flutter. Sink is null"
//             )
//         }
//     }

//     companion object {
//         private val INTERFACE = ZebraDevice.Interfaces.datawedge

//         @JvmField
//         var barcodeLast: String = ""
//         @JvmField
//         var seenLast: Long = 0

//         fun isSupported(context: Context): Boolean {
//             try {
//                 val i = Intent()
//                 i.action = "com.symbol.datawedge.api.ACTION"
//                 i.putExtra("com.symbol.datawedge.api.GET_VERSION_INFO", "")
//                 context.sendBroadcast(i)
//                 return true
//             } catch (e: Exception) {
//                 Log.d(
//                     Zebra123Plugin.getTagName(context),
//                     "Reader does not support Data Wedge"
//                 )
//             }
//             return false
//         }

//         fun send(context: Context, extraKey: String, extraValue: Bundle) {
//             try {
//                 val dwIntent = Intent()
//                 dwIntent.action = "com.symbol.datawedge.api.ACTION"
//                 dwIntent.putExtra(extraKey, extraValue)
//                 context.sendBroadcast(dwIntent)
//             } catch (e: Exception) {
//                 Log.e(
//                     Zebra123Plugin.getTagName(context),
//                     "Error sending command to device ${e.message}"
//                 )
//             }
//         }

//         @JvmStatic
//         fun send(context: Context, extraKey: String, extraValue: String) {
//             try {
//                 val dwIntent = Intent()
//                 dwIntent.action = "com.symbol.datawedge.api.ACTION"
//                 dwIntent.putExtra(extraKey, extraValue)
//                 context.sendBroadcast(dwIntent)
//             } catch (e: Exception) {
//                 Log.e(
//                     Zebra123Plugin.getTagName(context),
//                     "Error sending command to device ${e.message}"
//                 )
//             }
//         }
//     }
// }