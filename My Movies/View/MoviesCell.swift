//
//  MoviesCell.swift
//  My Movies
//
//  Created by Zackary O'Connor on 1/18/19.
//  Copyright © 2019 Zackary O'Connor. All rights reserved.
//

import UIKit

class MoviesCell: UICollectionViewCell {

    
    override var isHighlighted: Bool {
        didSet {
            highlightedView.isHidden = !isHighlighted
        }
    }
    
    override var isSelected: Bool {
        didSet {
            highlightedView.isHidden = !isSelected
            checkmarkLabel.isHidden = !isSelected
        }
    }
    
    
    var movie: SavedMovies! {
        didSet {
            movieCoverImageView.loadImageUsingUrlString(urlString: movieCoverImageUrl + movie.posterPath)
            movieTitleLabel.text = movie.title
        }
    }
    
    
    let movieCoverImageView = UIImageView(image: "", cornerRadius: 6)
    let movieTitleLabel = UILabel(text: "", textColor: .label, fontSize: 17, fontWeight: .medium, textAlignment: .left, numberOfLines: 1)
    
    let highlightedView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.red.withAlphaComponent(0.5)
        view.isHidden = true
        return view
    }()
    
    let checkmarkLabel = UILabel(text: "✔︎", textColor: .black, fontSize: 64, fontWeight: .semibold, textAlignment: .center, numberOfLines: 0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        movieCoverImageView.layer.borderColor = UIColor(red:0.80, green:0.80, blue:0.81, alpha:0.75).cgColor
//        movieCoverImageView.layer.borderWidth = 0.5
        movieCoverImageView.constrainWidth(constant: frame.width)
        movieCoverImageView.constrainHeight(constant: 246)
        
        let stackView = UIStackView(arrangedSubviews: [
            movieCoverImageView,
            movieTitleLabel
            ])
        
        addSubview(stackView)
        stackView.axis = .vertical
        stackView.fillSuperview()
        
        setupSelectedCell()
    }
    
    
    func setupSelectedCell() {
        checkmarkLabel.isHidden = true
        
        [highlightedView, checkmarkLabel].forEach { addSubview($0) }
        highlightedView.fillSuperview()
        checkmarkLabel.centerInSuperview()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

