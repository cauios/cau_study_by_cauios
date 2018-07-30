//
//  SavedTableViewCell.swift
//  cau_study_ios
//
//  Created by 강호현 on 2018. 7. 9..
//  Copyright © 2018년 신형재. All rights reserved.
//

import UIKit
import FirebaseAuth
import SDWebImage


class SavedTableViewCell: UITableViewCell {

    @IBOutlet weak var saveTitle: UILabel!
    @IBOutlet weak var saveTags: UILabel!
    @IBOutlet weak var saveCategory: UILabel!
    @IBOutlet weak var savedLikeImageView: UIImageView!
    
    var post: Post? {
        didSet {
            updateView()
        }
    }
    
    var delegate: ExploreTableViewCellDelegate?
    
    func updateView() {
        saveTitle.text = post?.title
        saveCategory.text = post?.category
        saveTags.text = post?.tags

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
                    Api.Saved.REF_SAVED.child(currentUser.uid).child(self.post!.id!).removeValue()
                    self.savedLikeImageView.image = UIImage(named: "like")


                }
            }
            
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
