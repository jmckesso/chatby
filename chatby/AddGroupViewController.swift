//
//  AddGroupViewController.swift
//  chatby
//
//  Created by Tanner Strom on 2/23/17.
//  Copyright © 2017 Jacob McKesson. All rights reserved.
//

import Foundation
import UIKit

class AddGroupViewController: UIViewController, UITextFieldDelegate {
    
    var groupname:      UITextField!;
    var timeAliveHr:    UITextField!;
    var timeAliveMin:   UITextField!;
    var groupRadius:    UITextField!;
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        addBar();
        addFields();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }
    
    // Functional shit
    
    func dismissView(_ sender: UIBarButtonItem) {
        
        // Todo: Clear all input boxes on view dismissal, can be done later
        // it might actually do this automatically, I haven't checked
        // it does, just checked. im a GOD
        
        dismiss(animated: true, completion: nil);
    }
    
    func makeGroup(_ sender: UIBarButtonItem) {
        // Jacob, you know what to do
        dismiss(animated: true, completion: nil);
    }
    
    // UI shit
    
    func addBar() {
        let nav: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 84));
        
        let addButton:UIBarButtonItem = UIBarButtonItem(title: "Add",
                                                        style: UIBarButtonItemStyle.plain,
                                                        target: self,
                                                        action: #selector(makeGroup(_:)));
        let cancelButton:UIBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                           style: UIBarButtonItemStyle.plain,
                                                           target: self,
                                                           action: #selector(dismissView(_:)));
        let navItems = UINavigationItem(title: "Add Group");
        navItems.rightBarButtonItem = addButton;
        navItems.leftBarButtonItem = cancelButton;
        
        self.view.addSubview(nav);
        nav.setItems([navItems], animated: true);
    }
    
    func addFields() {
        
        let inpWid:CGFloat = 300.0;
        let inpHei:CGFloat = 30.0;
        
        groupname =         UITextField(frame: CGRect(x: self.view.bounds.width / 2 - (inpWid / 2),
                                                      y: self.view.bounds.height / 5,
                                                      width: inpWid,
                                                      height: inpHei));
        
        timeAliveHr =         UITextField(frame: CGRect(x: self.view.bounds.width / 2 - (inpWid / 2),
                                                      y: self.view.bounds.height / 3.7,
                                                      width: inpWid,
                                                      height: inpHei));
        
        timeAliveMin =         UITextField(frame: CGRect(x: self.view.bounds.width / 2 - (inpWid / 2),
                                                      y: self.view.bounds.height / 2.9,
                                                      width: inpWid,
                                                      height: inpHei));
        
        groupRadius =         UITextField(frame: CGRect(x: self.view.bounds.width / 2 - (inpWid / 2),
                                                      y: self.view.bounds.height / 2.4,
                                                      width: inpWid,
                                                      height: inpHei));
        
        groupname.placeholder = "Group Name";

        timeAliveHr.placeholder = "Time alive (hours)";
        timeAliveHr.keyboardType = UIKeyboardType.numberPad;

        timeAliveMin.placeholder = "Time alive (mins)";
        timeAliveMin.keyboardType = UIKeyboardType.numberPad;

        groupRadius.placeholder = "Group radius";
        groupRadius.keyboardType = UIKeyboardType.numberPad;

        
        self.view.addSubview(groupname);
        self.view.addSubview(timeAliveHr);
        self.view.addSubview(timeAliveMin);
        self.view.addSubview(groupRadius);
        
    }
    
    
    
}
