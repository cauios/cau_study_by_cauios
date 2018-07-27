//
//  SavedViewController.swift
//  cau_study_ios
//
//  Created by 강호현 on 2018. 7. 27..
//  Copyright © 2018년 신형재. All rights reserved.
//

import UIKit

class SavedViewController: UIViewController {

    @IBOutlet var savedTableView: UITableView!
    var posts = [Post]()
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        savedTableView.dataSource = self
        loadPost()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadPost() {
        Api.Post.observePosts{
            (post) in
            //self.posts.append(post) Dahye: This shows the new post on the bottom
            self.posts.insert(post, at: 0) // Dahye: Show the new post on the top
            self.savedTableView.reloadData()
            
        }
        
        // Dahye: reload posts after deletion of post in profileView is operated
        Api.Post.REF_POSTS.observe(.childRemoved, with: {snap in
            let snapId = snap.key
            if let index = self.posts.index(where: {(item)-> Bool in item.id == snapId}) {
                self.posts.remove(at: index)
                self.savedTableView.reloadData()
            }
        })
    }
    func fetchUser(uid: String, completed: @escaping () -> Void ) {
        Api.User.observeUser(withId: uid, completion: {
            user in
            self.users = [user]
            completed()
        })
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SavedViewController: UITableViewDataSource {
    // [Dahye Comment] how many cells?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    // [Dahye Comment] What does the each cell look like?
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = savedTableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! SavedTableViewCell
        let post = posts[indexPath.row]
        cell.post = post
        return cell
        
        
    }
}




