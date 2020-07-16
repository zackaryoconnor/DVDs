//
//  AddNewDvdHeaderCell.swift
//  My Movies
//
//  Created by Zackary O'Connor on 5/8/20.
//  Copyright © 2020 Zackary O'Connor. All rights reserved.
//

import UIKit

class AddNewDvdHeaderCell: UICollectionReusableView {
    
    static let identifier = "addNewDvdHeaderCellIdentifier"
    
//    Popular Movies
    let label = UILabel(text: "Unfortunately you can not add the TV shows you own on DVD just yet. ☹️", fontWeight: .medium)
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .secondarySystemBackground
        addSubview(label)
        
        label.fillSuperview(padding: .init(top: padding, left: padding, bottom: padding, right: padding))
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
