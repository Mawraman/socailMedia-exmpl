//
//  ViewController.swift
//  SocialMedia
//
//  Created by Oguzhan Akbudak on 11.04.2017.
//  Copyright © 2017 Oguzhan Akbudak. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import SwiftKeychainWrapper

class SignInVC: UIViewController {

    @IBOutlet weak var emailField: FancyField!
    @IBOutlet weak var passwordField: FancyField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID){
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
    }


    @IBAction func facebookBtnTapped(_ sender: Any) {
        
        let facebookLoginManager = FBSDKLoginManager()
        facebookLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil{
                print("OZZY: Unable to authenticate via Facebook - \(error.debugDescription)")
            }else if (result?.isCancelled)!{
                print("OZZY: User cancelled Facebook authentication - \(error.debugDescription)")
            }else{
                print("OZZY: Successfully to authenticated via Facebook")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuthenticate(credential)
            }
        }
    }
    
    @IBAction func signInTapped(_ sender: Any) {
        
        if let email = emailField.text, let pwd = passwordField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error != nil{
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil{
                            print("OZZY: Unable to authenticate via Firebase email - \(error.debugDescription)")
                        }else{
                            print("OZZY: Successfully created authenticated user via Firebase email")
                            if let user = user {
                                self.complateSignIn(id: user.uid)
                            }
                        }
                    })
                }else{
                    print("OZZY: Successfully to authenticated via Firebase email")
                    if let user = user {
                        self.complateSignIn(id: user.uid)
                    }
                    
                }
            })
        }
        
    }
    
    func firebaseAuthenticate(_ credential: FIRAuthCredential) {
        
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil{
                print("OZZY: Unable to authenticate via Firebase - \(error.debugDescription)")
            }else{
                print("OZZY: Successfully to authenticated via Firebase")
                if let user = user {
                    self.complateSignIn(id: user.uid)
                }
            }
        })
        
    }
    
    func complateSignIn(id: String ) {
        KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("Ozzy: Key chain data saved")
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }
}

