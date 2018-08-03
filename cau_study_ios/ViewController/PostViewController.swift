//
//  PostViewController.swift
//  cau_study_ios
//
//  Created by Dahye on 2018. 7. 23..
//  Copyright © 2018년 신형재. All rights reserved.
//

import UIKit
import FirebaseAuth

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
    
    // buttom toolbar factors
    @IBOutlet weak var postViewToolBar: UIToolbar!
    @IBOutlet weak var sendAMessageButton: UIBarButtonItem!
    
    @IBOutlet weak var postSavedLikeImageView: UIImageView!
    
    var postId: String?
    
    
    var post: Post? {
        didSet {
            updateView()
        }
    }
    
    //[Dahye 0725]
    var user: User!
    //
    
    override func viewDidLoad() {
        
        // hohyun: make imageview as a right bar button!!!
        let barButton = UIBarButtonItem(customView: postSavedLikeImageView)
        self.navigationItem.rightBarButtonItem = barButton
        
        loadPost()
        
        
        // Dahye: Customize the bottom toolbar button
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        postViewToolBar.setItems([flexibleSpace, sendAMessageButton, flexibleSpace], animated: true)
        
        
        //for username touch
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.touchUsernameAction))
        postUidLabel.addGestureRecognizer(tapGesture)
        postUidLabel.isUserInteractionEnabled = true
        
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
                    self.postSavedLikeImageView.image = UIImage(named: "like")
                } else {
                    
                    self.postSavedLikeImageView.image = UIImage(named: "likeSelected")
                    
                }
            }
            
            
            
        }
        
    }

    
  func showAlert() {
        // UIAlertController를 생성해야 한다. style은 .alert로 해준다.
        let alertController = UIAlertController(title: "목록 삭제", message: "저장 목록에서 삭제하시겠습니까?", preferredStyle: .alert)
        // style이 .cancel이면 bold체. handler가 nil일 경우에는 아무 일이 일어나지 않고 닫힌다.
            alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: {alertAction in
                NSLog("OK Pressed")
            }))
            // style이 .destructive면 빨간색 text color
            alertController.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: {
                alertAction in
                NSLog("Delete Pressed")
                Api.User.REF_USERS.child((Auth.auth().currentUser?.uid)!).child("saved").child(self.post!.id!).removeValue()
                self.postSavedLikeImageView.image = UIImage(named: "like")
                Api.Saved.REF_SAVED.child((Auth.auth().currentUser?.uid)!).child(self.post!.id!).removeValue()
                let transition: CATransition = CATransition()
                transition.duration = 0.5
                transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                transition.type = kCATransitionReveal
                transition.subtype = kCATransitionFromRight
                self.view.window!.layer.add(transition, forKey: nil)
                self.dismiss(animated: false, completion: nil)
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
    
    
}

