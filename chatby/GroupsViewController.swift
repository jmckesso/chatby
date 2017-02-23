//
//  GroupsViewController.swift
//  chatby
//
//  Created by Tanner Strom on 2/23/17.
//  Copyright © 2017 Jacob McKesson. All rights reserved.
//

import Foundation
import UIKit

// Cell prototype for future use
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
    
    // Jacob, put the data in the data array, replace the instances of testData with data, ???, profit
    var data = [[String:AnyObject]]();
    let testData = ["Cat", "Dog", "Austin's Fursona"];
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        tableInit();
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setToolbarHidden(true, animated: true);
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setToolbarHidden(false, animated: true);
    }
    
    // Table shit
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection: Int) -> Int {
        // Change this
        return self.testData.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Text label is the good shit
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell;
        cell.textLabel?.text = self.testData[indexPath.row];
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt: IndexPath) {
        // FIND A WAY TO SEGUE NAMES INTO THIS AND PRINT THEM ON THE VIEW CONTROLLER
        let infostory = UIStoryboard(name: "Login", bundle: nil);
        let infocontr = infostory.instantiateViewController(withIdentifier: "GroupInfoMain");
        self.navigationController?.pushViewController(infocontr, animated: true);
    }

    
    // Transition shit
    
    func addUserView(_ sender: UIBarButtonItem) {
        let addboard = UIStoryboard(name: "Login", bundle: nil);
        let addcontr = addboard.instantiateViewController(withIdentifier: "AddGroupMain");
        let style = UIModalTransitionStyle.coverVertical;
        addcontr.modalTransitionStyle = style;
        self.present(addcontr, animated: true, completion: nil);
    }
    
    // needs logic to sign the user out
    func loginout(_ sender: UIBarButtonItem) {
        let logboard = UIStoryboard(name: "Login", bundle: nil);
        let logcontr = logboard.instantiateViewController(withIdentifier: "LoginMain");
        let style = UIModalTransitionStyle.coverVertical;
        logcontr.modalTransitionStyle = style;
        self.present(logcontr, animated: true, completion: nil);
    }
    
    // UI shit
    
    func tableInit() {
        
        let addButton:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                        target: self,
                                                        action: #selector(addUserView(_:)));
        
        let loginButton:UIBarButtonItem = UIBarButtonItem(title: "Login",
                                                          style: UIBarButtonItemStyle.plain,
                                                          target: self,
                                                          action: #selector(loginout(_:)));
        // To be implemented later
        let logoutButton:UIBarButtonItem = UIBarButtonItem(title: "Logout",
                                                           style: UIBarButtonItemStyle.plain,
                                                           target: self,
                                                           action: #selector(loginout(_:)));
        
        table = UITableView(frame: self.view.bounds, style: UITableViewStyle.plain);
        table.dataSource = self;
        table.delegate = self;
        self.table.register(UITableViewCell.self, forCellReuseIdentifier: "cell");
        
        self.title = "Groups";
        
        self.navigationItem.rightBarButtonItem = addButton;
        self.navigationItem.leftBarButtonItem = loginButton;
        
        var items = [UIBarButtonItem]();
        items.append(
            UIBarButtonItem(title: "Tanner Strom",
                            style: UIBarButtonItemStyle.plain,
                            target: nil, action: nil)
        );
        self.navigationController?.toolbar.items = items;
        
        self.view.addSubview(table);
    }
    
}




