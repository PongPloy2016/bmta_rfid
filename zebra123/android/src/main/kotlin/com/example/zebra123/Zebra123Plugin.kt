// package com.example.zebra123

// import android.content.Context
// import android.util.Log
// import android.widget.Toast
// import androidx.annotation.NonNull
// import com.example.zebra123.ZebraDataWedge
// import com.example.zebra123.ZebraRfid
// import io.flutter.embedding.engine.plugins.FlutterPlugin
// import io.flutter.plugin.common.EventChannel
// import io.flutter.plugin.common.EventChannel.EventSink
// import io.flutter.plugin.common.EventChannel.StreamHandler
// import io.flutter.plugin.common.MethodCall
// import io.flutter.plugin.common.MethodChannel
// import io.flutter.plugin.common.MethodChannel.MethodCallHandler
// import io.flutter.plugin.common.MethodChannel.Result
// import java.util.*
// import java.util.Arrays

// /** Zebra123  */class Zebra123Plugin : FlutterPlugin, MethodCallHandler, EventChannel.StreamHandler {
//     private var methodHandler: MethodChannel? = null
//     private var eventHandler: EventChannel? = null
//     private var device: ZebraDevice? = null
//     private var context: Context? = null
//     private var eventSink: EventChannel.EventSink? = null

//     private val METHODCHANNEL = "methodX"
//     private val EVENTCHANNEL = "eventX"

//     private var supportsRfid: Boolean = false
//     private var supportsDatawedge: Boolean = false

//     override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
//         context = binding.applicationContext

//         methodHandler = MethodChannel(binding.binaryMessenger, METHODCHANNEL)
//         methodHandler?.setMethodCallHandler(this)

//         eventHandler = EventChannel(binding.binaryMessenger, EVENTCHANNEL)
//         eventHandler?.setStreamHandler(this)
//     }

//     override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
//         disconnect()
//         methodHandler?.setMethodCallHandler(null)
//         eventHandler?.setStreamHandler(null)
//         eventSink = null
//     }

//     override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {

//         Log.i(getTagName(context), "onMethodCall ${call.method} ${call.arguments}")
//         val method = try {
//             ZebraDevice.Methods.valueOf(call.method)
//         } catch (e: Exception) {
//             ZebraDevice.Methods.unknown
//         }

//         when (method) {
//             ZebraDevice.Methods.track -> {
//                 val request = getRequest(call)
//                 val tags = call.argument<String>("tags") ?: ""
//                 val tagList = tags.split(",").map { it.trim() }.filter { it.isNotEmpty() }
//                 device?.track(request, ArrayList(tagList))
//             }

//             ZebraDevice.Methods.scan -> {
//                disconnect()
//               connect(eventSink)
//                 val request = getRequest(call)
//                 device?.scan(request)
//             }

//             ZebraDevice.Methods.mode -> {
//                 val mode = try {
//                     call.argument<String>("mode")?.let { ZebraDevice.Modes.valueOf(it) }
//                 } catch (e: Exception) {
//                     null
//                 } ?: ZebraDevice.Modes.mixed

//               Log.e(getTagName(context), "kotlin Setting onMethodCall  mode to $mode")


//                 device?.setMode(mode)

//             }

//             ZebraDevice.Methods.write -> {
//                 val epc = call.argument<String>("epc") ?: ""
//                 val newEpc = call.argument<String>("epcNew") ?: ""
//                 val password = call.argument<String>("password") ?: ""
//                 val newPassword = call.argument<String>("passwordNew") ?: ""
//                 val data = call.argument<String>("data") ?: ""
//                 device?.write(epc, newEpc, password, newPassword, data)
//             }

//             // ZebraDevice.Methods.reconnect -> {
//             //     disconnect()
//             //     connect(eventSink)
//             // }

//             else -> {
//                 Toast.makeText(context, "Method ${call.method} not implemented", Toast.LENGTH_LONG).show()
//                 result.notImplemented()
//                 return
//             }
//         }

//         result.success(null)
//     }

//     override fun onListen(arguments: Any?, sink: EventChannel.EventSink?) {
//             Log.i(getTagName(context), "onListen...")
//         eventSink = sink
//         supportsRfid = context?.let { ZebraRfid.isSupported(it) } ?: false
//         supportsDatawedge = context?.let { ZebraDataWedge.isSupported(it) } ?: false

