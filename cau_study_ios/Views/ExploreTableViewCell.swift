//
//  ExploreTableViewCell.swift
//  cau_study_ios
//
//  Created by Davee on 2018. 3. 20..
//  Copyright © 2018년 신형재. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import TTGSnackbar

protocol ExploreTableViewCellDelegate {
    func goToPostVC(postId: String)
}



class ExploreTableViewCell: UITableViewCell {
    
    @IBOutlet weak var exploreTitleLabel: UILabel!
    @IBOutlet weak var exploreTagsLabel: UILabel!
    @IBOutlet weak var savedLikeImageView: UIImageView!
    @IBOutlet weak var exploreCateImageView: UIImageView!
    
    @IBOutlet weak var exploreFinImageView: UIImageView!
    
    @IBOutlet weak var exploreUnameLabel: UILabel!
    @IBOutlet weak var exploreTimestampLabel: UILabel!
    
    var delegate: ExploreTableViewCellDelegate?
    
    // [Dahye Comment] didSet is an obsever. We can group all methods that require this post instance as an input in this observer.
    // [Dahye 05.20] We must set didSet observer to conveniently update a cell, when there is an updated data.
    var posts = [Post]()
    
    var post: Post? {
        didSet {
            
            updateView()
        }
    }
    
    lazy var snackbar_like = TTGSnackbar(message: "        저장목록에서 삭제됨",
                                         duration: .middle,
                                         actionText: "실행취소",
                                         actionBlock: { (snackbar) in
                                            self.savedSelected()
                                            self.snackbar_like_selected.show()
                                            
    })
    
    lazy var snackbar_like_selected = TTGSnackbar(message: "        저장목록에 추가됨", duration: .middle, actionText: "실행취소") { (snackbar) in
        self.savedDefault()
        self.snackbar_like.show()
        
    }
    
    // [Dahye Comment] Fetch newly posting data from FB
    func updateView() {
        //hohyun: updating status bar!!
        snackbar_like_selected.backgroundColor = UIColor.white
        snackbar_like_selected.messageTextColor = .black
        snackbar_like_selected.actionTextColor = .black
        snackbar_like_selected.separateViewBackgroundColor = .clear
        snackbar_like_selected.bottomMargin = 51
        
        
        snackbar_like.backgroundColor = .white
        snackbar_like.messageTextColor = .black
        snackbar_like.actionTextColor = .black
        snackbar_like.separateViewBackgroundColor = .clear
        snackbar_like.bottomMargin = 51
        
        
        exploreTitleLabel.text = post?.title
        exploreTagsLabel.text = post?.tags
        
        // [0806 Dahye]
        setTimestamp()
        setUsername()
        
        // [0731 Dahye] for category image
        if post?.category == "학업" {
            if post?.wanted == false {
                exploreCateImageView?.image = #imageLiteral(resourceName: "finstu")
                exploreFinImageView?.image = #imageLiteral(resourceName: "fin")
                
            } else {
                exploreCateImageView?.image = #imageLiteral(resourceName: "catstu")
                exploreFinImageView?.image = nil
            }
        }
        if post?.category == "취업" {
            if post?.wanted == false {
                exploreCateImageView?.image = #imageLiteral(resourceName: "finjob")
                exploreFinImageView?.image = #imageLiteral(resourceName: "fin")
                
            } else {
                exploreCateImageView?.image = #imageLiteral(resourceName: "catjob")
                exploreFinImageView?.image = nil
            }
        }
        if post?.category == "어학" {
            if post?.wanted == false {
                exploreCateImageView?.image = #imageLiteral(resourceName: "finlan")
                exploreFinImageView?.image = #imageLiteral(resourceName: "fin")
                
            } else {
                exploreCateImageView?.image = #imageLiteral(resourceName: "catlan")
                exploreFinImageView?.image = nil
            }
        }
        
        
        
        
        
        let tapGestureForExploreTitleLabel = UITapGestureRecognizer(target: self, action: #selector(self.exploreTitleLabel_TouchUpInside))
        
        exploreTitleLabel.addGestureRecognizer(tapGestureForExploreTitleLabel)
        exploreTitleLabel.isUserInteractionEnabled = true
        
        let tapGestureForSavedLikeImageView =
            UITapGestureRecognizer(target: self, action: #selector(self.savedLikeImageView_TouchUpInside))
        savedLikeImageView.addGestureRecognizer(tapGestureForSavedLikeImageView)
        savedLikeImageView.isUserInteractionEnabled = true
        
        if let currentUser = Auth.auth().currentUser {
            Api.User.REF_USERS.child(currentUser.uid).child("saved").child(post!.id!).observeSingleEvent(of: .value) { snapshot in
                if let _ = snapshot.value as? NSNull {
                    self.savedLikeImageView.image = UIImage(named: "like")
                } else {
                    self.savedLikeImageView.image = UIImage(named: "likeSelected")
                    
                }
            }
            
            
            
        }
        
    }
    
    // [0805 Dahye] set username & timestamp of each post
    func setUsername() {
        if let uid = post?.uid {
            Api.User.REF_USERS.child(uid).observeSingleEvent(of: DataEventType.value, with: { snapshot in
                if let dict = snapshot.value as? [String: Any] {
                    let postUser = User.transformUser(dict: dict, key: snapshot.key)
                    self.exploreUnameLabel.text = postUser.username
                }
            })
        }
    }
    
    func setTimestamp() {
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
            
            exploreTimestampLabel.text = postTimestampText
            
            
        }
    }
    func savedSelected() {
        let currentUser = Auth.auth().currentUser
        Api.User.REF_USERS.child((currentUser?.uid)!).child("saved").child(self.post!.id!).setValue(true)
        self.savedLikeImageView.image = UIImage(named: "likeSelected")
        Api.Saved.REF_SAVED.child((currentUser?.uid)!).child(self.post!.id!).setValue(true)
        self.snackbar_like_selected.show()
    }
    
    func savedDefault() {
        _ = Auth.auth().currentUser
        Api.User.REF_USERS.child((Auth.auth().currentUser?.uid)!).child("saved").child(self.post!.id!).removeValue()
        self.savedLikeImageView.image = UIImage(named: "like")
        Api.Saved.REF_SAVED.child((Auth.auth().currentUser?.uid)!).child(self.post!.id!).removeValue()
        self.snackbar_like.show()
    }
    
    
    // hohyun Comment saved like button activate!
    
    @objc func savedLikeImageView_TouchUpInside(){
        if let currentUser = Auth.auth().currentUser {
            Api.User.REF_USERS.child(currentUser.uid).child("saved").child(post!.id!).observeSingleEvent(of: .value) { snapshot in
                if let _ = snapshot.value as? NSNull {
                    self.savedSelected()
                    
                    
                }
                else {
                    self.savedDefault()
                }
            }
            
        }
        
    }
    
    
    
    
    @objc func exploreTitleLabel_TouchUpInside(){
        if let id = post?.id {
            delegate?.goToPostVC(postId: id)
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
