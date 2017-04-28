//
//  GroupInfo.swift
//  chatby
//
//  Created by Jacob McKesson on 4/27/17.
//  Copyright © 2017 Jacob McKesson. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import SwiftyJSON
import LBTAComponents
import Alamofire

class GroupInfo: JSQMessagesViewController, MenuDismissControllerDelegate {
    
    var messages = [JSQMessage]()

    var group_name = String()
    var group_page = String()
    var curr_user = String()
    
    var auth_token: JSON!
    var confirmBtn :UIButton!;
    
    let auth_page = "http://chatby.vohras.tk/api/auth/";
    let message_list = "http://chatby.vohras.tk/api/messages/";
    let membership_list = "http://chatby.vohras.tk/api/memberships/";
    
    var curr_group: [String: Any]!
    var favorites: JSON!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        self.tabBarController?.tabBar.isHidden = true
        
        self.title = group_name
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.00, green:0.74, blue:0.83, alpha:1.0)
        
        let close_button = UIButton()
        close_button.setImage(UIImage(named: "Left-50"), for: UIControlState.normal)
        close_button.tintColor = UIColor.white
        close_button.addTarget(self, action: #selector(dismissView(sender:)), for: UIControlEvents.touchUpInside)
        close_button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let close_bar_button = UIBarButtonItem(customView: close_button)
        self.navigationItem.leftBarButtonItem = close_bar_button
        
        let more_button = UIButton()
        more_button.setImage(UIImage(named: "More-50"), for: UIControlState.normal)
        more_button.tintColor = UIColor.white
        more_button.addTarget(self, action: #selector(handleMore), for: UIControlEvents.touchUpInside)
        more_button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let more_bar_button = UIBarButtonItem(customView: more_button)
        self.navigationItem.rightBarButtonItem = more_bar_button
        
        self.view.backgroundColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)
        
        //chat stuff
        
        self.inputToolbar.contentView.leftBarButtonItem = nil;
        self.inputToolbar.contentView.textView.placeHolder = "Message";
        
        self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize(width: 0, height: 0);
        
        self.senderId = "temp"
        self.senderDisplayName = "temp"
        
        JSQMessagesCollectionViewCell.registerMenuAction(#selector(favorite(_:)));
        JSQMessagesCollectionViewCell.registerMenuAction(#selector(delete(_:)));
        
        UIMenuController.shared.menuItems = [
            UIMenuItem(title: "Favorite", action: #selector(favorite(_:))),
            UIMenuItem(title: "Delete", action: #selector(delete(_:)))
        ];
        
        UIMenuController.shared.arrowDirection = .down
        UIMenuController.shared.setMenuVisible(true, animated: true);
        UIMenuController.shared.setTargetRect(CGRect(x: 100, y: 80, width: 50, height: 50), in: self.view);
        
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
        
        self.messages = self.messages.sorted{$0.date < $1.date}
        
        self.automaticallyScrollsToMostRecentMessage = true;
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(GroupInfoViewController.DismissKeyboard));
        view.addGestureRecognizer(tap);
        
    }
    
    let menu_launcher = MenuLauncher()
    
    func handleMore() {
        menu_launcher.delegate = self
        menu_launcher.favorites = self.favorites
        menu_launcher.curr_group = self.curr_group
        menu_launcher.curr_user = self.curr_user
        menu_launcher.showMenu()
    }
    
    func manageUsers() {
        print("manage from info")
    }
    
    func dismissView(sender: UIBarButtonItem) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func groupDeleted() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    //Chat stuff
    
    
    
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
            let avi = UIImage(named: "profile_2");
            let image_view = UIImageView(image: avi);
            image_view.tintColor = UIColor(red:0.00, green:0.74, blue:0.83, alpha:1.0);
            
            let image = JSQMessagesAvatarImageFactory.avatarImage(with: image_view.image, diameter: 30)
            return image;
            
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
        
        print(messages[indexPath.item]);
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count;
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let message = messages[indexPath.row];
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        
        if message.senderId == senderId {
            cell.avatarContainerView.isHidden = true;
            
        }
        if message.senderId != senderId {
            cell.messageBubbleTopLabel.textInsets = UIEdgeInsetsMake(0.0, 50.0, 0.0, 0.0);
        }
        
        cell.textView.isSelectable = false;
        
        
        return cell
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAt indexPath: IndexPath!) {
        let message = messages[indexPath.row];
    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return true;
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        let auth_string = "Token " + keychain.get("auth")!
        
        let header = [
            "Authorization" : auth_string
        ]
        
        let mess_param : Parameters = [
            "anonymous": "false",
            "content": text,
            "room": group_page,
            ]
        
        print("sending message")
        Alamofire.request("http://chatby.vohras.tk/api/messages/", method: .post, parameters: mess_param, encoding: JSONEncoding.default, headers: header).validate().responseJSON(completionHandler: { response in
        })
        
        messages.append(JSQMessage(senderId: senderId, displayName: senderDisplayName, text: text))
        collectionView.reloadData()
        
        finishSendingMessage()
    }
    
    func favorite(_ sender: Any?) {
        // JACOBBBBBBB
        print("Fav :D");
    }
    
    override func delete(_ sender: Any?) {
        // BOI I TOOK A CAFFINE PILL DO SHIT HERE
        print("YOOOOO");
    }
    
    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return (action == #selector(favorite(_:)) || action == #selector(delete(_:)))
    }
    
    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        if action == #selector(favorite(_:)) {
            print("Damn. Fav.");
        }
        if action == #selector(delete(_:)) {
            print("Cya. Delete.")
        }
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(favorite(_:)) {
            return true;
        }
        if action == #selector(delete(_:)) {
            return true;
        }
        return super.canPerformAction(action, withSender: sender);
    }
    
    func roomDeleteAlert(_ sender: Any?) {
        let time: JSQMessagesTimestampFormatter;
        
        //let alert = UIAlertController(title: "Conversation End Time", message: "Conversation will end at", , preferredStyle: .no)
    }
    
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true);
        self.resignFirstResponder();
    }
    
    func setName(content: String, room: String, id: String, date: Date) {
        //print("--- Setting Name --- ")
        
        Alamofire.request("http://chatby.vohras.tk/api/users/").validate().responseJSON(completionHandler: { response in
            let users = JSON(response.result.value!)
            var j = 0
            while (j < users.count) {
                if (id == users[j]["url"].stringValue) {
                    let name = users[j]["username"].stringValue
                    self.messages.append(JSQMessage(senderId: id, senderDisplayName: name, date: date, text: content))
                }
                j = j + 1
            }
            self.messages = self.messages.sorted(by: { $0.date.compare($1.date) == ComparisonResult.orderedAscending })
            self.collectionView.reloadData()
            
        })
    }
    
    func gettingMessageData() {
        Alamofire.request(message_list).validate().responseJSON(completionHandler: { response in
            switch response.result {
            case .success:
                let output = JSON(response.result.value!)
                let message = JSON(response.result.value!)
                var i = 0;
                while (i < message.count) {
                    let t = message[i]["content"].stringValue
                    let room = message[i]["room"].stringValue
                    let id = message[i]["created_by"].stringValue
                    let myDate = message[i]["creation_time"].stringValue;
                    
                    let dateFormatter = DateFormatter();
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
                    let date = dateFormatter.date(from:myDate)!
                    
                    if (room == self.group_page) {
                        self.setName(content: t, room: room, id: id, date: date)
                    }
                    i = i + 1
                }
            case .failure:
                break
            }
            
        })
    }
    
}
