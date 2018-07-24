//
//  ChatViewController.swift
//  cau_study_ios
//
//  Created by 신형재 on 27/03/2018.
//  Copyright © 2018 신형재. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    public var destinationUid: String? //내가 채팅할 상대의 id
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var tableview: UITableView!
    
    var uid :String?
    var chatRoomUid :String?
    var comments : [ChatModel.Comment] = []
    @IBOutlet weak var textField_message: UITextField!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let view = tableview.dequeueReusableCell(withIdentifier: "MyMessageCell", for: indexPath)
        view.textLabel?.text = self.comments[indexPath.row].message
        
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uid = Auth.auth().currentUser?.uid
        sendButton.addTarget(self, action: #selector(createRoom), for: .touchUpInside)
        print("5번 포인트")
        checkChatRoom()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        //I will change this viewcontroller
    }
    
    @objc func createRoom(){
        print("4번 포인트")
        let createRoomInfo :Dictionary<String,Any> = [
            "users" :[
                uid!: true,
                destinationUid!: true
            ]
        ]
        if(chatRoomUid == nil){
            //방생성
            self.sendButton.isEnabled = false
            Database.database().reference().child("chatRooms").childByAutoId().setValue(createRoomInfo, withCompletionBlock: {(err, ref) in
                if(err==nil){
                    self.checkChatRoom()
                }
            })
        }else{
            let value :Dictionary<String,Any> = [
                    "uid":uid!,
                    "message":textField_message.text!
            ]
            Database.database().reference().child("chatRooms").child(chatRoomUid!).child("comments").childByAutoId().setValue(value)
        }
    }

    func checkChatRoom(){
        Database.database().reference().child("chatRooms").queryOrdered(byChild: "users/" + uid!).queryEqual(toValue: true).observeSingleEvent(of: DataEventType.value, with: {(datasnapshot) in
            for item in datasnapshot.children.allObjects as! [DataSnapshot]{
                
                if let chatRoomdic = item.value as? [String:AnyObject]{
                    
                    let chatModel = ChatModel(JSON: chatRoomdic)
                        if(chatModel?.users[self.destinationUid!] == true){
                            self.chatRoomUid=item.key
                            self.sendButton.isEnabled = true
                            self.getMessageList()
                    }
                }
                
            }
            
        })
    }
    
    func getMessageList(){
        Database.database().reference().child("chatRooms").child(self.chatRoomUid!).child("comments").observe(DataEventType.value, with: { (datasnapshot) in
            self.comments.removeAll()
            
            for item in datasnapshot.children.allObjects as! [DataSnapshot]{
                let comment = ChatModel.Comment(JSON: item.value as! [String:AnyObject])
                self.comments.append(comment!)
            }
            self.tableview.reloadData()
        })
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
