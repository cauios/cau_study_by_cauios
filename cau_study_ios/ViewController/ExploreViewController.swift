//
//  ExploreViewController.swift
//  cau_study_ios
//
//  Created by Davee on 2018. 3. 13..
//  Copyright © 2018년 신형재. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SDWebImage


class ExploreViewController: UIViewController {

 
    @IBAction func writeTouchUpInside(_ sender: Any) {
       
    }
    
    //

    @IBOutlet weak var exploreTableView: UITableView!
    var posts = [Post]()
    var users = [User]()
    // [0728 Dahye] Declare array for each category
    var acaPosts = [Post]()
    var empPosts = [Post]()
    var lanPosts = [Post]()
    //
    

    var post: Post?
    
    var selectedSeg: Int?


    
    // [0729 Dahye] Outlets for buttons

    @IBOutlet weak var allCateButton: UIButton!
    @IBOutlet weak var acaCateButton: UIButton!
    @IBOutlet weak var empCateButton: UIButton!
    @IBOutlet weak var lanCateButton: UIButton!
    
     // [0729 Dahye] Actions for buttons
    @IBAction func allCateTouchUpInside(_ sender: Any) {
//        posts = [Post]()
//        selectedSeg = 1
//        Api.Post.observePosts{
//            (post) in
//            //self.posts.append(post) Dahye: This shows the new post on the bottom
//            self.posts.insert(post, at: 0) // Dahye: Show the new post on the top
//            self.exploreTableView.reloadData()
//
//        }
        selectedSeg = 1
        Api.Post.REF_POSTS.observe(.childAdded, with: {
            snapshot in
            Api.Post.observePost(withId: snapshot.key, completion: { post in
                self.posts.insert(post, at: 0)
                self.exploreTableView.reloadData()
            })
            
        })
            self.exploreTableView.reloadData()

    }
    @IBAction func acaCateTouchUpInside(_ sender: Any) {
//        posts = [Post]()
        selectedSeg = 2
        loadAcaPost()
        self.exploreTableView.reloadData()
        
    }
    
    @IBAction func empCateTouchUpInside(_ sender: Any) {
        posts = [Post]()
        selectedSeg = 3
        loadEmpPost()
//        Api.Category.REF_CATEGORY_EMPLPREP.observe(.childAdded, with: {
//            snapshot in
//            print(snapshot.key)
//            Api.Post.observePost(withId: snapshot.key, completion: { post in
//
//                self.posts.insert(post, at: 0)
//                self.exploreTableView.reloadData()
//            })
//        })
        self.exploreTableView.reloadData()
    }
    @IBAction func lanCateTouchUpInside(_ sender: Any) {
        posts = [Post]()
        selectedSeg = 4
        loadLanPost()
//        Api.Category.REF_CATEGORY_LANGUAGE.observe(.childAdded, with: {
//            snapshot in
//            print(snapshot.key)
//            Api.Post.observePost(withId: snapshot.key, completion: { post in
//
//                self.posts.insert(post, at: 0)
//                self.exploreTableView.reloadData()
//            })
//        })
        self.exploreTableView.reloadData()
}

    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedSeg = 1
        addNavBarImage()
        exploreTableView.dataSource = self

