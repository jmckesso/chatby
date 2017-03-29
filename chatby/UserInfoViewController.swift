//
//  UserInfoViewController.swift
//  chatby
//
//  Created by Tanner Strom on 3/28/17.
//  Copyright © 2017 Jacob McKesson. All rights reserved.
//

import Foundation
import UIKit

class UserInfoViewController: UIViewController {
    var rows = [[String]]();
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.title = "User";
        setNav();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }
    
    func drawPage() {
        
    }
    
    func setNav() {
        let settingsBtn:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.action,
                                                          target: self,
                                                          action: #selector(presentActionSheet(_:)));
        self.navigationItem.rightBarButtonItem = settingsBtn;
    }
    
    func presentActionSheet(_ sender:UIBarButtonItem) {
        let storybrd = UIStoryboard(name: "Login", bundle: nil);
        let settingsController:UIViewController = storybrd.instantiateViewController(withIdentifier: "UserSettingsMain");
        
        let confirmLogout:UIAlertController = UIAlertController(title: "Logout",
                                                                message: "Are you sure you wish to log out?",
                                                                preferredStyle: .alert);
        let logoutOK:UIAlertAction = UIAlertAction(title: "Yes",
                                                   style: .default,
                                                   handler: {
                                                    (alert:UIAlertAction) in
                                                    // Code to logout here
        });
        let logoutCANCEL:UIAlertAction = UIAlertAction(title: "No",
                                                       style: .cancel,
                                                       handler:{ (alert:UIAlertAction) -> Void in
        });
        confirmLogout.addAction(logoutOK);
        confirmLogout.addAction(logoutCANCEL);
        
        
        let menu:UIAlertController = UIAlertController(title: nil,
                                                       message: "Options",
                                                       preferredStyle: .actionSheet);
        let settings:UIAlertAction = UIAlertAction(title: "Settings",
                                                    style: .default,
                                                    handler:{ (alert:UIAlertAction) in
                                                        self.navigationController?.pushViewController(settingsController,
                                                                                                      animated: true);
        } );
        let logout:UIAlertAction = UIAlertAction(title: "Logout",
                                                 style: .default,
                                                 handler: {
                                                    (alert:UIAlertAction) in
                                                    self.present(confirmLogout,
                                                            animated: true,
                                                            completion: nil);
                                                 })
        let cancel:UIAlertAction = UIAlertAction(title: "Cancel",
                                                 style: .cancel,
                                                 handler: {(alert:UIAlertAction) -> Void in});
        
        menu.addAction(settings);
        menu.addAction(logout);
        menu.addAction(cancel);
        
        self.present(menu, animated: true, completion: nil);
        
    }
    
    func logout(_ sender: UIAlertAction) {
        let logboard = UIStoryboard(name: "Login", bundle: nil);
        let logcontr = logboard.instantiateViewController(withIdentifier: "LoginMain");
        let style = UIModalTransitionStyle.coverVertical;
        logcontr.modalTransitionStyle = style;
        self.present(logcontr, animated: true, completion: nil);
    }
}
