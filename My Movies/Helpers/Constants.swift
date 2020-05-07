//
//  Constants.swift
//  My Movies
//
//  Created by Zackary O'Connor on 1/18/19.
//  Copyright © 2019 Zackary O'Connor. All rights reserved.
//

import Foundation
import Firebase


enum EditMode {
    case notEditing
    case isEditing
}




struct firebase {
    
}

let uid = Auth.auth().currentUser?.uid

let firebaseCheckForConnectionReference = Database.database().reference(withPath: ".info/connected")
let firebaseDatabaseReference = Database.database().reference()
let firebaseUsersReference = "users"
let firebaseMoviesReference = "movies"
let firebaseAccountMoviesReference = "account-movies"
let firebaseCurrentUserEmail = Auth.auth().currentUser?.email



fileprivate let apiKey = "c74a05860eaa0b6c8f22aa1b8342691c"
let query = "&query="
let language = "&language=en-US"
let includeAdultContent = "&include_adult=false"

struct tmdb {
    
}

let movieCoverImageUrl = "https://image.tmdb.org/t/p/w500/"
let moviesUrl = "https://api.themoviedb.org/3/movie/popular?api_key=\(apiKey)\(language)"
// movie only search url
let baseSearchUrl = "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)\(language)\(query)"
// multi search url
//let baseSearchUrl = "https://api.themoviedb.org/3/search/multi?api_key=\(apiKey)\(language)\(query)"


func updateSearchUrl(with searchQuery: String) -> String {
    let isSearchingUrl = baseSearchUrl + searchQuery + includeAdultContent
    return isSearchingUrl
}
