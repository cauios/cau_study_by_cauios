//
//  PostViewController.swift
//  cau_study_ios
//
//  Created by Dahye on 2018. 7. 23..
//  Copyright © 2018년 신형재. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {
    
    // postScrollView factors
    @IBOutlet weak var postScrollView: UIScrollView!
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var postUidLabel: UILabel!
    @IBOutlet weak var postDateLabel: UILabel!
    @IBOutlet weak var postCategoryLabel: UILabel!
    @IBOutlet weak var postTagsLabel: UILabel!
    @IBOutlet weak var postNumOfVacanLabel: UILabel!
    @IBOutlet weak var postTimeLabel: UILabel!
    @IBOutlet weak var postLocationLabel: UILabel!
    @IBOutlet weak var postDescriptionLabel: UILabel!
    
    // buttom toolbar factors
    @IBOutlet weak var postViewToolBar: UIToolbar!
    @IBOutlet weak var sendAMessageButton: UIBarButtonItem!
    
    
    var postId: String?
    
    //[Dahye 0725]
    var user: User!
    var userId = ""
    //
    
    var post: Post? {
        didSet {
            updateView()
        }
    }
    
    override func viewDidLoad() {

        loadPost()

        // Dahye: Customize the bottom toolbar button
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        postViewToolBar.setItems([flexibleSpace, sendAMessageButton, flexibleSpace], animated: true)
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
        setPostDescriptionLabelSize()
    }
    
    func loadPost() {
        Api.Post.observePost(withId: postId!, completion: {post in
            self.post = post
        })
    }
    // [Dahye 0725] This should be implemented in cooperation with Minjung
    // See the lecture 71
   /*
    func fetchUser() {
        Api.User.ob
    }
 */
    
    // Dahye: Make the description label dynamically resizing
    func setPostDescriptionLabelSize() {
        postScrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: postDescriptionLabel.bottomAnchor).isActive = true
    }
  

}
