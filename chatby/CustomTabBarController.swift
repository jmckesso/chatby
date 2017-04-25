//
//  CustomTabBarController.swift
//  chatby
//
//  Created by Jacob McKesson on 4/25/17.
//  Copyright © 2017 Jacob McKesson. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let groups_controller = GroupPage()
        let groupsNavController = UINavigationController(rootViewController: groups_controller)
        groupsNavController.tabBarItem.title = "Nearby"
        groupsNavController.tabBarItem.image = UIImage(named: "nearby")
        
        let active_controller = UserSettingsViewController()
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
