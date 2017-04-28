//
//  MenuCell.swift
//  chatby
//
//  Created by Jacob McKesson on 4/27/17.
//  Copyright © 2017 Jacob McKesson. All rights reserved.
//

import UIKit
import LBTAComponents

class MenuCell: UICollectionViewCell {
    
    let cell_name: UILabel = {
       let label = UILabel()
        label.text = "Placceholder"
        label.textColor = UIColor.white
        return label
    }()
    
    let divider_line: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        editViews()
    }
    
    func editViews() {
        addSubview(cell_name)
        addSubview(divider_line)
        
        cell_name.anchor(self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 25)
        
        divider_line.anchor(nil, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        
    }
}
