//
//  NetTool.swift
//  Zuyu2
//
//  Created by million on 2019/12/28.
//  Copyright © 2019 million. All rights reserved.
//

import Foundation
import Moya
import SVProgressHUD
import RxSwift

protocol Auth {
    func needToken() -> Bool
}

enum NetworkIndicatorStyle {
    case `default`
    case custom
    case none
}

public enum NetTool {
    case getDynamicKey
    case login([String : Any])
    case sendSmsCode([String : Any])
    case verifyCode([String : Any])
    case uploadData(String, Data)
    case uploadBase64(String, Data)
    
    /* 楼面端*/
    case list([String : Any])
    case createWalletOrder([String : Any])
    case walletOrderPay([String : Any])
    case walletTemplateList
    
    /* 技师端*/
    case callProject([String : Any])
    case callWaiter([String : Any])
    case getAllProjectList([String : Any])
}

extension NetTool : Auth {
    func needToken() -> Bool {
        var needToken = true
        switch self {
        case .getDynamicKey,
             .login,
             .sendSmsCode,
             .verifyCode:
            needToken = false
            break
        default:
            break
        }
        return needToken
    }
}

extension NetTool: Moya.TargetType {
    public var baseURL: URL {
        return URL(string: serverUrl)!
    }
    
    public var path:String{
        var tempPath = self.pathBase
        if serverUrl.contains("192.168"){
            tempPath = tempPath.replacingOccurrences(of: "", with: "/apiFloor", options: .literal, range: nil)
            tempPath = tempPath.replacingOccurrences(of: "", with: "/apiFloor", options: .literal, range: nil)
        }
        return tempPath
    }
    
    public var pathBase: String {
        switch self {
        case .getDynamicKey:
            return "/common/getDynamicKey"
        case .login:
            return "/login"
        case .sendSmsCode:
            return "/common/sendSmsCode"
        case .verifyCode:
            return "/common/verifyCode"
        
        case .uploadData:
            return "/file-manage/upload"
        case .uploadBase64:
            return "/file-manage/uploadBase64"
            
        /* 楼面端*/
        case .list:
            return "/store/list"
        case .createWalletOrder:
            return "/store-wallet/createWalletOrder"
        case .walletOrderPay:
            return "/store-wallet/walletOrderPay"
        case .walletTemplateList:
            return "/store-wallet/walletTemplateList"
            
        /* 技师端*/
        case .callProject:
            return "/callService/callProject"
        case .callWaiter:
            return "/callService/callWaiter"
        case .getAllProjectList:
            return "/callService/getAllProjectList"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getDynamicKey,
             .walletTemplateList:
            return .get
        default:
            return .post
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Moya.Task {
        switch self {
        case .getDynamicKey,
             .walletTemplateList
            :
            return .requestParameters(parameters: [:], encoding: URLEncoding.default)
        case .login(let dict),
             .sendSmsCode(let dict),
             .verifyCode(let dict),
             .list(let dict),
             .callProject(let dict),
             .callWaiter(let dict),
             .getAllProjectList(let dict),
             .createWalletOrder(let dict),
             .walletOrderPay(let dict)
            :
            return .requestParameters(parameters: dict, encoding: JSONEncoding.default)
        case .uploadData(let fileName, let data),
             .uploadBase64(let fileName, let data)
            :
            print("data len: \(data.count)")
            return .uploadMultipart([MultipartFormData(provider: .data(data),
                                                       name: "file",
                                                       fileName: fileName,
                                                       mimeType: "application/octet-stream")])
            
        }
    }
    
    public var headers: [String : String]? {
        var headers : [String : String] = [:]
        headers["Content-Type"] = "application/json"
        if let user = getUser(), needToken() {
            let token = user.accessToken
            headers["accessToken"] = token
        }
        return headers
    }
    
    public var validationType: ValidationType {
        return .successCodes
    }
    
}
