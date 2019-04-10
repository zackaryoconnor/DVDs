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
            movieCoverImageView.loadImageUsingUrlString(urlstring: movieCoverImageUrl + movie.posterPath)
            movieTitleLabel.text = movie.title
        }
    }
    
    let movieCoverImageView = UIImageView(image: "", cornerRadius: 8)
    let movieTitleLabel = UILabel(text: "", textColor: .black, fontSize: 18, fontWeight: .medium, textAlignment: .left, numberOfLines: 1)
    let deleteButton = UIButton(title: "X")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let deleteButtonSize: CGFloat = 32
        deleteButton.backgroundColor = .red
        deleteButton.constrainWidth(constant: deleteButtonSize)
        deleteButton.constrainHeight(constant: deleteButtonSize)
        deleteButton.layer.cornerRadius = deleteButtonSize / 2
        deleteButton.setTitleColor(.white, for: .normal)
        
        movieCoverImageView.constrainWidth(constant: frame.width)
        movieCoverImageView.constrainHeight(constant: 246)
        
        let stackView = UIStackView(arrangedSubviews: [
            movieCoverImageView,
            movieTitleLabel
            ])
        
        addSubview(stackView)
        stackView.axis = .vertical
        stackView.fillSuperview()
        
        addSubview(deleteButton)
        deleteButton.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: -12, left: -12, bottom: 0, right: 0))
        deleteButton.isHidden = true
        deleteButton.isEnabled = false
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

