//
//  ImageViews.swift
//  My Movies
//
//  Created by Zackary O'Connor on 1/18/19.
//  Copyright © 2019 Zackary O'Connor. All rights reserved.
//

import UIKit

class ImageViews: UIImageView {
    fileprivate let _image: String
    
    init(image: String) {
        self._image = image
        
        super.init(frame: .zero)
        
        self.image = UIImage(named: "\(image)")
        self.contentMode = .scaleAspectFill
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
