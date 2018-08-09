//
//  ChatRoomsViewController.swift
//  cau_study_ios
//
//  Created by 신형재 on 30/07/2018.
//  Copyright © 2018 신형재. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class ChatRoomsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var chattableview: UITableView!
    
    var uid: String!
    var chatrooms : [ChatModel]! = []
    var destinationUsers : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavBarImage() // [0809 Dahye] call func to show navilogo 
        self.uid = Auth.auth().currentUser?.uid
        self.getChatroomsList()
        // Do any additional setup after loading the view.
    }
    
    func getChatroomsList(){
        Database.database().reference().child("chatRooms").queryOrdered(byChild: "users/"+uid).queryEqual(toValue: true).observeSingleEvent(of: DataEventType.value, with: {(datasnapshot) in
            self.chatrooms.removeAll()
            print("5번포인트")
            for item in datasnapshot.children.allObjects as! [DataSnapshot]{
                print("6번포인트")
                if let chatroomdic = item.value as? [String:AnyObject]{
                    let chatModel = ChatModel(JSON: chatroomdic)
                    self.chatrooms.append(chatModel!)
                }
            }
            //테이블뷰 갱신코드
            self.chattableview.reloadData()
        })
    }
    
    // [0809 Dahye] add logo in the middle of the navibar
    func addNavBarImage() {
        let navController = navigationController!
        
        let image = #imageLiteral(resourceName: "logo")
        let imageView = UIImageView(image: image)
        
        let bannerWidth = navController.navigationBar.frame.size.width / 2
        let bannerHeight = navController.navigationBar.frame.size.height / 2
        
        let bannerX = bannerWidth / 2 - image.size.width / 2
        let bannerY = bannerHeight / 2 - image.size.height / 2
        
        imageView.frame = CGRect(x: bannerX, y: bannerY, width: bannerWidth, height: bannerHeight)
        imageView.contentMode = .scaleAspectFit
        
        navigationItem.titleView = imageView
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chatrooms.count
    }
    
    //어떤 뷰를 쓸껀지
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RowCell", for: indexPath) as! CustomCell
        
        var destinationUid : String?
        
        for item in chatrooms[indexPath.row].users{
            if(item.key != self.uid){
                destinationUid = item.key
                destinationUsers.append(destinationUid!)
            }
        }
        
       //setvalueForKeys swift용으로 대체
       /* Database.database().reference().child("users").child(destinationUid!).observeSingleEvent(of: DataEventType.value, with: {
            (datasnapshot) in
            var user = User()
            let user = datasnapshot.value as! [String:AnyObject]
            */
        
        Api.User.observeUser(withId: destinationUid!, completion: { user in
            var userModel = User()
            userModel = user
            //왜 되는지 모르곘음;;;;
            cell.label_title.text = userModel.username
            let url = URL(string: userModel.profileImageUrl!)
            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, err) in
                DispatchQueue.main.sync{
                    cell.imageVIEW.image = UIImage(data:data!)
                    cell.imageVIEW.layer.cornerRadius = cell.imageVIEW.frame.width/2
                    cell.imageVIEW.layer.masksToBounds = true
                }
            }).resume()
            
            //마지막 메세지를 띄어주는 코드
            let lastMessageKey = self.chatrooms[indexPath.row].comments.keys.sorted(){$0>$1}
            //오름차순: {$0>$1} 내림차순 : {$0<$1}
            cell.label_lastmessage.text = self.chatrooms[indexPath.row].comments[lastMessageKey[0]]?.message
            let unixTime = self.chatrooms[indexPath.row].comments[lastMessageKey[0]]?.timestamp
            cell.label_timestamp.text = unixTime?.toDayTime
        })
        
        return cell
    }
    
    //테이블뷰를 클릭할때 발생되는 이벤트
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //클릭하면 회색이되었다가 사라지게하는 코드
        tableView.deselectRow(at: indexPath, animated: true)
        let destinationUid = self.destinationUsers[indexPath.row]
        let view = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        view.destinationUid = destinationUid
        self.navigationController?.pushViewController(view, animated: true)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        //다시로딩
        viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
