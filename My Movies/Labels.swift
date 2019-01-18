//
//  Labels.swift
//  My Movies
//
//  Created by Zackary O'Connor on 1/18/19.
//  Copyright © 2019 Zackary O'Connor. All rights reserved.
//

import UIKit

class Labels: UILabel {
    fileprivate let _text: String
    fileprivate let _textColor: UIColor
    fileprivate let _fontSize: CGFloat
    fileprivate let _fontWeight: UIFont.Weight
    fileprivate let _textAlignment: NSTextAlignment
    fileprivate let _numberOfLines: Int
    
    init(text: String, textColor: UIColor, fontSize: CGFloat, fontWeight: UIFont.Weight, textAlignment: NSTextAlignment, numberOfLines: Int) {
        self._text = text
        self._textColor = textColor
        self._fontSize = fontSize
        self._fontWeight = fontWeight
        self._textAlignment = textAlignment
        self._numberOfLines = numberOfLines
        
        super.init(frame: .zero)
        
        self.text = "\(text)"
        self.textColor = textColor
        self.font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
        self.textAlignment = textAlignment
        self.numberOfLines = numberOfLines
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
