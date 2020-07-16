//
//  Service.swift
//  My Movies
//
//  Created by Zackary O'Connor on 3/7/19.
//  Copyright © 2019 Zackary O'Connor. All rights reserved.
//

import Foundation

class Service {

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ///change all functions to static
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    static let shared = Service()
    
    func fetchDvds(url: String, completion: @escaping (WebsiteResultData?, Error?) ->  ()) {
        fetchGenericJsonData(urlString: url, completion: completion)
    }
    
    
    func fetchSearchedDvds(searchTerm: String, completion: @escaping (WebsiteResultData?, Error?) ->  ()) {
        let url = "\(tmdb.baseSearchUrl)\(searchTerm)\(tmdb.includeAdultContent)"
        fetchGenericJsonData(urlString: url, completion: completion)
    }
    
    
    func fetchGenericJsonData<T: Decodable>(urlString: String, completion: @escaping (T?, Error?) -> ()) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Failed to fetch apps:", error)
                completion(nil, error)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let object = try JSONDecoder().decode(T?.self, from: data)
                completion(object, nil)
            } catch let jsonError {
                print("Failed to decode json:", jsonError)
                completion(nil, jsonError)
            }
            } .resume()
    }
}
