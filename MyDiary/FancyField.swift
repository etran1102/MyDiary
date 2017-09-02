//
//  FancyField.swift
//  MyDiary
//
//  Created by Erick Tran on 9/2/17.
//  Copyright © 2017 Erick Tran. All rights reserved.
//

import UIKit

class FancyField: UITextField {

    override func awakeFromNib() {
        superview?.awakeFromNib()
        
        layer.borderColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 20.0
        
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 5)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx:10, dy: 5)
        
    }
    

}
