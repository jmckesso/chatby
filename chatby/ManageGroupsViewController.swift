//
//  ManageGroupsViewController.swift
//  chatby
//
//  Created by Tanner Strom on 3/29/17.
//  Copyright © 2017 Jacob McKesson. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class ManageGroupsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var data = [[String]]();
    var table = UITableView();
    
    var group_path:String!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        
        let auth_string = "Token " + keychain.get("auth")!
        
        let header = [
            "Authorization" : auth_string
        ]
        
        var curr_user = ""
        
        Alamofire.request("http://chatby.vohras.tk/api/users/current/", method: .get, encoding: JSONEncoding.default, headers: header).validate().responseJSON(completionHandler: {
            response in
            
            let curr = JSON(response.result.value!)
            curr_user = curr["url"].stringValue
        })
        
        
        Alamofire.request("http://chatby.vohras.tk/api/rooms/").validate().responseJSON(completionHandler: { response in
            
            switch response.result {
            case .success:
                let groups = JSON(response.result.value!)
                
                for (_,subJson):(String, JSON) in groups {
                    let cb = subJson["created_by"].stringValue
                    if ( cb == curr_user ) {
                        let name = subJson["name"].stringValue
                        let path = subJson["url"].stringValue
                        var entry = [String]()
                        entry.append(name)
                        entry.append(path)
                        self.data.append(entry)
                        self.table.reloadData();
                    }
                }
                
            case .failure:
                print("mega fail")
            }
        })
        tableInitM();
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }

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
        let infostory = UIStoryboard(name: "Login", bundle: nil);
        let infocontr = infostory.instantiateViewController(withIdentifier: "GroupInfoMain") as! GroupInfoViewController;
        //let g_name = self.data[didSelectRowAt.row]

        infocontr.group_path = self.data[didSelectRowAt.row][1];
        self.navigationController?.pushViewController(infocontr, animated: true);
    }
    
    func tableInitM() {
        table = UITableView(frame: self.view.bounds, style: UITableViewStyle.plain);
        table.contentInset = UIEdgeInsetsMake(100.0, 0.0, 0.0, 0.0);
        table.dataSource = self;
        table.delegate = self;
        self.table.register(UITableViewCell.self, forCellReuseIdentifier: "cell");
        
        self.title = "Manage Groups";
        
        self.view.addSubview(table);
    }
}
