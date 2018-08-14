//
//  PostViewController.swift
//  cau_study_ios
//
//  Created by Dahye on 2018. 7. 23..
//  Copyright © 2018년 신형재. All rights reserved.
//

import UIKit
import FirebaseAuth
import TTGSnackbar

class PostViewController: UIViewController {
    
    // postScrollView factors
    @IBOutlet weak var postScrollView: UIScrollView!
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var postUidLabel: UILabel!
    @IBOutlet weak var postTimestampLabel: UILabel!
    @IBOutlet weak var postCategoryLabel: UILabel!
    @IBOutlet weak var postTagsLabel: UILabel!
    @IBOutlet weak var postNumOfVacanLabel: UILabel!
    @IBOutlet weak var postTimeLabel: UILabel!
    @IBOutlet weak var postLocationLabel: UILabel!
    @IBOutlet weak var postDescriptionLabel: UILabel!
    @IBOutlet weak var postCategoryImage: UIImageView!
    @IBOutlet weak var postCategoryBar: UIView!
    @IBOutlet weak var postFinImageView: UIImageView!
    @IBOutlet weak var postFinLabel: UILabel!
    
    // buttom toolbar factors
    @IBOutlet weak var postViewToolBar: UIToolbar!
    @IBOutlet weak var sendAMessageButton: UIBarButtonItem!
    
    @IBOutlet weak var postSavedLikeImageView: UIImageView!
    @IBOutlet weak var editImageView: UIImageView!
    
    
    var postId: String?
    var postUid: String?
    
    var post: Post? {
        didSet {
            updateView()
            checkCurrentUser()
        }
    }
    
    //[Dahye 0725]
    var user: User!
    //
    //[hohyun 0804]

    
    lazy var snackbar_like = TTGSnackbar(message: "        저장목록에서 삭제됨",
                               duration: .middle,
                               actionText: "실행취소",
                               actionBlock: { (snackbar) in
                                self.savedSelected() //실행취소 누르면 다시 색칠
                                self.snackbar_like_selected.show()
                               
    })
    
