//
//  Service.swift
//  My Movies
//
//  Created by Zackary O'Connor on 3/7/19.
//  Copyright © 2019 Zackary O'Connor. All rights reserved.
//

import Foundation

class Service {
    static let shared = Service()
    
    func fetchMovies(url: String, completion: @escaping ([Results], Error?) ->  ()) {
        let urlString = url
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Failed to fetch apps:", error)
                completion([], nil)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let movieResults = try JSONDecoder().decode(WebsiteResultData.self, from: data)
                completion(movieResults.results, nil)
            } catch let jsonError {
                print("Failed to decode json:", jsonError)
                completion([], jsonError)
            }
        } .resume()
    }
}
