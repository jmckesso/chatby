//
//  ManageGroupsInfoViewController.swift
//  chatby
//
//  Created by Tanner Strom on 3/30/17.
//  Copyright © 2017 Jacob McKesson. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import KeychainSwift

class ManageGroupsInfoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var user_list = [[String]]();
    var table:UITableView = UITableView();
    
    var group_path:String!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.extendedLayoutIncludesOpaqueBars = true;
        self.edgesForExtendedLayout = .all;
        
        Alamofire.request(group_path).validate().responseJSON(completionHandler: { response in
            
            switch response.result {
            case .success:
                
                let group = JSON(response.result.value!)
                let members = group["members"]
                var i = 0
                while (i < members.count) {
                    self.user_list.append([members[i].stringValue])
                    i = i + 1
                }
                self.makeTable();
            case .failure:
                print("mega fail")
            }
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected cell");
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection: Int) -> Int {
        return self.user_list.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell;
        let name = self.user_list[indexPath.row][0]
        cell.textLabel?.text = String(name);
        
        return cell;
    }
    
    /*func deleteRequests(name: JSON) {
        let auth_string = "Token " + keychain.get("auth")!
        
        let header = [
            "Authorization" : auth_string
        ]
        
        Alamofire.request("http://chatby.vohras.tk/api/memberships/", method: .delete, parameters: json, encoding: JSONEncoding.default, headers: header).validate().responseJSON(completionHandler: {
            response in
            
        })
    }*/
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            
            
            
            /*let auth_string = "Token " + keychain.get("auth")!
            
            let header = [
                "Authorization" : auth_string
            ]
            
            let group_param : Parameters = [
                "user":user_list[indexPath.row],
                "room":group_path
            ]
            
            Alamofire.request("http://chatby.vohras.tk/api/memberships/", method: .get, parameters: group_param, encoding: JSONEncoding.default, headers: header).validate().responseJSON(completionHandler: {
                response in
                
                let stuff = JSON(response.result.value!)
                self.deleteRequests(stuff)
                
                
            })*/
            
            
            
            user_list.remove(at: indexPath.row);
            
            tableView.deleteRows(at: [indexPath], with: .automatic);
            
        }
    }
    
    func makeTable() {
        table = UITableView(frame: self.view.bounds, style: UITableViewStyle.plain);
        table.contentInset = UIEdgeInsetsMake(70.0, 0.0, 0.0, 0.0);
        table.dataSource = self;
        table.delegate = self;
        
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell");
        
        self.view.addSubview(table);
    }
}
