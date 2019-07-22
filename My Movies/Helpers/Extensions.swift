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
    convenience init(title: String, backgroundColor: UIColor, setTitleColor: UIColor, font: UIFont, cornerRadius: CGFloat) {
        self.init(type: .system)
        self.setTitle(title, for: .normal)
        self.backgroundColor = backgroundColor
        self.setTitleColor(setTitleColor, for: .normal)
        self.titleLabel?.font = font
        self.layer.cornerRadius = cornerRadius
    }
}


extension UITextField {
    convenience init(placeholder: String, keyboardType: UIKeyboardType, returnKeyType: UIReturnKeyType, autocorrectionType: UITextAutocorrectionType) {
        self.init(frame: .zero)
        self.placeholder = placeholder
        self.keyboardType = keyboardType
        self.returnKeyType = returnKeyType
        self.enablesReturnKeyAutomatically = true
        self.autocorrectionType = autocorrectionType
    }
}


extension UIView {
    convenience init(backgroundColor: UIColor) {
        self.init(frame: .zero)
        self.backgroundColor = backgroundColor
    }
}


extension UIStackView {
    convenience init(arrangedSubviews: [UIView], customSpacing: CGFloat = 0, axis: NSLayoutConstraint.Axis = .vertical) {
        self.init(arrangedSubviews: arrangedSubviews)
        self.spacing = customSpacing
        self.axis = axis
    }
}


extension UIActivityIndicatorView {
    convenience init(indicatorColor: UIColor) {
        self.init(style: .whiteLarge)
        self.color = .darkGray
        self.isHidden = false
        self.startAnimating()
    }
}


extension UIViewController {
    func displayAlertController(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
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
