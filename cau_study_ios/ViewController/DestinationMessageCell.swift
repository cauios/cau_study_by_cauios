//
//  DestinationMessageCell.swift
//  cau_study_ios
//
//  Created by 신형재 on 14/07/2018.
//  Copyright © 2018 신형재. All rights reserved.
//

import UIKit

class DestinationMessageCell: UITableViewCell {

    
    @IBOutlet weak var label_message: UIImageView!
    @IBOutlet weak var imageview_profile: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
