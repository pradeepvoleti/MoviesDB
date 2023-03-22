//
//  MovieCollectionViewCell.swift
//  MovieDB
//
//  Created by Ram Voleti on 28/02/21.
//

import UIKit
import Kingfisher

class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var favorite: UIButton!

    @IBAction func favoriteTapped(_ sender: UIButton) {
        
        let name = title.tag
        let tagString = "\(title.tag)"
        guard let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let imagepath = documentPath.appendingPathComponent("\(name).png")
        sender.isSelected = !sender.isSelected

        if sender.isSelected {
            guard let imageData = poster.image?.pngData() else { return }
            do {
                try imageData.write(to: imagepath)
            } catch {
                print(error)
            }
            var favoritesDict = UserDefaults.standard.dictionary(forKey: UserDefaultsKey.favorites) ?? [: ]
            favoritesDict[tagString] = title.text
            UserDefaults.standard.set(favoritesDict, forKey: UserDefaultsKey.favorites)
            
        } else {
            guard FileManager.default.fileExists(atPath: imagepath.relativePath) else { return }
            do {
                try FileManager.default.removeItem(at: imagepath)
            } catch {
                print(error)
            }
            guard var favoritesDict = UserDefaults.standard.dictionary(forKey: UserDefaultsKey.favorites)  else { return }
            favoritesDict[tagString] = nil
            UserDefaults.standard.set(favoritesDict, forKey: UserDefaultsKey.favorites)
        }
    }
    
    func setup(with model: NowPlayingModel) {
        title.text = model.title
        title.tag = model.tag
        poster.kf.setImage(with: model.url)
        favorite.isSelected = model.isFav
    }
}

extension UIColor {
    static var random: UIColor {
        return UIColor(red: .random(in: 0...1),
                       green: .random(in: 0...1),
                       blue: .random(in: 0...1),
                       alpha: 1.0)
    }
}

