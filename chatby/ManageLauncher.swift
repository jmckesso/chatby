//
//  ManageLauncher.swift
//  chatby
//
//  Created by Jacob McKesson on 4/28/17.
//  Copyright © 2017 Jacob McKesson. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ManageLauncher: NSObject, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate, ManageCellCallsDelegate {

    let backView = UIView()
    
    var group_url: String!
    var members = [String]()
    
    let memberships_url = "http://chatby.vohras.tk/api/memberships/"
    var curr_user: String!
    
    
    let menu: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor(red:0.00, green:0.74, blue:0.83, alpha:1.0)
        return cv
    }()
    
    var height = CGFloat(250)
    
    func actuallyShow() {
        if (members.count == 0) {
            return
        }
        if (members.count < 6) {
            height = CGFloat(members.count * 50)
        }
        
        if let window = UIApplication.shared.keyWindow {
            backView.backgroundColor = UIColor(white: 0, alpha: 0.0)
            
            backView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissMore)))
            
            window.addSubview(backView)
            window.addSubview(menu)
            
            menu.frame = CGRect(x: 0, y: 0 - height, width: window.frame.width, height: height)
            
            backView.frame = window.frame
            backView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.backView.alpha = 1
                self.menu.frame = CGRect(x: 0, y: 20, width: window.frame.width, height: self.height)
            }, completion: nil)
        }
    }
    
    func populateMenu() {
        members.removeAll()
        Alamofire.request(memberships_url, method: .get, encoding: JSONEncoding.default).validate().responseJSON(completionHandler: { response in
            switch response.result {
            case .success:
                let updated_json = JSON(response.result.value!)

                for (_, js):(String, JSON) in updated_json {
                    let room = js["room"].stringValue
                    let user = js["user"].stringValue
                    if room == self.group_url {
                        self.members.append(user)
                    }
                }

                self.actuallyShow()
                
                self.menu.reloadData()
            case .failure:
                break
            }
        })
    }
    
    func showMenu() {
        populateMenu()
    }
    
    func dismissMore() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.backView.alpha = 0

            if let window = UIApplication.shared.keyWindow {
                self.menu.frame = CGRect(x: 0, y:  0 - self.height, width: window.frame.width, height: self.height)
            }
        }, completion: nil)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return members.count
        //return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:ManageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ManageCell
        if members.isEmpty == false {
            
            Alamofire.request(members[indexPath.row], method: .get, encoding: JSONEncoding.default).validate().responseJSON(completionHandler: { response in
                switch response.result {
                case .success:
                    let jso = JSON(response.result.value!)
                    cell.cell_name.text = jso["username"].stringValue
                    
                case .failure:
                    break
                }
            })
        }
        
        if (members.count - 1 == indexPath.row) {
            cell.divider_line.backgroundColor = UIColor(red:0.00, green:0.74, blue:0.83, alpha:1.0)
        }
        
        cell.delegate = self
        return cell
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
                print("success")
                self.populateMenu()
            case .failure:
                break
            }
        })
    }
    
 
    func removeFunc(user: String) {
        print(user)
        Alamofire.request("http://chatby.vohras.tk/api/memberships/", method: .get, encoding: JSONEncoding.default).validate().responseJSON(completionHandler: { response in
            switch response.result {
            case .success:
                print("success")
                let stuff = JSON(response.result.value!)
                for (_,s):(String, JSON) in stuff {
                    let membership_group = s["room"].stringValue
                    let membership_sender = s["user"].stringValue
                    if membership_sender == user && membership_group == self.group_url {
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
        
        menu.register(ManageCell.self, forCellWithReuseIdentifier: "cell")
        
    }
    
    
}
