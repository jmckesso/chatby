//
//  MenuLauncher.swift
//  chatby
//
//  Created by Jacob McKesson on 4/27/17.
//  Copyright © 2017 Jacob McKesson. All rights reserved.
//

import UIKit
import SwiftyJSON
import KeychainSwift
import Alamofire

class MenuLauncher: NSObject, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let blackView = UIView()
    var curr_user = String()
    
    let favorites_url = "http://chatby.vohras.tk/api/roomlikes/"
    
    var curr_group: [String: Any]!
    var favorites: JSON!
    
    var is_member = false
    var is_favorite = false
    var is_anon = false
    
    let menu: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor(red:0.00, green:0.74, blue:0.83, alpha:1.0)
        return cv
    }()
    
    func showMenu() {
        var height = CGFloat()
        
        let creator = curr_group["created_by"] as! String
        if creator == curr_user {
            height = 250
        }
        else {
            height = 150
        }
        
        if let window = UIApplication.shared.keyWindow {
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissMore)))
            
            window.addSubview(blackView)
            window.addSubview(menu)
            
            menu.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
            
            blackView.frame = window.frame
            blackView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                self.menu.frame = CGRect(x: 0, y: window.frame.height - height, width: window.frame.width, height: height)
            }, completion: nil)
        }
    }
    
    func dismissMore() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackView.alpha = 0
            
            if let window = UIApplication.shared.keyWindow {
                self.menu.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: 200)
            }
        }, completion: nil)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let creator = curr_group["created_by"] as! String
        if creator == curr_user {
            return 5
        }
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell:MenuCell = collectionView.cellForItem(at: indexPath) as! MenuCell
        if indexPath.row == 0 {
            if cell.cell_name.text == "Join Group" {
                joinGroup()
            }
            else if cell.cell_name.text == "Leave Group" {
                leaveGroup()
            }
        }
        if indexPath.row == 1 {
            if cell.cell_name.text == "Add to Favorites" {
                likeRoom()
            }
            else if cell.cell_name.text == "Remove from Favorites" {
                deleteLike()
            }
        }
        if indexPath.row == 2 {
            if cell.cell_name.text == "Chat Anonymously" {
                anonOn()
            }
            else if cell.cell_name.text == "Chat Publicly" {
                anonOff()
            }
        }
        if indexPath.row == 3 {
            print("Managing users")
        }
        if indexPath.row == 4 {
            print("Deleting room")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:MenuCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MenuCell
    
        let members = curr_group["members"] as? [String]
        let group_path = curr_group["url"] as! String
        
        self.is_favorite = false
        for (_, fav):(String, JSON) in favorites {
            let room_fav = fav["room"].stringValue
            let user_fav = fav["user"].stringValue
            if room_fav == group_path && user_fav == curr_user {
                self.is_favorite = true
                break
            }
        }
        
        if (members?.contains(curr_user))! {
            is_member = true
        }
        else {
            is_member = false
        }
        
        if indexPath.row == 0 {
            cell.divider_line.backgroundColor = UIColor.white
            if is_member == true {
                cell.cell_name.text = "Leave Group"
            }
            else if is_member == false {
                cell.cell_name.text = "Join Group"
            }
        }
        else if indexPath.row == 1 {
            if is_favorite == true {
                cell.divider_line.backgroundColor = UIColor.white
                cell.cell_name.text = "Remove from Favorites"
            }
            else if is_favorite == false {
                cell.divider_line.backgroundColor = UIColor.white
                cell.cell_name.text = "Add to Favorites"
            }
        }
        else if indexPath.row == 2 {
            if is_anon == true {
                cell.divider_line.backgroundColor = UIColor.white
                cell.cell_name.text = "Chat Publicly"
            }
            else if is_anon == false {
                cell.divider_line.backgroundColor = UIColor.white
                cell.cell_name.text = "Chat Anonymously"
            }
            let creator = curr_group["created_by"] as! String
            if creator != curr_user {
                cell.divider_line.backgroundColor = UIColor(red:0.00, green:0.74, blue:0.83, alpha:1.0)
            }
        }
        else if indexPath.row == 3 {
            cell.divider_line.backgroundColor = UIColor.white
            cell.cell_name.text = "Manage Users"
        }
        else if indexPath.row == 4 {
            cell.divider_line.backgroundColor = UIColor.white
            cell.cell_name.text = "Delete Group"
            cell.divider_line.backgroundColor = UIColor(red:0.00, green:0.74, blue:0.83, alpha:1.0)
        }
        return cell
    }
    
    func anonOn() {
        print("anon on")
        self.is_anon = true
    }
    
    func anonOff() {
        print("anon off")
        self.is_anon = false
    }
    
    func updateFavorites() {
        Alamofire.request(favorites_url).validate().responseJSON(completionHandler: { response in
            switch response.result {
            case .success:
                self.favorites = JSON(response.result.value!)
                self.menu.reloadData()
            case .failure:
                break
            }
        })
    }
    
    func updateGroup() {
        let group_path = curr_group["url"] as! String
        Alamofire.request(group_path, method: .get, encoding: JSONEncoding.default).validate().responseJSON(completionHandler: { response in
            switch response.result {
            case .success:
                let updated_json = JSON(response.result.value!)
                self.curr_group = updated_json.dictionaryObject
                self.menu.reloadData()
                self.dismissMore()
            case .failure:
                break
            }
        })
        
    }
    
    func deleteLikeRequest(req: JSON) {
        let auth_string = "Token " + keychain.get("auth")!
        
        let header = [
            "Authorization" : auth_string
        ]
        
        let curr_user = req["user"].stringValue
        let group_path = req["room"].stringValue
        
        let url = req["url"].stringValue
        
        let delete_params : Parameters = [
            "user": curr_user,
            "room": group_path
        ]
        
        Alamofire.request(url, method: .delete, parameters: delete_params,  encoding: JSONEncoding.default, headers: header).validate().responseJSON(completionHandler: { response in
            switch response.result {
            case .success:
                self.updateFavorites()
            case .failure:
                break
            }
        })
    }
    
    func deleteLike() {
        let group_path = curr_group["url"] as! String
        Alamofire.request(favorites_url, method: .get, encoding: JSONEncoding.default).validate().responseJSON(completionHandler: { response in
            switch response.result {
            case .success:
                let stuff = JSON(response.result.value!)
                for (_,s):(String, JSON) in stuff {
                    let fav_group = s["room"].stringValue
                    let fav_sender = s["user"].stringValue
                    if fav_sender == self.curr_user && fav_group == group_path {
                        self.deleteLikeRequest(req: s)
                    }
                }
            case .failure:
                break
            }
        })
    }
    
    func likeRoom() {
        let auth_string = "Token " + keychain.get("auth")!
        
        let header = [
            "Authorization" : auth_string
        ]
        
        let group_path = curr_group["url"] as! String
        
        let room_parameters : Parameters = [
            "room":group_path
        ]
        
        Alamofire.request(favorites_url, method: .post, parameters: room_parameters, encoding: JSONEncoding.default, headers: header).validate().responseJSON(completionHandler: { response in
            switch response.result {
            case .success:
                self.updateFavorites()
            case .failure:
                break
            }
        })
    }
    
    func joinGroup() {
        let auth_string = "Token " + keychain.get("auth")!
        
        let header = [
            "Authorization" : auth_string
        ]
        
        let group_path = curr_group["url"] as! String
        
        let room_parameters : Parameters = [
            "muted":false,
            "room":group_path
        ]
        
        Alamofire.request("http://chatby.vohras.tk/api/memberships/", method: .post, parameters: room_parameters, encoding: JSONEncoding.default, headers: header).validate().responseJSON(completionHandler: { response in
 
            switch response.result {
            case .success:
                self.updateGroup()
            case .failure:
                break
            }
        })
    }
    
    func deleteRequests(req: JSON) {
        let auth_string = "Token " + keychain.get("auth")!
     
        let header = [
            "Authorization" : auth_string
        ]
        
        let curr_user = req["user"].stringValue
        let group_path = req["room"].stringValue
        
        let url = req["url"].stringValue
        
        let delete_params : Parameters = [
            "user": curr_user,
            "room": group_path
        ]
        
        Alamofire.request(url, method: .delete, parameters: delete_params,  encoding: JSONEncoding.default, headers: header).validate().responseJSON(completionHandler: { response in
            switch response.result {
            case .success:
                self.updateGroup()
            case .failure:
                break
            }
        })
    }
    
    func leaveGroup() {
        let group_path = curr_group["url"] as! String
        Alamofire.request("http://chatby.vohras.tk/api/memberships/", method: .get, encoding: JSONEncoding.default).validate().responseJSON(completionHandler: { response in
            switch response.result {
            case .success:
                let stuff = JSON(response.result.value!)
                for (_,s):(String, JSON) in stuff {
                    let membership_group = s["room"].stringValue
                    let membership_sender = s["user"].stringValue
                    if membership_sender == self.curr_user && membership_group == group_path {
                        self.deleteRequests(req: s)
                    }
                }
            case .failure:
                break
            }
         
         })
    }
    
    override init() {
        super.init()
        
        menu.delegate = self
        menu.dataSource = self
        
        menu.register(MenuCell.self, forCellWithReuseIdentifier: "cell")
        
        
    }
}
