//
//  DetailViewController.swift
//  cau_study_ios
//
//  Created by Davee on 2018. 4. 22..
//  Copyright © 2018년 신형재. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class DetailViewController: UIViewController {
    

   // var postId: String! // [Dahye 05.20] it will be set to the corresponding postId, after the segue transition.
    var postId = ""
    var post = Post()
    var user = User()

    @IBOutlet weak var detailTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("postId: \(postId)")
        // [Dahye 05.20] set the datasource of the detailTableView to the DetailViewController(right here). So let it feed the data from the protocal to the DetailViewController implemented.
        detailTableView.dataSource = self
        // [Dahye 05.20] let cells to know how to update itself, given the data they are fed.
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
    /* [Dahye 05.20] commented out to try another way.
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

    }*/
    
    func loadPost() {
        // [Dahye 0723]
        Api.Post.observePost(withId: postId) { (post) in
            guard let postUid = post.uid else {
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
            completed()
        })
    }
    
}

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = detailTableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as! DetailTableViewCell
        cell.post = post

        // cell.user = user [Dahye 05.20] in the future, we should add user info in the DetailTableViewCell as well!
        return cell
    }
    
}
