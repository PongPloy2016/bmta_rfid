package com.zebra123.zebra123;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

public class Zebra123Plugin implements FlutterPlugin, MethodCallHandler {
    private MethodChannel channel;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPlugin.FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "zebra123");
        channel.setMethodCallHandler(this);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        switch (call.method) {
            case "getPlatformVersion":
                result.success("Android " + android.os.Build.VERSION.RELEASE);
                break;

            case "startScan":
                String scanResult = startScan(); // สแกนบาร์โค้ดและคืนค่า
                result.success(scanResult);
                break;

            default:
                result.notImplemented();
                break;
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPlugin.FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }

    private String startScan() {
        // ตรงนี้คุณสามารถเชื่อมกับ Zebra SDK จริงได้
        // สำหรับตัวอย่างเราจะ return ค่าจำลอง
        return "FakeBarcode1234567890";
    }
}