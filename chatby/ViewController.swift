//
//  ViewController.swift
//  chatby
//
//  Created by Jacob McKesson on 2/13/17.
//  Copyright © 2017 Jacob McKesson. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController {
    
    let list_of_users = "http://chatby.vohras.tk/api/users/"
    let auth_page = "http://chatby.vohras.tk/api/auth/"

    @IBOutlet weak var username_field: UITextField!
    @IBOutlet weak var password_field: UITextField!
    
    var name_list = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //callAlamo( url: list_of_users )
        
    }
    
   func callAlamo( url: String ) {
        Alamofire.request( url ).responseJSON(completionHandler: {
            response in
            print(response.result)
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
            }
        })
    }
    
    @IBAction func login_button(_ sender: UIButton) {
        
        let username = username_field.text
        let password = password_field.text
        
        if (username == "") {
            print("username field cannot be blank")
            return
        }
        else if (password == "") {
            print("password cannot be blank")
            return
        }
        
        let user_log : Parameters = [
            "username":username!,
            "password":password!
        ]
        
        Alamofire.request(auth_page, method: .post, parameters: user_log, encoding: JSONEncoding.default).validate().responseJSON(completionHandler: { response in
            print(response.request!)  // original URL request
            print(response.response!) // HTTP URL response
            print(response.data!)     // server data
            print(response.result)
            
            switch response.result {
                case .success:
                    print("super success")
                    self.performSegue(withIdentifier: "toTable", sender: self)
                case .failure:
                    print("mega fail")
                    let alert_controller = UIAlertController(title: "YOU SUCK", message: "also this is an alert", preferredStyle: UIAlertControllerStyle.alert)
                    let ok_action = UIAlertAction(title: "I Know", style: .default)
                    
                    alert_controller.addAction(ok_action)
                    self.present(alert_controller, animated: true, completion: nil)
                
                
                
            }
            
            //let auth_data = JSON(response.result.value!)
            //print("auth_data \(auth_data)")
            
        })
        
        
        
        
        /*Alamofire.request(list_of_users).validate().responseJSON(completionHandler: {
            response in
            
                let users = JSON(response.result.value!)
                print("\(users)")

        })*/

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

}

