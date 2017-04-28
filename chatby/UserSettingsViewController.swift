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

/* Changed the Profile page - Now everything is stored in a table.  The table has two different cell types.  Still to do, clarify variable
    names, implement functionality for the buttons.  Colors probably need to be changed and the table for some reason
    doesn't extend to the far left but imo that's minor*/


class UserSettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ProfileCellCallsDelegate {
    
    var table_view: UITableView!
    var image_view: UIImageView!
    var profile_table_data: [[String]] = [["Email", ""],["Username", ""],["Fullname",""]]
    
    override func viewDidLoad() {
        
        self.title = "Account"
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.00, green:0.74, blue:0.83, alpha:1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        
        table_view = UITableView()
        table_view.dataSource = self
        table_view.delegate = self
        
        table_view.tableFooterView = UIView(frame: .zero)
        table_view.isScrollEnabled = false
        table_view.rowHeight = 50
        
        table_view.register(ProfileCell.self, forCellReuseIdentifier: "cell")
        table_view.register(ProfileCell2.self, forCellReuseIdentifier: "cell2")
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.view.addSubview(table_view)
        
        self.view.backgroundColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)
        
        let auth_string = "Token " + keychain.get("auth")!
        
        let header = [
            "Authorization" : auth_string
        ]
        
        let frame_width = view.frame.width
        
        Alamofire.request("http://chatby.vohras.tk/api/users/current/", method: .get, headers: header).validate().responseJSON(completionHandler:  { response in
            
            let json = JSON(response.result.value!)
            let email = json["email"].stringValue
            let username = json["username"].stringValue
            let full_name = json["first_name"].stringValue + " " + json["last_name"].stringValue
            
            self.profile_table_data[0][1] = email
            self.profile_table_data[1][1] = username
            self.profile_table_data[2][1] = full_name
            
            self.table_view.reloadData()
            
            let row_height = self.table_view.rowHeight
            
            self.table_view.frame = CGRect(x: 0, y: 200, width: frame_width, height: row_height * 6)
            
            self.table_view.reloadData()
            
        })
        
        let image = UIImage(named: "profile_2")
        image_view = UIImageView(image: image)
        image_view.tintColor = UIColor(red:0.00, green:0.74, blue:0.83, alpha:1.0)
        image_view.frame = CGRect(x: view.frame.width/2 - 25, y: 100, width: 50, height: 50)
        
        self.view.addSubview(image_view)
        
        super.viewDidLoad();
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row < 3 {
        
            let cell:ProfileCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! ProfileCell
        
            cell.cell_type.text = self.profile_table_data[indexPath.row][0]
            cell.cell_info.text = self.profile_table_data[indexPath.row][1]
            
            cell.edit_button.tag = indexPath.row
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            cell.delegate = self
        
            return cell
        }
        
