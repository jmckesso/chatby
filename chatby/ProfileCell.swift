//
//  ProfileCell.swift
//  chatby
//
//  Created by Jacob McKesson on 4/24/17.
//  Copyright © 2017 Jacob McKesson. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        editViews()

    }
    
    let cell_type: UILabel = {
        let label = UILabel()
        label.text = "Sample"
        //label.font = UIFont(name: label.font.fontName, size: 10)
        label.font = UIFont.systemFont(ofSize: 10)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let cell_info: UILabel = {
        let label = UILabel()
        label.text = "Sample 2"
        //label.font = UIFont(name: label.font.fontName, size: 12)
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
    
    func editInfo() {
        print("edit blah")
    }

}
