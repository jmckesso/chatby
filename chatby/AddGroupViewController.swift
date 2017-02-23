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
        
        // Todo: Clear all input boxes on view dismissal
        
        dismiss(animated: true, completion: nil);
    }
    
    func addGroup(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil);
    }
    
    // UI shit
    
    func addBar() {
        let nav: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 84));
        
        let addButton:UIBarButtonItem = UIBarButtonItem(title: "Add",
                                                        style: UIBarButtonItemStyle.plain,
                                                        target: self,
                                                        action: #selector(addGroup(_:)));
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
        
        
        let gunderline = CALayer();
        let gundWid:CGFloat = 2.0;
        gunderline.borderColor = UIColor.black.cgColor;
        gunderline.frame = CGRect(x: 0,
                                 y: groupname.frame.size.height - gundWid,
                                 width: groupname.frame.size.width,
                                 height: groupname.frame.size.height);
        
        gunderline.borderWidth = gundWid;
        groupname.placeholder = "Group Name";
        //groupname.layer.addSublayer(gunderline);

        
        let thunderline = CALayer();
        let thundWid:CGFloat = 2.0;
        thunderline.borderColor = UIColor.black.cgColor;
        thunderline.frame = CGRect(x: 0,
                                 y: timeAliveHr.frame.size.height - thundWid,
                                 width: timeAliveHr.frame.size.width,
                                 height: timeAliveHr.frame.size.height);
        
        thunderline.borderWidth = thundWid;
        timeAliveHr.placeholder = "Time alive (hours)";
        timeAliveHr.keyboardType = UIKeyboardType.numberPad;
        //timeAliveHr.layer.addSublayer(thunderline);
        
        let tmunderline = CALayer();
        let tmundWid:CGFloat = 2.0;
        tmunderline.borderColor = UIColor.black.cgColor;
        tmunderline.frame = CGRect(x: 0,
                                 y: timeAliveMin.frame.size.height - tmundWid,
                                 width: timeAliveMin.frame.size.width,
                                 height: timeAliveMin.frame.size.height);
        tmunderline.borderWidth = tmundWid;
        timeAliveMin.placeholder = "Time alive (mins)";
        timeAliveMin.keyboardType = UIKeyboardType.numberPad;
        //timeAliveMin.layer.addSublayer(tmunderline);

        
        let runderline = CALayer();
        let rundWid:CGFloat = 2.0;
        runderline.borderColor = UIColor.black.cgColor;
        runderline.frame = CGRect(x: 0,
                                 y: groupRadius.frame.size.height - rundWid,
                                 width: groupRadius.frame.size.width,
                                 height: groupRadius.frame.size.height);
        runderline.borderWidth = rundWid;
        groupRadius.placeholder = "Group radius";
        groupRadius.keyboardType = UIKeyboardType.numberPad;
        //groupRadius.layer.addSublayer(runderline);

        
        self.view.addSubview(groupname);
        self.view.addSubview(timeAliveHr);
        self.view.addSubview(timeAliveMin);
        self.view.addSubview(groupRadius);
        
    }
    
    
    
}
