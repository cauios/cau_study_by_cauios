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

        loadPost()

        // Dahye: Customize the bottom toolbar button
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        postViewToolBar.setItems([flexibleSpace, sendAMessageButton, flexibleSpace], animated: true)
    }

    
    func updateView() {
        
        // [0726] Dahye: Add timestamp property
        // here we use optional chaining because old posts don't have timestamps

        
        postTitleLabel.text = post?.title
        //postUidLabel.text = post?.uid
        postUidLabel.text = user.username
        postTimestampLabel.text = " " // [dahye's comment] this should be modified in the future
        postCategoryLabel.text = post?.category
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
                    Api.User.REF_USERS.child(currentUser.uid).child("saved").child(self.post!.id!).removeValue()
                    self.postSavedLikeImageView.image = UIImage(named: "like")
                    Api.Saved.REF_SAVED.child(currentUser.uid).child(self.post!.id!).removeValue()
                    
                    
                    
                }
            }
            
        }
        
        
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
