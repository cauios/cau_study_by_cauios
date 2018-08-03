//
//  SavedCollectionViewCell.swift
//  cau_study_ios
//
//  Created by 강호현 on 2018. 7. 31..
//  Copyright © 2018년 신형재. All rights reserved.
//

import UIKit
import FirebaseAuth
import SDWebImage

class SavedCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var saveTitle: UILabel!
    @IBOutlet weak var saveTags: UILabel!
    @IBOutlet weak var saveCategory: UIImageView!

    var post: Post? {
        didSet {
            updateView()
        }
    }
    
    var delegate: ExploreTableViewCellDelegate?
    
    func updateView() {
        saveTitle.text = post?.title
        saveTags.text = post?.tags
        
        if post?.wanted == true {
            switch post?.category {
            case "어학":
                saveCategory.image = UIImage(named: "collan")
            case "학업":
                saveCategory.image = UIImage(named: "colstu")
            default:
                saveCategory.image = UIImage(named: "coljob")
            }
        } else {
            switch post?.category {
            case "어학":
                saveCategory.image = UIImage(named: "fincollan")
            case "학업":
                saveCategory.image = UIImage(named: "fincolstu")
            default:
                saveCategory.image = UIImage(named: "fincoljob")
            }
        }


        }
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        // Initialization code
    }
    
   
}
