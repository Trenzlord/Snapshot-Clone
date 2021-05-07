//
//  UploadViewController.swift
//  SnapchatClone
//
//  Created by Mert Kaan on 2.05.2021.
//

import UIKit
import Firebase

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var uploadImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        uploadImageView.isUserInteractionEnabled = true
        
        let gestureImage =  UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        uploadImageView.addGestureRecognizer(gestureImage)
    }
    
    @objc func chooseImage() {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        uploadImageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func uploadButtonClicked(_ sender: Any) {
        
        let storage = Storage.storage()
        let storageReferance = storage.reference()
        
        let mediaFolder = storageReferance.child("media")
        
        if let data = uploadImageView.image?.jpegData(compressionQuality: 0.5) {
            
            let uuid = UUID().uuidString
            
            let imageReferance = mediaFolder.child("\(uuid).jpg")
            
            imageReferance.putData(data, metadata: nil) { metadata, error in
                if error != nil {
                
                    let alert = makeAlert(title: "Error", message: error?.localizedDescription ?? "error")
                    self.present(alert, animated: true, completion: nil)
                  
                }else {
                    
                    imageReferance.downloadURL { url, error in
                        if error == nil {
                            
                            let imageUrl = url?.absoluteString
                            
                            //Firestore
                            let fireStore = Firestore.firestore()
                            
                            fireStore.collection("Snaps").whereField("SnapOwner", isEqualTo: UserSingleton.sharedUserInfo.username).getDocuments { snapshot, error in
                                if error != nil {
                                    self.present(makeAlert(title: "error", message: error?.localizedDescription ?? "error"), animated: true, completion: nil)
                                }else {
                                    if snapshot?.isEmpty == false && snapshot != nil  {
                                        
                                        for document in snapshot!.documents {
                                            let documentId = document.documentID
                                            
                                            if var imageUrlArray = document.get("imageUrlArray") as? [String] {
                                                imageUrlArray.append(imageUrl!)
                                                
                                                let additionalDictionary = ["imageUrlArray" : imageUrlArray] as [String : Any]
                                                
                                                fireStore.collection("Snaps").document(documentId).setData(additionalDictionary, merge: true) { error in
                                                    if error == nil {
                                                        self.tabBarController?.selectedIndex = 0
                                                        self.uploadImageView.image = UIImage(named: "select-image")
                                                    }
                                                }
                                            }
                                            
                                        }
                                    }else {
                                        let snapDictionary = ["imageUrlArray": [imageUrl!], "SnapOwner" :UserSingleton.sharedUserInfo.username,"date" : FieldValue.serverTimestamp()] as [ String : Any]
                                        
                                        fireStore.collection("Snaps").addDocument(data: snapDictionary) { error in
                                            if error != nil {
                                                self.present(makeAlert(title: "error", message: error?.localizedDescription ?? "error"), animated: true, completion: nil)
                                            }else {
                                                self.tabBarController?.selectedIndex = 0
                                                self.uploadImageView.image = UIImage(named: "select-image")
                        
                                            }
                                        }

                                        
                                    }
                                }
                            }
                            
                           
                            
                        }
                    }
                    
                }
            }
            
        }
        
    }
    
}
