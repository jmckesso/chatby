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
    //let incoming = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: UIColor.blue);
    //let outgoing = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: UIColor.white);

    let auth_page = "http://chatby.vohras.tk/api/auth/";
    let message_list = "http://chatby.vohras.tk/api/messages/";
    let membership_list = "http://chatby.vohras.tk/api/memberships/";
    
    func setName(content: String, room: String, id: String) {
        //print("--- Setting Name --- ")
        
        Alamofire.request("http://chatby.vohras.tk/api/users/").validate().responseJSON(completionHandler: { response in
            let users = JSON(response.result.value!)
            //print("users \n")
            //print(users)
            
            
            var j = 0
            while (j < users.count) {
                //print("print comparing id to stringVal")
                //print(id + " : " + users[j]["url"].stringValue)
                if (id == users[j]["url"].stringValue) {
                    let name = users[j]["username"].stringValue
                    //print("appending message")
                    self.messages.append(JSQMessage(senderId: id, displayName: name, text: content))
                }
                j = j + 1
            }
            self.collectionView.reloadData()
            
        })
    }
    
    func gettingMessageData() {
        //print("\n --- Getting Message List --- \n")
        

        Alamofire.request(message_list).validate().responseJSON(completionHandler: { response in
            
            switch response.result {
            case .success:
                //print("super success")
                let output = JSON(response.result.value!)
                //print(output)
                let message = JSON(response.result.value!)
                var i = 0;
                while (i < message.count) {
                    let t = message[i]["content"].stringValue
                    let room = message[i]["room"].stringValue
                    let id = message[i]["created_by"].stringValue
                    if (room == self.group_path) {
                        self.setName(content: t, room: room, id: id)
                    }
                    i = i + 1
                }
                
                
    
                /*Alamofire.request("http://chatby.vohras.tk/api/users/").validate().responseJSON(completionHandler: { response in
                    let users = JSON(response.result.value!)
                    
                    var j = 0
                    while (j < users.count) {
                        if (id == users[j]["url"].stringValue) {
                            name = users[j]["username"].stringValue
                        }
                        j = j + 1
                    }
                    
                    self.collectionView.reloadData()
                    
                })
                
                var i = 0
                while (i < message.count) {
                    if (room == self.group_path) {
                        self.messages.append(JSQMessage(senderId: id, displayName: name, text: t))
                        self.collectionView.reloadData()
                    }
                    i = i + 1
                }
                
                self.collectionView.reloadData()*/
                
                
            case .failure:
                print("mega fail")
            }
            
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.title = groupName;
        self.inputToolbar.contentView.leftBarButtonItem = nil;
        self.inputToolbar.contentView.textView.placeHolder = "Message";
        
        self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize(width: 0, height: 0);

        self.senderId = "temp"
        self.senderDisplayName = "temp"
        
        let auth_string = "Token " + keychain.get("auth")!
        
        let header = [
            "Authorization" : auth_string
        ]
        
        Alamofire.request("http://chatby.vohras.tk/api/users/current/", method: .get, encoding: JSONEncoding.default, headers: header).validate().responseJSON(completionHandler: {
            response in
            switch response.result {
            case .success:
                let user_data = JSON(response.result.value!)
                self.senderId = user_data["url"].stringValue
                self.senderDisplayName = user_data["username"].stringValue
                
                self.gettingMessageData()
            case .failure:
                print("ah naw")
            }
            
        })

        drawUI();

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
    
    
    
    /*func joingroup(_ sender: UIBarButtonItem) {
        let auth_string = "Token " + keychain.get("auth")!

        let header = [
            "Authorization" : auth_string
        ]
        
        let room_parameters : Parameters = [
            "muted":false,
            "room":group_path
        ]

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
    
    // UI Shit down here*/
    
    func drawUI() {
        /*self.title = groupName;
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
        confirmBtn.layer.backgroundColor = UIColor.white.cgColor;*/
        
        let settingsBtn = UIBarButtonItem(barButtonSystemItem: .edit,
                                          target: self,
                                          action: #selector(toManageGroupInfo(_:)));
        self.navigationItem.rightBarButtonItem = settingsBtn;
        
        /*self.view.addSubview(confirmBtn);
        self.view.addSubview(label);*/
        
    }
    
    func toManageGroupInfo(_ sender:UIBarButtonItem) {
        let strybrd = UIStoryboard(name: "Login", bundle: nil);
        //let controller = strybrd.instantiateViewController(withIdentifier: "ManageGroupsInfoMain");
        let infocontr = strybrd.instantiateViewController(withIdentifier: "ManageGroupsInfoMain") as! ManageGroupsInfoViewController;
        infocontr.group_path = group_path
        //controller.group_url = group_path;
        self.navigationController?.pushViewController(infocontr, animated: true);
    }

    // Chat stuff all down here
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        let message = messages[indexPath.item]
        
        if message.senderId != senderId {
            return bubbleFactory?.incomingMessagesBubbleImage(with: UIColor.lightGray);
        }

        return bubbleFactory?.outgoingMessagesBubbleImage(with: UIColor(red:0.00, green:0.74, blue:0.83, alpha:1.0));
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat {
        let message = messages[indexPath.row];
        
        if message.senderId == self.senderId {
            return 0;
        }
        if indexPath.item > 0 {
            let previousMessage = messages[indexPath.row - 1];
            if previousMessage.senderId == message.senderId {
                return 0;
            }
        }
        
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAt indexPath: IndexPath!) -> CGFloat {
        let message = messages[indexPath.row];

        if message.senderId == self.senderId {
            return 0;
        }
        if indexPath.item > 0 {
            let previousMessage = messages[indexPath.row - 1];
            if previousMessage.senderId == message.senderId {
                return 0;
            }
        }
        
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        let message = messages[indexPath.row];
        
        // You sent it
        if message.senderId == self.senderId {
            return nil
        }
        
        // Only puts label on first bubble of chain
        if indexPath.item > 0 {
            let previousMessage = messages[indexPath.row - 1];
            if previousMessage.senderId == message.senderId {
                return nil;
            }
        }
        print("User:", self.messages[indexPath.row]);
        return NSAttributedString(string: self.messages[indexPath.row].senderDisplayName);
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        let message = messages[indexPath.row];
        
        // You sent it
        if message.senderId == self.senderId {
            return nil
        }
        
        // Only puts label on first bubble of chain
        if indexPath.item > 0 {
            let previousMessage = messages[indexPath.row - 1];
            if previousMessage.senderId == message.senderId {
                return nil;
            }
        }
        
        return JSQMessagesTimestampFormatter.shared().attributedTimestamp(for: message.date);
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        let message = messages[indexPath.row];
        
        if(message.senderId != senderId) {
            return JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named: "profile_2"), diameter: 30)
        }
        
        if indexPath.item > 0 {
            let previousMessage = messages[indexPath.row - 1];
            if previousMessage.senderId == message.senderId {
                return nil;
            }
        }
        
        return nil;
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count;
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let message = messages[indexPath.row];
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        
        if message.senderId == senderId {
            //cell.backgroundColor = UIColor(cgColor: UIColor(red:0.00, green:0.74, blue:0.83, alpha:1.0).cgColor);
            cell.avatarContainerView.isHidden = true;
            
        }
        if message.senderId != senderId {
            //cell.backgroundColor = UIColor(cgColor: UIColor.lightGray.cgColor);
            cell.messageBubbleTopLabel.textInsets = UIEdgeInsetsMake(0.0, 50.0, 0.0, 0.0);
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAt indexPath: IndexPath!) {
        let message = messages[indexPath.row];
        
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        let auth_string = "Token " + keychain.get("auth")!
        
        let header = [
            "Authorization" : auth_string
        ]
        
        let mess_param : Parameters = [
            "anonymous": "false",
            "content": text,
            "room": group_path,
            ]
        
        print("sending message")
        Alamofire.request("http://chatby.vohras.tk/api/messages/", method: .post, parameters: mess_param, encoding: JSONEncoding.default, headers: header).validate().responseJSON(completionHandler: {
            response in
            print(response.request!)  // original URL request
            print(response.response!) // HTTP URL response
            print(response.data!)     // server data
            print(response.result)
            
        })
        
        messages.append(JSQMessage(senderId: senderId, displayName: senderDisplayName, text: text))
        collectionView.reloadData()
        
        finishSendingMessage()
    }
    
}













