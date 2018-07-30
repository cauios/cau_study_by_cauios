//
//  PeopleViewTableViewCell.swift
//  cau_study_ios
//
//  Created by 신형재 on 30/07/2018.
//  Copyright © 2018 신형재. All rights reserved.
//

import UIKit

class PeopleViewTableViewCell: UITableViewCell {

    var imageview :UIImageView! = UIImageView()
    var label :UILabel! = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(imageview)
        self.addSubview(label)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
