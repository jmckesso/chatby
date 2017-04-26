//
//  CreateGroup.swift
//  chatby
//
//  Created by Jacob McKesson on 4/26/17.
//  Copyright © 2017 Jacob McKesson. All rights reserved.
//

import UIKit

class CreateGroup: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Create New Group"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.00, green:0.74, blue:0.83, alpha:1.0)
        
        self.view.backgroundColor = UIColor.white

        // Do any additional setup after loading the view.
    }

}
