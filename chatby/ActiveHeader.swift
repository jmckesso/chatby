//
//  ActiveHeader.swift
//  chatby
//
//  Created by Jacob McKesson on 4/26/17.
//  Copyright © 2017 Jacob McKesson. All rights reserved.
//

import UIKit
import LBTAComponents

class ActiveHeader: UICollectionReusableView {
    
    let section_name: UILabel = {
        let label = UILabel()
        label.text = "Sample"
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let section_image: UIImageView = {
        let image_view = UIImageView()
        image_view.frame = CGRect(x: 0, y: 0, width: 5, height: 5)
        image_view.contentMode = .scaleAspectFit
        image_view.translatesAutoresizingMaskIntoConstraints = false
        return image_view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        edit_views()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func edit_views() {
        addSubview(section_name)
        addSubview(section_image)
        
        section_image.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, topConstant: 15, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 10, heightConstant: 10)
        
        section_name.anchor(self.topAnchor, left: section_image.rightAnchor, bottom: nil, right: self.rightAnchor, topConstant: 15, leftConstant: 4, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 10)
    }
    
}
