//
//  NearbyHeader.swift
//  chatby
//
//  Created by Jacob McKesson on 4/26/17.
//  Copyright © 2017 Jacob McKesson. All rights reserved.
//

import UIKit

class NearbyHeader: UICollectionReusableView {
    let curr_loc: UILabel = {
        let label = UILabel()
        label.text = "Sample"
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        edit_views()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func edit_views() {
        addSubview(curr_loc)
        
        curr_loc.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 15, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 20)
    }
    
}
