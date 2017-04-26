//
//  CreateGroup.swift
//  chatby
//
//  Created by Jacob McKesson on 4/26/17.
//  Copyright © 2017 Jacob McKesson. All rights reserved.
//

import UIKit
import LBTAComponents

class CreateGroup: UIViewController {

    let group_name: UITextField = {
        let text_field = UITextField()
        text_field.placeholder = "Title"
        //text_field.backgroundColor = UIColor(red:0.00, green:0.74, blue:0.83, alpha:1.0)
        text_field.backgroundColor = UIColor.red
        text_field.textColor = UIColor.white
        //label.translatesAutoresizingMaskIntoConstraints = false
        return text_field
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Create New Group"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.00, green:0.74, blue:0.83, alpha:1.0)
        
        let item1 = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(dismissView(sender:)))
        item1.tintColor =  UIColor.white
        self.navigationItem.leftBarButtonItem = item1
        
        self.view.backgroundColor = UIColor(red:0.00, green:0.74, blue:0.83, alpha:1.0)

        addViews()
        
        
        // Do any additional setup after loading the view.
    }
    
    func addViews() {
        self.view.addSubview(group_name)
        
        group_name.anchor(self.view.topAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, topConstant: 40, leftConstant: 8, bottomConstant: 0, rightConstant: 8, widthConstant: 0, heightConstant: 20)
    }
    
    func dismissView(sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil);
    }

}
