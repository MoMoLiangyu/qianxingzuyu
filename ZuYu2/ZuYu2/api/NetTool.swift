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

enum Skill {
    case loumian
    case jishi
    case gudong
}

public enum NetTool {
    case getDynamicKey
    case login([String : Any])
    case refreshToken(String)
    case qxFloorRegistration([String : Any])
    case sendSmsCode([String : Any])
    case uploadData(String, Data)
    case uploadBase64(String, Data)
    
    /* 楼面端*/
    case achievements
    case createWalletOrder([String : Any])
    case walletOrderPay([String : Any])
    case walletTemplateList
    
    /* 技师端*/
    case callProject([String : Any])
    case callWaiter([String : Any])
    case getAllProjectList([String : Any])
    
    case getTechStatus
    
    case editTechInfo([String : Any])

    
}

extension NetTool: Moya.TargetType {
    public var baseURL: URL {
        return URL(string: serverUrl)!
    }
    
    public var path:String{
        var tempPath = self.pathBase
        if serverUrl.contains("192.168") || serverUrl.contains("qx08.cn"){
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
        case .refreshToken(let userType):
            return "/home/\(userType)"
        case .sendSmsCode:
            return "/common/sendSmsCode"
        case .qxFloorRegistration:
            return "/registration"
        case .uploadData:
            return "/file-manage/upload"
        case .uploadBase64:
            return "/file-manage/uploadBase64"
            
        /* 楼面端*/
        case .achievements:
            return "/home/achievements"
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
            
        case .getTechStatus:
//            return "/apiFloor/techStatus/getTechStatus"
            return "/techStatus/getTechStatus"
            
        case .editTechInfo:
//            return "/apiFloor/techInfo/editTechInfo"
            return "/techInfo/editTechInfo"
        
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getDynamicKey,
             .refreshToken,
             .achievements,
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
             .refreshToken,
             .achievements,
             .walletTemplateList,
             .getTechStatus
            :
            return .requestParameters(parameters: [:], encoding: URLEncoding.default)
        case .login(let dict),
             .sendSmsCode(let dict),
             .qxFloorRegistration(let dict),
             .callProject(let dict),
             .callWaiter(let dict),
             .getAllProjectList(let dict),
             .createWalletOrder(let dict),
             .walletOrderPay(let dict),
             .editTechInfo(let dict)
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
        if let user = getUser() {
            let token = user.accessToken
            headers["accessToken"] = token
        }
        return headers
    }
    
    public var validationType: ValidationType {
        return .successCodes
    }
    
}
