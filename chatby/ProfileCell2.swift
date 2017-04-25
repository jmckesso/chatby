//
//  ProfileCell2.swift
//  chatby
//
//  Created by Jacob McKesson on 4/24/17.
//  Copyright © 2017 Jacob McKesson. All rights reserved.
//

import UIKit

class ProfileCell2: UITableViewCell {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        editViews()
        
    }
    
    let cell_text: UILabel = {
        let label = UILabel()
        label.text = "Sample"
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func editViews() {
        addSubview(cell_text)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cell_text]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cell_text]))

    }
    
}
