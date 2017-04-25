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
        print("--- Setting Name --- ")
        
        Alamofire.request("http://chatby.vohras.tk/api/users/").validate().responseJSON(completionHandler: { response in
            let users = JSON(response.result.value!)
            print("users \n")
            //print(users)
            
            
            var j = 0
            while (j < users.count) {
                print("print comparing id to stringVal")
                print(id + " : " + users[j]["url"].stringValue)
                if (id == users[j]["url"].stringValue) {
                    let name = users[j]["username"].stringValue
                    print("appending message")
                    self.messages.append(JSQMessage(senderId: id, displayName: name, text: content))
                }
                j = j + 1
            }
            self.collectionView.reloadData()
            
        })
    }
    
    func gettingMessageData() {
        print("\n --- Getting Message List --- \n")
        

        Alamofire.request(message_list).validate().responseJSON(completionHandler: { response in
            
            switch response.result {
            case .success:
                print("super success")
                let output = JSON(response.result.value!)
                print(output)
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
        
        //self.senderId = "1"
        //self.senderDisplayName = "Jake"
        
        /*print("--- Group Info ---")
        print(group_path)

        self.senderId = "null";
        self.senderDisplayName = "null";
        
        Alamofire.request(message_list).responseJSON { response in
            //print(response.request!)  // original URL request
            //print(response.response!) // HTTP URL response
            //print(response.data!)     // server data
            //print(response.result)   // result of response serialization
            
            switch response.result {
            case .success:
                print("Super dia");
                
            case .failure:
                print("ah naw")
            }
            
        }*/
        
        drawUI();

        /*automaticallyScrollsToMostRecentMessage = true;
        self.inputToolbar.delegate = nil;

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(GroupInfoViewController.DismissKeyboard));
        view.addGestureRecognizer(tap);*/
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

    /*override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item];
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count;
    }

    func sendMessage() {
        // Do this
        let auth_string = "Token " + keychain.get("auth")!
        
        let header = [
            "Authorization" : auth_string
        ]
        
        let mess_param : Parameters = [
            "anonymous": "false",
            "content": "hi",
            "room": group_path,
        ]
        
        print("sending message")
        Alamofire.request("http://chatby.vohras.tk/api/messages", method: .post, parameters: mess_param, encoding: JSONEncoding.default, headers: header).validate().responseJSON(completionHandler: {
            response in
            print(response.request!)  // original URL request
            print(response.response!) // HTTP URL response
            print(response.data!)     // server data
            print(response.result)
            
        })
    }
    
    func recievedMessagePressed(sender: UIBarButtonItem) {
        showTypingIndicator = true;
        scrollToBottom(animated: true);
        finishReceivingMessage(animated: true);
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        JSQSystemSoundPlayer.jsq_playMessageSentSound();
        print("did press send")
        sendMessage();
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
    }*/
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        let message = messages[indexPath.item]
        return bubbleFactory?.outgoingMessagesBubbleImage(with: UIColor.blue)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named: "ph"), diameter: 30)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count;
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        return cell
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













