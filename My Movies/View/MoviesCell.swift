//
//  MoviesCell.swift
//  My Movies
//
//  Created by Zackary O'Connor on 1/18/19.
//  Copyright © 2019 Zackary O'Connor. All rights reserved.
//

import UIKit

class MoviesCell: UICollectionViewCell {

    var movie: SavedMovies! {
        didSet {
            movieCoverImageView.loadImageUsingUrlString(urlString: movieCoverImageUrl + movie.posterPath)
            movieTitleLabel.text = movie.title
        }
    }
    
    let movieCoverImageView = UIImageView(image: "", cornerRadius: 6)
    let movieTitleLabel = UILabel(text: "", textColor: .black, fontSize: 17, fontWeight: .medium, textAlignment: .left, numberOfLines: 1)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        movieCoverImageView.layer.borderColor = UIColor(red:0.80, green:0.80, blue:0.81, alpha:0.75).cgColor
        movieCoverImageView.layer.borderWidth = 0.5
        movieCoverImageView.constrainWidth(constant: frame.width)
        movieCoverImageView.constrainHeight(constant: 246)
        
        let stackView = UIStackView(arrangedSubviews: [
            movieCoverImageView,
            movieTitleLabel
            ])
        
        addSubview(stackView)
        stackView.axis = .vertical
        stackView.fillSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

