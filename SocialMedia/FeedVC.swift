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

class FeedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func signOutPressed(_ sender: Any) {
        
        if KeychainWrapper.standard.removeObject(forKey: KEY_UID){
            try! FIRAuth.auth()?.signOut()
            performSegue(withIdentifier: "goToSignIn", sender: nil)
        }
    }


}
