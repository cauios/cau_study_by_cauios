//
//  DetailTableViewCell.swift
//  cau_study_ios
//
//  Created by Davee on 2018. 5. 8..
//  Copyright © 2018년 신형재. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var numOfVacanLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
 
    // 08/05 Dahye implementation
    // [Dahye 05.20] We must set didSet observer to conveniently update a cell, when there is an updated data.
    
    var post: Post? {
        didSet {
            updateView()
        }
    }
    
    
    // [Dahye 5.20] This will be called when the cell receives data.
    func updateView() {
        titleLabel.text = post?.title
        idLabel.text = post?.id
        dateLabel.text = " " // [dahye's comment] this should be modified in the future
        categoryLabel.text = post?.category
        tagsLabel.text = post?.tags
        numOfVacanLabel.text = post?.numOfVacan
        timeLabel.text = post?.time
        locationLabel.text = post?.location
        descriptionLabel.text = post?.description
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
