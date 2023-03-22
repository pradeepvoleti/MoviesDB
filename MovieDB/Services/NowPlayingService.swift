//
//  NowPlayingService.swift
//  MovieDB
//
//  Created by Ram Voleti on 28/02/21.
//

import Foundation
import PromiseKit

protocol NowPlayingServiceType {
    static func getAllMovies(apiKey: String, page: Int) -> Promise<NowPlaying>
}

struct NowPlayingService: NowPlayingServiceType {

    private enum Path: String {
        case getAll = "/movie/now_playing?api_key=%@&page=%i"
    }

    static var service: NetworkDispatcher.Type = BaseNetworkDispatcher.self

    static func getAllMovies(apiKey: String, page: Int) -> Promise<NowPlaying> {

        let path = String(format: Path.getAll.rawValue, apiKey, page)
        let request = BaseRequest(path: path)
        service.network.domain = Urls.api.rawValue
        return service.execute(request: request, for: NowPlaying.self).compactMap { $0 }
    }
}
