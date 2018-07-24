//
//  PostViewController.swift
//  cau_study_ios
//
//  Created by Dahye on 2018. 7. 23..
//  Copyright © 2018년 신형재. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {
    
    @IBOutlet weak var postView: UIView!
    
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var postUidLabel: UILabel!
    @IBOutlet weak var postDateLabel: UILabel!
    @IBOutlet weak var postCategoryLabel: UILabel!
    @IBOutlet weak var postTagsLabel: UILabel!
    @IBOutlet weak var postNumOfVacanLabel: UILabel!
    @IBOutlet weak var postTimeLabel: UILabel!
    @IBOutlet weak var postLocationLabel: UILabel!
    @IBOutlet weak var postDescriptionLabel: UILabel!
    
    
    var postId: String?
    var post: Post? {
        didSet {
            updateView()
        }
    }
    
    override func viewDidLoad() {
        loadPost()

        // Do any additional setup after loading the view.
    }

    
    func updateView() {
        postTitleLabel.text = post?.title
        postUidLabel.text = post?.id
        postDateLabel.text = " " // [dahye's comment] this should be modified in the future
        postCategoryLabel.text = post?.category
        postTagsLabel.text = post?.tags
        postNumOfVacanLabel.text = post?.numOfVacan
        postTimeLabel.text = post?.time
        postLocationLabel.text = post?.location
        postDescriptionLabel.text = post?.description
    }
    
    func loadPost() {
        Api.Post.observePost(withId: postId!, completion: {post in
            self.post = post
        })
    }
  

}
