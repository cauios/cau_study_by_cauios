//
//  MyPostsTableViewCell.swift
//  cau_study_ios
//
//  Created by CAUAD19 on 2018. 7. 11..
//  Copyright © 2018년 신형재. All rights reserved.
//

import UIKit

class MyPostsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var exploreTitleLabel: UILabel!
    @IBOutlet weak var exploreTagsLabel: UILabel!
    @IBOutlet weak var exploreCategoryLabel: UILabel!
    @IBOutlet weak var exploreWanted: UILabel!
    
    var post: Post? {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        exploreTitleLabel.text = post?.title
        exploreCategoryLabel.text = post?.category
        exploreTagsLabel.text = post?.tags
        
        if (post?.wanted)! {
            exploreWanted.text = "모집중"
        } else {
            exploreWanted.text = "모집마감"
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
