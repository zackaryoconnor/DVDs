//
//  Extensions.swift
//  My Movies
//
//  Created by Zackary O'Connor on 3/7/19.
//  Copyright © 2019 Zackary O'Connor. All rights reserved.
//

import UIKit

extension UILabel {
    convenience init(text: String, textColor: UIColor, fontSize: CGFloat, fontWeight: UIFont.Weight, textAlignment: NSTextAlignment, numberOfLines: Int) {
        self.init(frame: .zero)
        self.text = text
        self.textColor = textColor
        self.font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
        self.textAlignment = textAlignment
        self.numberOfLines = numberOfLines
    }
}

extension UIImageView {
    convenience init(image: String, cornerRadius: CGFloat) {
        self.init(image: nil)
        self.image = UIImage(named: "\(image)")
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        self.contentMode = .scaleAspectFill
    }
}

extension UIButton {
    convenience init(title: String) {
        self.init(type: .system)
        self.setTitle(title, for: .normal)
    }
}
