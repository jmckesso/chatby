//
//  GroupsViewController.swift
//  chatby
//
//  Created by Tanner Strom on 2/23/17.
//  Copyright © 2017 Jacob McKesson. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import KeychainSwift


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
    
    let keychain = KeychainSwift()
    
    var nav: UINavigationBar!;
    var table = UITableView();
    var auth_token: JSON!
    
    let refreshControl = UIRefreshControl();
    
    var group_url = "http://chatby.vohras.tk/api/rooms/"
    
    var data = [[String]]();
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
 
        Alamofire.request(group_url).validate().responseJSON(completionHandler: { response in
            
            switch response.result {
            case .success:
                print("super success")
                let groups = JSON(response.result.value!)
                for (_,subJson):(String, JSON) in groups {
                    let name = subJson["name"].stringValue
                    let path = subJson["url"].stringValue
                    var entry = [String]()
                    entry.append(name)
                    entry.append(path)
                    self.data.append(entry)
                    self.table.reloadData();
                }
                
            case .failure:
                print("mega fail")
            }
        })
        
        tableInit();
        table.refreshControl = refreshControl;
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged);
    }
    
    func refreshData() {
        self.table.reloadData();
        refreshControl.endRefreshing();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setToolbarHidden(true, animated: true);
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //self.navigationController?.setToolbarHidden(false, animated: true);
        self.tabBarController?.tabBar.isHidden = false;
    }
    
    // Table shit
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection: Int) -> Int {
        // Change this
        return self.data.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Text label is the good shit
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell;
        let name = self.data[indexPath.row][0]
        cell.textLabel?.text = String(name);
        
        return cell;
    }

    func tableView(_ tableView: UITableView, didSelectRowAt: IndexPath) {
        // FIND A WAY TO SEGUE NAMES INTO THIS AND PRINT THEM ON THE VIEW CONTROLLER
        let infostory = UIStoryboard(name: "Login", bundle: nil);
        let infocontr = infostory.instantiateViewController(withIdentifier: "GroupInfoMain") as! GroupInfoViewController;
        let g_path = self.data[didSelectRowAt.row][1]
        let g_name = self.data[didSelectRowAt.row][0]
        infocontr.group_path = g_path;
        infocontr.groupName = g_name
        self.navigationController?.pushViewController(infocontr, animated: true);
    }

    
    // Transition shit
    
    func addUserView(_ sender: UIAlertAction) {
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
                                                        action: #selector(createActionSheet(_:)));
        
        /*let loginButton:UIBarButtonItem = UIBarButtonItem(title: "Logout",
                                                          style: UIBarButtonItemStyle.plain,
                                                          target: self,
                                                          action: #selector(loginout(_:)));
        // To be implemented later
        let logoutButton:UIBarButtonItem = UIBarButtonItem(title: "Logout",
                                                           style: UIBarButtonItemStyle.plain,
                                                           target: self,
                                                           action: #selector(loginout(_:)));
        */
        table = UITableView(frame: self.view.bounds, style: UITableViewStyle.plain);
        table.dataSource = self;
        table.delegate = self;
        self.table.register(UITableViewCell.self, forCellReuseIdentifier: "cell");
        
        self.title = "Groups";
        
        self.navigationItem.rightBarButtonItem = addButton;
        //self.navigationItem.leftBarButtonItem = loginButton;
        
        var items = [UIBarButtonItem]();
        items.append(
            UIBarButtonItem(title: "Tanner Strom",
                            style: UIBarButtonItemStyle.plain,
                            target: nil, action: nil)
        );
        
        self.navigationController?.toolbar.items = items;
        
        self.view.addSubview(table);
    }
    
    func createActionSheet(_ sender:UIBarButtonItem) {
        
        let addboard = UIStoryboard(name: "Login", bundle: nil);
        let addcontr = addboard.instantiateViewController(withIdentifier: "AddGroupMain");
        let managecontr = addboard.instantiateViewController(withIdentifier: "ManageGroupsMain");
        let style = UIModalTransitionStyle.coverVertical;
        addcontr.modalTransitionStyle = style;
        
        let actionSheet = UIAlertController(title: "Options", message: nil, preferredStyle: .actionSheet);
        let toAddGroup = UIAlertAction(title: "Create Group",
                                       style: .default,
                                       handler: { (action:UIAlertAction) in
                                            self.present(addcontr, animated: true, completion: nil);
                                        });
        let toManageGroup = UIAlertAction(title: "Manage Groups",
                                          style: .default,
                                          handler: {(action:UIAlertAction) in
                                            self.navigationController?.pushViewController(managecontr, animated: true);
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: {(action:UIAlertAction) -> Void in});
        
        actionSheet.addAction(toAddGroup);
        actionSheet.addAction(toManageGroup);
        actionSheet.addAction(cancel);
        
        self.present(actionSheet, animated: true, completion: nil);
    }
    
    func backFromLogin() {
        print("Back from login")
    }
    
}




