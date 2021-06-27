//
//  AppDelegate.swift
//  ZuYu
//
//  Created by million on 2020/7/11.
//  Copyright © 2020 million. All rights reserved.
//

import UIKit
import Toast_Swift
import SVProgressHUD
import IQKeyboardManagerSwift
import AMapFoundationKit
import SystemConfiguration.CaptiveNetwork
import Bugly
import CocoaLumberjack


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
 
    var fileLogger: DDFileLogger?
    
    var window: UIWindow?
    static var shared: AppDelegate { return UIApplication.shared.delegate as! AppDelegate }
    
    var locationManager : CLLocationManager = CLLocationManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        globalSettings()
        setupLogManager()
        AMapServices.shared()?.apiKey = amapKey
        requestLocationPermission()
        setJushAction(launchOptions)
        WXApi.startLog(by: .detail) { (info) in
            print(info)
        }
        WXApi.registerApp(WX_APPID, universalLink: "https://m.sz-mysaas.com/app")
        print("wifi : \(getWifiName() ?? "")")
        
        //加入bugly崩溃日志收集
        Bugly.start(withAppId: "5b89ad1fbf")
        
        return true
    }
    
    fileprivate func setupLogManager() {
        if #available(iOS 10.0, *) {
            DDLog.add(DDOSLogger.sharedInstance)
        } else {
            // Fallback on earlier versions
        } // Uses os_log
        
        let fileLogger: DDFileLogger = DDFileLogger() // File Logger
        fileLogger.rollingFrequency = 60 * 60 * 24 // 24 hours
        fileLogger.logFileManager.maximumNumberOfLogFiles = 9
        fileLogger.maximumFileSize = 900 * 1024 //最大上传不超过 1MB
        DDLog.add(fileLogger)
        
        self.fileLogger = fileLogger
    }
    
    func requestLocationPermission() {
        if #available(iOS 14.0, *) {
            switch locationManager.authorizationStatus {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            default:
                break
            }
        } else {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            default:
                break
            }
        }
    }
    
    //获取用户使用wifi名称
        func getWifiName() -> String? {
            var wifiName : String = ""
            let wifiInterfaces = CNCopySupportedInterfaces()
            if wifiInterfaces == nil {
                return nil
            }
            let interfaceArr = CFBridgingRetain(wifiInterfaces!) as! Array<String>
            if interfaceArr.count > 0 {
                let interfaceName = interfaceArr[0] as CFString
                let ussafeInterfaceData = CNCopyCurrentNetworkInfo(interfaceName)
                
                if (ussafeInterfaceData != nil) {
                    let interfaceData = ussafeInterfaceData as! Dictionary<String, Any>
                    wifiName = interfaceData["SSID"]! as! String
                }
            }
            return wifiName
        }
    
    func globalSettings() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        ToastManager.shared.isTapToDismissEnabled = false
        ToastManager.shared.isQueueEnabled = true
        SVProgressHUD.setDefaultMaskType(.clear)
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}

// MARK: - 支付回调
extension AppDelegate{
    // iOS 8 及以下请用这个
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if url.host == "safepay"{//支付宝
            //支付回调
            AlipaySDK.defaultService().processOrder(withPaymentResult: url, standbyCallback:{ (resultDic) in
                if resultDic != nil{
                    AliPayManager.shared.showResult(result:resultDic! as NSDictionary)
                }
            })
            //授权回调
            AlipaySDK.defaultService().processAuth_V2Result(url, standbyCallback: { (resultDic) in
                if resultDic != nil{
                    AliPayManager.shared.showAuth_V2Result(result:resultDic! as NSDictionary)
                }
            })
            return true
        }else{//微信
            return WXApi.handleOpen(url, delegate:WXApiManager.shared)
        }
        
    }
    
    // iOS 9 以上请用这个
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        if url.host == "safepay"{//支付宝
            //支付回调
            AlipaySDK.defaultService().processOrder(withPaymentResult: url, standbyCallback:{ (resultDic) in
                if resultDic != nil{
                    AliPayManager.shared.showResult(result:resultDic! as NSDictionary)
                }
            })
            //授权回调
            AlipaySDK.defaultService().processAuth_V2Result(url, standbyCallback: { (resultDic) in
                if resultDic != nil{
                    AliPayManager.shared.showAuth_V2Result(result:resultDic! as NSDictionary)
                }
            })
            return true
        }else{//微信
            return WXApi.handleOpen(url,delegate:WXApiManager.shared)
        }
    }
}


extension AppDelegate: JPUSHRegisterDelegate {
    
    func setJushAction(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        let entity = JPUSHRegisterEntity()
        entity.types = 1 << 0 | 1 << 1 | 1 << 2
        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
        JPUSHService.setup(withOption: launchOptions,
                           appKey: "c58c972c3158e58d16f676ba",
                           channel: "App Store",
                           apsForProduction: false,
                           advertisingIdentifier: nil)
    }
    
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        let userInfo = notification.request.content.userInfo
        if notification.request.trigger is UNPushNotificationTrigger {
            JPUSHService.handleRemoteNotification(userInfo)
        }
        print("前台 收到推送 userInfo=\(userInfo)")
        NotificationCenter.default.post(name: NSNotification.Name("JSNotification"), object: nil);
        // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
        completionHandler(Int(UNNotificationPresentationOptions.alert.rawValue))
    }
    
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        let userInfo = response.notification.request.content.userInfo
        if response.notification.request.trigger is UNPushNotificationTrigger {
            JPUSHService.handleRemoteNotification(userInfo)
        }
        print("点击推送消息 content=\(response.notification.request.content.userInfo)")
        // 系统要求执行这个方法
        completionHandler()
    }
    
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, openSettingsFor notification: UNNotification!) {
        
    }
    
    //点推送进来执行这个方法
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        JPUSHService.handleRemoteNotification(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
        
    }
    //系统获取Token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        UserDefaults.standard.set(deviceToken, forKey: "deviceToken")
        JPUSHService.registerDeviceToken(deviceToken)
    }
    //获取token 失败
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) { //可选
        print("did Fail To Register For Remote Notifications With Error: \(error)")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        //在应用进入后台时清除推送消息角标
        application.applicationIconBadgeNumber = 0
        JPUSHService.setBadge(0)
    }
    
}
