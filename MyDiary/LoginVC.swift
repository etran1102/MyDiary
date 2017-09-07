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
import SwiftKeychainWrapper

class LoginVC: UIViewController {
    
    @IBOutlet weak var emailLbl: FancyField!
    @IBOutlet weak var passwordLbl: FancyField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //keep keychain for instant login
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            performSegue(withIdentifier: "goToMainVC", sender: nil)
        }
    }
    
    //when the facebook button is press
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
    
    //authorize with firebase.
    func firebaseAuth(_ credential: AuthCredential) {
        Auth.auth().signIn(with: credential, completion: {(user, error) in
            if error != nil {
                print("Unable to authenticate with Firebase")
            } else {
                print("Successfully authenticated with Firebase")
                if let user = user{
                    let userData = ["provider": credential.provider]
                    self.completeSignIn(id: user.uid, userData: userData)
                }
            }
        })
    }
    
    //when the sign in button is pressed.
    @IBAction func signInPressed(_ sender: Any) {
        
        if let email = emailLbl.text, let pwd = passwordLbl.text {
            Auth.auth().signIn(withEmail: email, password: pwd, completion: {(user, error) in
                if error == nil {
                 print("User authenticated with Firebase")
                    if let user = user {
                        let userData = ["provider": user.providerID]
                        self.completeSignIn(id: user.uid, userData: userData)
                    }
                } else {
                    //authorize with firebase for email and password
                    Auth.auth().createUser(withEmail: email, password: pwd, completion: {(user,error) in
                        if error != nil {
                            print("Unable to create user with Firebase using email")
                        } else {
                            print("Successfully created user with Firebase")
                            if let user = user {
                                let userData = ["proveider": user.providerID]
                                self.completeSignIn(id: user.uid, userData: userData)
                            }
                        }
                    })
                }
            })
        }
    }
    
    //complete the sign in process and go to MainVC
    func completeSignIn(id: String, userData: Dictionary<String, String>) {
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("Data saved to keychain \(keychainResult)")
        performSegue(withIdentifier: "goToMainVC", sender: nil)
        
    }

}


                


