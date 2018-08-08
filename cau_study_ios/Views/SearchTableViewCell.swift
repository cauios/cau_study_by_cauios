//
//  SearchTableViewCell.swift
//  cau_study_ios
//
//  Created by Dahye on 2018. 8. 3..
//  Copyright © 2018년 신형재. All rights reserved.
//

import UIKit
import FirebaseAuth

protocol SearchTableViewCellDelegate {
    func openPostVC(postId: String)
}

class SearchTableViewCell: UITableViewCell {
    

    @IBOutlet weak var searchTitleLabel: UILabel!
    @IBOutlet weak var searchTagsLabel: UILabel!
    @IBOutlet weak var savedLikeImageView: UIImageView!
    
    // [0808 Dahye]
    

    
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
        searchTitleLabel.text = post?.title
        searchTagsLabel.text = post?.tags
        //
        //        // [0731 Dahye] for category image
        //        if post?.category == "학업" {
        //            if post?.wanted == false {
        //                exploreCateImageView?.image = #imageLiteral(resourceName: "finstu")
        //                exploreFinImageView?.image = #imageLiteral(resourceName: "fin")
        //
        //            } else {
        //                exploreCateImageView?.image = #imageLiteral(resourceName: "catstu")
        //                exploreFinImageView?.image = nil
        //            }
        //        }
        //        if post?.category == "취업" {
        //            if post?.wanted == false {
        //                exploreCateImageView?.image = #imageLiteral(resourceName: "finjob")
        //                exploreFinImageView?.image = #imageLiteral(resourceName: "fin")
        //
        //            } else {
        //                exploreCateImageView?.image = #imageLiteral(resourceName: "catjob")
        //                exploreFinImageView?.image = nil
        //            }
        //        }
        //        if post?.category == "어학" {
        //            if post?.wanted == false {
        //                exploreCateImageView?.image = #imageLiteral(resourceName: "finlan")
        //                exploreFinImageView?.image = #imageLiteral(resourceName: "fin")
        //
        //            } else {
        //                exploreCateImageView?.image = #imageLiteral(resourceName: "catlan")
        //                exploreFinImageView?.image = nil
        //            }
        //        }
        //
        //
        //
        //
        //
        let tapGestureForSearchTitleLabel = UITapGestureRecognizer(target: self, action: #selector(self.searchTitleLabel_TouchUpInside))
        
        searchTitleLabel.addGestureRecognizer(tapGestureForSearchTitleLabel)
        searchTitleLabel.isUserInteractionEnabled = true
        
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
    // hohyun Comment saved like button activate!
    
    @objc func savedLikeImageView_TouchUpInside(){
        if let currentUser = Auth.auth().currentUser {
            Api.User.REF_USERS.child(currentUser.uid).child("saved").child(post!.id!).observeSingleEvent(of: .value) { snapshot in
                if let _ = snapshot.value as? NSNull {
                    Api.User.REF_USERS.child(currentUser.uid).child("saved").child(self.post!.id!).setValue(true)
                    self.savedLikeImageView.image = UIImage(named: "likeSelected")
                    Api.Saved.REF_SAVED.child(currentUser.uid).child(self.post!.id!).setValue(true)
                    
                    
                }
                else {
                    Api.User.REF_USERS.child(currentUser.uid).child("saved").child(self.post!.id!).removeValue()
                    self.savedLikeImageView.image = UIImage(named: "like")
                    Api.Saved.REF_SAVED.child(currentUser.uid).child(self.post!.id!).removeValue()
                    
                    
                    
                }
            }
            
        }
        
        
    }
    
    
    @objc func searchTitleLabel_TouchUpInside(){
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

