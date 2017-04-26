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

class GroupPage: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {

    let keychain = KeychainSwift()
    
    var collection_view: UICollectionView!
    
    var nav: UINavigationBar!;
    var table = UITableView();
    var auth_token: JSON!
    
    //let refreshControl = UIRefreshControl();
    
    let group_url = "http://chatby.vohras.tk/api/rooms/"
    
    var data = [[String]]();
    var member_counts = [Int]();
    var expire_dates = [String]();
    
    override func viewDidLoad() {
        
        self.title = "Active"
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        collection_view = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collection_view.dataSource = self
        collection_view.delegate = self
        
        collection_view.backgroundColor = UIColor.white
        collection_view.alwaysBounceVertical = true
        
        collection_view.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerID")
        collection_view.register(GroupCell2.self, forCellWithReuseIdentifier: "cell")
        
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
            
                self.collection_view.reloadData()
        })
        
        self.view.addSubview(collection_view)
        
        super.viewDidLoad()

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
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerID", for: indexPath)
        header.backgroundColor = UIColor.lightGray
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
    
}
