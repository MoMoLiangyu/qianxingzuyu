//
//  AchievementsBean.swift
//  Model Generated using http://www.jsoncafe.com/
//  Created on September 20, 2020

import Foundation

struct AchievementsBean : Codable {
    
        let jdkf : Int?//接待客房
        let kdjj : Int?//客单均价
        let krsl : Int?//客人数量
        let skyj : Int?//售卡业绩
        let spyj : Int?//商品业绩
        let xcyj : Int?//续卡业绩
        let xmyj : Int?//项目业绩
        let xzhy : Int?//新增会员

        enum CodingKeys: String, CodingKey {
                case jdkf = "jdkf"
                case kdjj = "kdjj"
                case krsl = "krsl"
                case skyj = "skyj"
                case spyj = "spyj"
                case xcyj = "xcyj"
                case xmyj = "xmyj"
                case xzhy = "xzhy"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                jdkf = try values.decodeIfPresent(Int.self, forKey: .jdkf)
                kdjj = try values.decodeIfPresent(Int.self, forKey: .kdjj)
                krsl = try values.decodeIfPresent(Int.self, forKey: .krsl)
                skyj = try values.decodeIfPresent(Int.self, forKey: .skyj)
                spyj = try values.decodeIfPresent(Int.self, forKey: .spyj)
                xcyj = try values.decodeIfPresent(Int.self, forKey: .xcyj)
                xmyj = try values.decodeIfPresent(Int.self, forKey: .xmyj)
                xzhy = try values.decodeIfPresent(Int.self, forKey: .xzhy)
        }

}
