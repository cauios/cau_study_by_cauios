//
//  SearchTableViewCell.swift
//  cau_study_ios
//
//  Created by Dahye on 2018. 8. 3..
//  Copyright © 2018년 신형재. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

protocol SearchTableViewCellDelegate {
    func openPostVC(postId: String)
}

class SearchTableViewCell: UITableViewCell {
    

    @IBOutlet weak var searchTitleLabel: UILabel!
    @IBOutlet weak var searchTagsLabel: UILabel!
    @IBOutlet weak var savedLikeImageView: UIImageView!
    
    // [0808 Dahye]
    
    @IBOutlet weak var searchCateView: UIView!
    @IBOutlet weak var searchContentView: UIView!
    
    @IBOutlet weak var searchFinImageView: UIImageView!
    
    @IBOutlet weak var searchFinLabel: UILabel!
    
    @IBOutlet weak var searchUnameLabel: UILabel!
    
    @IBOutlet weak var searchTimestampLabel: UILabel!
    
    
    
    @IBOutlet weak var searchCateImageView: UIImageView!
    
    
    @IBOutlet weak var searchCateLabel: UILabel!
    
    var delegate: SearchTableViewCellDelegate?
    
    // [Dahye Comment] didSet is an obsever. We can group all methods that require this post instance as an input in this observer.
    // [Dahye 05.20] We must set didSet observer to conveniently update a cell, when there is an updated data.
    var posts = [Post]()
    
