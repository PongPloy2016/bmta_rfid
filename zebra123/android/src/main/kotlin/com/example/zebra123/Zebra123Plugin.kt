package com.example.zebra123

import android.content.Context
import android.util.Log
import android.widget.Toast
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class Zebra123Plugin : FlutterPlugin, MethodChannel.MethodCallHandler, EventChannel.StreamHandler {
    private lateinit var methodChannel: MethodChannel
    private lateinit var eventChannel: EventChannel
    private lateinit var context: Context
    private var eventSink: EventChannel.EventSink? = null
    private var device: ZebraDevice? = null

    companion object {
        private const val METHOD_CHANNEL = "method"
        private const val EVENT_CHANNEL = "com.example.zebra123/event"

        fun getPackageName(context: Context?): String = context?.packageName ?: "unknown"
        fun getProfileName(context: Context?): String = "${context?.packageName}.profile"
        fun getActionName(context: Context?): String = "${context?.packageName}.ACTION"
        fun getTagName(context: Context?): String = "${getPackageName(context)}.ZEBRA"
    }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        context = binding.applicationContext

        methodChannel = MethodChannel(binding.binaryMessenger, METHOD_CHANNEL)
        methodChannel.setMethodCallHandler(this)

        eventChannel = EventChannel(binding.binaryMessenger, EVENT_CHANNEL)
        eventChannel.setStreamHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel.setMethodCallHandler(null)
        eventChannel.setStreamHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val method = try {
            ZebraDevice.Methods.valueOf(call.method)
        } catch (e: Exception) {
            ZebraDevice.Methods.unknown
        }

        when (method) {
            ZebraDevice.Methods.startScan -> {
                result.success("FakeBarcode1234567890YYYY")
            }

            ZebraDevice.Methods.track -> {
                device?.let {
                    val request = try {
                        ZebraDevice.Requests.valueOf(call.argument<String>("request") ?: "")
                    } catch (e: Exception) {
                        ZebraDevice.Requests.unknown
                    }
                    val tags = call.argument<String>("tags")?.split(",") ?: emptyList()
                    it.track(request, ArrayList(tags))
                }
            }

            ZebraDevice.Methods.scan -> {
                device?.let {
                    val request = try {
                        ZebraDevice.Requests.valueOf(call.argument<String>("request") ?: "")
                    } catch (e: Exception) {
                        ZebraDevice.Requests.unknown
                    }
                    it.scan(request)
                }
            }

            ZebraDevice.Methods.mode -> {
                device?.let {
                    val mode = try {
                        ZebraDevice.Modes.valueOf(call.argument<String>("mode") ?: "")
                    } catch (e: Exception) {
                        ZebraDevice.Modes.mixed
                    }
                    it.setMode(mode)
                }
            }

            ZebraDevice.Methods.write -> {
                device?.let {
                    val epc = call.argument<String>("epc") ?: ""
                    val newEpc = call.argument<String>("epcNew") ?: ""
                    val password = call.argument<String>("password") ?: ""
                    val newPassword = call.argument<String>("passwordNew") ?: ""
                    val data = call.argument<String>("data") ?: ""
                    it.write(epc, newEpc, password, newPassword, data)
                }
            }

            else -> {
                Toast.makeText(context, "Method ${call.method} not implemented", Toast.LENGTH_LONG).show()
                result.notImplemented()
                return
            }
        }

        result.success(null)
    }

    override fun onListen(arguments: Any?, sink: EventChannel.EventSink?) {
        eventSink = sink

        val supportsRfid = ZebraRfid.isSupported(context)
        val supportsDatawedge = ZebraDataWedge.isSupported(context)

        val map = hashMapOf<String, Any>(
            ZebraDevice.Interfaces.rfidapi3.toString() to supportsRfid.toString(),
            ZebraDevice.Interfaces.datawedge.toString() to supportsDatawedge.toString()
        )
        sendEvent(ZebraDevice.Events.support, map)

        connect()
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
        Log.i(getTagName(context), "EventChannel cancelled by Flutter")
    }

    private fun connect() {
        try {
            device?.disconnect()
            device = null

            device = when {
                ZebraRfid.isSupported(context) -> ZebraRfid(context, eventSink)
                ZebraDataWedge.isSupported(context) -> ZebraDataWedge(context, eventSink)
                else -> {
                    val map = hashMapOf<String, Any>(
                        "status" to ZebraDevice.ZebraConnectionStatus.error.toString()
                    )
                    sendEvent(ZebraDevice.Events.connectionStatus, map)
                    null
                }
            }

            device?.connect()
        } catch (e: Exception) {
            Log.e(getTagName(context), "Error connecting to device: ${e.message}")
            sendEvent(ZebraDevice.Events.error, ZebraDevice.toError("Error during connect()", e))
        }
    }

    private fun sendEvent(event: ZebraDevice.Events, map: HashMap<String, Any>) {
        eventSink?.let {
            try {
                map["eventSource"] = ZebraDevice.Interfaces.unknown.toString()
                map["eventName"] = event.toString()
                it.success(map)
            } catch (e: Exception) {
                Log.e(getTagName(context), "Error sending event: ${e.message}")
            }
        } ?: Log.e(getTagName(context), "Cannot send event, sink is null")
    }
}