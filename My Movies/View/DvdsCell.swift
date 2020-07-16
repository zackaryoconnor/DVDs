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
            guard let backdropPath = dvd.backdropPath else { return }
            
            dvdCoverImageView.loadImageUsingUrlString(urlString: tmdb.dvdCoverImageUrl + posterPath)
            
            if dvd.mediaType == "tv" {
                dvdTitleLabel.text = dvd.name
            } else {
                dvdTitleLabel.text = dvd.title
            }
        }
    }
    
    static let identifier = "dvdsCellIdentifier"
    
    let dvdCoverImageView: CustomImageView = {
        let imageView = CustomImageView(cornerRadius: 6)
        imageView.backgroundColor = .systemGray2
        imageView.layer.borderColor = UIColor.black.withAlphaComponent(0.16).cgColor
        imageView.layer.borderWidth = 0.5
        return imageView
    }()
    
    let dvdTitleLabel = UILabel(fontWeight: .medium, numberOfLines: 1)
    let checkmarkImageView = UIImageView(image: UIImage(systemName: "checkmark.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 24, weight: .black, scale: .large)))
    let redView = UIView(backgroundColor: UIColor.systemRed.withAlphaComponent(0.7))
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        dvdCoverImageView.constrainWidth(constant: 164.67)
        dvdCoverImageView.constrainHeight(constant: 247)
        dvdCoverImageView.clipsToBounds = true
        dvdCoverImageView.addSubview(redView)
        
        let stackView = UIStackView(arrangedSubviews: [dvdCoverImageView,
                                                       dvdTitleLabel])
        
        addSubview(stackView)
        stackView.axis = .vertical
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        ///fix vertical alignment
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        stackView.fillSuperview()
        
        setupSelectedCell()
    }
    
    
    func setupSelectedCell() {
        checkmarkImageView.isHidden = true
        checkmarkImageView.tintColor = .white
        checkmarkImageView.translatesAutoresizingMaskIntoConstraints = false
        
        redView.isHidden = true
        
        [redView, checkmarkImageView].forEach { dvdCoverImageView.addSubview($0) }
        redView.fillSuperview()
        checkmarkImageView.centerXInSuperview()
        checkmarkImageView.bottomAnchor.constraint(equalTo: dvdCoverImageView.bottomAnchor, constant: -padding).isActive = true
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
