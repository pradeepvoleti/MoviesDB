//
//  NowPlayingViewModel.swift
//  MovieDB
//
//  Created by Ram Voleti on 28/02/21.
//

import Foundation
import PromiseKit
import Reachability

class NowPlayingViewModel {

    var reload: Dynamic<Bool> = Dynamic(false)
    var showLoader: Dynamic<Bool> = Dynamic(false)
    var showError: Dynamic<Error?> = Dynamic(nil)
    
    var noOfMovies: Int {
        if getLocal {
            return localModel.count
        } else {
            return model?.movies.count ?? 0
        }
    }
    
    var currentPage: Int = 1

    var model: NowPlaying?
    var localModel: [NowPlayingModel] = []
    let service: NowPlayingServiceType.Type
    let reachability = try! Reachability()
    var getLocal: Bool = false

    init(service: NowPlayingServiceType.Type = NowPlayingService.self) {

        self.service = service
    }

    func viewDidLoadCalled() {
        do {
            if reachability.connection == .unavailable {
                getLocal = true
                localModel = getLocalInfo()
                reload.value = true
            } else {
                getLocal = false
                fetchAllMovies()
            }
        } catch {
            print(error)
        }
    }
    
    func fetchNextSetOfMovies() {
        currentPage += 1
        fetchAllMovies(at: currentPage)
    }
    func canScroll() -> Bool {
        guard let totalPages = model?.totalPages else { return false }
        return currentPage <= totalPages
    }
    
    func getInfo(at index: Int) -> NowPlayingModel? {
        if getLocal {
            return localModel[index]
        } else {
            
            guard let tag = model?.movies[index].idNum,
                  let title = model?.movies[index].title,
                  let path = model?.movies[index].posterPath else { return nil }
            let urlString = Urls.posters.rawValue + "/w780" + path
            guard let url = URL(string: urlString) else { return nil }
            let model = NowPlayingModel(tag: tag, title: title, url: url, isFav: isFavorite(id: tag))
            return model
        }
    }
}

private extension NowPlayingViewModel {

    func fetchAllMovies(at page: Int = 1) {
        service.getAllMovies(apiKey: Config.apiKey.rawValue, page: page).done { model in
            if self.model != nil {
                self.model?.movies.append(contentsOf: model.movies)
            } else {
                self.model = model
            }
            self.reload.value = true
        }.catch { error in
            self.reload.value = true
        }
    }
    
    func isFavorite(id: Int) -> Bool {
        do {
            guard let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return false }
            let arr = try FileManager.default.contentsOfDirectory(at: documentPath, includingPropertiesForKeys: nil, options: .skipsSubdirectoryDescendants)
            let values = arr.map { $0.relativePath.components(separatedBy: "/").last?.components(separatedBy: ".").first }
            let flag = values.contains("\(id)")
            return flag
        } catch {
            print(error)
        }
        return false
    }
    
    func getLocalInfo() -> [NowPlayingModel] {

        do {
            guard let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first,
                  let favoritesDict = UserDefaults.standard.dictionary(forKey: UserDefaultsKey.favorites) as? [String: String] else { return [] }

            let arr = try FileManager.default.contentsOfDirectory(at: documentPath, includingPropertiesForKeys: nil, options: .skipsSubdirectoryDescendants)
            let model = arr.compactMap { url -> NowPlayingModel? in
                guard let tagString = url.relativePath.components(separatedBy: "/").last?.components(separatedBy: ".").first,
                      let tag = Int(tagString),
                      let name = favoritesDict[tagString] else { return  nil }

                let model = NowPlayingModel(tag: tag, title: name, url: url, isFav: true)
                return model
            }
            return model
        } catch {
            print(error)
        }
        return []
    }
}
struct NowPlayingModel {
    let tag: Int
    let title: String
    let url: URL
    let isFav: Bool
}
