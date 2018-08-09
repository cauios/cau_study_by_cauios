//
//  ChatViewController.swift
//  cau_study_ios
//
//  Created by 신형재 on 27/03/2018.
//  Copyright © 2018 신형재. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class ChatViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    public var destinationUid: String? //내가 채팅할 상대의 id
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    
    var uid :String?
    var chatRoomUid :String?
    var comments : [ChatModel.Comment] = []
    var userModel : User?
    
    override func viewDidLoad() {
        navigationController?.navigationBar.barTintColor = UIColor.white // [0809 Dahye] change the navgi bar color into white
        super.viewDidLoad()
        uid = Auth.auth().currentUser?.uid
        sendButton.addTarget(self, action: #selector(createRoom), for: .touchUpInside)
        checkChatRoom()
        self.tabBarController?.tabBar.isHidden = true
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    
    
    //시작시 작동, 키보드가 나타나고 사라지는 코드(옵저버)
    override func viewWillAppear(_ animated: Bool) {
        
        navigationController?.navigationBar.barTintColor = UIColor.white // [0809 Dahye] change the navgi bar color into white
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    //종료시 작동
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)  //옵저버 제거
        self.tabBarController?.tabBar.isHidden = false  //탭바다시노출
        // [0809 Dahye] change the navi color into concept gray color
        navigationController?.navigationBar.barTintColor = UIColor(red: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1.0)
        
    }
    
    @objc func keyboardWillShow(notification : Notification){
        if let keyboardSize = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
            self.bottomConstraint.constant = keyboardSize.height
        }
        UIView.animate(withDuration: 0, animations: {
            self.view.layoutIfNeeded()
        }, completion: {
            (complete) in
            //대화가있으면 제일 밑으로 내려준다
            if self.comments.count > 0 {
                self.tableview.scrollToRow(at: IndexPath(item: self.comments.count-1, section: 0), at: UITableViewScrollPosition.bottom, animated: true)
            }
        })
    }
    
    @objc func keyboardWillHide(notification: Notification){
        self.bottomConstraint.constant = 20
        self.view.layoutIfNeeded()
    }
    
    //다른곳 눌러도 키보드 다시 내려가도록 코딩, viewDidLoad에서 호출
    @objc func dismissKeyboard(){
        self.view.endEditing(true)
    }
    
    @IBOutlet weak var textField_message: UITextField!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(self.comments[indexPath.row].uid == uid){
            let view = tableview.dequeueReusableCell(withIdentifier: "MyMessageCell", for: indexPath) as! MyMessageCellTableViewCell
            view.label_message.text = self.comments[indexPath.row].message
            view.label_message.numberOfLines = 0
            
            if let time = self.comments[indexPath.row].timestamp{
                view.label_timestamp.text = time.toDayTime
            }
            return view
        }else{
            let view = tableview.dequeueReusableCell(withIdentifier: "DestinationMessageCell", for: indexPath) as! DestinationMessageCell
            view.labelName.text = userModel?.username
            view.label_message.text = self.comments[indexPath.row].message
            view.label_message.numberOfLines = 0
            
            let url = URL(string: (self.userModel?.profileImageUrl)!)
            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, err) in
                DispatchQueue.main.async {
                    view.imageview_profile.image = UIImage(data: data!)
                    view.imageview_profile.layer.cornerRadius = view.imageview_profile.frame.width/2
                    view.imageview_profile.clipsToBounds = true
                }
            }).resume()
            
            if let time = self.comments[indexPath.row].timestamp{
                view.label_timestamp.text = time.toDayTime
            }
            
            return view
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        //I will change this viewcontroller
    }
    
    @objc func createRoom(){
        let createRoomInfo :Dictionary<String,Any> = [
            "users" :[
                uid!: true,
                destinationUid!: true
            ]
        ]
        if(chatRoomUid == nil){
            //방생성
            self.sendButton.isEnabled = true
            Database.database().reference().child("chatRooms").childByAutoId().setValue(createRoomInfo, withCompletionBlock: {(err, ref) in
                if(err==nil){
                    self.checkChatRoom()
                }
            })
        }else{
            let value :Dictionary<String,Any> = [
                "uid":uid!,
                "message":textField_message.text!,
                "timestamp":ServerValue.timestamp()
                //현재시간에서1970년정도 뺀 밀리초가 저장됨(변환해야한다) 맨아래 extension Int했다.
            ]
            if textField_message.text! != ""
            { Database.database().reference().child("chatRooms").child(chatRoomUid!).child("comments").childByAutoId().setValue(value, withCompletionBlock: {
                (err, ref) in
                self.textField_message.text = "" //메세지 보낸다음에 지워준다
            })
            }
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
                        self.getDestinationInfo()
                        
                        //[0809 Dahye] send data to DB right after creation of the new chat room. Do not need to touchUpInside twice anymore.
                        let value :Dictionary<String,Any> = [
                            "uid":self.uid!,
                            "message":self.textField_message.text!,
                            "timestamp":ServerValue.timestamp()
                            //현재시간에서1970년정도 뺀 밀리초가 저장됨(변환해야한다) 맨아래 extension Int했다.
                        ]
                        if self.textField_message.text! != ""
                        { Database.database().reference().child("chatRooms").child(self.self.chatRoomUid!).child("comments").childByAutoId().setValue(value, withCompletionBlock: {
                            (err, ref) in
                            self.textField_message.text = "" //메세지 보낸다음에 지워준다
                        })
                        }
                        //
                    }
                }
                
            }
            
        })
    }
    
    func getDestinationInfo(){
        /*기존코드 Database.database().reference().child("users").child(self.destinationUid!).observeSingleEvent(of: DataEventType.value, with: { (datasnapshot) in
         self.userModel = User()
         self.userModel?.setValuesForKeys(datasnapshot.value as! [String:Any])
         self.getMessageList()
         })
         */
        Api.User.observeUser(withId: destinationUid!, completion: { user in
            self.userModel = User()
            self.userModel = user
            self.getMessageList()
        })
        //왜 되는지 모르곘음;;;;
    }
    
    func getMessageList(){
        Database.database().reference().child("chatRooms").child(self.chatRoomUid!).child("comments").observe(DataEventType.value, with: { (datasnapshot) in
            self.comments.removeAll()
            
            for item in datasnapshot.children.allObjects as! [DataSnapshot]{
                let comment = ChatModel.Comment(JSON: item.value as! [String:AnyObject])
                self.comments.append(comment!)
            }
            self.tableview.reloadData()
            
            //상대방데이터가 넘어올때도 최하단으로 내려준다.
            if self.comments.count > 0 {
                self.tableview.scrollToRow(at: IndexPath(item: self.comments.count-1, section: 0), at: UITableViewScrollPosition.bottom, animated: true)
            }
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

extension Int{
    var toDayTime : String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy.MM.dd HH:mm"
        let date = Date(timeIntervalSince1970: Double(self)/1000)
        return dateFormatter.string(from: date)
    }
}
