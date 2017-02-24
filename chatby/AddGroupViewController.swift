//
//  AddGroupViewController.swift
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
import CoreLocation

class AddGroupViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {
    
    var groupname:      UITextField!;
    var timeAliveHr:    UITextField!;
    var timeAliveMin:   UITextField!;
    var groupRadius:    UITextField!;
    
    var make_url = "http://chatby.vohras.tk/api/rooms/"
    
    var locationManager: CLLocationManager?
    var current_location: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        addBar();
        addFields();

        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.startUpdatingLocation()
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestAlwaysAuthorization()
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard));
        view.addGestureRecognizer(tap);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.current_location = locations[0]
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }

    
    
    // Functional shit
    
    func dismissView(_ sender: UIBarButtonItem) {
        
        // Todo: Clear all input boxes on view dismissal, can be done later
        // it might actually do this automatically, I haven't checked
        // it does, just checked. im a GOD
        
        dismiss(animated: true, completion: nil);
    }
    
    func makeGroup(_ sender: UIBarButtonItem) {
        
        // Jacob, you know what to do
    
        let group_param : Parameters = [
            "name": groupname.text!,
            "radius": groupRadius.text!,
            "expire_time": "2017-02-28T20:46:52.125000Z",
            "image_url": "",
            "latitude": current_location!.coordinate.latitude,
            "longitude": current_location!.coordinate.longitude
        ]
    
        locationManager?.stopUpdatingLocation()
        
        let header = [
            "Authorization": "Token " + keychain.get("auth")!
        ]
        
        
        Alamofire.request(make_url, method: .post, parameters: group_param, encoding: JSONEncoding.default, headers: header).validate().responseJSON(completionHandler: {
            response in
            print(response.request!)  // original URL request
            print(response.response!) // HTTP URL response
            print(response.data!)     // server data
            print(response.result)
         
        })
        
        
        
        
        dismiss(animated: true, completion: nil);
    }
    
    // UI shit
    
    func addBar() {
        let nav: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 74));
        
        let addButton:UIBarButtonItem = UIBarButtonItem(title: "Add",
                                                        style: UIBarButtonItemStyle.plain,
                                                        target: self,
                                                        action: #selector(makeGroup(_:)));
        let cancelButton:UIBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                           style: UIBarButtonItemStyle.plain,
                                                           target: self,
                                                           action: #selector(dismissView(_:)));
        let navItems = UINavigationItem(title: "Add Group");
        navItems.rightBarButtonItem = addButton;
        navItems.leftBarButtonItem = cancelButton;
        
        self.view.addSubview(nav);
        nav.setItems([navItems], animated: true);
    }
    
    func addFields() {
        
        let inpWid:CGFloat = 300.0;
        let inpHei:CGFloat = 30.0;
        
        groupname =         UITextField(frame: CGRect(x: self.view.bounds.width / 2 - (inpWid / 2),
                                                      y: self.view.bounds.height / 5,
                                                      width: inpWid,
                                                      height: inpHei));
        
        timeAliveHr =         UITextField(frame: CGRect(x: self.view.bounds.width / 2 - (inpWid / 2),
                                                      y: self.view.bounds.height / 3.7,
                                                      width: inpWid,
                                                      height: inpHei));
        
        timeAliveMin =         UITextField(frame: CGRect(x: self.view.bounds.width / 2 - (inpWid / 2),
                                                      y: self.view.bounds.height / 2.9,
                                                      width: inpWid,
                                                      height: inpHei));
        
        groupRadius =         UITextField(frame: CGRect(x: self.view.bounds.width / 2 - (inpWid / 2),
                                                      y: self.view.bounds.height / 2.4,
                                                      width: inpWid,
                                                      height: inpHei));
        
        groupname.placeholder = "Group Name";

        timeAliveHr.placeholder = "Time alive (hours)";
        timeAliveHr.keyboardType = UIKeyboardType.numberPad;

        timeAliveMin.placeholder = "Time alive (mins)";
        timeAliveMin.keyboardType = UIKeyboardType.numberPad;

        groupRadius.placeholder = "Group radius";
        groupRadius.keyboardType = UIKeyboardType.numberPad;

        
        self.view.addSubview(groupname);
        self.view.addSubview(timeAliveHr);
        self.view.addSubview(timeAliveMin);
        self.view.addSubview(groupRadius);
        
        let addGroupToolbar = UIToolbar(frame: CGRect(x: 0,
                                                    y: 0,
                                                    width: self.view.frame.size.width,
                                                    height: 50));
        addGroupToolbar.barStyle = UIBarStyle.default;
        addGroupToolbar.items = [
            UIBarButtonItem(image: UIImage(named: "keyboardPreviousButton"), style: .plain, target: self, action: nil),
            UIBarButtonItem(image: UIImage(named: "iq"), style: .plain, target: self, action: nil),
            //UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.rewind, target: self, action: nil),
            //UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fastForward, target: self, action: nil),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: nil)]
        addGroupToolbar.sizeToFit();

        groupname.inputAccessoryView = addGroupToolbar
        timeAliveHr.inputAccessoryView = addGroupToolbar;
        timeAliveMin.inputAccessoryView = addGroupToolbar;
        groupRadius.inputAccessoryView = addGroupToolbar;
    }
    
    func DismissKeyboard() {
        view.endEditing(true);
    }
    
}