//         val supportMap = hashMapOf(
//             ZebraDevice.Interfaces.rfidapi3.toString() to supportsRfid.toString(),
//             ZebraDevice.Interfaces.datawedge.toString() to supportsDatawedge.toString()
//         )

//         sendEvent(sink, ZebraDevice.Events.support, supportMap)
//         connect(sink)
        

//     }

//     override fun onCancel(arguments: Any?) {
//         Log.w(getTagName(context), "Cancelling listener")
//         disconnect()
//         eventSink = null
//     }

//     private fun getRequest(call: MethodCall): ZebraDevice.Requests {
//         return try {
//             call.argument<String>("request")?.let {
//                 ZebraDevice.Requests.valueOf(it)
//             }
//         } catch (e: Exception) {
//             null
//         } ?: ZebraDevice.Requests.unknown
//     }

//     private fun connect(sink: EventChannel.EventSink?) {
//         try {
//             Log.i(getTagName(context), "Attempting to connect...")

//             device?.disconnect()
//             device = null

//             supportsRfid = context?.let { ZebraRfid.isSupported(it) } ?: false
//             supportsDatawedge = context?.let { ZebraDataWedge.isSupported(it) } ?: false

//             when {
//                 supportsRfid -> {
//                     device = context?.let { ZebraRfid(it, sink) }
//                     device?.connect()
//                     Log.e(getTagName(context), " connecting to device ZebraRfid ")
//                     Toast.makeText(context, "connecting to device ZebraRfid", Toast.LENGTH_LONG).show()
//                 }
//                 supportsDatawedge -> {
//                     device = context?.let { ZebraDataWedge(it, sink) }
//                     device?.connect()
//                     Log.e(getTagName(context), "connecting to device ZebraDataWedge ${device.toString()}")
//                     Toast.makeText(context, "connecting to device ZebraDataWedge", Toast.LENGTH_LONG).show()
//                 }
//                 else -> {
//                     val map = HashMap<String, Any>().apply {
//                         put("status", ZebraDevice.ZebraConnectionStatus.error.toString())
//                     }
//                     sendEvent(sink, ZebraDevice.Events.connectionStatus, map)
//                     Log.e(getTagName(context), "Status: ${ZebraDevice.ZebraConnectionStatus.error}")
//                     Toast.makeText(context, "notify device", Toast.LENGTH_LONG).show()
//                 }
//             }

//         } catch (e: Exception) {
//           Log.e(getTagName(context), "Error connecting to device ${e.message}")
//             // sendEvent(sink, ZebraDevice.Events.error, ZebraDevice.toError("Error during connect()", e))
//             Toast.makeText(context, "Error connecting to device ${e.message}", Toast.LENGTH_LONG).show()
//         }
//     }

//     private fun disconnect() {
//         Log.i(getTagName(context), "Disconnecting device...")
//         device?.disconnect()
//         device = null
//     }

//     private fun sendEvent(sink: EventChannel.EventSink?, event: ZebraDevice.Events, map: Map<String, Any>) {
//         if (sink == null) {
//             Log.e(getTagName(context), "EventSink is null. Cannot send event: $event")
//             return
//         }

//         try {
//             val eventMap = HashMap(map).apply {
//                 put("eventSource", INTERFACE.toString())
//                 put("eventName", event.toString())
//             }
//             sink.success(eventMap)
//         } catch (e: Exception) {
//             Log.e(getTagName(context), "Error sending event: ${e.message}")
//         }
//     }

//     companion object {
//         private val INTERFACE = ZebraDevice.Interfaces.unknown

//         @JvmStatic
//         fun getPackageName(context: Context?): String = context?.packageName ?: "unknown"

//         @JvmStatic
//         fun getProfileName(context: Context?): String = "${getPackageName(context)}.profile"

//         @JvmStatic
//         fun getActionName(context: Context?): String = "${getPackageName(context)}.ACTION"

//         @JvmStatic
//         fun getTagName(context: Context?): String = "${getPackageName(context)}.ZEBRA"
//     }
// }
