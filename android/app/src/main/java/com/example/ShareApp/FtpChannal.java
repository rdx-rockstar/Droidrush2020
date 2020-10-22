package com.example.ShareApp;

import android.Manifest;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.android.FlutterActivity;
import android.app.Activity;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/**
 * NearbyConnectionsPlugin
 */
public class FtpChannal extends FlutterActivity {
    private static MethodChannel channel;

    @Override
    public void configureFlutterEngine(FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), "ftp")
                .setMethodCallHandler(
                        (call, result) -> {
                            switch (call.method) {
                                case "check":
                                    result.success("done and dusted");
                                    break;
                                default:
                                    result.notImplemented();
                            }
                        }
                );
    }
}
