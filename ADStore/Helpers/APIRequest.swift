//
//  APIRequest.swift
//  ADStore
//
//  Created by Naji Kanounji on 10/22/20.
//  Copyright © 2020 Naji Kanounji. All rights reserved.
//

import Foundation

enum APIError: Error {
    case responseProblem
    case decodingProblem
    case encodingProblem
}

struct APIRequest {
    let resourceURL: URL
    
    init(endpoint: String) {
        let resourceString = "http://127.0.0.1:3000/\(endpoint)"
        guard let resourceURL = URL(string: resourceString) else { fatalError() }
        self.resourceURL = resourceURL
    }
    
    func save(_ ads: Ads, completion: @escaping (Result<Ads, APIError>) -> Void) {
        do {
            var urlRequest = URLRequest(url: resourceURL)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-type")
            urlRequest.httpBody = try JSONEncoder().encode(ads)
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, _ in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201, let jsonData = data else {
                    completion(.failure(.responseProblem))
                    return
                }
                do {
                    let adsData = try JSONDecoder().decode(Ads.self, from: jsonData)
                    completion(.success(adsData))
                } catch {
                    completion(.failure(.decodingProblem))
                }
                
            }
            dataTask.resume()
        } catch {
            completion(.failure(.encodingProblem))
        }
    }
}
