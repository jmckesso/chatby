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
import LBTAComponents

class GroupPage: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, CLLocationManagerDelegate, NearbyHeaderCallsDelegate {

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
    
    var curr_user = String()
    var curr_group: JSON!
    
    var curr = ""
    //let refreshControl = UIRefreshControl();
    
    let group_url = "http://chatby.vohras.tk/api/rooms/"
    let favorites_url = "http://chatby.vohras.tk/api/roomlikes/"
    
    var data = [[Any]]()
    var favs: JSON!
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getFavorites()
        loadData()
    }
    
    override func viewDidLoad() {
        
        self.title = "Nearby"
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.00, green:0.74, blue:0.83, alpha:1.0)
        
        let item1 = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(rightButtonAction(sender:)))
        item1.tintColor = UIColor.white
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
        
        self.view.addSubview(collection_view)
        
        let auth_string = "Token " + keychain.get("auth")!
        
        let header = [
            "Authorization" : auth_string
        ]
        
        Alamofire.request("http://chatby.vohras.tk/api/users/current/", method: .get, headers: header).validate().responseJSON(completionHandler:  { response in
            let user = JSON(response.result.value!)
            self.curr_user = user["url"].stringValue
        })
        
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
        cell.group_name.text = (data[indexPath.row][0] as! String)
        cell.member_count.text = String(data[indexPath.row][3] as! Int) + " members"
        
        let myDate = data[indexPath.row][2] as! String
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
        header.curr_loc.font = UIFont.systemFont(ofSize: 10)
        
        header.delegate = self
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Cell", self.data[indexPath.row][0], "selected");
        let info_vc = GroupInfo()
        info_vc.group_name = self.data[indexPath.row][0] as! String
        info_vc.curr_user = self.curr_user
        info_vc.favorites = self.favs
        info_vc.group_page = self.data[indexPath.row][1] as! String
        info_vc.curr_group = self.data[indexPath.row][6] as! [String: Any]
        let nav_contr = UINavigationController(rootViewController: info_vc)
        nav_contr.modalTransitionStyle = .coverVertical
        self.present(nav_contr, animated: true, completion: nil)
        
    }
    
    func getFavorites() {
        Alamofire.request(favorites_url).validate().responseJSON(completionHandler: { response in
            switch response.result {
            case .success:
                self.favs = JSON(response.result.value!)
            case .failure:
                break
            }
        })
    }
    
    func loadData() {
        Alamofire.request(group_url).validate().responseJSON(completionHandler: { response in
            let groups = JSON(response.result.value!)
            for (_,subJson):(String, JSON) in groups {
                
                var entry = [Any]()
                
                let name = subJson["name"].stringValue
                let path = subJson["url"].stringValue
                let expire = subJson["expire_time"].stringValue
                let member_c = subJson["members"].count
                
                entry.append(name)
                entry.append(path)
                entry.append(expire)
                entry.append(member_c)
                
                let group_lat = subJson["latitude"].doubleValue
                let group_long = subJson["longitude"].doubleValue
                
                let group_location = CLLocation(latitude: group_lat, longitude: group_long)
                let distance = group_location.distance(from: self.current_location!) / 1000
                
                entry.append(group_location)
                
                let group_radius = subJson["radius"].doubleValue
                entry.append(group_radius)
                
                let group_json = subJson.dictionaryObject
                entry.append(group_json!)
                
                var contains = false
                
                if distance <= group_radius {
                    for d in self.data {
                        if d[1] as! String == path {
                            contains = true
                            break
                        }
                    }
                    if contains == false {
                        self.data.append(entry)
                    }
                }
                
            }
            self.collection_view.reloadData()
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        self.current_location = locations[0]
        loadData()
        
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
        let create_vc = CreateGroup()
        let nav_contr = UINavigationController(rootViewController: create_vc)
        nav_contr.modalTransitionStyle = .coverVertical
        self.present(nav_contr, animated: true, completion: nil)
    }
    
    func sortButton(type:String) {
        if type == "default" {
            print("sorting default")
        }
        else if type == "close" {
            print("sorting closest")
            self.data = self.data.sorted{ ($0[4] as? CLLocation)!.distance(from: self.current_location!) < ($1[4] as? CLLocation)!.distance(from: self.current_location!) }
            self.collection_view.reloadData()
        }
        else if type == "far" {
            print("sorting far")
            self.data = self.data.sorted{ ($0[4] as? CLLocation)!.distance(from: self.current_location!) > ($1[4] as? CLLocation)!.distance(from: self.current_location!) }
            self.collection_view.reloadData()
        }
        else if type == "trm" {
            print("sorting time remaining most")
            self.data = self.data.sorted{ ($0[2] as? String)! > ($1[2] as? String)! }
            self.collection_view.reloadData()
        }
        else if type == "trl" {
            print("sorting time remaining least")
            self.data = self.data.sorted{ ($0[2] as? String)! < ($1[2] as? String)! }
            self.collection_view.reloadData()
        }
        else if type == "mcm" {
            print("sorting member count least")
            self.data = self.data.sorted{ ($0[3] as? Int)! > ($1[3] as? Int)! }
            self.collection_view.reloadData()
        }
        else if type == "mcl" {
            print("sorting member count most")
            self.data = self.data.sorted{ ($0[3] as? Int)! < ($1[3] as? Int)! }
            self.collection_view.reloadData()
        }
    }
    
}
