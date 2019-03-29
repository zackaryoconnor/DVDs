//
//  Results.swift
//  My Movies
//
//  Created by Zackary O'Connor on 1/18/19.
//  Copyright © 2019 Zackary O'Connor. All rights reserved.
//

import UIKit

struct WebsiteResultData: Decodable {
    let results: [Results]
}

struct Results: Decodable {
    let id: Int?
    let posterPath: String?
    let title: String?
    let releaseDate: String?
    
    private enum CodingKeys: String, CodingKey {
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case id, title
    }
}

