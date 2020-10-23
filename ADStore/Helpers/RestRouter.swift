//
//  RestRouter.swift
//  ADStore
//
//  Created by Naji Kanounji on 10/22/20.
//  Copyright © 2020 Naji Kanounji. All rights reserved.
//

import Foundation

// Encode this no-id struct for POST, PUT requests

public enum PostRouter {
    
    // Possible requests
    case getAll
    case get(Int)
    case create(Ads)
    case update(Int, Ads)
    case delete(Int)
    
    // Base endpoint
    static var baseURLString = "http://127.0.0.1:3000/Ads/"
    
    // Set the method
    var method: String {
        // TODO: Return "GET", "POST", "PUT" or "DELETE", as appropriate
        switch self {
        case .getAll, .get: return "GET"
        case .create: return "POST"
        case .update: return "PUT"
        case .delete: return "DELETE"
        }
    }
    
    // Construct the request from url, method and parameters
    public func asURLRequest() -> URLRequest {
        // Build the request endpoint
        let url: URL = {
            let relativePath: String?
            // TODO: Set relativePath to use id, as appropriate
            switch self {
            case .getAll, .create: relativePath = ""
            case .get(let id), .update(let id, _), .delete(let id): relativePath = "\(id)"
            }
            
            var url = URL(string: PostRouter.baseURLString)!
            if let path = relativePath {
                url = url.appendingPathComponent(path)
            }
            return url
        }()
        
        // Set up request parameters
        let parameters: Ads? = {
            switch self {
            case .getAll, .get, .delete: return nil
            case .create(let post), .update(_, let post): return post
            }
        }()
        
        // Create request
        var request = URLRequest(url: url)
        // TODO: Set httpMethod
        request.httpMethod = method
        // TODO: Set HTTP header field content-type to application/json
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        // TODO: If there are parameters, and they can be converted to data, set httpBody
        guard let post = parameters else { return request }
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(post)
            request.httpBody = data
        } catch let errorEncoder as NSError {
            print("error from \(errorEncoder)")
        }
        
        return request
}
}
