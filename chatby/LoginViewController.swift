//
//  LoginViewController.swift
//  chatby
//
//  Created by Tanner Strom on 2/22/17.
//  Copyright © 2017 Jacob McKesson. All rights reserved.
//

import UIKit
import AVKit
import Alamofire
import SwiftyJSON
import KeychainSwift

let keychain = KeychainSwift()

class LogInViewController: UIViewController, UITextFieldDelegate {
    
    var username = UITextField()
    var password = UITextField()

    var logo = UILabel()

    let list_of_users = "http://chatby.vohras.tk/api/users/";
    let auth_page = "http://chatby.vohras.tk/api/auth/";
    
    override func viewDidLoad() {
        
        print("view did load")
        
        self.view.backgroundColor = UIColor(red:0.00, green:0.74, blue:0.83, alpha:1.0)
        
        super.viewDidLoad();

        drawLoginFields();
        print("draw login")
        drawLoginButton();
        print("draw button")
        drawSignupButton();
        print("draw signup")

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LogInViewController.DismissKeyboard));
        view.addGestureRecognizer(tap);
        print("tap")
        
        

    }

    func login(_ sender: UIButton) {
        let user = username.text
        let pass = password.text
        
        if (user == "") {
            return
        }
        else if (pass == "") {
            return
        }
        
        let user_log : Parameters = [
            "username":user!,
            "password":pass!
        ]
        
        Alamofire.request(auth_page, method: .post, parameters: user_log, encoding: JSONEncoding.default).validate().responseJSON(completionHandler: { response in
            
            switch response.result {
            case .success:
                let session_key = JSON(response.result.value!)
                
                keychain.set(session_key["token"].stringValue, forKey: "auth")
                //self.navigationController?.popViewController(animated: true)
                print("dismissing")
                
                //var window: UIWindow?
                
                //window = UIWindow(frame: UIScreen.main.bounds)
                //window?.backgroundColor = UIColor.white
                //window?.makeKeyAndVisible()
                
                //let tabController = CustomTabBarController()
                //let navController = UINavigationController(rootViewController: tabController)
                //navController.navigationBar.isHidden = true
                //self.(tabController, animated: true, completion: nil)
                //self.navigationController?.pushViewController(tabController, animated: true)
                //window?.rootViewController = navController
                
                //window?.rootViewController = CustomTabBarController()

                let tabController = CustomTabBarController()
                let navController = UINavigationController(rootViewController: tabController)
                navController.navigationBar.isHidden = true
                    //self.(tabController, animated: true, completion: nil)
                self.navigationController?.pushViewController(tabController, animated: true)
                    //window?.rootViewController = navController
                self.dismiss(animated: true, completion: nil)
                
            case .failure:
                
                let animation = CABasicAnimation(keyPath: "position");
                animation.duration = 0.07;
                animation.repeatCount = 4;
                animation.autoreverses = true;
                animation.fromValue = NSValue(cgPoint: CGPoint(x: self.username.center.x - 10, y: self.username.center.y));
                animation.toValue = NSValue(cgPoint: CGPoint(x: self.username.center.x + 10, y: self.username.center.y));
                self.username.layer.add(animation, forKey: "position");
                self.password.layer.add(animation, forKey: "position");

                
                let alert_controller = UIAlertController(title: "YOU SUCK", message: "also this is an alert", preferredStyle: UIAlertControllerStyle.alert)
                let ok_action = UIAlertAction(title: "I Know", style: .default)
                
                alert_controller.addAction(ok_action)
                self.present(alert_controller, animated: true, completion: nil)
            }
        })
    }
    
    func presentSignup(_ sender: UIButton) {
        let loginStory = UIStoryboard(name: "Login", bundle: nil);
        let loginContr = loginStory.instantiateViewController(withIdentifier: "SignupMain");
        let style: UIModalTransitionStyle = UIModalTransitionStyle.coverVertical;
        loginContr.modalTransitionStyle = style;
        self.present(loginContr, animated: true, completion: nil);
    }

    // UI shit goes here

    func drawLoginFields() {

        // Create text fields
        let inpWid:CGFloat = 200.0;
        let inpHei:CGFloat = 40.0;

        username = UITextField(frame: CGRect(x: self.view.bounds.width / 2 - (inpWid / 2),
                                             y: self.view.bounds.height / 2.2,
                                             width: inpWid,
                                             height: inpHei));

        password = UITextField(frame: CGRect(x: self.view.bounds.width / 2 - (inpWid / 2),
                                             y: self.view.bounds.height / 1.9,
                                             width: inpWid,
                                             height: inpHei));

        let underline = CALayer();
        let undWid:CGFloat = 1.0;
        underline.borderColor = UIColor.white.cgColor;
        underline.frame = CGRect(x: 0,
                                 y: username.frame.size.height - undWid,
                                 width: username.frame.size.width,
                                 height: username.frame.size.height);

        underline.borderWidth = undWid;
        username.clipsToBounds = true;
        username.textColor = UIColor.white;
        username.layer.addSublayer(underline);
        username.layer.masksToBounds = true;
        username.placeholder = "Username"
        username.textAlignment = NSTextAlignment.left;
        username.returnKeyType = UIReturnKeyType.done;
        username.keyboardType = UIKeyboardType.emailAddress;
        username.alpha = 1.0;
        username.autocorrectionType = UITextAutocorrectionType.no;
        username.autocapitalizationType = UITextAutocapitalizationType.none;

        self.view.addSubview(username);

        let punderline = CALayer();
        let pundWid:CGFloat = 1.0;
        punderline.borderColor = UIColor.white.cgColor;
        punderline.frame = CGRect(x: 0,
                                 y: password.frame.size.height - pundWid,
                                 width: password.frame.size.width,
                                 height: password.frame.size.height);

        punderline.borderWidth = pundWid;

        password.clipsToBounds = true;
        password.textColor = UIColor.white;
        punderline.borderWidth = pundWid;
        password.layer.addSublayer(punderline);
        password.layer.masksToBounds = true;
        password.placeholder = "Password"
        password.textAlignment = NSTextAlignment.left;
        username.returnKeyType = UIReturnKeyType.done;
        password.isEnabled = true;
        password.isSecureTextEntry = true;
        password.alpha = 1.0;

        self.view.addSubview(password);
    }

    func drawLoginButton() {
        let logowid: CGFloat = 200.0;
        let logohei: CGFloat = 50.0;

        logo = UILabel(frame: CGRect(x: self.view.bounds.width / 2 - (logowid / 2),
                                     y: self.view.bounds.height / 2.5 - (logohei / 2),
                                     width: logowid,
                                     height: logohei));
        logo.text = "chatby";
        logo.textColor = UIColor.white;
        logo.font = UIFont.boldSystemFont(ofSize: 32.0);

        self.view.addSubview(logo);

        let lgnWid:CGFloat = 200.0;
        let lgnHei:CGFloat = 30.0;

        let loginButton: UIButton = UIButton(frame: CGRect(x: self.view.bounds.width / 2 - (lgnWid / 2),
                                                           y: self.view.bounds.height / 1.47 - (lgnHei / 2),
                                                           width: lgnWid,
                                                           height: lgnHei));
        loginButton.backgroundColor = UIColor.clear;
        loginButton.layer.cornerRadius = 8.0;
        loginButton.setTitle("Login", for: UIControlState.normal);
        loginButton.setTitleColor(UIColor.white, for: UIControlState.normal);
        loginButton.titleLabel?.font = UIFont(name: "System", size: 20);
        loginButton.addTarget(self, action: #selector(LogInViewController.login(_:)), for: UIControlEvents.touchUpInside);
        loginButton.alpha = 1.0;
        loginButton.isEnabled = true;

        self.view.addSubview(loginButton);
    }

    func drawSignupButton() {
        let sgnWid:CGFloat = 200.0;
        let sgnHei:CGFloat = 60.0;

        let signupButton:UIButton =  UIButton(frame: CGRect(x: self.view.bounds.width / 2 - (sgnWid / 2),
                                                            y: self.view.bounds.height - (sgnHei),
                                                            width: sgnWid,
                                                            height: sgnHei));

        signupButton.backgroundColor = UIColor.clear;
        signupButton.layer.cornerRadius = 8.0;
        signupButton.setTitle("Dont have an account?", for: UIControlState.normal);
        signupButton.setTitleColor(UIColor.white, for: UIControlState.normal);
        signupButton.titleLabel?.font = UIFont(name: "System", size: 20);
        signupButton.addTarget(self, action: #selector(LogInViewController.presentSignup(_:)), for: UIControlEvents.touchUpInside);
        signupButton.alpha = 1.0;
        signupButton.isEnabled = true;

        self.view.addSubview(signupButton);

    }

    //Keyboard shit
    func keyboardWillShow(notification: NSNotification) {

        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }

    }

    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }

    func DismissKeyboard() {
        view.endEditing(true);
    }
}
