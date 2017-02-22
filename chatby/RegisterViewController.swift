//
//  RegisterViewController.swift
//  chatby
//
//  Created by Jacob McKesson on 2/22/17.
//  Copyright © 2017 Jacob McKesson. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RegisterViewController: UIViewController {

    let user_page = "http://chatby.vohras.tk/api/users/"
    
    @IBOutlet weak var username_field: UITextField!
    @IBOutlet weak var email_field: UITextField!
    @IBOutlet weak var first_name_field: UITextField!
    @IBOutlet weak var last_name_field: UITextField!
    @IBOutlet weak var password_field: UITextField!
    @IBOutlet weak var confirm_password_field: UITextField!
    
    @IBAction func submit_registration(_ sender: Any) {
        
        let username = username_field.text!
        let email = email_field.text!
        let first_name = first_name_field.text!
        let last_name = last_name_field.text!
        let password = password_field.text!
        let confirm_password = confirm_password_field.text!
        
        if (username == "" || email == "" || password == "" || confirm_password == "") {
            print("please fill out all fields")
            return
        }
        
        if (password != confirm_password) {
            print("password and confirm password must match")
            return
        }
        
        let user_reg : Parameters = [
            "username":username,
            "email":email,
            "first_name":first_name,
            "last_name":last_name,
            "password":password
        ]
        
        Alamofire.request(user_page, method: .post, parameters: user_reg, encoding: JSONEncoding.default).validate().responseJSON(completionHandler: { response in
            print(response.request!)  // original URL request
            print(response.response!) // HTTP URL response
            print(response.data!)     // server data
            print(response.result)
            
            switch response.result {
            case .success:
                print("super success")
                //self.performSegue(withIdentifier: "toTable", sender: self)
            case .failure:
                print("mega fail")
                //let alert_controller = UIAlertController(title: "YOU SUCK", message: "also this is an alert", preferredStyle: UIAlertControllerStyle.alert)
                //let ok_action = UIAlertAction(title: "I Know", style: .default)
                
                //alert_controller.addAction(ok_action)
                //self.present(alert_controller, animated: true, completion: nil)
            }
            
            let response_data = JSON(response.result.value!);
            print(response_data)
            
            
        })
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
