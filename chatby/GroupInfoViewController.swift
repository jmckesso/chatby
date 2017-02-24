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
import KeychainSwift

class GroupInfoViewController: UIViewController {
    
    var groupName: String!;
    var group_path: String!;
    var auth_token: JSON!
    
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
        
        //let keychain = KeychainSwift()
        
        print(group_path)
        
        print("here2")
        print(keychain.get("auth")!)
        
        let auth_string = "Token " + keychain.get("auth")!
        print("auth string")
        print(auth_string)
        print(group_path)
        
        let header = [
            "Authorization" : auth_string
        ]
        let room_parameters : Parameters = [
            "muted":false,
            "room":group_path
        ]

        
        /* Alamofire.request("http://chatby.vohras.tk/api/users/current/", encoding: JSONEncoding.default, headers: header).validate().responseJSON(completionHandler: {
            response in
            print(response.request!)  // original URL request
            print(response.response!) // HTTP URL response
            print(response.data!)     // server data
            print(response.result)
            
            let user_info = JSON(response.result.value!)
            print(user_info)
            
        }) */

        Alamofire.request("http://chatby.vohras.tk/api/membership", method: .post, parameters: room_parameters, encoding: JSONEncoding.default, headers: header).validate().responseJSON(completionHandler: {
            response in
            print(response.request!)  // original URL request
            print(response.response!) // HTTP URL response
            print(response.data!)     // server data
            print(response.result)
        })

        
        
        
        
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
        confirmBtn.setTitle("Join group", for: .normal);
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
