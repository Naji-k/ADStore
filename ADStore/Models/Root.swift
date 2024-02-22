//
//  Category.swift
//  ADStore
//
//  Created by Naji Kanounji on 8/31/20.
//  Copyright © 2020 Naji Kanounji. All rights reserved.
//

import Foundation


struct Root : Codable {
    
    var category : [Category]?
        
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        category = try values.decodeIfPresent([Category].self, forKey: .category)
    }
    
}


// MARK: - Category
struct Category: Codable {
    let id: String?
    let name, image: String?
    let subCategory: [SubCategory]?
}

struct SubCategory: Codable {
    let id: Int?
    let subName: String?
    let subImage: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case subImage = "image"
        case subName = "name"
    }
}

