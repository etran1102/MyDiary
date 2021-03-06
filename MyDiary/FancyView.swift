//
//  FancyView.swift
//  MyDiary
//
//  Created by Erick Tran on 9/2/17.
//  Copyright © 2017 Erick Tran. All rights reserved.
//

import UIKit

class FancyView: UIView {

    //create a shadow for UIView
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.6
        layer.shadowRadius = 3
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        layer.cornerRadius = 2.0
    }
}
