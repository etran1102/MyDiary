//
//  RoundButton.swift
//  MyDiary
//
//  Created by Erick Tran on 9/2/17.
//  Copyright © 2017 Erick Tran. All rights reserved.
//

import UIKit

class RoundButton: UIButton {

    override func awakeFromNib() {
        superview?.awakeFromNib()
     
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 0.8
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        imageView?.contentMode = .scaleAspectFit
        
        layer.cornerRadius = 50.0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = self.frame.width / 2
    }
    
}
