//
//  AuthViewController.swift
//  DRace
//
//  Created by wonjongpill on 2017. 11. 18..
//  Copyright © 2017년 Jayron Cena. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FacebookLogin
import GoogleSignIn

var ref:DatabaseReference?
var handle:DatabaseHandle?

class AuthViewController: UIViewController, LoginButtonDelegate, GIDSignInUIDelegate{
    @IBOutlet weak var activityLoadingSpin: UIActivityIndicatorView!
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var imgCenterY: NSLayoutConstraint!
    @IBOutlet weak var imgTop: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingIndicator.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        loadingIndicator.startAnimating()
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if let _user = user{
                userID = _user.uid
                userRef = Database.database().reference().child("users/" + (Auth.auth().currentUser?.uid)!)
                exerciseRankRef = Database.database().reference().child("exerciseRanking")
                lossRankRef = Database.database().reference().child("lossWeightRanking")
                
                Database.database().reference().child("users").observeSingleEvent(of: .value, with: { (DataSnapshot) in
                    self.loadingIndicator.stopAnimating()
                    if DataSnapshot.hasChild(userID!){
                        self.performSegue(withIdentifier: "moveToHome", sender: nil)
                    }
                    else{
                        self.performSegue(withIdentifier: "firstLogin", sender: nil)
                    }
                })
            } else {
                self.loadingIndicator.stopAnimating()
                self.logoImg.isHidden = false
                
                self.imgCenterY.isActive = false
                self.imgTop.isActive = true
                UIView.animate(withDuration: 1, animations: {
                    self.view.layoutIfNeeded()
                }, completion: {finished in
                    
                    let FBloginButton = LoginButton(frame: CGRect(x: 0, y: 0, width: 290, height: 40),readPermissions: [ .publicProfile ])
                    FBloginButton.center.x = self.view.center.x
                    FBloginButton.center.y = self.view.center.y * 1.25
                    FBloginButton.delegate = self;
                    self.view.addSubview(FBloginButton)
                    
                    GIDSignIn.sharedInstance().uiDelegate = self
                    //GIDSignIn.sharedInstance().signIn()
                    
                    let GGloginButton = GIDSignInButton(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
                    GGloginButton.center.x = self.view.center.x
                    GGloginButton.center.y = FBloginButton.center.y + 50
                    GGloginButton.style = GIDSignInButtonStyle.wide
                    
                    self.view.addSubview(GGloginButton)
                })
                
                /*
                //FaceBook Signin
                let FBloginButton = LoginButton(frame: CGRect(x: 0, y: 0, width: 290, height: 40),readPermissions: [ .publicProfile ])
                FBloginButton.center.x = self.view.center.x
                FBloginButton.center.y = self.view.center.y * 1.25
                FBloginButton.delegate = self;
                self.view.addSubview(FBloginButton)
 
                
                //Google Signin
                GIDSignIn.sharedInstance().uiDelegate = self
                //GIDSignIn.sharedInstance().signIn()
                
                let GGloginButton = GIDSignInButton(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
                GGloginButton.center.x = self.view.center.x
                GGloginButton.center.y = FBloginButton.center.y + 50
                GGloginButton.style = GIDSignInButtonStyle.wide
                
                self.view.addSubview(GGloginButton)
                
 
                */
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.imgCenterY.isActive = false
        self.imgTop.isActive = true
    }
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        switch result {
        case .failed(let error):
            print(error)
        case .cancelled:
            print("Cancelled")
        case .success(let grantedPermissions, let declinedPermissions, let accessToken):
            print("Logged In")
            
            print("grantedPermissions = \(grantedPermissions), declinedPermissions = \(declinedPermissions), accessToken = \(accessToken)")
            print("FaceBook user ID = " + accessToken.userId!)
            
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.authenticationToken)
            Auth.auth().signIn(with: credential) { (user, error) in
                if let error = error {
                    print(error)
                }
                else{
                    print("FireBase FaceBook Login Success")
                }
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        print("FaceBook log out")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
