//
//  AddNewMovieCell.swift
//  My Movies
//
//  Created by Zackary O'Connor on 1/18/19.
//  Copyright © 2019 Zackary O'Connor. All rights reserved.
//

import UIKit

class AddNewMovieCell: UICollectionViewCell {
    let activitityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    let movieCoverImageView = ImageViews(image: "")
    let movieTitleLabel = Labels(text: "test", textColor: .black, fontSize: 18, fontWeight: .medium, textAlignment: .left, numberOfLines: 2)
    let yearReleasedLabel = Labels(text: "09-03-2010", textColor: .lightGray, fontSize: 16, fontWeight: .regular, textAlignment: .left, numberOfLines: 1)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    func setupCell() {
        movieCoverImageView.backgroundColor = .lightGray
        [movieCoverImageView, movieTitleLabel, yearReleasedLabel].forEach { addSubview($0) }
        
        movieCoverImageView.addAnchors(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil, padding: .init(top: 8, left: 16, bottom: 8, right: 0), size: .init(width: 64, height: frame.height))
        
        movieTitleLabel.addAnchors(top: nil, leading: movieCoverImageView.trailingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 16))
        movieTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -10).isActive = true
        
        yearReleasedLabel.addAnchors(top: movieTitleLabel.bottomAnchor, leading: movieCoverImageView.trailingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 16))
        
//        movieCoverImageView.loadImageUsingUrlString(urlstring: moviesUrl)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

