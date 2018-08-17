//
//  WriterPostsTableViewCell.swift
//  cau_study_ios
//
//  Created by CAUAD30 on 2018. 7. 30..
//  Copyright © 2018년 신형재. All rights reserved.
//

import UIKit

class WriterPostsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var writeInfoCateView: UIView!
    @IBOutlet weak var writeInfoFinImageView: UIImageView!
    @IBOutlet weak var writeInfoFinLabel: UILabel!
    
    @IBOutlet weak var writeInfoCateImageView: UIImageView!
    
  
    @IBOutlet weak var writeInfoContentView: UIView!
    
    @IBOutlet weak var exploreTitleLabel: UILabel!
    @IBOutlet weak var exploreTagsLabel: UILabel!
    @IBOutlet weak var exploreCategoryLabel: UILabel!
    //@IBOutlet weak var savedLikeImageView: UIImageView!
    @IBOutlet weak var writeInfoTimestampLabel: UILabel!
    
    
    
    var post: Post? {
        didSet {
            updateView()
        }
    }
    func updateView() {
        exploreTitleLabel.text = post?.title
        exploreCategoryLabel.text = post?.category
        exploreTagsLabel.text = post?.tags
        
        // [0808 Dahye]
        setTimestamp()

        
        // [0807 Dahye] Make corners of Views rounded
        writeInfoCateView.layer.cornerRadius = 10.0
        writeInfoContentView.layer.cornerRadius = 10.0
        writeInfoCateView.layer.borderWidth = 0.7
        writeInfoCateView.layer.borderColor = UIColor(red: 237.0/255.0, green: 238.0/255.0, blue: 239.0/255.0, alpha: 1.0).cgColor
        writeInfoContentView.layer.borderWidth = 1.0
        writeInfoContentView.layer.borderColor = UIColor(red: 237.0/255.0, green: 238.0/255.0, blue: 239.0/255.0, alpha: 1.0).cgColor
        
        
        
        // [0731 Dahye] for category image
        
        if post?.category == "학업" {
            if post?.wanted == false {
                writeInfoCateView?.backgroundColor = UIColor(red: 197/255.0, green: 197/255.0, blue: 197/255.0, alpha: 1)
               writeInfoFinImageView?.image = #imageLiteral(resourceName: "finicon")
                writeInfoFinLabel?.text = "마감"
                writeInfoCateImageView?.image = #imageLiteral(resourceName: "stulogo")
                exploreCategoryLabel?.textColor = UIColor.white
                
            } else {
                writeInfoCateView?.backgroundColor = UIColor(red: 202/255.0, green: 237/255.0, blue: 253/255.0, alpha: 1.0)
                writeInfoFinImageView?.image = nil
                writeInfoFinLabel?.text = nil
                writeInfoCateImageView?.image = #imageLiteral(resourceName: "catstulogo")
                exploreCategoryLabel?.textColor =  UIColor.darkGray
            }
        }
        if post?.category == "취업" {
            if post?.wanted == false {
                writeInfoCateView?.backgroundColor = UIColor(red: 197.0/255.0, green: 197/255.0, blue: 197/255.0, alpha: 1.0)
                writeInfoFinImageView?.image = #imageLiteral(resourceName: "finicon")
                writeInfoFinLabel?.text = "마감"
                writeInfoCateImageView?.image = #imageLiteral(resourceName: "finjoblogo")
                exploreCategoryLabel?.textColor = UIColor.white
                
            } else {
                writeInfoCateView?.backgroundColor = UIColor(red: 255/255.0, green: 219/255.0, blue: 217/255.0, alpha: 1.0)
                writeInfoFinImageView?.image = nil
                writeInfoFinLabel?.text = nil
                writeInfoCateImageView?.image = #imageLiteral(resourceName: "catjoblogo")
                exploreCategoryLabel?.textColor =  UIColor.darkGray
            }
        }
        if post?.category == "어학" {
            if post?.wanted == false {
                writeInfoCateView?.backgroundColor = UIColor(red: 197/255.0, green: 197/255.0, blue: 197/255.0, alpha: 1.0)
                writeInfoFinImageView?.image = #imageLiteral(resourceName: "finicon")
                writeInfoFinLabel?.text = "마감"
                writeInfoCateImageView?.image = #imageLiteral(resourceName: "finlanlogo")
                exploreCategoryLabel?.textColor = UIColor.white
            } else {
                writeInfoCateView?.backgroundColor = UIColor(red: 255/255.0, green: 237/255.0, blue: 165/255.0, alpha: 1.0)
                writeInfoFinImageView?.image = nil
                writeInfoFinLabel?.text = nil
                writeInfoCateImageView?.image = #imageLiteral(resourceName: "catlanlogo")
                exploreCategoryLabel?.textColor =  UIColor.darkGray
            }
        }
        if post?.category == "기타" {
            if post?.wanted == false {
                writeInfoCateView?.backgroundColor = UIColor(red: 197/255.0, green: 197/255.0, blue: 197/255.0, alpha: 1.0)
                writeInfoFinImageView?.image = #imageLiteral(resourceName: "finicon")
                writeInfoFinLabel?.text = "마감"
                writeInfoCateImageView?.image = #imageLiteral(resourceName: "fincatetc")
                exploreCategoryLabel?.textColor = UIColor.white
            } else {
                writeInfoCateView?.backgroundColor = UIColor(red: 202/255.0, green: 248/255.0, blue: 238/255.0, alpha: 1.0)
                writeInfoFinImageView?.image = nil
                writeInfoFinLabel?.text = nil
                writeInfoCateImageView?.image = #imageLiteral(resourceName: "catetc")
                exploreCategoryLabel?.textColor =  UIColor.darkGray
            }
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
            
            writeInfoTimestampLabel.text = postTimestampText
            
            
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
