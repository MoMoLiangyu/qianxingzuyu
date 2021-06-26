//
//  CommonUtils.swift
//  ZuYu2
//
//  Created by million on 2020/11/5.
//  Copyright © 2020 million. All rights reserved.
//

import UIKit
import CoreLocation
import Photos


func dealTimeStr(timeStr: String) -> String {
    if timeStr.count < 21 {
        return timeStr
    }else{
        let str = timeStr.replacingOccurrences(of: "T", with: " ");
        let tempStr:String = String(str.prefix(19))
        return tempStr
    }
}

class AboutAuth: NSObject {
    typealias OperationBlock = ( () -> Void )?
    // 相机授权
    static func cameraPermissions(authorizedBlock: OperationBlock?, deniedBlock: OperationBlock?) {
        let authStatus = AVCaptureDevice.authorizationStatus(for: .video)
        if authStatus == .notDetermined {
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    guard let block = authorizedBlock, block != nil else {
                        return
                    }
                    block!()
                }else{
                    guard let block = deniedBlock, block != nil else {
                        return
                    }
                    block!()
                }
               
            }
        }else if authStatus == .authorized {
            guard let block = authorizedBlock, block != nil else {
                return
            }
            block!()
        }else{
            guard let block = deniedBlock, block != nil else {
                return
            }
            block!()
        }
        
    }
    //相册授权
    static func photoAlbumPermissions(authorizedBlock: OperationBlock?, deniedBlock: OperationBlock?) {
        let authStatus = PHPhotoLibrary.authorizationStatus()
        if authStatus == .notDetermined {
            PHPhotoLibrary.requestAuthorization { status in
                if status == .authorized {
                    guard let block = authorizedBlock, block != nil else {
                        return
                    }
                    block!()
                }else{
                    guard let block = deniedBlock, block != nil else {
                        return
                    }
                    block!()
                }
            }
        }else if authStatus == .authorized {
            guard let block = authorizedBlock, block != nil else {
                return
            }
            block!()
        }else{
            guard let block = deniedBlock, block != nil else {
                return
            }
            block!()
        }
        
    }
    
    static func photoAndCameraAuthAction(view: UIView){
    AboutAuth.photoAlbumPermissions {
        print("相册允许")
    } deniedBlock: {
        view.makeToast("请在手机设置页，打开相册的权限")
    }
    
    AboutAuth.cameraPermissions {
        print("相机允许")
    } deniedBlock: {
        view.makeToast("请在手机设置页，打开相机的权限")
    }
    }
    
}

// 跳转到设置界面获得位置授权
func checkLocatePermisson(controller : UIViewController) {

       if(CLLocationManager.authorizationStatus() != .denied) {

           print("应用拥有定位权限")

       }else {

           let alertController = UIAlertController(title: "打开定位开关",

                                                   message: "定位服务未开启,请进入系统设置>隐私>定位服务中打开开关,并允许App使用定位服务",

                                                   preferredStyle: .alert)

           let settingsAction = UIAlertAction(title: "设置", style: .default) { (alertAction) in



            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
               }

           }

           alertController.addAction(settingsAction)

           let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)

           alertController.addAction(cancelAction)

           controller.present(alertController, animated: true, completion: nil)

       }



}
