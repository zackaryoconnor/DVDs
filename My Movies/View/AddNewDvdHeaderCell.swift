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
    
    let label = UILabel(text: "Unfortunately you can not add the TV shows you own on DVD just yet. ☹️", textColor: .label, fontSize: 17, fontWeight: .regular, textAlignment: .left, numberOfLines: 0)
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .secondarySystemBackground
        addSubview(label)
        
        label.fillSuperview(padding: .init(top: inset, left: inset, bottom: inset, right: inset))
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
