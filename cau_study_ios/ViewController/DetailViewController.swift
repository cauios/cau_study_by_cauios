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
    
    
    var postId = ""
    var posts = Post()
    var users = User()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadPost()
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
