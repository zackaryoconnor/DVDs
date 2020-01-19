//
//  DvdsCell.swift
//  My Movies
//
//  Created by Zackary O'Connor on 1/18/19.
//  Copyright © 2019 Zackary O'Connor. All rights reserved.
//

import UIKit

class DvdsCell: UICollectionViewCell {
    
    override var isHighlighted: Bool {
        didSet {
            redView.isHidden = !isHighlighted
        }
    }
    
    override var isSelected: Bool {
        didSet {
            redView.isHidden = !isSelected
            checkmarkImageView.isHidden = !isSelected
        }
    }
    
    var dvd: SavedDvds! {
        didSet {
            guard let posterPath = dvd.posterPath else { return }
            
            movieCoverImageView.loadImageUsingUrlString(urlString: movieCoverImageUrl + posterPath)
                
            movieTitleLabel.text = dvd.title
            
            
        }
    }
    
    
    let movieCoverImageView: CustomImageView = {
        let imageView = CustomImageView(image: "", cornerRadius: 6)
        return imageView
    }()
    
    let movieTitleLabel = UILabel(text: "", textColor: .label, fontSize: 17, fontWeight: .medium, textAlignment: .left, numberOfLines: 1)
    let checkmarkImageView = UIImageView(image: UIImage(systemName: "checkmark.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 24, weight: .black, scale: .large)))
    let redView = UIView(backgroundColor: UIColor.systemRed.withAlphaComponent(0.7))
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let posterHeight = frame.height - movieTitleLabel.frame.height - 36
        movieCoverImageView.constrainWidth(constant: frame.width)
        movieCoverImageView.constrainHeight(constant: posterHeight)
        movieCoverImageView.addSubview(redView)
        
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
        checkmarkImageView.isHidden = true
        checkmarkImageView.tintColor = .white
        checkmarkImageView.translatesAutoresizingMaskIntoConstraints = false
        
        redView.isHidden = true
        
        [redView, checkmarkImageView].forEach { movieCoverImageView.addSubview($0) }
        redView.fillSuperview()
        checkmarkImageView.centerXInSuperview()
        checkmarkImageView.bottomAnchor.constraint(equalTo: movieCoverImageView.bottomAnchor, constant: -16).isActive = true
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
