//
//  Constants.swift
//  My Movies
//
//  Created by Zackary O'Connor on 1/18/19.
//  Copyright © 2019 Zackary O'Connor. All rights reserved.
//

import Foundation
import Firebase


let dvdsController = DvdsController()
let addNewDvdController = AddNewDvdController()
let welcomeController: WelcomeScreen = {
    let controller = WelcomeScreen()
    controller.modalPresentationStyle = .fullScreen
    return controller
}()


struct firebase {
    static let uid = Auth.auth().currentUser?.uid
    static let checkForConnectionReference = Database.database().reference(withPath: ".info/connected")
    static let databaseReference = Database.database().reference()
    static let usersReference = "users"
    static let dvdsReference = "dvds"
    static let accountDvdsReference = "account-dvds"
    static let currentUserEmail = Auth.auth().currentUser?.email
}


struct tmdb {
    static fileprivate let apiKey = "c74a05860eaa0b6c8f22aa1b8342691c"
    
    static let query = "&query="
    static let language = "&language=en-US"
    static let includeAdultContent = "&include_adult=false"
    
    static let dvdCoverImageUrl = "https://image.tmdb.org/t/p/w500/"
    static let dvdsUrl = "https://api.themoviedb.org/3/movie/popular?api_key=\(apiKey)\(language)"
    
    // movie only search url
    // static let baseSearchUrl = "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)\(language)\(query)"
    
    // multi search url
    static let baseSearchUrl = "https://api.themoviedb.org/3/search/multi?api_key=\(apiKey)\(language)\(query)"
    
    func updateSearchUrl(with searchQuery: String) -> String {
        let isSearchingUrl = tmdb.baseSearchUrl + searchQuery + tmdb.includeAdultContent
        return isSearchingUrl
    }
}