        loadPost()
        self.exploreTableView.reloadData()

//        if selectedSeg == 1 {
//            loadPost()
//            self.exploreTableView.reloadData()
//        }
//        if selectedSeg == 2 {
//            loadAcaPost()
//            self.exploreTableView.reloadData()
//        }
//        if selectedSeg == 3 {
//            self.exploreTableView.reloadData()
//        } else {
//            loadLanPost()
//            self.exploreTableView.reloadData()
//        }

    }
    
    func loadPost() {
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        Api.Post.observePosts{
            (post) in
            //self.posts.append(post) Dahye: This shows the new post on the bottom
            self.posts.insert(post, at: 0) // Dahye: Show the new post on the top
            self.exploreTableView.reloadData()
            
        }
        
        // Dahye: reload posts after deletion of post in profileView is operated
        Api.Post.REF_POSTS.observe(.childRemoved, with: {snap in
            let snapId = snap.key
            if let index = self.posts.index(where: {(item)-> Bool in item.id == snapId}) {
                self.posts.remove(at: index)
                self.exploreTableView.reloadData()
        }
        })
        
      // saved에서 하트를 두번 눌러서 제거되면 saved api에서 확인해서 바로 explore 하트에도 이를 반영한다.
        Api.Saved.REF_SAVED.child(currentUser.uid).observe(.childRemoved, with: {snap in
            self.exploreTableView.reloadData()
    
        })
        
        Api.Saved.REF_SAVED.child(currentUser.uid).observe(.childAdded, with: {snap in
            self.exploreTableView.reloadData()
            
        })
     
    }

    //[0728 Dahye] load Academic Posts
    func loadAcaPost() {
        Api.Category.REF_CATEGORY_ACADEMIC.observe(.childAdded, with: {
            snapshot in
            print(snapshot.key)
            Api.Post.observePost(withId: snapshot.key, completion: { post in
                
                self.posts.insert(post, at: 0)
                self.exploreTableView.reloadData()
            })
        })

}
    //
    
    //[0728 Dahye] load Employment Preperation Posts
    func loadEmpPost() {
        Api.Category.REF_CATEGORY_EMPLPREP.observe(.childAdded, with: {
            snapshot in
            print(snapshot.key)
            Api.Post.observePost(withId: snapshot.key, completion: { post in
                
                self.posts.insert(post, at: 0)
                self.exploreTableView.reloadData()
            })
        })
    }

 //[0728 Dahye] load Language Posts
    func loadLanPost() {

        Api.Category.REF_CATEGORY_LANGUAGE.observe(.childAdded, with: {
            snapshot in
            print(snapshot.key)
            Api.Post.observePost(withId: snapshot.key, completion: { post in
                
                self.posts.insert(post, at: 0)
                self.exploreTableView.reloadData()
            })
        })
    }


    
    
    func fetchUser(uid: String, completed: @escaping() -> Void) {
        Api.User.observeUser(withId: uid, completion: {
            user in
            //self.users.append(user)
            self.users.insert(user, at: 0)
            completed()})
    }
    
    // [Dahye 5.20] prepare method will be called right before the transition which is a perfect place to send the data on the destination view controller. prepare method should be implemented in the file where the performSegue is implemented. We should note that the data passed along is a string Id. So we need to convert the sender parameter of type any into string.
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Open_PostSegue" {
            let postVC = segue.destination as! PostViewController
            let postId = sender as! String
            postVC.postId = postId
        }
        if segue.identifier == "Open_WritingSegue" {
            let writingVC = segue.destination as! WritingViewController
            writingVC.delegate = self
        }
    }
                      
    
    // [Dahye Comment] This is to create an image title of a Navigation Bar.
    
    func addNavBarImage() {
        let navController = navigationController!
        
        let image = #imageLiteral(resourceName: "logo")
        let imageView = UIImageView(image: image)
        
        let bannerWidth = navController.navigationBar.frame.size.width / 2
        let bannerHeight = navController.navigationBar.frame.size.height / 2
        
        let bannerX = bannerWidth / 2 - image.size.width / 2
        let bannerY = bannerHeight / 2 - image.size.height / 2
        
        imageView.frame = CGRect(x: bannerX, y: bannerY, width: bannerWidth, height: bannerHeight)
        imageView.contentMode = .scaleAspectFit

        navigationItem.titleView = imageView
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}




// [Dahye Comment] With extension, we let the exploreViewController promise to implement a few methods in the UItableViewDataSource. This protocol declares some methods that can be adopted to provide some information to tableview object. Basically, those methods can be implemented to decide how our small pieces of papare there are. What info? how the appreance of scene and so on. ExploreViewController must implement these methods.

