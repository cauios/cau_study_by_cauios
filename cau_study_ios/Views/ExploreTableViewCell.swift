//
//  ExploreTableViewCell.swift
//  cau_study_ios
//
//  Created by Davee on 2018. 3. 20..
//  Copyright © 2018년 신형재. All rights reserved.
//

import UIKit

class ExploreTableViewCell: UITableViewCell {

    @IBOutlet weak var exploreImageView: UIImageView!
    @IBOutlet weak var exploreTitleLabel: UILabel!
    @IBOutlet weak var exploreObjectivesLabel: UILabel!
    @IBOutlet weak var exploreCategoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
