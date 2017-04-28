//
//  ActivePage.swift
//  chatby
//
//  Created by Jacob McKesson on 4/26/17.
//  Copyright © 2017 Jacob McKesson. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import KeychainSwift
import CoreLocation

class ActivePage: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {

    var collection_view: UICollectionView!
    
    var data_created = [[Any]]()
    var data_favorited = [[Any]]()
    var data_joined = [[Any]]()
    
    var favorites: JSON!
    
    let group_url = "http://chatby.vohras.tk/api/rooms/"
    let favorites_url = "http://chatby.vohras.tk/api/roomlikes/"
    
    var curr_user = String()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        
        
        data_created.removeAll()
        data_favorited.removeAll()
        data_joined.removeAll()
        
        getFavorites()
        loadData()
    }
    
    /*override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.tabBar.isHidden = false

        
        data_created.removeAll()
        data_favorited.removeAll()
        data_joined.removeAll()
        
        getFavorites()
        loadData()
    }*/
    
    override func viewDidLoad() {
        
        self.title = "Active"
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.00, green:0.74, blue:0.83, alpha:1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        collection_view = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collection_view.dataSource = self
        collection_view.delegate = self
        
        collection_view.backgroundColor = UIColor.white
        collection_view.alwaysBounceVertical = true
        
        collection_view.register(ActiveHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerID")
        collection_view.register(GroupCell2.self, forCellWithReuseIdentifier: "cell")

        self.view.addSubview(collection_view)
        
        super.viewDidLoad()
    }

    func loadData() {
        let auth_string = "Token " + keychain.get("auth")!
        
        let header = [
            "Authorization" : auth_string
        ]
        
        Alamofire.request("http://chatby.vohras.tk/api/users/current/", method: .get, headers: header).validate().responseJSON(completionHandler:  { response in
            let user = JSON(response.result.value!)
            self.curr_user = user["url"].stringValue
        })
        
        Alamofire.request(group_url).validate().responseJSON(completionHandler: { response in
            let groups = JSON(response.result.value!)
            for (_,subJson):(String, JSON) in groups {
                let name = subJson["name"].stringValue
                let path = subJson["url"].stringValue
                let expire = subJson["expire_time"].stringValue
                let member_c = subJson["members"].count
                let created_by = subJson["created_by"].stringValue
                
                let member_list = subJson["members"].rawValue as? [String]
                
                var entry = [Any]()
                entry.append(name)
                entry.append(path)
                entry.append(expire)
                entry.append(member_c)
                
                
                let group_json = subJson.dictionaryObject
                entry.append(group_json!)
                
                if created_by == self.curr_user {
                    self.data_created.append(entry)
                }
                
                if (member_list?.contains(self.curr_user))! {
                    self.data_joined.append(entry)
                }
                
                for (_, fav):(String, JSON) in self.favorites {
                    let room_fav = fav["room"].stringValue
                    let user_fav = fav["user"].stringValue
                    if room_fav == path && user_fav == self.curr_user {
                        self.data_favorited.append(entry)
                        break
                    }
                }
                
            }
            
            self.collection_view.reloadData()
        })
    }
    
    func getFavorites() {
        Alamofire.request(favorites_url).validate().responseJSON(completionHandler: { response in
            switch response.result {
            case .success:
                self.favorites = JSON(response.result.value!)
            case .failure:
                break
            }
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return data_created.count
        }
        else if section == 1 {
            return data_favorited.count
        }
        else if section == 2 {
            return data_joined.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:GroupCell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! GroupCell2

        if indexPath.section == 0 {
            cell.group_name.text = (data_created[indexPath.row][0] as! String)
            cell.member_count.text = String(data_created[indexPath.row][3] as! Int) + " members"
            
            let myDate = data_created[indexPath.row][2] as! String
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            let date = dateFormatter.date(from:myDate)!
            dateFormatter.dateFormat = "MMM dd 'at' h:mm"
            let dateString = dateFormatter.string(from:date)
            
            cell.expire_time.text = dateString
        }
        else if indexPath.section == 1 {
            cell.group_name.text = (data_favorited[indexPath.row][0] as! String)
            cell.member_count.text = String(data_favorited[indexPath.row][3] as! Int) + " members"
            
            let myDate = data_favorited[indexPath.row][2] as! String
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            let date = dateFormatter.date(from:myDate)!
            dateFormatter.dateFormat = "MMM dd 'at' h:mm"
            let dateString = dateFormatter.string(from:date)
            
            cell.expire_time.text = dateString
        }
        else if indexPath.section == 2 {
            cell.group_name.text = (data_joined[indexPath.row][0] as! String)
            cell.member_count.text = String(data_joined[indexPath.row][3] as! Int) + " members"
            
            let myDate = data_joined[indexPath.row][2] as! String
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            let date = dateFormatter.date(from:myDate)!
            dateFormatter.dateFormat = "MMM dd 'at' h:mm"
            let dateString = dateFormatter.string(from:date)
            
            cell.expire_time.text = dateString
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        
        let info_vc = GroupInfo()

        if indexPath.section == 0 {
            info_vc.group_name = self.data_created[indexPath.row][0] as! String
            info_vc.curr_user = self.curr_user
            info_vc.favorites = self.favorites
            info_vc.group_page = self.data_created[indexPath.row][1] as! String
            info_vc.curr_group = self.data_created[indexPath.row][4] as! [String: Any]
            self.navigationController?.pushViewController(info_vc, animated: true)
        }
        else if indexPath.section == 1 {
            info_vc.group_name = self.data_favorited[indexPath.row][0] as! String
            info_vc.curr_user = self.curr_user
            info_vc.favorites = self.favorites
            info_vc.group_page = self.data_favorited[indexPath.row][1] as! String
            info_vc.curr_group = self.data_favorited[indexPath.row][4] as! [String: Any]
            self.navigationController?.pushViewController(info_vc, animated: true)
        }
        else if indexPath.section == 2{
            info_vc.group_name = self.data_joined[indexPath.row][0] as! String
            info_vc.curr_user = self.curr_user
            info_vc.favorites = self.favorites
            info_vc.group_page = self.data_joined[indexPath.row][1] as! String
            info_vc.curr_group = self.data_joined[indexPath.row][4] as! [String: Any]
            self.navigationController?.pushViewController(info_vc, animated: true)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header:ActiveHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerID", for: indexPath) as! ActiveHeader
        header.backgroundColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)
        if indexPath.section == 0 {
            header.section_name.text = "Created"
            header.section_image.image = UIImage(named: "profile_holder")
        }
        else if indexPath.section == 1 {
            header.section_name.text = "Starred"
            header.section_image.image = UIImage(named: "profile_holder")
        }
        else if indexPath.section == 2 {
            header.section_name.text = "Active"
            header.section_image.image = UIImage(named: "profile_holder")
        }
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 40)
    }

}
