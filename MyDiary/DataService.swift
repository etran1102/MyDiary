//
//  DataService.swift
//  MyDiary
//
//  Created by Erick Tran on 9/4/17.
//  Copyright © 2017 Erick Tran. All rights reserved.
//

import Foundation
import Firebase
import SwiftKeychainWrapper

let DB_BASE = Database.database().reference()
let STORAGE_BASE = Storage.storage().reference()


class DataService {

    static let ds = DataService()
    
    //DB references and storage declare
    private var _REF_BASE = DB_BASE
    private var _REF_POSTS = DB_BASE.child("posts")
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_STORAGE_POST_IMAGE = STORAGE_BASE.child("pics")      
    
    //init them
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_POSTS: DatabaseReference {
        return _REF_POSTS
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    
    var REF_STORAGE_POST_IMAGE: StorageReference {
        return _REF_STORAGE_POST_IMAGE
    }
    
    var REF_CURRENT_USER: DatabaseReference {
        let uid = KeychainWrapper.standard.string(forKey: KEY_UID)
        let user = REF_USERS.child(uid!)
        return user
    }
    
    var REF_CURRENT_POST: DatabaseReference {
        let uid = KeychainWrapper.standard.string(forKey: KEY_UID)
        let post = REF_POSTS.child(uid!)
        return post
    }
    
    //create firebase database user
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>) {
        REF_USERS.child(uid).updateChildValues(userData)
        
    }
}