        let cell:ProfileCell2 = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath as IndexPath) as! ProfileCell2
        
        if indexPath.row == 3 {
            cell.cell_text.text = "Change Password"
        }
        else if indexPath.row == 4 {
            cell.cell_text.text = "Logout"
        }
        else if indexPath.row == 5 {
            cell.cell_text.text = "Delete Account"
            cell.cell_text.textColor = UIColor.white
            cell.backgroundColor = UIColor(red:0.99, green:0.33, blue:0.34, alpha:1.0)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 3 {
            changePass()
            
        }
        else if indexPath.row == 4 {
            logout()
        }
        else if indexPath.row == 5 {
            deleteAccount()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func editButton(type:String) {
        if type == "email" {
            changeEmail()
        }
        else if type == "username" {
            changeUsername()
        }
        else if type == "fullname" {
            changeName()
        }
    }
    
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //Old stuff below//////////////////////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    func changePass() {
        let alert = UIAlertController(title: "Change Password", message: "Change Your Password", preferredStyle: .alert);
        let confirmAction = UIAlertAction(title: "Confirm",
                                          style: .default,
                                          handler: {(action:UIAlertAction) in
                                            //Code to save password here
                                            let newPass = alert.textFields?[1].text;
                                            let confirmNewPass = alert.textFields?[2].text;
                                            
                                            if ( newPass == confirmNewPass ) {
                                                    let auth_string = "Token " + keychain.get("auth")!
                                                    
                                                    let header = [
                                                        "Authorization" : auth_string
                                                    ]
                                                    
                                                    let pass_parameters : Parameters = [
                                                        "password":newPass!,
                                                    ]
                                                    
                                                    Alamofire.request("http://chatby.vohras.tk/api/users/current/", method: .patch, parameters: pass_parameters, encoding: JSONEncoding.default, headers: header).validate().responseJSON(completionHandler: {
                                                        response in
                                                    })
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
    
    func deleteAccount() {
        let alert = UIAlertController(title: "Delete Your Account?", message: nil, preferredStyle: .alert);
        let confirmAct = UIAlertAction(title: "Yes", style: .destructive, handler: {(alert:UIAlertAction) in
            // Delete your account - Hillary Clinton
            
            let auth_string = "Token " + keychain.get("auth")!
            
            let header = [
                "Authorization" : auth_string
            ]
            
            Alamofire.request("http://chatby.vohras.tk/api/users/current/", method: .delete, encoding: JSONEncoding.default, headers: header).validate().responseJSON(completionHandler: { response in })
            
            
        });
        let cancelAct = UIAlertAction(title: "No", style: .cancel, handler: {(alert:UIAlertAction) -> Void in});
        
        alert.addAction(confirmAct);
        alert.addAction(cancelAct);
        
        self.present(alert, animated: true, completion: nil);
    }
    
    func logout() {
        let alert = UIAlertController(title: "Are you sure you want to logout?", message: nil, preferredStyle: .alert);
        let confirmAct = UIAlertAction(title: "Yes", style: .destructive, handler: {(alert:UIAlertAction) in
            keychain.delete("auth");
            self.navigationController?.popToRootViewController(animated: true)
            //self.navigationController?.popViewController(animated: true)
            //self.navigationController?.popViewController(animated: true)
            //let logboard = UIStoryboard(name: "Login", bundle: nil);
            //let logcontr = logboard.instantiateViewController(withIdentifier: "LoginMain");
            //let style = UIModalTransitionStyle.coverVertical;
            //logcontr.modalTransitionStyle = style;
            //self.present(logcontr, animated: true, completion: nil);
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
            
            Alamofire.request("http://chatby.vohras.tk/api/users/current/", method: .patch, parameters: name_parameters, encoding: JSONEncoding.default, headers: header).validate().responseJSON(completionHandler: { response in
            })
            
            self.profile_table_data[2][1] = firstName! + " " + lastName!
            self.table_view.reloadData()

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

            let username = changeUsernameAlert.textFields?[0].text;
            
            let auth_string = "Token " + keychain.get("auth")!
            
            let header = [
                "Authorization" : auth_string
            ]
            
            let name_parameters : Parameters = [
                "username":username!,
            ]
            
            Alamofire.request("http://chatby.vohras.tk/api/users/current/", method: .patch, parameters: name_parameters, encoding: JSONEncoding.default, headers: header).validate().responseJSON(completionHandler: { response in })
            
            self.profile_table_data[1][1] = username!
            
            self.table_view.reloadData()
            
        });
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(alert:UIAlertAction) -> Void in});
        
        changeUsernameAlert.addTextField(configurationHandler: {(textField:UITextField) in
            textField.placeholder = "New Username";
        })
        
        changeUsernameAlert.addAction(confirmAction);
        changeUsernameAlert.addAction(cancelAction);
        
        self.present(changeUsernameAlert, animated: true, completion: nil);
    }
    
    func changeEmail() {
        let changeEmailAlert = UIAlertController(title: "Change Email", message: "Input new email", preferredStyle: .alert);
        let confirmAction = UIAlertAction(title: "Confirm", style: .default, handler: {(alert:UIAlertAction)  in
            // Code to change username here
            let email = changeEmailAlert.textFields?[0].text;
            
            let auth_string = "Token " + keychain.get("auth")!
            
            let header = [
                "Authorization" : auth_string
            ]
            
            let name_parameters : Parameters = [
                "email":email!,
                ]
            
            Alamofire.request("http://chatby.vohras.tk/api/users/current/", method: .patch, parameters: name_parameters, encoding: JSONEncoding.default, headers: header).validate().responseJSON(completionHandler: { response in })
            
            self.profile_table_data[0][1] = email!
            self.table_view.reloadData()
            
        });
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(alert:UIAlertAction) -> Void in});
        
        changeEmailAlert.addTextField(configurationHandler: {(textField:UITextField) in
            textField.placeholder = "New Email";
        })
        
        changeEmailAlert.addAction(confirmAction);
        changeEmailAlert.addAction(cancelAction);
        
        self.present(changeEmailAlert, animated: true, completion: nil);
    }
    
}











