//
//  TechStatusModel.swift
//  ZuYu2
//
//  Created by 默凉雨 on 2021/6/20.
//  Copyright © 2021 million. All rights reserved.
//

import Foundation

struct TechStatusModel : Codable {
    //项目的加钟时间(分钟)
    let addTimes : Int?
    //派单人
    let appointUser : String?
    //服务账单id
    let billId : Int?
    //派单时间
    let createTime : String?
    
    //是否当前班次 0=否 1= 是
    let isCurrentWork : Int?
    //项目类型 类型 0=主项项目 1=商品 2=售卡 3=副项项目 4=买钟
    let itemType : Int?
    //技师姓名
    let name : String?
    //昵称
    let nickName : String?
    
    //加钟的父账单id
    let parentBillId : Int?
    //服务中的项目id
    let projectId : Int?
    //服务中的项目名称
    let projectName : String?
    //项目状态 0= 等待技师 1 = 上钟 2 = 下钟
    let projectStatus : Int?
    
    //技师加钟数量
    let quantity : Int?
    let roomCode : String?
    let roomId : Int?
    let roomName : String?
    
    //服务中的项目时长
    let serviceTimes : Int?
    //服务剩余时间（秒）
    let surplusTimes : Int?
    //服务上钟时间
    let szTime : String?
    //上钟类型 1=轮钟；2=点钟；3=call钟；4=选钟，挑牌；5 =预约钟；6=加钟
    let szType : Int?

    //技师Id
    let techId : Int?
    //技师编号
    let techNo : String?
    //技师状态 0=打头牌(空闲）1=空闲 2=预约 3=待钟 4=上钟 5=盖牌 6=加钟
    let techStatus : Int?
    //技师预下钟时间
    let techXzTime : String?
 
    //服务超时时间（秒）
    let timeOut : Int?
    //服务下钟时间
    let xzTime : String?
    //已等待时间(秒)
    let waitTimes : Int?

    enum CodingKeys: String, CodingKey {
        case addTimes = "addTimes"
        case appointUser = "appointUser"
        case billId = "billId"
        case createTime = "createTime"

        case isCurrentWork = "isCurrentWork"
        case itemType = "itemType"
        case name = "name"
        case nickName = "nickName"
        
        case parentBillId = "parentBillId"
        case projectId = "projectId"
        case projectName = "projectName"
        case projectStatus = "projectStatus"
        
        case quantity = "quantity"
        case roomCode = "roomCode"
        case roomId = "roomId"
        case roomName = "roomName"
        
        case serviceTimes = "serviceTimes"
        case surplusTimes = "surplusTimes"
        case szTime = "szTime"
        case szType = "szType"
    
        case techId = "techId"
        case techNo = "techNo"
        case techStatus = "techStatus"
        case techXzTime = "techXzTime"
  
        case timeOut = "timeOut"
        case xzTime = "xzTime"
        case waitTimes = "waitTimes"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        addTimes = try values.decodeIfPresent(Int.self, forKey: .addTimes)
        appointUser = try values.decodeIfPresent(String.self, forKey: .appointUser)
        billId = try values.decodeIfPresent(Int.self, forKey: .billId)
        createTime = try values.decodeIfPresent(String.self, forKey: .createTime)
        
        isCurrentWork = try values.decodeIfPresent(Int.self, forKey: .isCurrentWork)
        itemType = try values.decodeIfPresent(Int.self, forKey: .itemType)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        nickName = try values.decodeIfPresent(String.self, forKey: .nickName)

        parentBillId = try values.decodeIfPresent(Int.self, forKey: .parentBillId)
        projectId = try values.decodeIfPresent(Int.self, forKey: .projectId)
        projectName = try values.decodeIfPresent(String.self, forKey: .projectName)
        projectStatus = try values.decodeIfPresent(Int.self, forKey: .projectStatus)

        quantity = try values.decodeIfPresent(Int.self, forKey: .quantity)
        roomCode = try values.decodeIfPresent(String.self, forKey: .roomCode)
        roomId = try values.decodeIfPresent(Int.self, forKey: .roomId)
        roomName = try values.decodeIfPresent(String.self, forKey: .roomName)

        serviceTimes = try values.decodeIfPresent(Int.self, forKey: .serviceTimes)
        surplusTimes = try values.decodeIfPresent(Int.self, forKey: .surplusTimes)
        szTime = try values.decodeIfPresent(String.self, forKey: .szTime)
        szType = try values.decodeIfPresent(Int.self, forKey: .szType)
   
        techId = try values.decodeIfPresent(Int.self, forKey: .techId)
        techNo = try values.decodeIfPresent(String.self, forKey: .techNo)
        techStatus = try values.decodeIfPresent(Int.self, forKey: .techStatus)
        techXzTime = try values.decodeIfPresent(String.self, forKey: .techXzTime)
    
        timeOut = try values.decodeIfPresent(Int.self, forKey: .timeOut)
        xzTime = try values.decodeIfPresent(String.self, forKey: .xzTime)
        waitTimes = try values.decodeIfPresent(Int.self, forKey: .waitTimes)
  
    }
}

