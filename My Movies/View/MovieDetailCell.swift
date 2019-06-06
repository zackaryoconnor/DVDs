//
//  MovieDetailCell.swift
//  My Movies
//
//  Created by Zackary O'Connor on 5/7/19.
//  Copyright © 2019 Zackary O'Connor. All rights reserved.
//

import UIKit

class MovieDetailCell: UICollectionViewCell {
        
    let moviesCell = MoviesCell()
    
    let moviePoster = UIImageView(image: "", cornerRadius: 0)
    let title = UILabel(text: "test", textColor: .black, fontSize: 18, fontWeight: .regular, textAlignment: .center, numberOfLines: 0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .orange
        
        [moviePoster, title].forEach { addSubview($0) }
        
        moviePoster.centerInSuperview()
        title.centerInSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

