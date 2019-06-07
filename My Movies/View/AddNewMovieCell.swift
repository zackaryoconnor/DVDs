//
//  AddNewMovieCell.swift
//  My Movies
//
//  Created by Zackary O'Connor on 1/18/19.
//  Copyright © 2019 Zackary O'Connor. All rights reserved.
//

import UIKit
import Firebase

class AddNewMovieCell: UICollectionViewCell {
    
    var movie: Results! {
        didSet {
            guard let posterPath = movie.posterPath else { return }
            
            movieCoverImageView.loadImageUsingUrlString(urlString: movieCoverImageUrl + posterPath)
            movieTitleLabel.text = movie.title
            
            let dateReleased = movie.releaseDate
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            if let date = formatter.date(from: dateReleased ?? "") {
                let displayFormatter = DateFormatter()
                displayFormatter.dateFormat = "yyyy"
                yearReleasedLabel.text = displayFormatter.string(from: date)
            }
        }
        
    }
    
    
    override var isSelected: Bool {
        didSet {
            
            if isSelected == true {
                movieTitleLabel.textColor = .red
                isUserInteractionEnabled = false
            } else {
                movieTitleLabel.textColor = .black
            }
            
        }
        
    }
    
    
    
    let movieCoverImageView = UIImageView(image: "", cornerRadius: 4)
    let movieTitleLabel = UILabel(text: "", textColor: .black, fontSize: 18, fontWeight: .medium, textAlignment: .left, numberOfLines: 2)
    let yearReleasedLabel = UILabel(text: "", textColor: .lightGray, fontSize: 16, fontWeight: .regular, textAlignment: .left, numberOfLines: 1)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        movieCoverImageView.constrainHeight(constant: frame.height)
        movieCoverImageView.constrainWidth(constant: 64)
        
        let movieTitleAndDateStackView = UIStackView(arrangedSubviews: [
            movieTitleLabel,
            yearReleasedLabel
            ])
        
        movieTitleAndDateStackView.axis = .vertical
        
        let movieStackView = UIStackView(arrangedSubviews: [
            movieCoverImageView,
            movieTitleAndDateStackView
            ])
        
        addSubview(movieStackView)
        movieStackView.fillSuperview(padding: .init(top: 8, left: 16, bottom: 8, right: 16))
        movieStackView.spacing = 8
        movieStackView.alignment = .center
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
