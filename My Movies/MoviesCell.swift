//
//  MoviesCell.swift
//  My Movies
//
//  Created by Zackary O'Connor on 1/18/19.
//  Copyright © 2019 Zackary O'Connor. All rights reserved.
//

import UIKit

class MoviesCell: UICollectionViewCell {
    let movieCoverImageView = ImageViews(image: "")
    let movieTitleLabel = Labels(text: "test", textColor: .black, fontSize: 24, fontWeight: .semibold, textAlignment: .center, numberOfLines: 2)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    func setupCell() {
        movieCoverImageView.backgroundColor = .lightGray
        [movieCoverImageView, movieTitleLabel].forEach { addSubview($0) }
        
        movieCoverImageView.addAnchors(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .zero, size: .init(width: frame.width, height: 225))
        
        movieTitleLabel.addAnchors(top: movieCoverImageView.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 8, left: 0, bottom: 0, right: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
