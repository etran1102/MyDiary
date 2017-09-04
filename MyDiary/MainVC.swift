//
//  MainVC.swift
//  MyDiary
//
//  Created by Erick Tran on 9/3/17.
//  Copyright © 2017 Erick Tran. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class MainVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func SIgnOutPressed(_ sender: Any) {
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print ("\(keychainResult)")
        if keychainResult == true {
            print("keychain removed")
        }
        try! Auth.auth().signOut()
        
            
        dismiss(animated: true, completion: nil)
    }
}
