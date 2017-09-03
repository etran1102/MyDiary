//
//  LoginVC.swift
//  MyDiary
//
//  Created by Erick Tran on 8/31/17.
//  Copyright © 2017 Erick Tran. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase


class LoginVC: UIViewController {
    @IBOutlet weak var emailLbl: FancyField!
    @IBOutlet weak var passwordLbl: FancyField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func fbBtnPressed(_ sender: Any) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) {(result, error) in if error != nil {
            print("Unable to authenticate with Facebook")
            
        } else if result?.isCancelled == true {
            print("User cancelled Facebook authentication")
        } else {
            print("Succesfully authenticated with Facebook")
            let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            
            self.firebaseAuth(credential)
            }
            
        
        }
    
    }
    
    func firebaseAuth(_ credential: AuthCredential) {
        Auth.auth().signIn(with: credential, completion: {(user, error) in
            if error != nil {
                print("Unable to authenticate with Firebase")
            } else {
                print("Successfully authenticated with Firebase")
            }
        })
    }
    
    @IBAction func signInPressed(_ sender: Any) {
        
        if let email = emailLbl.text, let pwd = passwordLbl.text {
            Auth.auth().signIn(withEmail: email, password: pwd, completion: {(user, error) in
                if error == nil {
                 print("User authenticated with Firebase")
                } else {
                    Auth.auth().createUser(withEmail: email, password: pwd, completion: {(user,error) in
                        if error != nil {
                            print("Unable to create user with Firebase using email")
                        } else {
                            print("Successfully created user with Firebase")
                        }
                    })
                }
            })
        
        }
    }

}


                


