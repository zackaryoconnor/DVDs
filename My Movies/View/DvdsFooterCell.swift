//
//  DvdsFooterCell.swift
//  My Movies
//
//  Created by Zackary O'Connor on 5/16/20.
//  Copyright © 2020 Zackary O'Connor. All rights reserved.
//

import UIKit

class DvdsFooterCell: UICollectionReusableView {
   
    static let identifier = "dvdsFooterCellIdentifier"
    
    let label = UILabel(textColor: .tertiaryLabel, fontSize: 14, fontWeight: .medium)
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            addSubview(label)
            label.fillSuperview(padding: .init(top: inset, left: inset, bottom: inset, right: inset))
        }
        
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

}

