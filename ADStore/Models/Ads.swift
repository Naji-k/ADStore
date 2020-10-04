//
//  Ads.swift
//  ADStore
//
//  Created by Naji Kanounji on 8/31/20.
//  Copyright © 2020 Naji Kanounji. All rights reserved.
//

import Foundation

struct Ads: Codable {
    let adsId: Int?
    let adsTitle: String?
    let adsDes: String?
    let adsDate: String?
//    let user: User?
    let adsPrice: String?
    let adsCondition: String?
    let adsImages: String?
    
    enum CodingKeys: String, CodingKey {
        case adsId = "adsId"
        case adsTitle = "adsTitle"
        case adsDes = "adsDes"
        case adsDate = "adsDate"
//        case user = "user"
        case adsPrice = "adsPrice"
        case adsCondition = "adsCondition"
        case adsImages = "adsImages"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        adsCondition = try values.decodeIfPresent(String.self, forKey: .adsCondition)
        adsDate = try values.decodeIfPresent(String.self, forKey: .adsDate)
        adsDes = try values.decodeIfPresent(String.self, forKey: .adsDes)
        adsId = try values.decodeIfPresent(Int.self, forKey: .adsId)
        adsImages = try values.decodeIfPresent(String.self, forKey: .adsImages)
        adsPrice = try values.decodeIfPresent(String.self, forKey: .adsPrice)
        adsTitle = try values.decodeIfPresent(String.self, forKey: .adsTitle)
    }
}

struct User: Codable {
    let userName: String
    let userNumber: Int
    
    enum CodingKeys: String, CodingKey {
        case userName = "userName"
        case userNumber = "userNumber"
    }
}
