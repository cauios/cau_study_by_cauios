//
//  DetailTableViewCell.swift
//  cau_study_ios
//
//  Created by Davee on 2018. 4. 23..
//  Copyright © 2018년 신형재. All rights reserved.
//

import UIKit


class DetailTableViewCell: UITableViewCell {

 
    @IBOutlet weak var detailTitleLabel: UILabel!
    @IBOutlet weak var detailCategoryLabel: UILabel!
    @IBOutlet weak var detailTagsLabel: UILabel!
    @IBOutlet weak var detailNumOfVacanLabel: UILabel!
    @IBOutlet weak var detailLocationLabel: UILabel!
    @IBOutlet weak var detailTimeLabel: UILabel!
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    
    
    var post: Post? {
        didSet {
            updateView()
        }
    }
    func updateView() {
        detailTitleLabel.text = post?.title
        detailCategoryLabel.text = post?.category
        detailTagsLabel.text = post?.tags
        detailNumOfVacanLabel.text = post?.numOfVacan
        detailLocationLabel.text = post?.location
        detailTimeLabel.text = post?.time
        detailDescriptionLabel.text = post?.description
    
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