//
//  APIRequest.swift
//  ADStore
//
//  Created by Naji Kanounji on 10/22/20.
//  Copyright © 2020 Naji Kanounji. All rights reserved.
//
//  helper for generic requests (get && post)
import Foundation

enum APIError: Error {
    case responseProblem
    case decodingProblem
    case encodingProblem
}

struct APIRequest {
    let resourceURL: URL
    
    init(endpoint: String) {
        let baseURL = "http://192.168.1.18:3000/\(endpoint)"
        guard let resourceURL = URL(string: baseURL) else { fatalError() }
        self.resourceURL = resourceURL
    }
    
    
    //Generic task request function
    //return URLSessionTask so you can cancel it, to avoid multi task request while the internet is bad
    //using @discarableResult (to avoid error, unused return value)
    func genericGetRequest<ResponseType: Decodable>(response: ResponseType.Type, completion: @escaping(Result<ResponseType, APIError>) -> Void) {
        
        let task = URLSession.shared.dataTask(with: resourceURL) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(.responseProblem))
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(responseObject))
                }
            } catch {
                DispatchQueue.main.async {
//                    if let string = String(data: data, encoding: .utf8) { print(string)}
                    completion(.failure(.decodingProblem))
                }
            }
        }
        task.resume()
    }
    
    func genericPostRequest<RequestType: Encodable, ResponseType: Decodable>( body: RequestType, response: ResponseType.Type, completion:@escaping(Result<ResponseType, APIError>) -> Void) {
        
        do {
            var request = URLRequest(url: resourceURL)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONEncoder().encode(body)
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else {
                    DispatchQueue.main.async {
                        completion(.failure(.responseProblem))
                    }
                    return
                }
                let decoder = JSONDecoder()
                do {
                    let responseObject = try decoder.decode(ResponseType.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(responseObject))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(.decodingProblem))
                    }
                }
            }
            task.resume()
        } catch {
            completion(.failure(.encodingProblem))
        }
    }
}
