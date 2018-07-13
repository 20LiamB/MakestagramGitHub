//
//  LoginViewController.swift
//  Makestagram
//
//  Created by Liam  Bakar on 7/11/18.
//  Copyright © 2018 Make School. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseUI

typealias FIRUser = FirebaseAuth.User


class LoginViewController: UIViewController{
    @IBOutlet weak var loginButton: UIButton!
    let user: FIRUser? = Auth.auth().currentUser
    
    override func viewDidLoad(){
        super.viewDidLoad()
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton){
        guard let authUI = FUIAuth.defaultAuthUI()
            else {
                return
            }
        
            authUI.delegate = self
        let authViewController = authUI.authViewController()
        present(authViewController, animated: true)
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        if let error = error {
            assertionFailure("Error signing in: \(error.localizedDescription)")
            return
        }
        
        guard let user = authDataResult?.user
            else { return }
        
        let userRef = Database.database().reference().child("users").child(user.uid)
        
        userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let user = User(snapshot: snapshot) {
                print("Welcome back, \(user.username).")
            } else {
                print("New user!")
            }
        })
    }
    
}

extension LoginViewController: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith user: FirebaseAuth.User?, error: Error?) {
        if let error = error {
            assertionFailure("Error signing in: \(error.localizedDescription)")
            return
        }
            print("handle user signup / login")
    }
}

