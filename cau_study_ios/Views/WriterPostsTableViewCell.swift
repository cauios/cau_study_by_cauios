//
//  WriterPostsTableViewCell.swift
//  cau_study_ios
//
//  Created by CAUAD30 on 2018. 7. 30..
//  Copyright © 2018년 신형재. All rights reserved.
//

import UIKit

class WriterPostsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var exploreTitleLabel: UILabel!
    @IBOutlet weak var exploreTagsLabel: UILabel!
    @IBOutlet weak var exploreCategoryLabel: UILabel!
    //@IBOutlet weak var savedLikeImageView: UIImageView!
    
    
    
    var post: Post? {
        didSet {
            updateView()
        }
    }
    func updateView() {
        exploreTitleLabel.text = post?.title
        exploreCategoryLabel.text = post?.category
        exploreTagsLabel.text = post?.tags
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
