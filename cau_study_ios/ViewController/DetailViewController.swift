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
    var post = Post()
    var user = User()

    @IBOutlet weak var detailTableView: UITableView!
    
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
            // 08/05 Dahye's way from Lec71
             (post) in guard let postUid = post.uid else {
                return
            }
            self.fetchUser(uid: postUid, completed: {
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "DetailTableViewCell"
        let cell = detailTableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! DetailTableViewCell
        cell.post = post
        return cell
    }
    
}
