//
//  PostRoomViewController.swift
//  cau_study_ios
//
//  Created by 강호현 on 2018. 8. 3..
//  Copyright © 2018년 신형재. All rights reserved.
//

import UIKit
import FirebaseAuth


    
class PostRoomViewController: UIViewController {

    

    @IBOutlet weak var collectionView: UICollectionView!
    
    var data = ""
    var postId: String?
    var posts = [Post]()
    var user: User!
    var selectedCellId: String?
    var saved = [SavedApi]()

    
    
    
    
    override func viewDidLoad() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
        switch data {
        case "lanBtn":
            loadLanPost()
        case "stuBtn":
            loadAcaPost()
        case "jobBtn":
            loadEmpPost()
        case "finBtn":
            loadFinPost() //모집마감은 어떻게 처리할지 고민!!
        default:
            break
        }
        super.viewDidLoad()
        
    }
    
    
    
    
    
    func fetchUser() {
        Api.User.observeCurrentUser { (user) in
            self.user = user
            
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PostViewController" {
            let vc = segue.destination as! PostViewController
            vc.postId = self.selectedCellId
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
        
    }
    
    func loadAcaPost() {
        Api.Category.REF_CATEGORY_ACADEMIC.observe(.childAdded, with: {
            snapshot in
            Api.Post.observePost(withId: snapshot.key, completion: { post in
                
                self.posts.insert(post, at: 0)
                self.collectionView.reloadData()
            })
        })
        
    }
    //
    
    //[0728 Dahye] load Employment Preperation Posts
    func loadEmpPost() {
        Api.Category.REF_CATEGORY_EMPLPREP.observe(.childAdded, with: {
            snapshot in
            Api.Post.observePost(withId: snapshot.key, completion: { post in
                
                self.posts.insert(post, at: 0)
                self.collectionView.reloadData()

            })
        })
    }
    
    //[0728 Dahye] load Language Posts
    func loadLanPost() {
        Api.Category.REF_CATEGORY_LANGUAGE.observe(.childAdded, with: {
            snapshot in
            Api.Post.observePost(withId: snapshot.key, completion: { post in
                self.posts.insert(post, at: 0)
                self.collectionView.reloadData()

            })
        })
    }
    
    func loadFinPost() {
        Api.Post.REF_POSTS.child("wanted").observe(.childAdded, with: {
            snapshot in
            Api.Post.observePost(withId: snapshot.key, completion: { post in
                self.posts.insert(post, at: 0)
                self.collectionView.reloadData()

            })
        })
        
    }
}




extension PostRoomViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return posts.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCollectionViewCell", for: indexPath) as! PostCollectionViewCell
        let post = posts[indexPath.row]
        cell.post = post
        return cell
    }
    
    
    
    //    //detail view
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell = posts[indexPath.row]
        if let selectedCellId = selectedCell.id {
            self.selectedCellId = selectedCellId
            performSegue(withIdentifier: "PostViewController", sender: self)
        }
    }
    
}

extension PostRoomViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 3 - 1, height: collectionView.frame.size.width / 3 - 1)
    }
    
}
