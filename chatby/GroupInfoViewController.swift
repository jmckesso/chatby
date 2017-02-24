//
//  GroupInfoViewController.swift
//  chatby
//
//  Created by Tanner Strom on 2/23/17.
//  Copyright © 2017 Jacob McKesson. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class GroupInfoViewController: UIViewController {
    
    var groupName: String!;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        drawUI();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }
    
    // Functional shit here
    
    func joingroup(_ sender: UIBarButtonItem) {
        // JACOB HELLO!
        <#T##HTTPMethod#>
        Alamofire.request("http://chatby.vohras.tk/api/users/current", encoding: JSONEncoding.default, headers: <#T##HTTPHeaders?#>)
        
        
        let room_parameters : Parameters = [
            "muted":false,
            "room_url":"roomname"
        ]

        
        
        
        
    }
    
    // UI Shit down here
    
    func drawUI() {
        self.title = groupName;
        let inpWid:CGFloat = self.view.bounds.width;
        
        let label: UILabel = UILabel(frame: CGRect(x: self.view.bounds.width / 2 - (inpWid / 2) + 20,
                                                   y: self.view.bounds.height / 4,
                                                   width: inpWid,
                                                   height: 100));
        
        label.text = groupName;
        label.textAlignment = NSTextAlignment.left;
        label.textColor = UIColor.black;
        
        let confirmBtn:UIButton = UIButton(frame: CGRect(x: self.view.bounds.width / 2 - (inpWid / 2) + 5,
                                                            y: self.view.frame.maxY - 70,
                                                            width: self.view.bounds.width - 10,
                                                            height: 65));
        confirmBtn.backgroundColor = UIColor.gray;
        confirmBtn.setTitleColor(UIColor.white, for: UIControlState.normal);
        confirmBtn.setTitleColor(UIColor.lightGray, for: UIControlState.highlighted);
        confirmBtn.setTitle("Add to group", for: .normal);
        confirmBtn.addTarget(self, action: #selector(joingroup(_:)), for: .touchUpInside);
        
        confirmBtn.setTitleColor(UIColor(colorLiteralRed: 14.0/255,
                                         green: 122.0/255,
                                         blue: 254.0/255,
                                         alpha: 1.0), for: UIControlState.normal);
        confirmBtn.setTitleColor(UIColor(colorLiteralRed: 14.0/255,
                                         green: 122.0/255,
                                         blue: 254.0/255,
                                         alpha: 0.5), for: UIControlState.highlighted);
        
        confirmBtn.layer.cornerRadius = 5;
        confirmBtn.layer.borderColor = UIColor(colorLiteralRed: 14.0/255,
                                               green: 122.0/255,
                                               blue: 254.0/255,
                                               alpha: 1.0).cgColor;
        confirmBtn.layer.borderWidth = 1;
        confirmBtn.layer.backgroundColor = UIColor.white.cgColor;
        
        self.view.addSubview(confirmBtn);
        self.view.addSubview(label);
    }
}