    var post: Post? {
        didSet {
            
            updateView()
        }
    }
    
    
    
    
    // [Dahye Comment] Fetch newly posting data from FB
    func updateView() {
        
        
        // [0807 Dahye] Make corners of Views rounded
        searchCateView.layer.cornerRadius = 10.0
        searchContentView.layer.cornerRadius = 10.0
        searchCateView.layer.borderWidth = 0.7
        searchCateView.layer.borderColor = UIColor(red: 237.0/255.0, green: 238.0/255.0, blue: 239.0/255.0, alpha: 1.0).cgColor
        searchContentView.layer.borderWidth = 1.0
        searchContentView.layer.borderColor = UIColor(red: 237.0/255.0, green: 238.0/255.0, blue: 239.0/255.0, alpha: 1.0).cgColor
        
        //
        
        searchTitleLabel.text = post?.title
        searchTagsLabel.text = post?.tags
        
        setTimestamp()
        setUsername()
        
        // [0731 Dahye] for category image
        
        if post?.category == "학업" {
            searchCateLabel?.text = "학업"
            if post?.wanted == false {
               searchCateView?.backgroundColor = UIColor(red: 197/255.0, green: 197/255.0, blue: 197/255.0, alpha: 1)
                searchFinImageView?.image = #imageLiteral(resourceName: "finicon")
                searchFinLabel?.text = "마감"
                searchCateImageView?.image = #imageLiteral(resourceName: "stulogo")
                searchCateLabel?.textColor = UIColor.white
                
            } else {
                searchCateView?.backgroundColor = UIColor(red: 202/255.0, green: 237/255.0, blue: 253/255.0, alpha: 1.0)
                searchFinImageView?.image = nil
                searchFinLabel?.text = nil
                searchCateImageView?.image = #imageLiteral(resourceName: "catstulogo")
                searchCateLabel?.textColor =  UIColor.darkGray
            }
        }
        if post?.category == "취업" {
            searchCateLabel?.text = "취업"
            if post?.wanted == false {
                searchCateView?.backgroundColor = UIColor(red: 197.0/255.0, green: 197/255.0, blue: 197/255.0, alpha: 1.0)
                searchFinImageView?.image = #imageLiteral(resourceName: "finicon")
                searchFinLabel?.text = "마감"
                searchCateImageView?.image = #imageLiteral(resourceName: "finjoblogo")
                searchCateLabel?.textColor = UIColor.white
                
            } else {
                searchCateView?.backgroundColor = UIColor(red: 255/255.0, green: 219/255.0, blue: 217/255.0, alpha: 1.0)
                searchFinImageView?.image = nil
                searchFinLabel?.text = nil
                searchCateImageView?.image = #imageLiteral(resourceName: "catjoblogo")
                searchCateLabel?.textColor =  UIColor.darkGray
            }
        }
        if post?.category == "어학" {
            searchCateLabel?.text = "어학"
            if post?.wanted == false {
                searchCateView?.backgroundColor = UIColor(red: 197/255.0, green: 197/255.0, blue: 197/255.0, alpha: 1.0)
                searchFinImageView?.image = #imageLiteral(resourceName: "finicon")
                searchFinLabel?.text = "마감"
                searchCateImageView?.image = #imageLiteral(resourceName: "finlanlogo")
                searchCateLabel?.textColor = UIColor.white
            } else {
                searchCateView?.backgroundColor = UIColor(red: 255/255.0, green: 237/255.0, blue: 165/255.0, alpha: 1.0)
                searchFinImageView?.image = nil
                searchFinLabel?.text = nil
                searchCateImageView?.image = #imageLiteral(resourceName: "catlanlogo")
                searchCateLabel?.textColor =  UIColor.darkGray
            }
        }
        
        
        
        
        let tapGestureForSearchTitleLabel = UITapGestureRecognizer(target: self, action: #selector(self.searchTitleLabel_TouchUpInside))
        
        searchTitleLabel.addGestureRecognizer(tapGestureForSearchTitleLabel)
        searchTitleLabel.isUserInteractionEnabled = true
        
        
        
        // [0807 Dahye] stretch the scope which is able to tap to go to postView
        
        let tapGestureForSearchCateView = UITapGestureRecognizer(target: self, action: #selector(self.searchCateView_TouchUpInside))
        
        searchCateView.addGestureRecognizer(tapGestureForSearchCateView)
        searchCateView.isUserInteractionEnabled = true
        
        let tapGestureForSearchContentView = UITapGestureRecognizer(target: self, action: #selector(self.searchContentView_TouchUpInside))
        
        searchContentView.addGestureRecognizer(tapGestureForSearchContentView)
        searchContentView.isUserInteractionEnabled = true
        
        //
        
        
        let tapGestureForSavedLikeImageView =
            UITapGestureRecognizer(target: self, action: #selector(self.savedLikeImageView_TouchUpInside))
        savedLikeImageView.addGestureRecognizer(tapGestureForSavedLikeImageView)
        savedLikeImageView.isUserInteractionEnabled = true
        
        if let currentUser = Auth.auth().currentUser {
            Api.User.REF_USERS.child(currentUser.uid).child("saved").child(post!.id!).observeSingleEvent(of: .value) { snapshot in
                if let _ = snapshot.value as? NSNull {
                    self.savedLikeImageView.image = UIImage(named: "explorelike")
                } else {
                    self.savedLikeImageView.image = UIImage(named: "fulllike")
                    
                }
            }
            
            
            
        }
        
    }
    // hohyun Comment saved like button activate!
    
    @objc func savedLikeImageView_TouchUpInside(){
        if let currentUser = Auth.auth().currentUser {
            Api.User.REF_USERS.child(currentUser.uid).child("saved").child(post!.id!).observeSingleEvent(of: .value) { snapshot in
                if let _ = snapshot.value as? NSNull {
                    Api.User.REF_USERS.child(currentUser.uid).child("saved").child(self.post!.id!).setValue(true)
                    self.savedLikeImageView.image = UIImage(named: "fulllike")
                    Api.Saved.REF_SAVED.child(currentUser.uid).child(self.post!.id!).setValue(true)
                    
                    
                }
                else {
                    Api.User.REF_USERS.child(currentUser.uid).child("saved").child(self.post!.id!).removeValue()
                    self.savedLikeImageView.image = UIImage(named: "explorelike")
                    Api.Saved.REF_SAVED.child(currentUser.uid).child(self.post!.id!).removeValue()
                    
                    
                    
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
                    self.searchUnameLabel.text = postUser.username
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
            
            searchTimestampLabel.text = postTimestampText
            
            
        }
    }
    
    
    
    @objc func searchTitleLabel_TouchUpInside(){
        if let id = post?.id {
            delegate?.openPostVC(postId: id)
        }
    }
    
    
    @objc func searchCateView_TouchUpInside(){
        if let id = post?.id {
            delegate?.openPostVC(postId: id)
        }
    }
    
    @objc func searchContentView_TouchUpInside(){
        if let id = post?.id {
            delegate?.openPostVC(postId: id)
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

