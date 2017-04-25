//
//  ProfileCell.swift
//  chatby
//
//  Created by Jacob McKesson on 4/24/17.
//  Copyright © 2017 Jacob McKesson. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import KeychainSwift

protocol ProfileCellCallsDelegate {
    func editButton(type: String);
}

class ProfileCell: UITableViewCell {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        editViews()

    }
    
    var delegate:ProfileCellCallsDelegate?
    
    let cell_type: UILabel = {
        let label = UILabel()
        label.text = "Sample"
        label.font = UIFont.systemFont(ofSize: 10)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let cell_info: UILabel = {
        let label = UILabel()
        label.text = "Sample 2"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let edit_button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func editViews() {
        addSubview(cell_type)
        addSubview(cell_info)
        addSubview(edit_button)
        
        edit_button.addTarget(self, action: #selector(ProfileCell.editInfo), for: .touchUpInside)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]-8-[v1(80)]-8-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cell_type, "v1": edit_button]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v2]-8-[v1(80)]-8-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v2": cell_info, "v1": edit_button]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-3-[v0][v2]-6-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cell_type, "v2": cell_info]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v1]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v1": edit_button]))
    }
    
    func editInfo(sender: UIButton) {
        let button_row = sender.tag
        
        if button_row == 0 {
            self.delegate?.editButton(type: "email")
            
        }
        else if button_row == 1 {
            self.delegate?.editButton(type: "username")
            
        }
        else if button_row == 2 {
            print("changing full name")
            self.delegate?.editButton(type: "fullname")
        }
        
    }

}
