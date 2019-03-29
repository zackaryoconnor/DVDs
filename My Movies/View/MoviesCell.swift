//
//  MoviesCell.swift
//  My Movies
//
//  Created by Zackary O'Connor on 1/18/19.
//  Copyright © 2019 Zackary O'Connor. All rights reserved.
//

import UIKit

class MoviesCell: UICollectionViewCell {
    
    var movie: Results! {
        didSet {
            guard let posterPath = movie.posterPath else { return }
            
            movieCoverImageView.loadImageUsingUrlString(urlstring: movieCoverImageUrl + posterPath)
            movieTitleLabel.text = movie.title
        }
    }
    
    let movieCoverImageView = UIImageView(image: "", cornerRadius: 8)
    let movieTitleLabel = UILabel(text: "", textColor: .black, fontSize: 24, fontWeight: .semibold, textAlignment: .left, numberOfLines: 0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        movieCoverImageView.constrainWidth(constant: frame.width)
        movieCoverImageView.constrainHeight(constant: 235)
        
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