extension ExploreViewController: UITableViewDataSource {
    // [Dahye Comment] how many cells?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /* original
        return posts.count
 */
        if selectedSeg == 1 {
            print(posts.count, "count all")
            return posts.count
        }
        if selectedSeg == 2 {

            print(posts.count, "count aca")
            return posts.count
        }
        if selectedSeg == 3 {
            print(posts.count, "count emp")
            return posts.count
        }
        if selectedSeg == 4 {
            print(posts.count, "count lan")
            return posts.count
        } else {
            print("return nothing")
            return 0
        }
        
    }
    
    // [Dahye Comment] What does the each cell look like?
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//[0728 Dahye] Mute for a while to try implementation for segmented
     /*   let cell = exploreTableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! ExploreTableViewCell
        let post = posts[indexPath.row]
        cell.post = post
        cell.delegate = self
        
        // [0728 Dahye] other tables too!
        let cell2 = exploreTableView.dequeueReusableCell(withIdentifier: "PostCellAca", for: indexPath) as! ExploreTableViewCell
        let acaPost = posts[indexPath.row]
        cell2.post = acaPost
        cell2.delegate = self
        
        let cell3 = exploreTableView.dequeueReusableCell(withIdentifier: "PostCellEmp", for: indexPath) as! ExploreTableViewCell
        let empPost = posts[indexPath.row]
        cell3.post = empPost
        cell3.delegate = self

        let cell4 = exploreTableView.dequeueReusableCell(withIdentifier: "PostCellLan", for: indexPath) as! ExploreTableViewCell
        let lanPost = posts[indexPath.row]
        cell4.post = lanPost
        cell4.delegate = self

        if selectedSeg == 1 {
            cell.post = post
            cell.delegate = self
            return cell
        }
        if selectedSeg == 2 {
            cell2.post = post
            cell2.delegate = self
            return cell2
        }
        if selectedSeg == 3 {
            cell3.post = post
            cell3.delegate = self
            return cell3
        } else {
            cell4.post = post
            cell4.delegate = self
            return cell4
        } */
        
        // [0730 Dahye]
        let cell = exploreTableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! ExploreTableViewCell
        let cell2 = exploreTableView.dequeueReusableCell(withIdentifier: "PostCellAca", for: indexPath) as! ExploreTableViewCell
        let cell3 = exploreTableView.dequeueReusableCell(withIdentifier: "PostCellEmp", for: indexPath) as! ExploreTableViewCell
        let cell4 = exploreTableView.dequeueReusableCell(withIdentifier: "PostCellLan", for: indexPath) as! ExploreTableViewCell
        let post = posts[indexPath.row]
        
        
        
        if selectedSeg == 1 {
            cell.post = post
            print("cell")
            cell.delegate = self
            print("cell.deleg")
            return cell
        }
        if selectedSeg == 2 {
            cell2.post = post
            print("cell2")
            cell2.delegate = self
            print("cell2.deleg")
            return cell2
        }
        if selectedSeg == 3 {
            cell3.post = post
            print("cell3")
            cell3.delegate = self
            print("cell3,deleg")
            return cell3
        } else {
            cell4.post = post
            print("cell4")
            cell4.delegate = self
            print("cell4.deleg")
            return cell4
        }
        /*
        if selectedSeg == 1 {
            return cell
        }
        if selectedSeg == 2 {
            return cell2
        }
        if selectedSeg == 3 {
            return cell3
        } else {
            return cell4
        }
        */

 

        
    }
}


extension ExploreViewController: ExploreTableViewCellDelegate {
    
    // [Dahye 05.20] this sender will actually be passed to prepare for segue method.
    func goToPostVC(postId: String) {
        performSegue(withIdentifier: "Open_PostSegue", sender: postId)
    }
    
}

extension ExploreViewController: dismissHandler {
    func showAllCateAfterDismiss() {
        allCateButton.sendActions(for: .touchUpInside)
        self.exploreTableView.reloadData()
        print("Connected with writingView")
    }
    

}

