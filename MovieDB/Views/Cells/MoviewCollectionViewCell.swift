//
//  MovieCollectionViewCell.swift
//  MovieDB
//
//  Created by Ram Voleti on 28/02/21.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var favorite: UIButton!
    
    @IBAction func favoriteTapped(_ sender: Any) {
        
    }
}
