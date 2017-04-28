//
//  CustomTabBarController.swift
//  chatby
//
//  Created by Jacob McKesson on 4/25/17.
//  Copyright © 2017 Jacob McKesson. All rights reserved.
//

import UIKit
import KeychainSwift

class CustomTabBarController: UITabBarController {
    
    override func viewDidAppear(_ animated: Bool) {
        /*super.viewDidAppear(animated)
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        print("view did appear")
        
        if (keychain.get("auth") == "" || keychain.get("auth") == nil) {
            print("presenting login vc")
            let login_vc = LogInViewController()
            _ = UINavigationController(rootViewController: login_vc)
            //self.pushViewController(loginNavController, animated: true)
        }*/
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("view did load")
        
        if (keychain.get("auth") == nil) {
            print("presenting login")
            let login_vc = LogInViewController()
            //let loginNavController = UINavigationController(rootViewController: login_vc)
            //view.pushViewController(loginNavController, animated: true)
            self.present(login_vc, animated: true, completion: nil);
        }
        else {
            
            print("tab bar")
        
        self.tabBar.tintColor = UIColor(red:0.00, green:0.74, blue:0.83, alpha:1.0)
        
        let groups_controller = GroupPage()
        let groupsNavController = UINavigationController(rootViewController: groups_controller)
        groupsNavController.tabBarItem.title = "Nearby"
        groupsNavController.tabBarItem.image = UIImage(named: "nearby")
        
        let active_controller = ActivePage()
        let activeNavController = UINavigationController(rootViewController: active_controller)
        activeNavController.tabBarItem.title = "Active"
        activeNavController.tabBarItem.image = UIImage(named: "active")
        
        let account_controller = UserSettingsViewController()
        let accountNavController = UINavigationController(rootViewController: account_controller)
        accountNavController.tabBarItem.title = "Account"
        accountNavController.tabBarItem.image = UIImage(named: "account")
        
        viewControllers = [groupsNavController, activeNavController, accountNavController]
        }
        //viewControllers = [groupsNavController]
    }
}
