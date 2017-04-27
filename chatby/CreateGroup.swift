//
//  CreateGroup.swift
//  chatby
//
//  Created by Jacob McKesson on 4/26/17.
//  Copyright © 2017 Jacob McKesson. All rights reserved.
//

import UIKit
import LBTAComponents
import CoreLocation
import Alamofire
import SwiftyJSON

class CreateGroup: UIViewController, CLLocationManagerDelegate {

    var locationManager: CLLocationManager?
    var current_location: CLLocation?
    
    var request_format: String!
    
    var make_url = "http://chatby.vohras.tk/api/rooms/"
    
    let group_name: UITextField = {
        let text_field = UITextField()
        text_field.placeholder = "Title"
        text_field.backgroundColor = UIColor(red:0.00, green:0.74, blue:0.83, alpha:1.0)
        text_field.textColor = UIColor.white
        return text_field
    }()
    
    let underline_1: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let group_radius: UITextField = {
        let text_field = UITextField()
        text_field.placeholder = "Radius (km)"
        text_field.backgroundColor = UIColor(red:0.00, green:0.74, blue:0.83, alpha:1.0)
        text_field.textColor = UIColor.white
        return text_field
    }()
    
    let underline_2: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let selected_date: UILabel = {
        let label = UILabel()
        label.text = "Please select a date"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.white
        return label
    }()
    
    let end_date_message: UILabel = {
        let label = UILabel()
        label.text = "End Date"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.white
        return label
    }()
    
    let date_picker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.timeZone = NSTimeZone.local
        dp.backgroundColor = UIColor(red:0.00, green:0.74, blue:0.83, alpha:1.0)
        dp.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        return dp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Create New Group"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.00, green:0.74, blue:0.83, alpha:1.0)
        
        let close_button = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(dismissView(sender:)))
        close_button.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = close_button
        
        let confirm_button = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(confirmGroup(sender:)))
        confirm_button.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = confirm_button
        
        self.view.backgroundColor = UIColor(red:0.00, green:0.74, blue:0.83, alpha:1.0)

        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.startUpdatingLocation()
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestAlwaysAuthorization()
        
        addViews()
        
        
        // Do any additional setup after loading the view.
    }
    
    func addViews() {
        self.view.addSubview(group_name)
        self.view.addSubview(underline_1)
        self.view.addSubview(group_radius)
        self.view.addSubview(underline_2)
        self.view.addSubview(selected_date)
        self.view.addSubview(end_date_message)
        self.view.addSubview(date_picker)
        
        group_name.anchor(self.view.topAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, topConstant: 150, leftConstant: 32, bottomConstant: 0, rightConstant: 32, widthConstant: 0, heightConstant: 50)
        
        underline_1.anchor(group_name.bottomAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, topConstant: 0, leftConstant: 32, bottomConstant: 0, rightConstant: 32, widthConstant: 0, heightConstant: 1)
        
        group_radius.anchor(underline_1.bottomAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, topConstant: 20, leftConstant: 32, bottomConstant: 0, rightConstant: 32, widthConstant: 0, heightConstant: 50)
        
        underline_2.anchor(group_radius.bottomAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, topConstant: 0, leftConstant: 32, bottomConstant: 0, rightConstant: 32, widthConstant: 0, heightConstant: 1)
        
        selected_date.anchor(underline_2.bottomAnchor, left: self.view.leftAnchor, bottom: nil, right: end_date_message.leftAnchor, topConstant: 40, leftConstant: 50, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 15)
        
        end_date_message.anchor(underline_2.bottomAnchor, left: nil, bottom: nil, right: self.view.rightAnchor, topConstant: 40, leftConstant: 0, bottomConstant: 0, rightConstant: 32, widthConstant: 75, heightConstant: 15)
        
        date_picker.anchor(end_date_message.bottomAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, topConstant: 20, leftConstant:32, bottomConstant: 0, rightConstant: 32, widthConstant: 100, heightConstant: 100)
        
    }
    
    func datePickerValueChanged(_ sender: UIDatePicker){
        
        let dateFormatter: DateFormatter = DateFormatter()
        let sent = sender.date
        
        dateFormatter.dateFormat = "EEE, MMM dd 'at' h:mm a"
        
        var selectedDate: String = dateFormatter.string(from: sent)
        selected_date.text = selectedDate
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.ssssssZ"
        
        selectedDate = dateFormatter.string(from: sent)
        print(selectedDate)
        request_format = selectedDate
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.current_location = locations[0]
        locationManager?.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func dismissView(sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil);
    }
    
    func confirmGroup(sender: UIBarButtonItem) {
        print("sending request")
        
        let header = [
            "Authorization": "Token " + keychain.get("auth")!
        ]
        
        let group_param : Parameters = [
            "name": group_name.text!,
            "radius": group_radius.text!,
            "expire_time": request_format,
            "image_url": "",
            "latitude": current_location!.coordinate.latitude,
            "longitude": current_location!.coordinate.longitude
        ]
        
        Alamofire.request(make_url, method: .post, parameters: group_param, encoding: JSONEncoding.default, headers: header).validate().responseJSON(completionHandler: {
            response in
            switch response.result {
            case .success:
                    self.dismiss(animated: true, completion: nil);
            case .failure:
                print("failed to make group")
            }
        })
        
    }

}
