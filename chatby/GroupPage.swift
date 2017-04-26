//
//  GroupPage.swift
//  chatby
//
//  Created by Jacob McKesson on 4/25/17.
//  Copyright © 2017 Jacob McKesson. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import KeychainSwift
import CoreLocation
import KCFloatingActionButton
import LBTAComponents

class GroupPage: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, CLLocationManagerDelegate {

    var statesDictionary = ["AL": "Alabama",
                            "AK": "Alaska",
                            "AZ": "Arizona",
                            "AR": "Arkansas",
                            "CA": "California",
                            "CO": "Colorado",
                            "CT": "Connecticut",
                            "DE": "Delaware",
                            "FL": "Florida",
                            "GA": "Georgia",
                            "HI": "Hawaii",
                            "ID": "Idaho",
                            "IL": "Illinois",
                            "IN": "Indiana",
                            "IA": "Iowa",
                            "KS": "Kansas",
                            "KY": "Kentucky",
                            "LA": "Louisiana",
                            "ME": "Maine",
                            "MD": "Maryland",
                            "MA": "Massachusetts",
                            "MI": "Michigan",
                            "MN": "Minnesota",
                            "MS": "Mississippi",
                            "MO": "Missouri",
                            "MT": "Montana",
                            "NE": "Nebraska",
                            "NV": "Nevada",
                            "NH": "New Hampshire",
                            "NJ": "New Jersey",
                            "NM": "New Mexico",
                            "NY": "New York",
                            "NC": "North Carolina",
                            "ND": "North Dakota",
                            "OH": "Ohio",
                            "OK": "Oklahoma",
                            "OR": "Oregon",
                            "PA": "Pennsylvania",
                            "RI": "Rhode Island",
                            "SC": "South Carolina",
                            "SD": "South Dakota",
                            "TN": "Tennessee",
                            "TX": "Texas",
                            "UT": "Utah",
                            "VT": "Vermont",
                            "VA": "Virginia",
                            "WA": "Washington",
                            "WV": "West Virginia",
                            "WI": "Wisconsin",
                            "WY": "Wyoming"]
    
    
    let keychain = KeychainSwift()
    
    var add_active = false
    
    var collection_view: UICollectionView!
    
    var locationManager: CLLocationManager?
    var current_location: CLLocation?
    
    var nav: UINavigationBar!;
    var table = UITableView();
    var auth_token: JSON!
    
    
    var curr = ""
    //let refreshControl = UIRefreshControl();
    
    let group_url = "http://chatby.vohras.tk/api/rooms/"
    
    var data = [[String]]();
    var member_counts = [Int]();
    var expire_dates = [String]();
    
    override func viewDidLoad() {
        
        self.title = "Nearby"
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.00, green:0.74, blue:0.83, alpha:1.0)
        
        let item1 = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(rightButtonAction(sender:)))
        self.navigationItem.rightBarButtonItem = item1
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        collection_view = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collection_view.dataSource = self
        collection_view.delegate = self
        
        collection_view.backgroundColor = UIColor.white
        collection_view.alwaysBounceVertical = true
        
        collection_view.register(NearbyHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerID")
        collection_view.register(GroupCell2.self, forCellWithReuseIdentifier: "cell")
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.startUpdatingLocation()
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestAlwaysAuthorization()
        
        print("loading groups")
        
        Alamofire.request(group_url).validate().responseJSON(completionHandler: { response in
                let groups = JSON(response.result.value!)
                for (_,subJson):(String, JSON) in groups {
                    let name = subJson["name"].stringValue
                    let path = subJson["url"].stringValue
                    let expire = subJson["expire_time"].stringValue
                    let member_c = subJson["members"].count
                    var entry = [String]()
                    entry.append(name)
                    entry.append(path)
                    
                    print(name)
                    print(path)
                    print(expire)
                    print(member_c)
                    
                    self.data.append(entry)
                    self.member_counts.append(member_c)
                    self.expire_dates.append(expire)
                }
            
                print(self.data.count)
            
                //self.collection_view.reloadData()
        })
        
        
        self.view.addSubview(collection_view)
        
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:GroupCell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! GroupCell2
        cell.group_name.text = data[indexPath.row][0]
        cell.member_count.text = String(member_counts[indexPath.row]) + " members"
        
        let myDate = expire_dates[indexPath.row]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from:myDate)!
        dateFormatter.dateFormat = "MMM dd 'at' h:mm"
        let dateString = dateFormatter.string(from:date)
        
        cell.expire_time.text = dateString
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header:NearbyHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerID", for: indexPath) as! NearbyHeader
        header.backgroundColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)
        header.curr_loc.text = self.curr
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Cell", self.data[indexPath.row], "selected");
        let infostory = UIStoryboard(name: "Login", bundle: nil);
        let infocontr = infostory.instantiateViewController(withIdentifier: "GroupInfoMain") as! GroupInfoViewController;
        let g_path = self.data[indexPath.row][1];
        let g_name = self.data[indexPath.row][0];
        infocontr.group_path = g_path;
        infocontr.groupName = g_name;
        
        self.navigationController?.pushViewController(infocontr, animated: true);
        
        print(infocontr);
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        self.current_location = locations[0]
        
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: (current_location?.coordinate.latitude)!, longitude: (current_location?.coordinate.longitude)!)
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { placemarks, error in
            guard let addressDict = placemarks?[0].addressDictionary else {
                return
            }

            let city = addressDict["City"]! as! String
            let state = addressDict["State"]! as! String
            let state_long = self.statesDictionary[state]
            
            self.curr = city + ", " + state_long!
            self.collection_view.reloadData()
            
        })
        
        locationManager?.stopUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func rightButtonAction(sender: UIBarButtonItem) {
        print("tappin that ass")
    
        let create_vc = CreateGroup()
        let nav_contr = UINavigationController(rootViewController: create_vc)
        nav_contr.modalTransitionStyle = .coverVertical
        self.present(nav_contr, animated: true, completion: nil)
    }
    
}
