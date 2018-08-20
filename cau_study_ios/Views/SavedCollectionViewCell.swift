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

    @IBOutlet weak var finimage: UIImageView!
    @IBOutlet weak var finLabel: UILabel!
    
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
                finimage.image = nil
                finLabel.text = nil
            case "학업":
                saveCategory.image = UIImage(named: "colstu")
                finimage.image = nil
                finLabel.text = nil
            case "취업":
                saveCategory.image = UIImage(named: "coljob")
                finimage.image = nil
                finLabel.text = nil
            default:
                saveCategory.image = UIImage(named: "coletc")
                finimage.image = nil
                finLabel.text = nil
            }
        } else {
            switch post?.category {
            case "어학":
                saveCategory.image = UIImage(named: "fincollan")
                finimage.image = #imageLiteral(resourceName: "finicon")
                finLabel.text = "마감"
            case "학업":
                saveCategory.image = UIImage(named: "fincolstu")
                finimage.image = #imageLiteral(resourceName: "finicon")
                finLabel.text = "마감"
            case "취업":
                saveCategory.image = UIImage(named: "fincoljob")
                finimage.image = #imageLiteral(resourceName: "finicon")
                finLabel.text = "마감"
            default:
                saveCategory.image = UIImage(named: "fincoletc")
                finimage.image = #imageLiteral(resourceName: "finicon")
                finLabel.text = "마감"
                
            }
        }


        }
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        // Initialization code
    }
    
   
}
