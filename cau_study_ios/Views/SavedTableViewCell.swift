//
//  SavedTableViewCell.swift
//  cau_study_ios
//
//  Created by 강호현 on 2018. 7. 9..
//  Copyright © 2018년 신형재. All rights reserved.
//

import UIKit

protocol SavedTableViewCellDelegate {
    func goToDetailVC(postId: String)
}

class SavedTableViewCell: UITableViewCell {

    @IBOutlet weak var saveTitle: UILabel!
    @IBOutlet weak var saveTags: UILabel!
    @IBOutlet weak var saveCategory: UILabel!
    
    var delegate: SavedTableViewCellDelegate?

    
    // [Dahye Comment] didSet is an obsever. We can group all methods that require this post instance as an input in this observer.
    var post: Post? {
        didSet {
            updateView()
        }
    }
    
    
    // [Dahye Comment] Fetch newly posting data from FB
    func updateView() {
        saveTitle.text = post?.title
        saveCategory.text = post?.category
        saveTags.text = post?.tags
        
        let tapGestureForExploreTitleLabel = UITapGestureRecognizer(target: self, action: #selector(self.saveTitleLabel_TouchUpInside))
        
        saveTitle.addGestureRecognizer(tapGestureForExploreTitleLabel)
        saveTitle.isUserInteractionEnabled = true
    }
    
    @objc func saveTitleLabel_TouchUpInside(){
        if let id = post?.id {
            delegate?.goToDetailVC(postId: id)
        }
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