    lazy var snackbar_like_selected = TTGSnackbar(message: "        저장목록에 추가됨", duration: .middle, actionText: "실행취소") { (snackbar) in
                    self.savedDefault()
                    self.snackbar_like.show()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barTintColor = UIColor.white // [0809 Dahye] change the navgi bar color into white
        loadPost()
    }

    
    override func viewDidLoad() {
        navigationController?.navigationBar.barTintColor = UIColor.white
        //hohyun: updating status bar!!
        snackbar_like_selected.backgroundColor = UIColor.white
        snackbar_like_selected.messageTextColor = .black
        snackbar_like_selected.actionTextColor = .black
        snackbar_like_selected.separateViewBackgroundColor = .clear
        snackbar_like_selected.bottomMargin = 50
        
        snackbar_like.backgroundColor = .white
        snackbar_like.messageTextColor = .black
        snackbar_like.actionTextColor = .black
        snackbar_like.separateViewBackgroundColor = .clear
        snackbar_like.bottomMargin = 50

        editImageView.tintColor = UIColor.black
        // hohyun: make imageview as a right bar button!!!
        let barButton = UIBarButtonItem(customView: postSavedLikeImageView)
        
        self.navigationItem.rightBarButtonItems = [barButton]
       
        
        
        //loadPost()
        
        
        // Dahye: Customize the bottom toolbar button
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        postViewToolBar.setItems([flexibleSpace, sendAMessageButton, flexibleSpace], animated: true)
        
        
        //for username touch
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.touchUsernameAction))
        postUidLabel.addGestureRecognizer(tapGesture)
        postUidLabel.isUserInteractionEnabled = true
        
    }
    
    func checkCurrentUser() {
        guard let currentUser = Auth.auth().currentUser else{
            return
        }
        if currentUser.uid == user.uid {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.editAction))
            editImageView.addGestureRecognizer(tapGesture)
            editImageView.isUserInteractionEnabled = true
            let editBarButton = UIBarButtonItem(customView: editImageView)
            self.navigationItem.rightBarButtonItems?.append(editBarButton)
            
        } else {
            
        }
        
    }
    @objc func editAction() {
        let actionSheet = UIAlertController(title: nil, message: nil , preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "수정", style: .default, handler: {(action: UIAlertAction) in
            
            self.performSegue(withIdentifier: "EditPostViewController", sender: self)
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: {(action: UIAlertAction) in
            
           
        }))

        actionSheet.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        self.present(actionSheet,animated: true,completion: nil)
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.barTintColor = UIColor(red: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1.0)
    }
    

    //newbro : sendbutton clicked
    @IBAction func SendMessageTouchUpinside(_ sender: Any) {
        self.performSegue(withIdentifier: "GoChatVC", sender:nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoChatVC" {
            if let destinationVC = segue.destination as? ChatViewController {
                destinationVC.destinationUid = user.uid
                destinationVC.viewWillAppear(true)
            }
        }
        if segue.identifier == "WriterInfoViewController" {
            let vc = segue.destination as! WriterInfoViewController
            vc.user = self.user
        }
        
        if segue.identifier == "EditPostViewController" {
            let vc = segue.destination as! EditPostViewController
            vc.postId = self.postId
        }
    }

    
    func updateView() {
        
        // [0726] Dahye: Add timestamp property
        // here we use optional chaining because old posts don't have timestamps
        
        
        postTitleLabel.text = post?.title
        //postUidLabel.text = post?.uid
        postUidLabel.text = user.username
        postTimestampLabel.text = " " // [dahye's comment] this should be modified in the future
        postCategoryLabel.text = post?.category
        if(postCategoryLabel.text == "학업") {
            postCategoryImage.image = #imageLiteral(resourceName: "stulogo")
            let color = UIColor(red: 00/255, green: 122/255, blue: 255/255, alpha: 1)
            postCategoryLabel.textColor = color
            postCategoryBar.backgroundColor = color
        }
        else if(postCategoryLabel.text == "취업") {
            postCategoryImage.image = #imageLiteral(resourceName: "joblogo")
            let color = UIColor(red: 255/255, green: 46/255, blue: 85/255, alpha: 1)
            postCategoryLabel.textColor = color
            postCategoryBar.backgroundColor = color
        }
        else if(postCategoryLabel.text == "어학") {
            postCategoryImage.image = #imageLiteral(resourceName: "lanlogo")
            let color = UIColor(red: 255/255, green: 192/255, blue: 00/255, alpha: 1)
            postCategoryLabel.textColor = color
            postCategoryBar.backgroundColor = color
        }
        postTagsLabel.text = post?.tags
        
        // [0803 Dahye] Show if it is finished or not
        if post?.wanted == false {
            postFinImageView.image = #imageLiteral(resourceName: "finicon")
            postFinLabel.text = "마감"
        } else {
            postFinImageView.image = nil
            postFinLabel.text = nil
        }
        
        postNumOfVacanLabel.text = post?.numOfVacan
        postTimeLabel.text = post?.time
        postLocationLabel.text = post?.location
        postDescriptionLabel.text = post?.description
        if let timestamp = post?.timestamp {
            print(timestamp)
            let timestampDate = Date(timeIntervalSince1970: TimeInterval(timestamp))
            let now = Date()
            let components = Set<Calendar.Component>([.second, .minute, .hour, .day, .weekOfMonth])
            let timeDiff = Calendar.current.dateComponents(components, from: timestampDate, to: now)
            
            var postTimestampText = ""
            
            // [0726] Dahye: Handle each case
            
            if timeDiff.second! <= 0 {
                postTimestampText = "Now"
            }
            if timeDiff.second! > 0 && timeDiff.minute! == 0 {
                postTimestampText = (timeDiff.second == 1) ? "\(timeDiff.second!) second ago" : "\(timeDiff.second!) seconds ago"
            }
            if timeDiff.minute! > 0 && timeDiff.hour! == 0 {
                postTimestampText = (timeDiff.minute == 1) ? "\(timeDiff.minute!) minute ago" : "\(timeDiff.minute!) minutes ago"
            }
            if timeDiff.hour! > 0 && timeDiff.day! == 0 {
                postTimestampText = (timeDiff.hour == 1) ? "\(timeDiff.hour!) hour ago" : "\(timeDiff.hour!) hours ago"
            }
            if timeDiff.day! > 0 && timeDiff.weekOfMonth! == 0 {
                postTimestampText = (timeDiff.day == 1) ? "\(timeDiff.day!) day ago" : "\(timeDiff.day!) days ago"
            }
            if timeDiff.weekOfMonth! > 0 {
                postTimestampText = (timeDiff.weekOfMonth == 1) ? "\(timeDiff.weekOfMonth!) week ago" : "\(timeDiff.weekOfMonth!) weeks ago"
            }
            
            postTimestampLabel.text = postTimestampText
            
            
        }
        setPostDescriptionLabelSize()
        
        let tapGestureForSavedLikeImageView =
            UITapGestureRecognizer(target: self, action: #selector(self.postSavedLikeImageView_TouchUpInside))
        postSavedLikeImageView.addGestureRecognizer(tapGestureForSavedLikeImageView)
        postSavedLikeImageView.isUserInteractionEnabled = true
        
        if let currentUser = Auth.auth().currentUser {
            Api.User.REF_USERS.child(currentUser.uid).child("saved").child(post!.id!).observeSingleEvent(of: .value) { snapshot in
                if let _ = snapshot.value as? NSNull {
                    self.postSavedLikeImageView.image = UIImage(named: "postlike")
                } else {
                    self.postSavedLikeImageView.image = UIImage(named: "postfull")
                    

                }
            }
            
            
            
        }
        
    }

    
    func savedSelected() {
        let currentUser = Auth.auth().currentUser
        Api.User.REF_USERS.child((currentUser?.uid)!).child("saved").child(self.post!.id!).setValue(true)
        self.postSavedLikeImageView.image = UIImage(named: "likeSelected")
        Api.Saved.REF_SAVED.child((currentUser?.uid)!).child(self.post!.id!).setValue(true)
    }
    
    func savedDefault() {
        _ = Auth.auth().currentUser
        Api.User.REF_USERS.child((Auth.auth().currentUser?.uid)!).child("saved").child(self.post!.id!).removeValue()
        self.postSavedLikeImageView.image = UIImage(named: "like")
        Api.Saved.REF_SAVED.child((Auth.auth().currentUser?.uid)!).child(self.post!.id!).removeValue()
        self.snackbar_like.show()
    }
    
    
  func showAlert() {
        // UIAlertController를 생성해야 한다. style은 .alert로 해준다.
        let alertController = UIAlertController(title: "목록 삭제", message: "저장 목록에서 삭제하시겠습니까?", preferredStyle: .alert)
        // style이 .cancel이면 bold체. handler가 nil일 경우에는 아무 일이 일어나지 않고 닫힌다.
            alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: {alertAction in
                NSLog("OK Pressed")
               let currentUser = Auth.auth().currentUser
                Api.User.REF_USERS.child((currentUser?.uid)!).child("saved").child(self.post!.id!).setValue(true)
                self.postSavedLikeImageView.image = UIImage(named: "likeSelected")
                Api.Saved.REF_SAVED.child((currentUser?.uid)!).child(self.post!.id!).setValue(true)
            }))
            // style이 .destructive면 빨간색 text color
            alertController.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: {
                alertAction in
                NSLog("Delete Pressed")
                Api.User.REF_USERS.child((Auth.auth().currentUser?.uid)!).child("saved").child(self.post!.id!).removeValue()
                self.postSavedLikeImageView.image = UIImage(named: "like")
                Api.Saved.REF_SAVED.child((Auth.auth().currentUser?.uid)!).child(self.post!.id!).removeValue()
                self.snackbar_like.show()
        
//                let transition: CATransition = CATransition()
//                transition.duration = 0.5
//                transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
//                transition.type = kCATransitionReveal
//                transition.subtype = kCATransitionFromRight
//                self.view.window!.layer.add(transition, forKey: nil)
//
//                self.dismiss(animated: false, completion: nil)

            // 실제로 화면에 보여주기 위해서는 present 메서드가 필요하다. animated : true/false로 해놓으면 애니메이션 효과가 있고/없다. present가 완료되어 화면이 보여지면 completion의 코드가 실행된다.
                
    }))
        self.present(alertController, animated: true, completion: nil)

    }
    
    // hohyun Comment saved like button activate!
    
    @objc func postSavedLikeImageView_TouchUpInside(){
        if let currentUser = Auth.auth().currentUser {
            Api.User.REF_USERS.child(currentUser.uid).child("saved").child(post!.id!).observeSingleEvent(of: .value) { snapshot in
                if let _ = snapshot.value as? NSNull {
                    Api.User.REF_USERS.child(currentUser.uid).child("saved").child(self.post!.id!).setValue(true)
                    self.postSavedLikeImageView.image = UIImage(named: "likeSelected")
                    Api.Saved.REF_SAVED.child(currentUser.uid).child(self.post!.id!).setValue(true)
                    self.snackbar_like_selected.show()
                    self.addRedDotAtTabBarItemIndex(index: 2)


                }
                else {
                    self.showAlert()
                    Api.User.REF_USERS.child(currentUser.uid).child("saved").child(self.post!.id!).removeValue()
                    self.postSavedLikeImageView.image = UIImage(named: "like")
                    Api.Saved.REF_SAVED.child(currentUser.uid).child(self.post!.id!).removeValue()
                    
                    
                    
                }
            }
            
        }
        
        
    }
    
    //username 터치시
    @objc func touchUsernameAction() {
        self.performSegue(withIdentifier: "WriterInfoViewController", sender: self)
    }

    
    /* 잘 된 애
     func loadPost() {
     Api.Post.observePost(withId: postId!, completion: {post in
     self.post = post
     })
     }
     */
    // [Dahye 0725] This should be implemented in cooperation with Minjung
    // See the lecture 71
    //[Dahye 0725] just try~
    func loadPost() {
        Api.Post.observePost(withId: postId!, completion: { (post) in
            guard let postUid = post.uid else {
                return
            }
            self.fetchUser(uid: postUid, completed: {
                self.post = post
            })
        })
        
        
    }
    
    func fetchUser(uid: String, completed: @escaping () -> Void ) {
        Api.User.observeUser(withId: uid, completion: {
            user in
            self.user = user
            completed()
        })
    }
    
    // Dahye: Make the description label dynamically resizing
    func setPostDescriptionLabelSize() {
        postScrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: postDescriptionLabel.bottomAnchor).isActive = true
    }
    
    func addRedDotAtTabBarItemIndex(index: Int) {
        for subview in tabBarController!.tabBar.subviews {
            
            if let subview = subview as? UIView {
                
                if subview.tag == 1234 {
                    subview.removeFromSuperview()
                    break
                }
            }
        }
        
        let RedDotRadius: CGFloat = 5
        let RedDotDiameter = RedDotRadius * 2
        
        let TopMargin:CGFloat = 5
        
        let TabBarItemCount = CGFloat(self.tabBarController!.tabBar.items!.count)
        
        let screenSize = UIScreen.main.bounds
        let HalfItemWidth = (screenSize.width) / (TabBarItemCount * 2)
        
        let  xOffset = HalfItemWidth * CGFloat(index * 2 + 1)
        
        let imageHalfWidth: CGFloat = (self.tabBarController!.tabBar.items![index] ).selectedImage!.size.width / 2
        
        let redDot = UIView(frame: CGRect(x: xOffset + imageHalfWidth - 7, y: TopMargin, width: RedDotDiameter, height: RedDotDiameter))
        
        redDot.tag = 1234
        redDot.backgroundColor = UIColor.red
        redDot.layer.cornerRadius = RedDotRadius
        
        self.tabBarController?.tabBar.addSubview(redDot)
        
    }
    
}

