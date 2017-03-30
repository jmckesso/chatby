//
//  GroupInfoViewController.swift
//  chatby
//
//  Created by Tanner Strom on 2/23/17.
//  Copyright © 2017 Jacob McKesson. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import KeychainSwift
import JSQMessagesViewController

class GroupInfoViewController: JSQMessagesViewController {
    
    var groupName: String!;
    var group_path: String!;
    var auth_token: JSON!
    var confirmBtn:UIButton!;
    
    var messages = [JSQMessage]();
    let incoming = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: UIColor.blue);
    let outgoing = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: UIColor.white);

    let auth_page = "http://chatby.vohras.tk/api/auth/";
    let message_list = "http://chatby.vohras.tk/api/messages/";
    let membership_list = "http://chatby.vohras.tk/api/memberships/";
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        let defaults = UserDefaults.standard;

        self.senderId = "null";
        self.senderDisplayName = "null";
        
        Alamofire.request(message_list).responseJSON { response in
            print(response.request!)  // original URL request
            print(response.response!) // HTTP URL response
            print(response.data!)     // server data
            print(response.result)   // result of response serialization
            
            switch response.result {
            case .success:
                print("Super dia");
                
            case .failure:
                print("ah naw")
            }
            
        }
        
        drawUI();

        automaticallyScrollsToMostRecentMessage = true;
        self.inputToolbar.delegate = nil;

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(GroupInfoViewController.DismissKeyboard));
        view.addGestureRecognizer(tap);
    }

    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true);
        self.resignFirstResponder();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true);
        self.tabBarController?.tabBar.isHidden = true;
    }
    
    func joingroup(_ sender: UIBarButtonItem) {
        // JACOB HELLO!
        
        print(group_path)
        
        print("here2")
        print(keychain.get("auth")!)
        
        let auth_string = "Token " + keychain.get("auth")!
        print("auth string")
        print(auth_string)
        print(group_path)
        
        let header = [
            "Authorization" : auth_string
        ]
        
        let room_parameters : Parameters = [
            "muted":false,
            "room":group_path
        ]

        
        /* Alamofire.request("http://chatby.vohras.tk/api/users/current/", encoding: JSONEncoding.default, headers: header).validate().responseJSON(completionHandler: {
            response in
            print(response.request!)  // original URL request
            print(response.response!) // HTTP URL response
            print(response.data!)     // server data
            print(response.result)
            
            let user_info = JSON(response.result.value!)
            print(user_info)
            
        }) */

        Alamofire.request("http://chatby.vohras.tk/api/memberships/", method: .post, parameters: room_parameters, encoding: JSONEncoding.default, headers: header).validate().responseJSON(completionHandler: {
            response in
            print(response.request!)  // original URL request
            print(response.response!) // HTTP URL response
            print(response.data!)     // server data
            print(response.result)
            
            switch response.result {
                case .success:
                    self.navigationController?.popViewController(animated: true);
                case .failure:
                    break
            }
            
            print(response.result.value!)
        })

        
        //confirmBtn.isEnabled = false;
        
        
    }
    
    // UI Shit down here
    
    func drawUI() {
        self.title = groupName;
        let inpWid:CGFloat = self.view.bounds.width;
        
        let label: UILabel = UILabel(frame: CGRect(x: self.view.bounds.width / 2 - (inpWid / 2) + 20,
                                                   y: self.view.bounds.height / 4,
                                                   width: inpWid,
                                                   height: 100));
        
        label.text = groupName;
        label.textAlignment = NSTextAlignment.left;
        label.textColor = UIColor.black;
        
        confirmBtn = UIButton(frame: CGRect(x: self.view.bounds.width / 2 - (inpWid / 2) + 5,
                                                            y: self.view.frame.maxY - 140,
                                                            width: self.view.bounds.width - 10,
                                                            height: 65));
        confirmBtn.backgroundColor = UIColor.gray;
        confirmBtn.setTitleColor(UIColor.white, for: UIControlState.normal);
        confirmBtn.setTitleColor(UIColor.lightGray, for: UIControlState.highlighted);
        confirmBtn.setTitle("Join Group", for: .normal);
        confirmBtn.addTarget(self, action: #selector(joingroup(_:)), for: .touchUpInside);
        
        confirmBtn.setTitleColor(UIColor(colorLiteralRed: 14.0/255,
                                         green: 122.0/255,
                                         blue: 254.0/255,
                                         alpha: 1.0), for: UIControlState.normal);
        confirmBtn.setTitleColor(UIColor(colorLiteralRed: 14.0/255,
                                         green: 122.0/255,
                                         blue: 254.0/255,
                                         alpha: 0.5), for: UIControlState.highlighted);
        
        confirmBtn.layer.cornerRadius = 5;
        confirmBtn.layer.borderColor = UIColor(colorLiteralRed: 14.0/255,
                                               green: 122.0/255,
                                               blue: 254.0/255,
                                               alpha: 1.0).cgColor;
        confirmBtn.layer.borderWidth = 1;
        confirmBtn.layer.backgroundColor = UIColor.white.cgColor;
        
        self.view.addSubview(confirmBtn);
        self.view.addSubview(label);
    }

    // Chat stuff all down here

    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item];
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count;
    }

    func sendMesage(text: String!, senderID: String!, senderName: String!) {
        // Do this
    }
    
    func recievedMessagePressed(sender: UIBarButtonItem) {
        showTypingIndicator = true;
        scrollToBottom(animated: true);
        finishReceivingMessage(animated: true);
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        JSQSystemSoundPlayer.jsq_playMessageSentSound();
        
        //sendMessage();
        finishSendingMessage(animated: true);
    }
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        print("Pressed accessory button");
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell;
        let message = messages[indexPath.item];
        
        if message.senderId == senderId {
            cell.textView!.textColor = UIColor.black
            cell.textView!.layer.borderColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [0.0, CGFloat(122.0/255.0), 1.0, 1.0]);
        } else {
            cell.textView!.textColor = UIColor.black
            cell.textView!.layer.borderColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [CGFloat(91.0/255.0), CGFloat(194.0/255.0), CGFloat(54.0/255.0), 1.0]);
        }
        cell.textView!.layer.borderWidth = 1.5;
        cell.textView!.layer.cornerRadius = 15;
        cell.textView!.layer.masksToBounds = true;
        cell.textView!.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 1.0]);
        
        return cell;
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        let message = messages[indexPath.item];
        
        // I sent the message
        if message.senderId == senderId {
            return nil;
        }
        // Same as previous sender, skip the label
        if indexPath.item > 0 {
            let previousMessage = messages[indexPath.item - 1];
            if previousMessage.senderId == message.senderId {
                return nil;
            }
        }
        return NSAttributedString(string:message.senderDisplayName);
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAt indexPath: IndexPath!) -> CGFloat {
        let message = messages[indexPath.item]
        
        // I sent the message
        if message.senderId == senderId {
            return CGFloat(0.0);
        }
        
        // Same as previous sender, skip
        if indexPath.item > 0 {
            let previousMessage = messages[indexPath.item - 1];
            if previousMessage.senderId == message.senderId {
                return CGFloat(0.0);
            }
        }
        
        return kJSQMessagesCollectionViewCellLabelHeightDefault
    }
    
}













