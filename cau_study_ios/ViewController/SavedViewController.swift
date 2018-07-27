//
//  SavedViewController.swift
//  cau_study_ios
//
//  Created by 강호현 on 2018. 7. 27..
//  Copyright © 2018년 신형재. All rights reserved.
//

import UIKit
import FirebaseAuth


class SavedViewController: UIViewController {

    @IBOutlet var tableView: UITableView!


    var postId: String?
    var posts = [Post]()
    var user: User!
    var selectedCellId: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        fetchUser()
        fetchSaved()
    }
    
   
    
    func fetchUser() {
        Api.User.observeCurrentUser { (user) in
            self.user = user

            
        }
    }
    
    func fetchSaved() {
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
            //추가된 포스트 리로드
            Api.Saved.REF_SAVED.child(currentUser.uid).observe(.childAdded, with: {
                snapshot in
                Api.Post.observeMyPosts(withId: snapshot.key, completion: {
                    post in
                    self.posts.insert(post, at: 0)
                    self.tableView.reloadData()
                    print(post.id!)
                    
                })
                
                
            })
        
        //삭제된 포스트 리로드
            Api.Saved.REF_SAVED.child(currentUser.uid).observe(.childRemoved, with: {snap in
                let snapId = snap.key
                if let index = self.posts.index(where: {(item)-> Bool in item.id == snapId}) {
                    self.posts.remove(at: index)
                    self.tableView.reloadData()
                }
            })
            
        }
        
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PostViewController" {
            let cell = sender as? MyPostsTableViewCell
            let vc = segue.destination as! PostViewController
            vc.postId = self.selectedCellId
        }
    }
    
}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */





extension SavedViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedTableViewCell", for: indexPath) as! SavedTableViewCell
        let post = posts[indexPath.row]
        cell.post = post
        return cell
    }

//    //detail view
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = posts[indexPath.row]
        if let selectedCellId = selectedCell.id {
            self.selectedCellId = selectedCellId
            performSegue(withIdentifier: "PostViewController", sender: self)
        }
//
//
//
   }
    
}


