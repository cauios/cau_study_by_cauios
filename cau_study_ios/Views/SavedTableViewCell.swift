//
//  SavedTableViewCell.swift
//  cau_study_ios
//
//  Created by 강호현 on 2018. 7. 9..
//  Copyright © 2018년 신형재. All rights reserved.
//

import UIKit
import FirebaseAuth


class SavedTableViewCell: UITableViewCell {

    @IBOutlet weak var saveTitle: UILabel!
    @IBOutlet weak var saveTags: UILabel!
    @IBOutlet weak var saveCategory: UILabel!
    
    
    var post: Post? {
        didSet {
            updateView()
        }
    }
    
        
    func updateView() {
        saveTitle.text = post?.title
        saveCategory.text = post?.category
        saveTags.text = post?.tags
    
    
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

