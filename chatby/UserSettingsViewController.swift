//
//  UserSettingsViewController.swift
//  chatby
//
//  Created by Tanner Strom on 3/29/17.
//  Copyright © 2017 Jacob McKesson. All rights reserved.
//

import Foundation
import UIKit
import KeychainSwift
import Alamofire
import SwiftyJSON

class UserSettingsViewController: UIViewController {
    
    var chngPassBtn:UIButton!;
    var deleteAccBtn:UIButton!;
    var changeInfoBtn:UIButton!;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        drawUI();
        
        self.title = "User Settings";
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }
    
    func drawUI() {
        let inpWid:CGFloat = self.view.bounds.width;

        chngPassBtn = UIButton(frame: CGRect(x: self.view.bounds.width / 2 - (inpWid / 2) + 5,
                                            y: self.view.frame.maxY - 200,
                                            width: self.view.bounds.width - 10,
                                            height: 65));
        chngPassBtn.backgroundColor = UIColor.gray;
        chngPassBtn.setTitleColor(UIColor.white, for: UIControlState.normal);
        chngPassBtn.setTitleColor(UIColor.lightGray, for: UIControlState.highlighted);
        chngPassBtn.setTitle("Change Password", for: .normal);
        chngPassBtn.addTarget(self, action: #selector(changePass(_:)), for: .touchUpInside);
        
        chngPassBtn.setTitleColor(UIColor(colorLiteralRed: 14.0/255,
                                         green: 122.0/255,
                                         blue: 254.0/255,
                                         alpha: 1.0), for: UIControlState.normal);
        chngPassBtn.setTitleColor(UIColor(colorLiteralRed: 14.0/255,
                                         green: 122.0/255,
                                         blue: 254.0/255,
                                         alpha: 0.5), for: UIControlState.highlighted);
        
        chngPassBtn.layer.cornerRadius = 5;
        chngPassBtn.layer.borderColor = UIColor(colorLiteralRed: 14.0/255,
                                               green: 122.0/255,
                                               blue: 254.0/255,
                                               alpha: 1.0).cgColor;
        chngPassBtn.layer.borderWidth = 1;
        chngPassBtn.layer.backgroundColor = UIColor.white.cgColor;
        
        
        deleteAccBtn = UIButton(frame: CGRect(x: self.view.bounds.width / 2 - (inpWid / 2) + 5,
                                             y: self.view.frame.maxY - 125,
                                             width: self.view.bounds.width - 10,
                                             height: 65));
        deleteAccBtn.backgroundColor = UIColor.gray;
        deleteAccBtn.setTitleColor(UIColor(colorLiteralRed: 14.0/255,
                                           green: 122.0/255,
                                           blue: 254.0/255,
                                           alpha: 1.0), for: UIControlState.normal);
        deleteAccBtn.setTitleColor(UIColor(colorLiteralRed: 14.0/255,
                                           green: 122.0/255,
                                           blue: 254.0/255,
                                           alpha: 0.5), for: UIControlState.highlighted);
        deleteAccBtn.setTitle("Delete Account", for: .normal);
        deleteAccBtn.addTarget(self, action: #selector(deleteAccount(_:)), for: .touchUpInside);
        
        deleteAccBtn.setTitleColor(UIColor(colorLiteralRed: 255.0/255,
                                          green: 0/255,
                                          blue: 0/255,
                                          alpha: 1.0), for: UIControlState.normal);
        deleteAccBtn.setTitleColor(UIColor(colorLiteralRed: 255.0/255,
                                          green: 0/255,
                                          blue: 0/255,
                                          alpha: 0.5), for: UIControlState.highlighted);
        
        deleteAccBtn.layer.cornerRadius = 5;
        deleteAccBtn.layer.borderColor = UIColor.red.cgColor;
        deleteAccBtn.layer.borderWidth = 1;
        deleteAccBtn.layer.backgroundColor = UIColor.white.cgColor;
        
        changeInfoBtn = UIButton(frame: CGRect(x: self.view.bounds.width / 2 - (inpWid / 2) + 5,
                                              y: self.view.frame.maxY - 275,
                                              width: self.view.bounds.width - 10,
                                              height: 65));
        changeInfoBtn.backgroundColor = UIColor.gray;
        changeInfoBtn.setTitleColor(UIColor.white, for: UIControlState.normal);
        changeInfoBtn.setTitleColor(UIColor.lightGray, for: UIControlState.highlighted);
        changeInfoBtn.setTitle("Change Info", for: .normal);
        changeInfoBtn.addTarget(self, action: #selector(changeInfoSheet(_:)), for: .touchUpInside);
        
        changeInfoBtn.setTitleColor(UIColor(colorLiteralRed: 14.0/255,
                                            green: 122.0/255,
                                            blue: 254.0/255,
                                            alpha: 1.0), for: UIControlState.normal);
        changeInfoBtn.setTitleColor(UIColor(colorLiteralRed: 14.0/255,
                                            green: 122.0/255,
                                            blue: 254.0/255,
                                            alpha: 0.5), for: UIControlState.highlighted);
        
        changeInfoBtn.layer.cornerRadius = 5;
        changeInfoBtn.layer.borderColor = UIColor(colorLiteralRed: 14.0/255,
                                                  green: 122.0/255,
                                                  blue: 254.0/255,
                                                  alpha: 1.0).cgColor;
        changeInfoBtn.layer.borderWidth = 1;
        changeInfoBtn.layer.backgroundColor = UIColor.white.cgColor;
        
        self.view.addSubview(chngPassBtn);
        self.view.addSubview(deleteAccBtn);
        self.view.addSubview(changeInfoBtn);
        
    }
    
    func changePass(_ sender:UIButton) {
        
        print(" ")
        print(" --- Changing Password --- ")
        print(" ")
        
        let auth_string = "Token " + keychain.get("auth")!
        
        let header = [
            "Authorization" : auth_string
        ]
        
        
        Alamofire.request("http://chatby.vohras.tk/api/users/current/", encoding: JSONEncoding.default, headers: header).validate().responseJSON(completionHandler: {
         response in
         print(response.request!)  // original URL request
         print(response.response!) // HTTP URL response
         print(response.data!)     // server data
         print(response.result)
         
         let user_info = JSON(response.result.value!)
         print(user_info)
         
         })
        
        
        
        let alert = UIAlertController(title: "Change Password", message: "Change Your Password", preferredStyle: .alert);
        let confirmAction = UIAlertAction(title: "Confirm",
                                          style: .default,
                                          handler: {(action:UIAlertAction) in
                                            //Code to save password here
                                            let oldPass = alert.textFields?[0].text;
                                            let newPass = alert.textFields?[1].text;
                                            let confirmNewPass = alert.textFields?[2].text;
                                            
                                            if ( newPass == confirmNewPass ) {
                                                if ( newPass == oldPass ) {
                                                    print("passwords must be different")
                                                }
                                                else {
                                                    
                                                }
                                            }
                                            
                                            
        })
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel,
                                         handler: {(action:UIAlertAction) -> Void in});
        
        
        alert.addTextField(configurationHandler: {(textField:UITextField) -> Void in
            textField.placeholder = "Old Password";
            textField.isSecureTextEntry = true;
        });
        alert.addTextField(configurationHandler: {(textField:UITextField) -> Void in
            textField.placeholder = "New Password";
            textField.isSecureTextEntry = true;
        });
        alert.addTextField(configurationHandler: {(textField:UITextField) -> Void in
            textField.placeholder = "Confirm Password";
            textField.isSecureTextEntry = true;
        });
        
        alert.addAction(confirmAction);
        alert.addAction(cancelAction);
        
        self.present(alert, animated: true, completion: nil);
    }
    
    func deleteAccount(_ sender:UIButton) {
        let alert = UIAlertController(title: "Delete Your Account?", message: nil, preferredStyle: .alert);
        let confirmAct = UIAlertAction(title: "Yes", style: .destructive, handler: {(alert:UIAlertAction) in
            // Delete your account - Hillary Clinton
        });
        let cancelAct = UIAlertAction(title: "No", style: .cancel, handler: {(alert:UIAlertAction) -> Void in});
        
        alert.addAction(confirmAct);
        alert.addAction(cancelAct);
        
        self.present(alert, animated: true, completion: nil);
    }
    
    func changeInfoSheet(_ sender:UIButton) {
        let alert = UIAlertController(title: "Change Info", message: nil, preferredStyle: .actionSheet);
        let changeNameAction = UIAlertAction(title: "Change Name", style: .default, handler: {(alert:UIAlertAction) in
            self.changeName();
        })
        let changeUsername = UIAlertAction(title: "Change Username", style: .default, handler: {(alert:UIAlertAction) in
            self.changeUsername();
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(alert:UIAlertAction) -> Void in})
        
        alert.addAction(changeNameAction);
        alert.addAction(changeUsername);
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil);
    }
    
    func changeName() {
        
        print(" ")
        print(" --- Changing Name --- ")
        print(" ")

        
        let changeNameAlert = UIAlertController(title: "Change Name", message: "Input new name here", preferredStyle: .alert);
        let confirmName = UIAlertAction(title: "Confirm", style: .default, handler: {(alert:UIAlertAction) in
            // Code to change name here
            let firstName = changeNameAlert.textFields?[0].text;
            let lastName = changeNameAlert.textFields?[1].text;
            
            let auth_string = "Token " + keychain.get("auth")!
            
            let header = [
                "Authorization" : auth_string
            ]
            
            let name_parameters : Parameters = [
                "first_name":firstName!,
                "last_name":lastName!
            ]
            
            Alamofire.request("http://chatby.vohras.tk/api/users/current/", method: .patch, parameters: name_parameters, encoding: JSONEncoding.default, headers: header).validate().responseJSON(completionHandler: {
                response in
                print(response.request!)  // original URL request
                print(response.response!) // HTTP URL response
                print(response.data!)     // server data
                print(response.result)
            })

            
            
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: {(alert:UIAlertAction) -> Void in});
        changeNameAlert.addTextField(configurationHandler: {(textField:UITextField) in
            textField.placeholder = "First Name";
        });
        changeNameAlert.addTextField(configurationHandler: {(textField:UITextField) in
            textField.placeholder = "Last Name";
        });
        changeNameAlert.addAction(confirmName);
        changeNameAlert.addAction(cancel);
        
        self.present(changeNameAlert, animated: true, completion: nil);
    }
    
    func changeUsername() {
        let changeUsernameAlert = UIAlertController(title: "Change Username", message: "Input new username", preferredStyle: .alert);
        let confirmAction = UIAlertAction(title: "Confirm", style: .default, handler: {(alert:UIAlertAction)  in
            // Code to change username here
            let username = changeUsernameAlert.textFields?[0].text;
            
            
        });
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(alert:UIAlertAction) -> Void in});
        
        changeUsernameAlert.addTextField(configurationHandler: {(textField:UITextField) in
            textField.placeholder = "New Username";
        })
        
        changeUsernameAlert.addAction(confirmAction);
        changeUsernameAlert.addAction(cancelAction);
        
        self.present(changeUsernameAlert, animated: true, completion: nil);
    }
    
}











