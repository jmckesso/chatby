//
//  ManageGroupsViewController.swift
//  chatby
//
//  Created by Tanner Strom on 3/29/17.
//  Copyright © 2017 Jacob McKesson. All rights reserved.
//

import Foundation
import UIKit

class ManageGroupsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var data = [[String]]();
    var table = UITableView();
    
    override func viewDidLoad() {
        super.viewDidLoad();
                
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
        let g_path = self.data[didSelectRowAt.row][1]
        let g_name = self.data[didSelectRowAt.row][0]
        infocontr.group_path = g_path;
        infocontr.groupName = g_name
        self.navigationController?.pushViewController(infocontr, animated: true);
    }
    
    func tableInitM() {
        table = UITableView(frame: self.view.bounds, style: UITableViewStyle.plain);
        table.dataSource = self;
        table.delegate = self;
        self.table.register(UITableViewCell.self, forCellReuseIdentifier: "cell");
        
        self.title = "Manage Groups";
        
        self.view.addSubview(table);
    }
}
