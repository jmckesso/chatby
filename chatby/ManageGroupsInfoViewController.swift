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

class ManageGroupsInfoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var user_list = [String]();
    var table:UITableView = UITableView();
    
    var group_path:String!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        print("--- Manage Group Info ---")
        print(group_path)
        
        Alamofire.request(group_path).validate().responseJSON(completionHandler: { response in
            //print(response.request!)  // original URL request
            //print(response.response!) // HTTP URL response
            //print(response.data!)     // server data
            //print(response.result)
            
            switch response.result {
            case .success:
                print("super success")
                let group = JSON(response.result.value!)
                let members = group["members"]
                print(members.count)
                var i = 0
                while (i < members.count) {
                    self.user_list.append(members[i].stringValue)
                    print("user_list_count adding: ")
                    print(self.user_list.count)
                    i = i + 1
                }
                //self.table.reloadData()
            case .failure:
                print("mega fail")
            }
        })
        
        makeTable();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected cell");
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection: Int) -> Int {
        print("user list count: "); print(user_list.count)
        return self.user_list.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell;
        let name = self.user_list[indexPath.row]
        //let name = "hello"
        cell.textLabel?.text = String(name);
        
        return cell;
    }
    
    func makeTable() {
        table = UITableView(frame: self.view.bounds, style: UITableViewStyle.plain);
        table.dataSource = self;
        table.delegate = self;
        
        self.view.addSubview(table);
    }
}
