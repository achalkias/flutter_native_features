import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    
    //Grab root view controller
    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    //Create a channel to listen on for requests
    let batteryChannel = FlutterMethodChannel(name:"ach.native_features/battery",binaryMessenger: controller)
    
    batteryChannel.setMethodCallHandler({ (call: FlutterMethodCall, result: FlutterResult) -> Void in
        guard call.method == "getBatteryLevel" else {
            result(FlutterMethodNotImplemented)
            return
        }
        
        self.receiveBateryLevel(result: result)
        
    })
    
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    private func receiveBateryLevel(result: FlutterResult) {
        let device = UIDevice.current
        device.isBatteryMonitoringEnabled = true
        if device.batteryState == UIDeviceBatteryState.unknown {
            result(FlutterError(code: "UNAVAILABLE", message: "Battery info unavailable", details: nil))
        } else {
            result(Int(device.batteryLevel * 100))
        }
    }
}


