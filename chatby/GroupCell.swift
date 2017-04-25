//
//  GroupCell.swift
//  chatby
//
//  Created by Jacob McKesson on 4/25/17.
//  Copyright © 2017 Jacob McKesson. All rights reserved.
//

import UIKit
import LBTAComponents

class GroupCell2: UICollectionViewCell {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        editViews()
    }
    
    let group_name: UILabel = {
        let label = UILabel()
        label.text = "Sample"
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let member_count: UILabel = {
        let label = UILabel()
        label.text = "Sample"
        label.font = UIFont.systemFont(ofSize: 10)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let expire_time: UILabel = {
        let label = UILabel()
        label.text = "Sample"
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let group_pic: UIImageView = {
        let image = UIImage(named: "profile_holder")
        let image_view = UIImageView(image: image)
        image_view.frame = CGRect(x: 0, y: 0, width: 5, height: 5)
        image_view.contentMode = .scaleAspectFit
        image_view.translatesAutoresizingMaskIntoConstraints = false
        return image_view
    }()
    
    let member_pic: UIImageView = {
        let image_view = UIImageView()
        image_view.image = UIImage(named: "profile_holder")
        image_view.contentMode = .scaleAspectFill
        image_view.translatesAutoresizingMaskIntoConstraints = false
        return image_view
    }()
    
    let clock_pic: UIImageView = {
        let image = UIImage(named: "profile_holder")
        let image_view = UIImageView(image: image)
        image_view.frame = CGRect(x: 0, y: 0, width: 5, height: 5)
        image_view.contentMode = .scaleAspectFit
        image_view.translatesAutoresizingMaskIntoConstraints = false
        return image_view
    }()
    
    let divider_line: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func editViews() {
        
        //addSubview(group_name)
        //addSubview(member_count)
        //addSubview(expire_time)
        addSubview(group_pic)
        //addSubview(member_pic)
        //addSubview(clock_pic)
        addSubview(divider_line)
        
        //group_pic.anchor()
        
        group_pic.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, topConstant: 12, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 25, heightConstant: 25)
        
        //addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[v0]-[v1]-[v2]-[v3]-[v4]-[v5]-8-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": group_pic, "v1": group_name, "v2": member_pic, "v3": member_count, "v4": clock_pic, "v5": expire_time]))
        //addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": group_pic]))
        //addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v1][v2]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v1": group_name, "v2": member_pic]))
        
        //addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]-2-[v1][v2][v3][v4][v5]-16-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": member_pic, "v1": group_name, "v2": member_pic, "v3": member_count, "v4": clock_pic, "v5": expire_time]))
        //addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": group_name]))
        
    }

}
