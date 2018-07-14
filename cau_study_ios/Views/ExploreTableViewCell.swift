//
//  ExploreTableViewCell.swift
//  cau_study_ios
//
//  Created by Davee on 2018. 3. 20..
//  Copyright © 2018년 신형재. All rights reserved.
//

import UIKit

protocol ExploreTableViewCellDelegate {
    func goToDetailVC(postId: String)
}

class ExploreTableViewCell: UITableViewCell {

    @IBOutlet weak var exploreTitleLabel: UILabel!
    @IBOutlet weak var exploreTagsLabel: UILabel!
    @IBOutlet weak var exploreCategoryLabel: UILabel!
    
    
    var delegate: ExploreTableViewCellDelegate?
    
    // [Dahye Comment] didSet is an obsever. We can group all methods that require this post instance as an input in this observer.
    // [Dahye 05.20] We must set didSet observer to conveniently update a cell, when there is an updated data.
    var post: Post? {
        didSet {
            updateView()
        }
    }
    
    
    // [Dahye Comment] Fetch newly posting data from FB
    func updateView() {
        exploreTitleLabel.text = post?.title
        exploreCategoryLabel.text = post?.category
        exploreTagsLabel.text = post?.tags
        
        let tapGestureForExploreTitleLabel = UITapGestureRecognizer(target: self, action: #selector(self.exploreTitleLabel_TouchUpInside))
        
        exploreTitleLabel.addGestureRecognizer(tapGestureForExploreTitleLabel)
        exploreTitleLabel.isUserInteractionEnabled = true
    }
    
    @objc func exploreTitleLabel_TouchUpInside(){
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
