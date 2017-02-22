//
//  ViewController.swift
//  chatby
//
//  Created by Jacob McKesson on 2/13/17.
//  Copyright © 2017 Jacob McKesson. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {
    
    var list_of_users = "http://chatby.vohras.tk/api/users"

    @IBOutlet weak var username_field: UITextField!
    @IBOutlet weak var password_field: UITextField!
    
    var names = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        callAlamo( url: list_of_users )
        
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
        
        Alamofire.request(list_of_users).responseJSON(completionHandler: {
            response in
            
            do {
                let readable_json = try JSONSerialization.jsonObject(with: response.data!) as? [[String: Any]]
                print(readable_json)
            }
            catch {
                print(error)
            }
            
        })
        
        
        if (username_field.text == "Jacob") {
            print("username set correctly")
        }
        else {
            print("username not set correctly")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

}

