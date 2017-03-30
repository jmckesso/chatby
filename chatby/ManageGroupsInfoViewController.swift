//
//  ManageGroupsInfoViewController.swift
//  chatby
//
//  Created by Tanner Strom on 3/30/17.
//  Copyright © 2017 Jacob McKesson. All rights reserved.
//

import Foundation
import UIKit

class ManageGroupsInfoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var user_list = [[String]]();
    var table:UITableView = UITableView();
    
    override func viewDidLoad() {
        super.viewDidLoad();
        makeTable();
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
    
    func makeTable() {
        table = UITableView(frame: self.view.bounds, style: UITableViewStyle.plain);
        table.dataSource = self;
        table.delegate = self;
        
        self.view.addSubview(table);
    }
}
