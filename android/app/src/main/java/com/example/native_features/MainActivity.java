package com.example.native_features;

import android.content.ContextWrapper;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.BatteryManager;
import android.os.Build;
import android.os.Bundle;
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

  private static final String CHANNEL = "ach.native_features/battery";


  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(new MethodChannel.MethodCallHandler() {
      @Override
      public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
          //HANDLE INCOMING MESSAGE
          if (methodCall.method.equals("getBatteryLevel")) {
            int batteryLevel = getBatteryLevel();
            if (batteryLevel != -1) {
              result.success(batteryLevel);
            } else {
              result.error("UNAVAILABLE","Battery level not available", null);
            }
          } else {
            result.notImplemented();
          }
      }
    });


  }

  private int getBatteryLevel() {
    int batteryLevel = -1;
    try {
      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
        BatteryManager batteryManager = (BatteryManager) getSystemService(BATTERY_SERVICE);
        batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY);
      } else {
        Intent intent = new ContextWrapper(getApplicationContext()).registerReceiver(null,new IntentFilter(Intent.ACTION_BATTERY_CHANGED));
        batteryLevel = (intent.getIntExtra(BatteryManager.EXTRA_LEVEL,-1) * 100) / intent.getIntExtra(BatteryManager.EXTRA_SCALE,-1);
      }
    } catch (Exception e) {
      return batteryLevel;
    }
    return  batteryLevel;
  }
}
