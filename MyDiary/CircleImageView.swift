//
//  CircleImageView.swift
//  MyDiary
//
//  Created by Erick Tran on 9/3/17.
//  Copyright © 2017 Erick Tran. All rights reserved.
//

import UIKit

class CircleImageView: UIImageView {

    override func awakeFromNib() {
        superview?.awakeFromNib()
        
        //create shadow for image view
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        layer.cornerRadius = 20.0
    }

    
    
}
