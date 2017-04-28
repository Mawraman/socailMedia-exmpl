//
//  FeedVC.swift
//  SocialMedia
//
//  Created by Oguzhan Akbudak on 14.04.2017.
//  Copyright © 2017 Oguzhan Akbudak. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class FeedVC: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView:UITableView!
    
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            print(snapshot.value!)
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot]{
                for snap in snapshots{
                    if let postDict = snap.value as? Dictionary<String,Any>{
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                    }
                }
            }
            self.tableView.reloadData()  
        })
        
    }

    @IBAction func signOutPressed(_ sender: Any) {
        
        if KeychainWrapper.standard.removeObject(forKey: KEY_UID){
            try! FIRAuth.auth()?.signOut()
            performSegue(withIdentifier: "goToSignIn", sender: nil)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        
        return tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
    }


}
