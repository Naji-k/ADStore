//
//  Category.swift
//  ADStore
//
//  Created by Naji Kanounji on 8/31/20.
//  Copyright © 2020 Naji Kanounji. All rights reserved.
//

import Foundation
/*
struct CategoryLocal: Codable {
    let id: Int
    let catName: String
    let catImage: String
    let subCat: [SubCategory]?
    
    init(id: Int, catName: String, catImage: String, subCat: [SubCategory]?) {
        self.id = id
        self.catName = catName
        self.catImage = catImage
        self.subCat = subCat
    }


}
 */

struct RootClass : Codable {
    
    var category : [Category]?
    
    enum CodingKeys: String, CodingKey {
        case category = "Category"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        category = try values.decodeIfPresent([Category].self, forKey: .category)
    }
    
}

//last Version just to load category and subcategory without ads
struct CategoryList: Codable {
    let category: [Category]

    enum CodingKeys: String, CodingKey {
        case category = "Category"
    }
}

// MARK: - Category
struct Category: Codable {
    let id: Int?
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
/*
 full version with Ads (for now it is still not working)..
struct Category : Codable {
    
    let id: Int?
    let name: String?
    let image: String?
    let subCategory: [SubCategory]?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case image = "image"
        case subCategory = "subCategory"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        subCategory = try values.decodeIfPresent([SubCategory].self, forKey: .subCategory)
        
    }
}

struct SubCategory: Codable {
    let id: Int?
    let subName: String?
    let subImage: String?
//    let ads: [Ads]?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case subImage = "image"
        case subName = "name"
//        case ads = "ads"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        subName = try values.decodeIfPresent(String.self, forKey: .subName)
        subImage = try values.decodeIfPresent(String.self, forKey: .subImage)
//        ads = try values.decodeIfPresent([Ads].self, forKey: .ads)
    }
}

*/
