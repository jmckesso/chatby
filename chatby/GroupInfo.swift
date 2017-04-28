//
//  GroupInfo.swift
//  chatby
//
//  Created by Jacob McKesson on 4/27/17.
//  Copyright © 2017 Jacob McKesson. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import SwiftyJSON
import LBTAComponents

class GroupInfo: UIViewController {

    var group_name = String()
    var curr_user = String()
    
    var curr_group: [String: Any]!
    var favorites: JSON!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = group_name
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.00, green:0.74, blue:0.83, alpha:1.0)
        
        let close_button = UIButton()
        close_button.setImage(UIImage(named: "Left-50"), for: UIControlState.normal)
        close_button.tintColor = UIColor.white
        close_button.addTarget(self, action: #selector(dismissView(sender:)), for: UIControlEvents.touchUpInside)
        close_button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let close_bar_button = UIBarButtonItem(customView: close_button)
        self.navigationItem.leftBarButtonItem = close_bar_button
        
        let more_button = UIButton()
        more_button.setImage(UIImage(named: "More-50"), for: UIControlState.normal)
        more_button.tintColor = UIColor.white
        more_button.addTarget(self, action: #selector(handleMore), for: UIControlEvents.touchUpInside)
        more_button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let more_bar_button = UIBarButtonItem(customView: more_button)
        self.navigationItem.rightBarButtonItem = more_bar_button
        
        self.view.backgroundColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)
        
    }
    
    let menu_launcher = MenuLauncher()
    
    func handleMore() {
        menu_launcher.favorites = self.favorites
        menu_launcher.curr_group = self.curr_group
        menu_launcher.curr_user = self.curr_user
        menu_launcher.showMenu()
    }
    
    func dismissView(sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil);
    }
    
    
    
}
