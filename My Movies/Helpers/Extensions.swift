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


extension UIStackView {
    convenience init(arrangedSubviews: [UIView], customSpacing: CGFloat = 0, axis: NSLayoutConstraint.Axis = .vertical) {
        self.init(arrangedSubviews: arrangedSubviews)
        self.spacing = customSpacing
        self.axis = axis
    }
}



let imageCache = NSCache<AnyObject, AnyObject>()
var imageUrlString: String?

extension UIImageView {
    
        func loadImageUsingUrlString(urlString: String) {
            
            imageUrlString = urlString
            
            let url = URL(string: urlString)

            image = nil
            
            if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
                
                if imageUrlString == urlString {
                    self.image = imageFromCache
                }
                
                return
            }
            
            URLSession.shared.dataTask(with: url!) { (data, response, error) in
                if error != nil {
                    print(error as Any)
                    return
                }
                
                DispatchQueue.main.async {
                    
                    let imageToCache = UIImage(data: data!)
                    
                    imageCache.setObject(imageToCache!, forKey: urlString as AnyObject)
                    
                    self.image = UIImage(data: data!)
                }
                }.resume()
    }
}


extension UICollectionView {
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel
    }
    
    func restore() {
        self.backgroundView = nil
    }
}
