//
//  DetailViewController.swift
//  cau_study_ios
//
//  Created by Davee on 2018. 4. 22..
//  Copyright © 2018년 신형재. All rights reserved.
//

import UIKit
import FirebaseDatabase

class DetailViewController: UIViewController {
    

    @IBOutlet weak var detailTableView: UITableView!
    

    
    
    var postId = ""
    var post = Post()
    var user = User()

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
                self.post = post
                self.detailTableView.reloadData()
            })
        }
    }
    
    func fetchUser(uid: String, completed: @escaping() -> Void) {
        Api.User.observeUser(withId: uid, completion: {
            user in
            self.user = user
            completed()})
    }
    
}

extension DetailViewController: UITableViewDataSource {
    // [Dahye's Comment] Specifiy the number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    // [Dahye's Comment] Customize the rows for showing the post data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = detailTableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! ExploreTableViewCell
        cell.post = post
        return cell
    }
    
}
