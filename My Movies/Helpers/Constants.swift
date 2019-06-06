//
//  Constants.swift
//  My Movies
//
//  Created by Zackary O'Connor on 1/18/19.
//  Copyright © 2019 Zackary O'Connor. All rights reserved.
//

import Foundation
import Firebase

let firebaseReference = Database.database().reference().child("movies")

fileprivate let apiKey = "c74a05860eaa0b6c8f22aa1b8342691c"
let query = "&query="
let language = "&language=en-US"
let includeAdultContent = "&include_adult=false"

let movieCoverImageUrl = "https://image.tmdb.org/t/p/w500/"

let moviesUrl = "https://api.themoviedb.org/3/movie/popular?api_key=\(apiKey)\(language)"

let baseSearchUrl = "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)\(language)\(query)"

func updateSearchUrl(with searchQuery: String) -> String {
    let isSearchingUrl = baseSearchUrl + searchQuery + includeAdultContent
    return isSearchingUrl
}
