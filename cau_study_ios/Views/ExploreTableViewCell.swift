//
//  ExploreTableViewCell.swift
//  cau_study_ios
//
//  Created by Davee on 2018. 3. 20..
//  Copyright © 2018년 신형재. All rights reserved.
//

import UIKit

class ExploreTableViewCell: UITableViewCell {

    @IBOutlet weak var exploreTitleLabel: UILabel!
    @IBOutlet weak var exploreObjectivesLabel: UILabel!
    @IBOutlet weak var exploreCategoryLabel: UILabel!
    
    
    // [Dahye Comment] didSet is an obsever. We can group all methods that require this post instance as an input in this observer.
    var post: Post? {
        didSet {
            updateView()
        }
    }
    
    
    // [Dahye Comment] Fetch newly posting data from FB
    func updateView() {
        exploreTitleLabel.text = post?.title
        exploreCategoryLabel.text = post?.category
        exploreObjectivesLabel.text = post?.objectives
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
