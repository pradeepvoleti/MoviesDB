//
//  Constants.swift
//  MovieDB
//
//  Created by Ram Voleti on 28/02/21.
//

import Foundation

enum CellIdentifiers: String {
    case movieCell
}

enum Segue: String {
    case tempSegue
}

enum Urls: String {
    case api = "https://api.themoviedb.org/3"
    case posters = "http://image.tmdb.org/t/p"
}

enum Config: String {
    case apiKey = "34c902e6393dc8d970be5340928602a7"
}

struct UserDefaultsKey {
    static let favorites = "favorites"
}
