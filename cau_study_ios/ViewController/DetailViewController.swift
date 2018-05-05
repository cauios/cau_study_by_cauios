//
//  DetailViewController.swift
//  cau_study_ios
//
//  Created by Davee on 2018. 4. 22..
//  Copyright © 2018년 신형재. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet var postDetailView: UIView!
    
    //ㅅㅈ
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var numOfVacanLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    //ㅅㅈ
    
    var postId = ""
    var posts = Post()
    var users = User()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadPost()
        //ㅅㅈ
        titleLabel.text = posts.title
        idLabel.text = posts.id
        dateLabel.text = " "
        categoryLabel.text = posts.category
        tagsLabel.text = posts.tags
        numOfVacanLabel.text = posts.numOfVacan
        durationLabel.text = posts.duration
        locationLabel.text = posts.location
        descriptionLabel.text = posts.description
        //ㅅㅈ
    }
    // [Dahye's comment] 나중에 id로 한 거 uid로 바꿔야 함. Lec 71 - 1:39 참고
    func loadPost() {
        Api.Post.observePost(withId: postId) {
            (post) in
            guard let postId = post.id else {
                return
            }
            self.fetchUser(uid: postId, completed: {
                self.posts = post
            })
        }
    }
    
    func fetchUser(uid: String, completed: @escaping() -> Void) {
        Api.User.observeUser(withId: uid, completion: {
            user in
            self.users = user
            completed()})
    }
    
}
