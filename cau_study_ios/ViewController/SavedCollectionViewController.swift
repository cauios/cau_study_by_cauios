//
//  Saved2ViewController.swift
//  cau_study_ios
//
//  Created by 강호현 on 2018. 7. 31..
//  Copyright © 2018년 신형재. All rights reserved.
//

import UIKit
import FirebaseAuth


class SavedCollectionViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var postId: String?
    var posts = [Post]()
    var user: User!
    var selectedCellId: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let logo = UIImage(named: "logo.png")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView

        
        collectionView.delegate = self
        collectionView.dataSource = self
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
                self.collectionView.reloadData()
            })
            
            
        })
        
        //삭제된 포스트 리로드
        Api.Saved.REF_SAVED.child(currentUser.uid).observe(.childRemoved, with: {snap in
            let snapId = snap.key
            if let index = self.posts.index(where: {(item)-> Bool in item.id == snapId}) {
                self.posts.remove(at: index)
                self.collectionView.reloadData()
                
            }
            
        }
        )
        
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



extension SavedCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostViewController", for: n)
        let post = posts[indexPath.row]
        cell.post = post
        return cell
    }
    
    //    //detail view
    func collectionView(_ collectionView: UICollectionView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = posts[indexPath.row]
        if let selectedCellId = selectedCell.id {
            self.selectedCellId = selectedCellId
            performSegue(withIdentifier: "PostViewController", sender: self)
        }
        //
    }
    
}

