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
        label.backgroundColor = UIColor.blue
        //label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.boldSystemFont(ofSize: 11)
        //label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let member_count: UILabel = {
        let label = UILabel()
        label.text = "Sample"
        label.backgroundColor = UIColor.green
        label.font = UIFont.systemFont(ofSize: 9)
        label.textColor = UIColor.gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let expire_time: UILabel = {
        let label = UILabel()
        label.text = "Sample"
        label.backgroundColor = UIColor.cyan
        label.font = UIFont.systemFont(ofSize: 9)
        label.textColor = UIColor.red
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let group_pic: UIImageView = {
        //let image = UIImage(named: "profile_holder")
        //let image_view = UIImageView(image: image)
        let image_view = UIImageView()
        image_view.backgroundColor = UIColor.red
        image_view.frame = CGRect(x: 0, y: 0, width: 5, height: 5)
        image_view.contentMode = .scaleAspectFit
        //image_view.translatesAutoresizingMaskIntoConstraints = false
        return image_view
    }()
    
    let member_pic: UIImageView = {
        let image_view = UIImageView()
        //image_view.image = UIImage(named: "profile_holder")
        image_view.backgroundColor = UIColor.yellow
        image_view.contentMode = .scaleAspectFill
        image_view.translatesAutoresizingMaskIntoConstraints = false
        return image_view
    }()
    
    let clock_pic: UIImageView = {
        //let image = UIImage(named: "profile_holder")
        //let image_view = UIImageView(image: image)
        let image_view = UIImageView();
        image_view.backgroundColor = UIColor.lightGray
        //image_view.frame = CGRect(x: 0, y: 0, width: 5, height: 5)
        image_view.contentMode = .scaleAspectFit
        image_view.translatesAutoresizingMaskIntoConstraints = false
        return image_view
    }()
    
    let divider_line: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func editViews() {
        
        addSubview(group_name)
        addSubview(member_count)
        addSubview(expire_time)
        addSubview(group_pic)
        addSubview(member_pic)
        addSubview(clock_pic)
        addSubview(divider_line)
        
        group_pic.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, topConstant: 12, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 25, heightConstant: 25)
        
        group_name.anchor(self.topAnchor, left: group_pic.rightAnchor, bottom: nil, right: clock_pic.leftAnchor, topConstant: 12, leftConstant: 4, bottomConstant: 0, rightConstant: 4, widthConstant: 250, heightConstant: 13)
        
        member_pic.anchor(group_name.bottomAnchor, left: group_name.leftAnchor, bottom: nil, right: nil, topConstant: 4, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 10, heightConstant: 9)
        
        member_count.anchor(group_name.bottomAnchor, left: member_pic.rightAnchor, bottom: nil, right: clock_pic.leftAnchor, topConstant: 4, leftConstant: 2, bottomConstant: 0, rightConstant: 4, widthConstant: 250, heightConstant: 9)
        
        expire_time.anchor(self.topAnchor, left: nil, bottom: nil, right: self.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 12, widthConstant: 100, heightConstant: 9)
        
        clock_pic.anchor(self.topAnchor, left: nil, bottom: nil, right: expire_time.leftAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 2, widthConstant: 9, heightConstant: 9)
        
        divider_line.anchor(nil, left: group_pic.rightAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 4, bottomConstant: 1, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        
    }

}
