//
//  PostModel.swift
//  OurDiaries
//
//  Created by Erick Tran on 9/4/17.
//  Copyright © 2017 Erick Tran. All rights reserved.
//

import Foundation
import Firebase

class Post {
 
    //Declare all private variables
    private var _description: String!
    private var _imageUrl: String!
    private var _likes: Int!
    private var _hiddenPost: Bool!
    private var _postKey: String!
    private var _postRef: DatabaseReference!
    
    //init them
    var description: String {
        return _description
    }
    
    var imageUrl: String {
        return _imageUrl
    }
    
    var likes: Int? {
        return _likes
    }
    
    var hiddenPost: Bool? {
        return _hiddenPost
    }
    
    var postKey: String {
        return _postKey
    }
    
    init(description: String, imageUrl: String, likes: Int, hiddenPost: Bool) {
        self._description = description
        self._imageUrl = imageUrl
        self._likes = likes
        self._hiddenPost = hiddenPost
    }
    
    init(postKey: String, postData: Dictionary<String, Any>) {
        self._postKey = postKey
        
        if let description = postData["description"] as? String {
            self._description = description
            
        }
        
        if let imageUrl = postData["imageUrl"] as? String {
            self._imageUrl = imageUrl
        }
        
        if let likes = postData["likes"] as? Int {
            self._likes = likes
        }
        
        if let hiddenPost = postData["hiddenPost"] as? Bool {
            self._hiddenPost = hiddenPost
        }
        
        _postRef = DataService.ds.REF_POSTS.child(_postKey)
        
    }
    
    //asjust the number of likes of the post
    func adjustLikes(addLike: Bool) {
        if addLike {
            _likes = _likes + 1
        } else {
            _likes = _likes - 1
        }
        _postRef.child("likes").setValue(_likes)
    }
    
    //change the flag to hide the post
    func setFlagToTrue() {
        _hiddenPost = true
        _postRef.child("hiddenPost").setValue(_hiddenPost)
    }
}
