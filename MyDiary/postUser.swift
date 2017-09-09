//
//  postUser.swift
//  MyDiary
//
//  Created by Erick Tran on 9/7/17.
//  Copyright © 2017 Erick Tran. All rights reserved.
//

import Foundation
import Foundation
import Firebase

class PostUser {
    private var _blockUser: String!
    private var _userKey: String!
    private var _userRef: DatabaseReference!
    
    
    //Declare all private variables
    var blockUser: String {
        return _blockUser
    }
    
    var userKey: String {
        return _userKey
    }
    
    init(blockUser: String) {
        self._blockUser = blockUser
    }    
    
    init(userKey: String, userData: Dictionary<String, Any>) {
        self._userKey = userKey
        
       
        if let blockUser = userData["blockUser"] as? String {
            self._blockUser = blockUser
        }
        _userRef = DataService.ds.REF_USERS.child(_userKey)        
    }
    
    func blockStatus(postKey: String, userKey: String) {
        //change the user's block status
        DataService.ds.REF_USERS.observe(.value, with: {(snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    if let userDict = snap.value as? Dictionary<String, Any> {
                        let key = snap.key
                        if userKey == key {
                            let user = PostUser(userKey: key, userData: userDict)
                            user._blockUser = "true"
                            user._userRef.child("blockUser").setValue(user._blockUser)
                        }
                    }
                }
            }
            
        })
        
    }
    
}
