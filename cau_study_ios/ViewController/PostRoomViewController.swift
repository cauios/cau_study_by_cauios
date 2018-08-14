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
    var post: Post?
    
    
    
    
    override func viewDidLoad() {
        collectionView.delegate = self
        collectionView.dataSource = self
        switch data {
        case "lanBtn":
            loadLanPost()
            self.title = "어학"
        case "stuBtn":
            loadAcaPost()
            self.title = "학업"
        case "jobBtn":
            loadEmpPost()
            self.title = "취업"
        case "finBtn":
            loadFinPost()
            self.title = "마감"
        default:
            break
        }
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.removeRedDotAtTabBarItemIndex(index: 2)
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


    func loadFinPost() {
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        //추가된 포스트 리로드
        Api.Saved.REF_SAVED.child(currentUser.uid).observe(.childAdded, with: {
            snapshot in
            Api.Post.observePost(withId: snapshot.key, completion: {
                post in
                if post.wanted == false{
                self.posts.insert(post, at: 0)
                self.collectionView.reloadData()
                }
            })
            
            
        })
        //삭제된 포스트 리로드

        Api.Saved.REF_SAVED.child(currentUser.uid).observe(.childRemoved, with: {snap in
            let snapId = snap.key
            if let index = self.posts.index(where: {(item)-> Bool in item.id == snapId}) {
                if self.post?.wanted == false{
                self.posts.remove(at: index)
                self.collectionView.reloadData()
                }
            }
            
        })
        
    }

    
    func loadAcaPost() {
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        //추가된 포스트 리로드
        Api.Saved.REF_SAVED.child(currentUser.uid).observe(.childAdded, with: {
            snapshot in
            Api.Post.observePost(withId: snapshot.key, completion: {
                post in
                if post.wanted == true{
                    if post.category == "학업"{
                    self.posts.insert(post, at: 0)
                    self.collectionView.reloadData()
                    }
                }
            })
            
            
        })
        //삭제된 포스트 리로드
        
        Api.Saved.REF_SAVED.child(currentUser.uid).observe(.childRemoved, with: {snap in
            let snapId = snap.key
            if let index = self.posts.index(where: {(item)-> Bool in item.id == snapId}) {
                if self.post?.wanted == true{
                    if self.post?.category == "학업"{                    self.posts.remove(at: index)
                    self.collectionView.reloadData()
                }
                }
            }
            
        })
           
    }
    //
    
    //[0728 Dahye] load Employment Preperation Posts
    func loadEmpPost() {
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        //추가된 포스트 리로드
        Api.Saved.REF_SAVED.child(currentUser.uid).observe(.childAdded, with: {
            snapshot in
            Api.Post.observePost(withId: snapshot.key, completion: {
                post in
                if post.wanted == true{
                    if post.category == "취업"{
                        self.posts.insert(post, at: 0)
                        self.collectionView.reloadData()
                    }
                }
            })
            
            
        })
        //삭제된 포스트 리로드
        
        Api.Saved.REF_SAVED.child(currentUser.uid).observe(.childRemoved, with: {snap in
            let snapId = snap.key
            if let index = self.posts.index(where: {(item)-> Bool in item.id == snapId}) {
                if self.post?.wanted == true{
                    if self.post?.category == "취업"{                    self.posts.remove(at: index)
                        self.collectionView.reloadData()
                    }
                }
            }
            
        })
    }
    
    //[0728 Dahye] load Language Posts
    func loadLanPost() {
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        //추가된 포스트 리로드
        Api.Saved.REF_SAVED.child(currentUser.uid).observe(.childAdded, with: {
            snapshot in
            Api.Post.observePost(withId: snapshot.key, completion: {
                post in
                if post.wanted == true{
                    if post.category == "어학"{
                        self.posts.insert(post, at: 0)
                        self.collectionView.reloadData()
                    }
                }
            })
            
            
        })
        //삭제된 포스트 리로드
        
        Api.Saved.REF_SAVED.child(currentUser.uid).observe(.childRemoved, with: {snap in
            let snapId = snap.key
            if let index = self.posts.index(where: {(item)-> Bool in item.id == snapId}) {
                if self.post?.wanted == true{
                    if self.post?.category == "어학"{                    self.posts.remove(at: index)
                        self.collectionView.reloadData()
                    }
                }
            }
            
        })
    }
    

    
    func removeRedDotAtTabBarItemIndex(index: Int) {
        for subview in tabBarController!.tabBar.subviews {
            
            if let subview = subview as? UIView {
                
                if subview.tag == 1234 {
                    subview.removeFromSuperview()
                    break
                }
            }
        }
        
        let RedDotRadius: CGFloat = 5
        let RedDotDiameter = RedDotRadius * 1.5
        
        let TopMargin:CGFloat = 1
        
        let TabBarItemCount = CGFloat(self.tabBarController!.tabBar.items!.count)
        
        let screenSize = UIScreen.main.bounds
        let HalfItemWidth = (screenSize.width) / (TabBarItemCount * 2)
        
        let  xOffset = HalfItemWidth * CGFloat(index * 2 + 1)
        
        let imageHalfWidth: CGFloat = (self.tabBarController!.tabBar.items![index] ).selectedImage!.size.width / 2
        
        let redDot = UIView(frame: CGRect(x: xOffset + imageHalfWidth - 1, y: TopMargin, width: RedDotDiameter, height: RedDotDiameter))
        
        redDot.tag = 1234
        redDot.backgroundColor = UIColor.red
        redDot.layer.cornerRadius = RedDotRadius
        
        self.tabBarController?.tabBar.willRemoveSubview(redDot)
        
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
