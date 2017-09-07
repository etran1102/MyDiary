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

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    //connect all the UI
    @IBOutlet weak var tableView: UITableView!    
    @IBOutlet weak var addImage: FancyBtn!
    @IBOutlet weak var postBtn: FancyBtn!
    @IBOutlet weak var statusText: UITextField!
    
    //declare ariables
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    var imageSelected = false
    
        
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.statusText.delegate = self
        
        //configure the tableView
        DataService.ds.REF_POSTS.observe(.value, with: {(snapshot) in
            self.posts.removeAll(keepingCapacity: true)
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    if let postDict = snap.value as? Dictionary<String, Any> {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        if post.hiddenPost == false {
                            self.posts.append(post)
                        }
                    }
                }
            }
            self.tableView.reloadData()
        })
        
        
    }
   
    // set number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //set number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return posts.count
    }
    
    //edit the cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CellView") as? CellView {
            
            if let image = MainVC.imageCache.object(forKey: post.imageUrl as NSString) {
                cell.configureCell(post: post, image: image)
            } else {
                cell.configureCell(post: post, image: nil)
            }
            return cell
        } else {
            return CellView()
        }
    }
    
    //picking the image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            addImage.setImage(image, for: .normal)
            imageSelected = true
        } else {
            print("A valid image wasn't selected")
            
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    //post button pressed
    @IBAction func PostBtnPressed(_ sender: Any) {
        guard let status = statusText.text, status != "" else {
            createAlert(title: "A status must be enter", message: "")
            return
        }
        guard let image = addImage.imageView?.image, imageSelected == true else {
            createAlert(title: "A picture must be select", message: "")
            return
        }
        if let imageData = UIImageJPEGRepresentation(image, 0.2) {
            let imageUid = NSUUID().uuidString
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            DataService.ds.REF_STORAGE_POST_IMAGE.child(imageUid).putData(imageData, metadata: metadata) { (metadata, error) in
                if error != nil {
                    print("Unable to upload image to Firebase Storage")
                } else {
                    print("Successfully upload image to Firebase Storage")
                    let downloadUrl = metadata?.downloadURL()?.absoluteString
                    if let url = downloadUrl {
                        self.postToFirebase(imageUrl: url)
                    }
                }
            
            }
            statusText.endEditing(true)
        }
    }
    
    //upload data to firebase
    func postToFirebase(imageUrl:String) {
        let post: Dictionary<String, Any> = [
            "description": statusText.text!,
            "imageUrl": imageUrl,
            "likes": 0,
            "hiddenPost": false
        ]
        
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        
        statusText.text = ""
        imageSelected = false
        addImage.setImage(UIImage(named: "add-image"), for: .normal)
        
        self.posts.removeAll(keepingCapacity: true)
        self.tableView.reloadData()
    }
    
    
    //when the add image is pressed
    @IBAction func addImagePressed(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    //when the sign out button is tapped
    @IBAction func SignOutTapped(_ sender: Any) {
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print ("\(keychainResult)")
        if keychainResult == true {
            print("keychain removed")
        }
        try! Auth.auth().signOut()        
        
        dismiss(animated: true, completion: nil)
    }
    
    //create alert for missing field
    func createAlert (title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action) in
        alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
