//
//  AddNewMovieCell.swift
//  My Movies
//
//  Created by Zackary O'Connor on 1/18/19.
//  Copyright © 2019 Zackary O'Connor. All rights reserved.
//

import UIKit
import Firebase


class AddNewDvdCell: UICollectionViewCell {
    
    static let identifier = "addNewDvdCellIdentifier"
    
    var dvd: Results! {
        didSet {
            guard let posterPath = dvd.posterPath else { return }
            guard let backdropPath = dvd.backdropPath else { return }
            
            dvdCoverImageView.loadImageUsingUrlString(urlString: tmdb.dvdCoverImageUrl + backdropPath)
            
            if dvd.mediaType == "tv" {
                dvdTitleLabel.text = dvd.name
                yearReleasedLabel.text = dvd.firstAirDate
            } else {
                dvdTitleLabel.text = dvd.title
                yearReleasedLabel.text = dvd.releaseDate
            }

            let dateReleased = dvd.releaseDate
            let tvShowDateReleased = dvd.firstAirDate
            
            let formatter = DateFormatter()
            
            formatter.dateFormat = "yyyy-MM-dd"
            
            if let date = formatter.date(from: dateReleased ?? "") {
                let displayFormatter = DateFormatter()
                displayFormatter.dateFormat = "yyyy"
                yearReleasedLabel.text = displayFormatter.string(from: date)
            } else if let date = formatter.date(from: tvShowDateReleased ?? "") {
                let displayFormatter = DateFormatter()
                displayFormatter.dateFormat = "yyyy"
                yearReleasedLabel.text = displayFormatter.string(from: date)
            }
            
        }
        
    }
    
    
    override var isSelected: Bool {
        didSet {
            if isSelected == true {
                dvdCoverImageView.layer.opacity = 0.6
                dvdTitleLabel.textColor = .secondaryLabel
                isUserInteractionEnabled = false
            } else {
                dvdTitleLabel.textColor = .label
                dvdCoverImageView.layer.opacity = 1.0
                isUserInteractionEnabled = true
            }
        }
    }
    
    
   let dvdCoverImageView: CustomImageView = {
        let imageView = CustomImageView(cornerRadius: 4)
        return imageView
    }()
    
    let dvdTitleLabel = UILabel(fontWeight: .medium, numberOfLines: 1)
    let yearReleasedLabel = UILabel(textColor: .secondaryLabel, fontSize: 16, numberOfLines: 1)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        dvdCoverImageView.constrainWidth(constant: 114)
        dvdCoverImageView.constrainHeight(constant: 64)
        dvdCoverImageView.backgroundColor = .quaternarySystemFill
        
        let titleDateStackView = UIStackView(arrangedSubviews: [dvdTitleLabel,
                                                                yearReleasedLabel], axis: .vertical)
        
        
        let StackView = UIStackView(arrangedSubviews: [dvdCoverImageView,
                                                            titleDateStackView], customSpacing: 8,axis: .horizontal , distribution: .fill)
        
        addSubview(StackView)
        StackView.fillSuperview(padding: .init(top: 8, left: padding, bottom: 8, right: padding))
        StackView.alignment = .center
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
