//
//  FeedViewController.swift
//  SnapchatClone
//
//  Created by Mert Kaan on 2.05.2021.
//

import UIKit
import Firebase
import SDWebImage

class FeedViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    let fireStoreDataBase = Firestore.firestore()
    var snapArray = [Snap]()
    var chosenSnap : Snap?
        
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        getUserInfo()
        getSnapsFromFirestore()
        
    }
    
    func getSnapsFromFirestore() {
        fireStoreDataBase.collection("Snaps").order(by: "date", descending: true).addSnapshotListener { (snapshot, error) in
            if error != nil {
                self.makeAlert(title: "error", message: error?.localizedDescription ?? "error")
                
            }else{
                if snapshot?.isEmpty == false && snapshot != nil {
                    self.snapArray.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents {
                        let documentId = document.documentID
                        if let username = document.get("SnapOwner") as? String {
                            if let imageUrlArray = document.get("imageUrlArray") as? [String] {
                                if let date = document.get("date") as? Timestamp {
                                    
                                    if let differance = Calendar.current.dateComponents([.hour], from: date.dateValue(), to: Date()).hour {
                                        if differance >= 24 {
                                            self.fireStoreDataBase.collection("Snaps").document(documentId).delete { error in }
                                        }else {
                                            
                                            let snap = Snap(username: username, imageUrlArray: imageUrlArray, date: date.dateValue(), timeDifferance: 24 - differance)
                                            self.snapArray.append(snap)
                                        }
                                        
                                    }
                                 
                                  
                                }
                            }
                        }
                    }
                    self.tableView.reloadData()
                }
            }
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        snapArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",for: indexPath) as! FeedCell
        cell.usernameLabel.text = snapArray[indexPath.row].username
        cell.feedImageViewCell.sd_setImage(with: URL(string: snapArray[indexPath.row].imageUrlArray[0]))
        return cell
    }
    
  
    func getUserInfo() {
        fireStoreDataBase.collection("UserInfo").whereField("e-mail", isEqualTo: Auth.auth().currentUser!.email!).getDocuments { snapshot, Error in
            if Error != nil {
                self.makeAlert(title: "Error", message: Error?.localizedDescription ?? "error")
            }else {
                if snapshot?.isEmpty == false && snapshot != nil {
                    for document in snapshot!.documents {
                        if let username = document.get("username") as? String {
                            UserSingleton.sharedUserInfo.email = Auth.auth().currentUser!.email!
                            UserSingleton.sharedUserInfo.username = username
                        }
                    }
                }
            }
        }
        
    }
    func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tosnapvc" {
        
            let destinationVC = segue.destination as! SnapViewController
            destinationVC.selectedSnap = chosenSnap
         
            
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenSnap = self.snapArray[indexPath.row]
        performSegue(withIdentifier: "tosnapvc", sender: nil)
    }
    
}
