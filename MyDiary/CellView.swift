//
//  CellView.swift
//  MyDiary
//
//  Created by Erick Tran on 9/3/17.
//  Copyright © 2017 Erick Tran. All rights reserved.
//

import UIKit
import Firebase

class CellView: UITableViewCell {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var picLbl: UIImageView!
    @IBOutlet weak var textFieldLbl: UITextView!
    @IBOutlet weak var numberOfLikeLbl: UILabel!
    @IBOutlet weak var likeImage: UIImageView!
    
    //declare variables
    var post: Post!
    var likeRef: DatabaseReference!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //edit for like button
        let press = UITapGestureRecognizer(target: self ,action: #selector(likePressed))
        press.numberOfTapsRequired = 1
        likeImage.addGestureRecognizer(press)
        likeImage.isUserInteractionEnabled = true
    }
    
    //configure the cell.
    func configureCell(post: Post, image: UIImage? = nil) {
        self.post = post
        //set text field and like label in the cell
        likeRef = DataService.ds.REF_CURRENT_USER.child("likes").child(post.postKey)
        self.textFieldLbl.text = post.description
        if let like = post.likes {
            self.numberOfLikeLbl.text = "\(like)"
        }
        
        if image != nil {
            self.picLbl.image = image
        } else {
            //download image from firebase
            let ref = Storage.storage().reference(forURL: post.imageUrl)
            ref.getData(maxSize: 2 * 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    print("Unable to download image from Firebase")
                } else {
                    print("Succesfully download image from Firebase")
                    if let imageData = data {
                        if let image = UIImage(data: imageData){
                            self.picLbl.image = image
                            MainVC.imageCache.setObject(image, forKey: post.imageUrl as NSString)
                        }
                    }
                }
            })
        }
        
        //change the heart like button
        likeRef.observeSingleEvent(of: .value, with: {(snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likeImage.image = UIImage(named: "empty-heart")
            } else {
                self.likeImage.image = UIImage(named: "filled-heart")
            }
        })
    }
    
    //when like button is pressed. It will toggle between the images.
    func likePressed(sender: UITapGestureRecognizer) {        
        likeRef.observeSingleEvent(of: .value, with: {(snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likeImage.image = UIImage(named: "filled-heart")
                self.post.adjustLikes(addLike: true)
                self.likeRef.setValue(true)
            } else {
                self.likeImage.image = UIImage(named: "empty-heart")
                self.post.adjustLikes(addLike: false)
                self.likeRef.removeValue()
            }
        })
    }
}














