//
//  CellView.swift
//  MyDiary
//
//  Created by Erick Tran on 9/3/17.
//  Copyright © 2017 Erick Tran. All rights reserved.
//

import UIKit

class CellView: UITableViewCell {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var PicLbl: UIImageView!
    @IBOutlet weak var textFieldLbl: UITextView!
    @IBOutlet weak var numberOfLikeLbl: UILabel!
    
    var post: Post!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
                
    }
    
    func configureCell(post: Post) {
        self.post = post
        self.textFieldLbl.text = post.description
        self.numberOfLikeLbl.text = "\(post.likes)"
        
        
    }
    
    

}
