//
//  DetailViewController.swift
//  cau_study_ios
//
//  Created by Davee on 2018. 4. 22..
//  Copyright © 2018년 신형재. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    

    var postId = ""
    var posts = Post()
    var users = User()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("postId: \(postId)")
        loadPost()
        //ㅅㅈ
/*        titleLabel.text = posts.title
        idLabel.text = posts.id
        dateLabel.text = " "
        categoryLabel.text = posts.category
        tagsLabel.text = posts.tags
        numOfVacanLabel.text = posts.numOfVacan
        timeLabel.text = posts.time
        locationLabel.text = posts.location
        descriptionLabel.text = posts.description*/
        //ㅅㅈ
    }
    // [Dahye's comment] 나중에 id로 한 거 uid로 바꿔야 함. Lec 71 - 1:39 참고
    func loadPost() {
        Api.Post.observePost(withId: postId) {
            (post) in
            guard let postId = post.id else {
                return
            }

    }
    

    
    func fetchUser(uid: String, completed: @escaping() -> Void) {
        Api.User.observeUser(withId: uid, completion: {
            user in
            self.users = user
            completed()})
    }
    
}
}
