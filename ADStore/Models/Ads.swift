//
//  Ads.swift
//  ADStore
//
//  Created by Naji Kanounji on 8/31/20.
//  Copyright © 2020 Naji Kanounji. All rights reserved.
//

import Foundation
import UIKit

public struct Ads: Codable {
    var id: Int?
    let adsTitle: String?
    let adsDes: String?
    let adsDate: String?
//    let user: User?
    let adsPrice: String?
    let adsCondition: String?
    let adsCategory: String?
    let adsImages: [String]?
    
    enum CodingKeys: String, CodingKey {
        case adsTitle = "adsTitle"
        case adsDes = "adsDes"
        case adsDate = "adsDate"
//        case user = "user"
        case adsPrice = "adsPrice"
        case adsCondition = "adsCondition"
        case adsCategory = "adsCategory"
        case adsImages = "adsImages"
        case id = "id"
    }
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        adsCondition = try values.decodeIfPresent(String.self, forKey: .adsCondition)
        adsDate = try values.decodeIfPresent(String.self, forKey: .adsDate)
        adsDes = try values.decodeIfPresent(String.self, forKey: .adsDes)
        adsImages = try values.decodeIfPresent([String].self, forKey: .adsImages)
        adsPrice = try values.decodeIfPresent(String.self, forKey: .adsPrice)
        adsTitle = try values.decodeIfPresent(String.self, forKey: .adsTitle)
        adsCategory = try values.decodeIfPresent(String.self, forKey: .adsCategory)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        
    }
     init(adsTitle: String, adsDes: String, adsDate: String, adsPrice: String, adsCondition: String, adsCategory: String, adsImages: [String]) {
        
        self.adsTitle = adsTitle
        self.adsDes = adsDes
        self.adsDate = adsDate
//        self.t user: User?
        self.adsPrice = adsPrice
        self.adsCondition = adsCondition
        self.adsCategory = adsCategory
        self.adsImages = adsImages
        
    }
//      public init(adsTitle: String, adsDes: String, adsDate: String, adsPrice: String, adsCondition: String, adsCategory: String, adsImages: String) {
//
//            self.adsTitle = adsTitle
//            self.adsDes = adsDes
//            self.adsDate = adsDate
//    //        self.t user: User?
//            self.adsPrice = adsPrice
//            self.adsCondition = adsCondition
//            self.adsCategory = adsCategory
//            self.adsImages = adsImages
//            
//        }
}

struct User: Codable {
    let userName: String
    let userNumber: Int
    
    enum CodingKeys: String, CodingKey {
        case userName = "userName"
        case userNumber = "userNumber"
    }
}
