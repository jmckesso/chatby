//
//  GroupsViewController.swift
//  chatby
//
//  Created by Tanner Strom on 2/23/17.
//  Copyright © 2017 Jacob McKesson. All rights reserved.
//

import Foundation
import UIKit

class GroupCell: UITableViewCell {
    var aMap: UILabel!;
    
    func setUpCell() {
        aMap = UILabel(frame: CGRect(x: 0,
                                     y: 0,
                                     width: 200,
                                     height: 50));
        self.contentView.addSubview(aMap);
    }
}

class GroupsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var nav: UINavigationBar!;

    var table = UITableView();
    var data = [[String:AnyObject]]();
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.title = "Groups";
        
        let addButton:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                  target: self,
                                                  action: #selector(addUserView(_:)));
        
        let loginButton:UIBarButtonItem = UIBarButtonItem(title: "Login",
                                                        style: UIBarButtonItemStyle.plain,
                                                        target: self,
                                                        action: #selector(loginout(_:)));
        
        let logoutButton:UIBarButtonItem = UIBarButtonItem(title: "Logout",
                                                          style: UIBarButtonItemStyle.plain,
                                                          target: self,
                                                          action: #selector(loginout(_:)));
        
        self.navigationItem.rightBarButtonItem = addButton;
        self.navigationItem.leftBarButtonItem = loginButton;
        
        table = UITableView(frame: self.view.bounds, style: UITableViewStyle.plain);
        table.dataSource = self;
        table.delegate = self;
        
        self.table.register(GroupCell.self as AnyClass, forCellReuseIdentifier: "GroupCell");
        
        self.view.addSubview(table);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }
    
    // Table shit
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:GroupCell? = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as? GroupCell;
        
        if cell == nil {
            cell = GroupCell(style: UITableViewCellStyle.default, reuseIdentifier: "GroupCell");
        }
        
        var tableData = data[indexPath.row];
        cell?.setUpCell();
        cell!.aMap.text = "TANNER IS COOL";
        return cell!
    }
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count;
    }
    
    // Transition shit
    
    func addUserView(_ sender: UIBarButtonItem) {
        let addboard = UIStoryboard(name: "Login", bundle: nil);
        let addcontr = addboard.instantiateViewController(withIdentifier: "AddGroupMain");
        let style = UIModalTransitionStyle.coverVertical;
        addcontr.modalTransitionStyle = style;
        self.present(addcontr, animated: true, completion: nil);
    }
    
    func loginout(_ sender: UIBarButtonItem) {
        let logboard = UIStoryboard(name: "Login", bundle: nil);
        let logcontr = logboard.instantiateViewController(withIdentifier: "LoginMain");
        let style = UIModalTransitionStyle.coverVertical;
        logcontr.modalTransitionStyle = style;
        self.present(logcontr, animated: true, completion: nil);
    }
    
    // UI shit
    
    
    
}




