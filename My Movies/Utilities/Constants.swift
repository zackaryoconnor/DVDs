//
//  Constants.swift
//  My Movies
//
//  Created by Zackary O'Connor on 1/18/19.
//  Copyright © 2019 Zackary O'Connor. All rights reserved.
//

import Foundation

private let apiKey = "c74a05860eaa0b6c8f22aa1b8342691c"
let searchContent = "&query="
let includeAdultContent = "&include_adult=false"

let moviesUrl = "https://api.themoviedb.org/3/movie/popular?api_key=\(apiKey)&language=en-US"

let baseSearchUrl = "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&language=en-US"
let isSearchingUrl = "\(baseSearchUrl)\(searchContent)"

let movieCoverImageUrl = "https://image.tmdb.org/t/p/w500/"
