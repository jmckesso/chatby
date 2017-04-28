//
//  NearbyHeader.swift
//  chatby
//
//  Created by Jacob McKesson on 4/26/17.
//  Copyright © 2017 Jacob McKesson. All rights reserved.
//

import UIKit

protocol NearbyHeaderCallsDelegate {
    func sortButton(type: String);
}

class NearbyHeader: UICollectionReusableView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let array = ["Default", "Closest", "Farthest", "Time Remaining (most)", "Time Remaining (least)", "Member Count (most)", "Member Count (least)"]
    
    var current_sort = "Default"
    
    var delegate:NearbyHeaderCallsDelegate?
    
    let curr_loc: UILabel = {
        let label = UILabel()
        label.text = "Sample"
        label.font = UIFont.systemFont(ofSize: 10)
        label.textAlignment = NSTextAlignment.right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let confirm_sort: UIButton = {
        let button = UIButton()
        button.setTitle("Sort", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        button.backgroundColor = UIColor(red:0.00, green:0.74, blue:0.83, alpha:1.0)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        edit_views()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func edit_views() {
        let sort_picker = UIPickerView()
        sort_picker.delegate = self
        sort_picker.dataSource = self
        sort_picker.backgroundColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)
        sort_picker.reloadAllComponents()
        
        confirm_sort.addTarget(self, action: #selector(NearbyHeader.sortInfo), for: .touchUpInside)
        
        addSubview(curr_loc)
        addSubview(confirm_sort)
        addSubview(sort_picker)
        
        confirm_sort.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, topConstant: 10, leftConstant: 12 , bottomConstant: 0, rightConstant: 0, widthConstant: 50, heightConstant: 20)
        
        sort_picker.anchor(self.topAnchor, left: confirm_sort.rightAnchor, bottom: self.bottomAnchor, right: curr_loc.leftAnchor, topConstant: 0, leftConstant: 0 , bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        curr_loc.anchor(self.topAnchor, left: nil, bottom: nil, right: self.rightAnchor, topConstant: 10, leftConstant: 0 , bottomConstant: 0, rightConstant: 12, widthConstant: 150, heightConstant: 20)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return array.count
    }
        
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.black
        pickerLabel.text = array[row]
        pickerLabel.font = UIFont.systemFont(ofSize: 10)
        pickerLabel.textAlignment = NSTextAlignment.center
        return pickerLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        current_sort = array[row]
    }
    
    func sortInfo(sender: UIButton) {
        if current_sort == "Default" {
            self.delegate?.sortButton(type: "default")
        }
        else if current_sort == "Closest" {
            self.delegate?.sortButton(type: "close")
        }
        else if current_sort == "Farthest" {
            self.delegate?.sortButton(type: "far")
        }
        else if current_sort == "Time Remaining (most)" {
            self.delegate?.sortButton(type: "trm")
        }
        else if current_sort == "Time Remaining (least)" {
            self.delegate?.sortButton(type: "trl")
        }
        else if current_sort == "Member Count (most)" {
            self.delegate?.sortButton(type: "mcm")
        }
        else if current_sort == "Member Count (least)" {
            self.delegate?.sortButton(type: "mcl")
        }
    }

}
