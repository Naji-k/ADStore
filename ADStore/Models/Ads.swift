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
    let userId: String?
    let adsPrice: String?
    let adsCondition: String?
    let adsCategory: String?
    let adsImages: [String]?
    let latitude: Double?
    let longitude: Double?
    let location: String?
    
    enum CodingKeys: String, CodingKey {
        case adsTitle = "adsTitle"
        case adsDes = "adsDes"
        case adsDate = "adsDate"
        case userId = "userId"
        case adsPrice = "adsPrice"
        case adsCondition = "adsCondition"
        case adsCategory = "adsCategory"
        case adsImages = "adsImages"
        case id = "id"
        case latitude = "latitude"
        case longitude = "longitude"
        case location = "location"
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
        userId = try values.decodeIfPresent(String.self, forKey: .userId)
        latitude = try values.decodeIfPresent(Double.self, forKey: .latitude)
        longitude = try values.decodeIfPresent(Double.self, forKey: .longitude)
        location = try values.decodeIfPresent(String.self, forKey: .location)
        
    }
    init(id: Int,adsTitle: String, adsDes: String, adsDate: String, userId: String, adsPrice: String, adsCondition: String, adsCategory: String, adsImages: [String], latitude: Double, longitude: Double, location: String) {
        self.id = id
        self.adsTitle = adsTitle
        self.adsDes = adsDes
        self.adsDate = adsDate
        self.userId = userId
        self.adsPrice = adsPrice
        self.adsCondition = adsCondition
        self.adsCategory = adsCategory
        self.adsImages = adsImages
        self.latitude = latitude
        self.longitude = longitude
        self.location = location
        
    }
}

class User: NSObject {
    var id: String?
    var userFName: String?
    var userEmail: String?
    var profileImageUrl: String?
    var createdDate: NSNumber?
    
    init(dictionary: [String: AnyObject]) {
        self.id = dictionary["id"] as? String
        self.userFName = dictionary["userFName"] as? String
        self.userEmail = dictionary["userEmail"] as? String
        self.profileImageUrl = dictionary["profileImageUrl"] as? String
        self.createdDate = dictionary["createdDate"] as? NSNumber
    }
    
}
