//
//  SignupViewController.swift
//  chatby
//
//  Created by Tanner Strom on 2/22/17.
//  Copyright © 2017 Jacob McKesson. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController, UITextFieldDelegate {

    var username:       UITextField!;
    var password:       UITextField!;
    var confirmPass:    UITextField!;
    var firstName:      UITextField!;
    var lastName:       UITextField!;

    override func viewDidLoad() {
        super.viewDidLoad();

        drawFields();

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LogInViewController.DismissKeyboard));
        view.addGestureRecognizer(tap);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }

    func dismissSignup(_ sender:UIButton) {
        self.dismiss(animated: true, completion: nil);
    }

    // Signup logic

    func signup(_ sender: UIButton) {
        let alert = UIAlertController(title: "YOOOOO", message: "You pressed the login button", preferredStyle: UIAlertControllerStyle.alert);
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.cancel, handler: nil));
        self.present(alert, animated: true, completion: nil);
    }

    // UI Shit

    func drawFields() {
        let inpWid:CGFloat = 200.0;
        let inpHei:CGFloat = 30.0;

        username =      UITextField(frame: CGRect(x: self.view.bounds.width / 2 - (inpWid / 2),
                                             y: self.view.bounds.height / 3.6,
                                             width: inpWid,
                                             height: inpHei));

        password =      UITextField(frame: CGRect(x: self.view.bounds.width / 2 - (inpWid / 2),
                                             y: self.view.bounds.height / 3,
                                             width: inpWid,
                                             height: inpHei));

        confirmPass =   UITextField(frame: CGRect(x: self.view.bounds.width / 2 - (inpWid / 2),
                                             y: self.view.bounds.height / 2.55,
                                             width: inpWid,
                                             height: inpHei));

        firstName =     UITextField(frame: CGRect(x: self.view.bounds.width / 2 - (inpWid / 2),
                                                y: self.view.bounds.height / 2.25,
                                                width: inpWid,
                                                height: inpHei));

        lastName =      UITextField(frame: CGRect(x: self.view.bounds.width / 2 - (inpWid / 2),
                                                y: self.view.bounds.height / 2,
                                                width: inpWid,
                                                height: inpHei));

        let underline = CALayer();
        let undWid:CGFloat = 2.0;
        underline.borderColor = UIColor.black.cgColor;
        underline.frame = CGRect(x: 0,
                                 y: username.frame.size.height - undWid,
                                 width: username.frame.size.width,
                                 height: username.frame.size.height);

        underline.borderWidth = undWid;
        username.clipsToBounds = true;
        username.textColor = UIColor.black;
        username.layer.addSublayer(underline);
        username.layer.masksToBounds = true;
        username.placeholder = "Username"
        username.textAlignment = NSTextAlignment.center;
        username.keyboardType = UIKeyboardType.emailAddress;
        username.alpha = 1.0;
        username.autocorrectionType = UITextAutocorrectionType.no;
        username.autocapitalizationType = UITextAutocapitalizationType.none;

        self.view.addSubview(username);

        let punderline = CALayer();
        let pundWid:CGFloat = 2.0;
        punderline.borderColor = UIColor.black.cgColor;
        punderline.frame = CGRect(x: 0,
                                  y: password.frame.size.height - pundWid,
                                  width: password.frame.size.width,
                                  height: password.frame.size.height);

        punderline.borderWidth = pundWid;

        password.clipsToBounds = true;
        password.textColor = UIColor.black;
        punderline.borderWidth = pundWid;
        password.layer.addSublayer(punderline);
        password.layer.masksToBounds = true;
        password.placeholder = "Password"
        password.textAlignment = NSTextAlignment.center;
        password.isEnabled = true;
        password.isSecureTextEntry = true;
        password.alpha = 1.0;

        self.view.addSubview(password);

        let cpunderline = CALayer();
        let cpundWid:CGFloat = 2.0;

        cpunderline.borderColor = UIColor.black.cgColor;
        cpunderline.frame = CGRect(x: 0,
                                  y: confirmPass.frame.size.height - cpundWid,
                                  width: confirmPass.frame.size.width,
                                  height: confirmPass.frame.size.height);

        punderline.borderWidth = cpundWid;

        confirmPass.clipsToBounds = true;
        confirmPass.textColor = UIColor.black;
        cpunderline.borderWidth = cpundWid;
        confirmPass.layer.addSublayer(cpunderline);
        confirmPass.layer.masksToBounds = true;
        confirmPass.placeholder = "Confirm Password"
        confirmPass.textAlignment = NSTextAlignment.center;
        confirmPass.isEnabled = true;
        confirmPass.isSecureTextEntry = true;
        confirmPass.alpha = 1.0;

        self.view.addSubview(confirmPass);

        let funderline = CALayer();
        let fundWid:CGFloat = 2.0;

        funderline.borderColor = UIColor.black.cgColor;
        funderline.frame = CGRect(x: 0,
                                   y: firstName.frame.size.height - fundWid,
                                   width: firstName.frame.size.width,
                                   height: firstName.frame.size.height);

        punderline.borderWidth = fundWid;

        firstName.clipsToBounds = true;
        firstName.textColor = UIColor.black;
        funderline.borderWidth = fundWid;
        firstName.layer.addSublayer(funderline);
        firstName.layer.masksToBounds = true;
        firstName.placeholder = "First Name"
        firstName.textAlignment = NSTextAlignment.center;
        firstName.isEnabled = true;
        firstName.isSecureTextEntry = false;
        firstName.alpha = 1.0;

        self.view.addSubview(firstName);


        let lunderline = CALayer();
        let lundWid:CGFloat = 2.0;

        lunderline.borderColor = UIColor.black.cgColor;
        lunderline.frame = CGRect(x: 0,
                                  y: lastName.frame.size.height - lundWid,
                                  width: lastName.frame.size.width,
                                  height: lastName.frame.size.height);

        punderline.borderWidth = lundWid;

        lastName.clipsToBounds = true;
        lastName.textColor = UIColor.black;
        lunderline.borderWidth = lundWid;
        lastName.layer.addSublayer(lunderline);
        lastName.layer.masksToBounds = true;
        lastName.placeholder = "Last Name"
        lastName.textAlignment = NSTextAlignment.center;
        lastName.isEnabled = true;
        lastName.isSecureTextEntry = false;
        lastName.alpha = 1.0;

        self.view.addSubview(lastName);

        drawButton();
        toLoginButton();
    }

    func drawButton() {
        let sgnWid:CGFloat = 200.0;
        let sgnHei:CGFloat = 30.0;

        let signupButton:UIButton =  UIButton(frame: CGRect(x: self.view.bounds.width / 2 - (sgnWid / 2),
                                                            y: self.view.bounds.height / 1.5 - (sgnHei / 2),
                                                            width: sgnWid,
                                                            height: sgnHei));

        signupButton.backgroundColor = UIColor.clear;
        signupButton.layer.cornerRadius = 8.0;
        signupButton.setTitle("Signup", for: UIControlState.normal);
        signupButton.setTitleColor(UIColor.black, for: UIControlState.normal);
        signupButton.titleLabel?.font = UIFont(name: "System", size: 20);
        signupButton.addTarget(self, action: #selector(SignupViewController.signup(_:)), for: UIControlEvents.touchUpInside);
        signupButton.alpha = 1.0;
        signupButton.isEnabled = true;

        self.view.addSubview(signupButton);
    }

    func toLoginButton() {
        let lgnWid:CGFloat = 200.0;
        let lgnHei:CGFloat = 30.0;

        let button: UIButton = UIButton(frame: CGRect(x: self.view.bounds.width / 2 - (lgnWid / 2),
                                                      y: self.view.bounds.height / 1.1 - (lgnHei / 2),
                                                      width: lgnWid,
                                                      height: lgnHei));

            button.backgroundColor = UIColor.clear;
            button.layer.cornerRadius = 8.0;
            button.setTitle("Cancel", for: UIControlState.normal);
            button.setTitleColor(UIColor.black, for: UIControlState.normal);
            button.titleLabel?.font = UIFont(name: "System", size: 20);
            button.addTarget(self, action: #selector(SignupViewController.dismissSignup(_:)), for: UIControlEvents.touchUpInside);
            button.alpha = 1.0;
            button.isEnabled = true;

            self.view.addSubview(button);
    }

    // Keyboard shit
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
