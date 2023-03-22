//
//  NowPlaying.swift
//  MovieDB
//
//  Created by Ram Voleti on 28/02/21.
//

import Foundation

struct NowPlaying: Codable {
    let page: Int
    var movies: [Movie]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case movies = "results"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct Movie: Codable {
    let idNum: Int
    let title: String
    let posterPath: String
    
    enum CodingKeys: String, CodingKey {
        case idNum = "id"
        case title
        case posterPath = "poster_path"
    }
}
