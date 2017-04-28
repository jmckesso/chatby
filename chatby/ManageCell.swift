//
//  ManageCell.swift
//  chatby
//
//  Created by Jacob McKesson on 4/28/17.
//  Copyright © 2017 Jacob McKesson. All rights reserved.
//

import UIKit

protocol ManageCellCallsDelegate  {
    func removeFunc(user: String)
}

class ManageCell: UICollectionViewCell {
    
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
    
    var delegate:ManageCellCallsDelegate?
    
    let remove_user: UIButton = {
        let button = UIButton()
        button.setTitle("Remove", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.setTitleColor(UIColor(red:0.99, green:0.33, blue:0.34, alpha:1.0), for: .normal)
        return button
        
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
        addSubview(remove_user)
        addSubview(divider_line)
        
        remove_user.addTarget(self, action: #selector(ManageCell.remove), for: .touchUpInside)
        
        cell_name.anchor(self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: remove_user.leftAnchor, topConstant: 0, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 25)
        
        remove_user.anchor(self.topAnchor, left: nil, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 12, bottomConstant: 0, rightConstant: 12, widthConstant: 50, heightConstant: 25)
        
        divider_line.anchor(nil, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        
    }
    
    func remove(sender: UIButton) {
        let user = cell_name.text
        self.delegate?.removeFunc(user: user!)
    
    }
    
}
