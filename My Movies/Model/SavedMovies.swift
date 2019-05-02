//
//  SavedMovies.swift
//  My Movies
//
//  Created by Zackary O'Connor on 4/10/19.
//  Copyright © 2019 Zackary O'Connor. All rights reserved.
//

import UIKit

struct SavedMovies: Decodable {
    let id: Int
    let title, posterPath: String
}
