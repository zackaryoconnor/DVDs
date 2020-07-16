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
    let mediaType, title, name, releaseDate, firstAirDate, posterPath, backdropPath: String?
    
    private enum CodingKeys: String, CodingKey {
        case mediaType = "media_type"
        case releaseDate = "release_date"
        case firstAirDate = "first_air_date"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case id, title, name
    }
}
