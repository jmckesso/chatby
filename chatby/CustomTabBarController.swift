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
        super.viewDidAppear(animated)
        
        if (keychain.get("auth") == "" || keychain.get("auth") == nil) {
            print("going to login")
            let login_vc = LogInViewController()
            self.present(login_vc, animated: true, completion: nil)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (keychain.getBool("auth") == false) {
            print("Sup nerd");
            let login_vc = LogInViewController();
            self.present(login_vc, animated: true, completion: nil);
        }
        
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
}
