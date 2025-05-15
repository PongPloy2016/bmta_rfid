package com.example.zebra123

import android.content.Context
import android.util.Log
import android.widget.Toast
import androidx.annotation.NonNull
import com.example.zebra123.ZebraDataWedge
import com.example.zebra123.ZebraRfid
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.EventChannel.StreamHandler
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.util.*
import java.util.Arrays

/** Zebra123  */
class Zebra123Plugin : FlutterPlugin, MethodCallHandler, StreamHandler {
    private var methodHandler: MethodChannel? = null
    private var eventHandler: EventChannel? = null
    private var device: ZebraDevice? = null
    private var context: Context? = null

    private val METHODCHANNEL = "methodX"
    private val EVENTCHANNEL = "eventX"

    var supportsRfid: Boolean = false
    var supportsDatawedge: Boolean = false

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext

        methodHandler?.setMethodCallHandler(null)
        methodHandler = MethodChannel(flutterPluginBinding.binaryMessenger, METHODCHANNEL)
        methodHandler?.setMethodCallHandler(this)

        eventHandler = EventChannel(flutterPluginBinding.binaryMessenger, EVENTCHANNEL)
        eventHandler?.setStreamHandler(this)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        disconnect()
        methodHandler?.setMethodCallHandler(null)
        eventHandler?.setStreamHandler(null)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        val method = try {
            ZebraDevice.Methods.valueOf(call.method)
        } catch (e: Exception) {
            ZebraDevice.Methods.unknown
        }

        when (method) {
            ZebraDevice.Methods.track -> device?.let {
                val request = try {
                    argument(call, "request")?.let { req ->
                        ZebraDevice.Requests.valueOf(req)
                    } ?: ZebraDevice.Requests.unknown
                } catch (e: Exception) {
                    ZebraDevice.Requests.unknown
                }
                val tags = argument(call, "tags") ?: ""
                val list = ArrayList(listOf(*tags.split(",").toTypedArray()))
                it.track(request, list)
            }

            ZebraDevice.Methods.scan -> device?.let {
                val request = try {
                    argument(call, "request")?.let { req ->
                        ZebraDevice.Requests.valueOf(req)
                    } ?: ZebraDevice.Requests.unknown
                } catch (e: Exception) {
                    ZebraDevice.Requests.unknown
                }
                Log.e(getTagName(context), "request: $request")
                val tags = argument(call, "tags") ?: ""
                Log.e(getTagName(context), "tags: $tags")
                it.scan(request)
            }

            ZebraDevice.Methods.mode -> device?.let {
                val mode = try {
                    argument(call, "mode")?.let { m ->
                        ZebraDevice.Modes.valueOf(m)
                    } ?: ZebraDevice.Modes.mixed
                } catch (e: Exception) {
                    ZebraDevice.Modes.mixed
                }
                it.setMode(mode)
            }

            ZebraDevice.Methods.write -> device?.let {
                val epc = argument(call, "epc") ?: ""
                val newEpc = argument(call, "epcNew") ?: ""
                val password = argument(call, "password") ?: ""
                val newPassword = argument(call, "passwordNew") ?: ""
                val data = argument(call, "data") ?: ""
                it.write(epc, newEpc, password, newPassword, data)
            }

            else -> Toast.makeText(
                context,
                "Method ${call.method} not implemented",
                Toast.LENGTH_LONG
            ).show()
        }

        result.success(null)
    }

    
    override fun onListen(arguments: Any?, sink: EventSink?) {
        supportsRfid = ZebraRfid.isSupported(context!!)
        supportsDatawedge = context?.let { ZebraDataWedge.isSupported(it) } ?: false

        val map = HashMap<String, Any>().apply {
            put(ZebraDevice.Interfaces.rfidapi3.toString(), supportsRfid.toString())
            put(ZebraDevice.Interfaces.datawedge.toString(), supportsDatawedge.toString())
        }
        sendEvent(sink, ZebraDevice.Events.support, map)

        Log.e(getTagName(context), "onListen: ${supportsDatawedge}")

        connect(sink)
    }

    override fun onCancel(arguments: Any?) {
        Log.w(getTagName(context), "cancelling listener")
    }

    private fun argument(call: MethodCall, key: String): String? {
        return call.argument<String>(key)
    }

    private fun connect(sink: EventSink?) {
        try {
            device?.disconnect()
            device = null

            when {
                supportsRfid -> {
                    device = context?.let { ZebraRfid(it, sink) }
                    device?.connect()
                    Log.e(getTagName(context), " connecting to device ZebraRfid ")
                    Toast.makeText(context, "connecting to device ZebraRfid", Toast.LENGTH_LONG).show()
                }
                supportsDatawedge -> {
                    device = context?.let { ZebraDataWedge(it, sink) }
                    device?.connect()
                    Log.e(getTagName(context), "connecting to device ZebraDataWedge ${device.toString()}")
                    Toast.makeText(context, "connecting to device ZebraDataWedge", Toast.LENGTH_LONG).show()
                }
                else -> {
                    val map = HashMap<String, Any>().apply {
                        put("status", ZebraDevice.ZebraConnectionStatus.error.toString())
                    }
                    sendEvent(sink, ZebraDevice.Events.connectionStatus, map)
                    Log.e(getTagName(context), "Status: ${ZebraDevice.ZebraConnectionStatus.error}")
                    Toast.makeText(context, "notify device", Toast.LENGTH_LONG).show()
                }
            }
        } catch (e: Exception) {
            Log.e(getTagName(context), "Error connecting to device ${e.message}")
            sendEvent(sink, ZebraDevice.Events.error, ZebraDevice.toError("Error during connect()", e))
            Toast.makeText(context, "Error connecting to device ${e.message}", Toast.LENGTH_LONG).show()
        }
    }

    private fun disconnect() {
        device?.disconnect()
    }

    private fun sendEvent(sink: EventSink?, event: ZebraDevice.Events, map: HashMap<*, *>) {
        if (sink == null) {
            Log.e(getTagName(context), "Can't send notification to flutter. Sink is null")
            return
        }

        try {
            val eventMap = HashMap(map).apply {
                put("eventSource", INTERFACE.toString())
                put("eventName", event.toString())
            }
            sink.success(eventMap)
        } catch (e: Exception) {
            Log.e(getTagName(context), "Error sending notification to flutter. Error: ${e.message}")
        }
    }

    companion object {
        private val INTERFACE = ZebraDevice.Interfaces.unknown

        @JvmStatic
        fun getPackageName(context: Context?): String {
            return context?.packageName ?: "unknown"
        }

        @JvmStatic
        fun getProfileName(context: Context?): String {
            return "${getPackageName(context)}.profile"
        }

        @JvmStatic
        fun getActionName(context: Context?): String {
            return "${getPackageName(context)}.ACTION"
        }

        @JvmStatic
        fun getTagName(context: Context?): String {
            return "${getPackageName(context)}.ZEBRA"
        }
    }
}
