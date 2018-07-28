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

    @IBOutlet weak var exploreTableView: UITableView!
    var posts = [Post]()
    var users = [User]()
    // [0728 Dahye] Declare array for each category
    var acaPosts = [Post]()
    var empPosts = [Post]()
    var lanPosts = [Post]()
    //
    
    var post: Post?
    
    
    // [0728 Dahye] Classify accroding to he Category
    
    var selectedSeg = 0
    
    @IBAction func categorySegToupUpInside(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            selectedSeg = 1
        }
        if sender.selectedSegmentIndex == 1 {
            selectedSeg = 2
        }
        if sender.selectedSegmentIndex == 2 {
            selectedSeg = 3
        }
        if sender.selectedSegmentIndex == 3 {
            selectedSeg = 4
        }
        self.exploreTableView.reloadData()
    }
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavBarImage()
        exploreTableView.dataSource = self
        loadPost()

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
        guard Auth.auth().currentUser != nil else {
            return
        }
        Api.Category.observeAcaPosts {
            (post) in
            //self.posts.append(post) Dahye: This shows the new post on the bottom
            self.acaPosts.insert(post, at: 0) // Dahye: Show the new post on the top
            self.exploreTableView.reloadData()
        }
    }
    //
    
    //[0728 Dahye] load Employment Preperation Posts
    func loadEmpPost() {
        guard Auth.auth().currentUser != nil else {
            return
        }
        Api.Category.observeAcaPosts {
            (post) in
            //self.posts.append(post) Dahye: This shows the new post on the bottom
            self.empPosts.insert(post, at: 0) // Dahye: Show the new post on the top
            self.exploreTableView.reloadData()
        }
    }
    //

    //[0728 Dahye] load Language Posts
    func loadLanPost() {
        guard Auth.auth().currentUser != nil else {
            return
        }
        Api.Category.observeAcaPosts {
            (post) in
            //self.posts.append(post) Dahye: This shows the new post on the bottom
            self.lanPosts.insert(post, at: 0) // Dahye: Show the new post on the top
            self.exploreTableView.reloadData()
        }
    }
    //
    
    
    func fetchUser(uid: String, completed: @escaping() -> Void) {
        Api.User.observeUser(withId: uid, completion: {
            user in
            //self.users.append(user)
            self.users.insert(user, at: 0)
            completed()})
    }
    
    // [Dahye 15.20] prepare method will be called right before the transition which is a perfect place to send the data on the destination view controller.
    // [Dahye 05.20] prepare method should be implemented in the file where the performSegue is implemented.
    // [Dahye 05.20] We should note that the data passed along is a string Id. So we need to convert the sender parameter of type any into string.
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Open_PostSegue" {
            let postVC = segue.destination as! PostViewController
            let postId = sender as! String
            postVC.postId = postId
        }
    }
                      
    
    // [Dahye Comment] This is to create an image title of a Navigation Bar.
    
    func addNavBarImage() {
        let navController = navigationController!
        
        let image = #imageLiteral(resourceName: "logo_cau")
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
        return posts.count
    }
    // [Dahye Comment] What does the each cell look like?
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//[0728 Dahye] Mute for a while to try implementation for segmented
        let cell = exploreTableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! ExploreTableViewCell
        let post = posts[indexPath.row]
        cell.post = post
        cell.delegate = self
        return cell
 

        
    }
}


extension ExploreViewController: ExploreTableViewCellDelegate {
    
    // [Dahye 05.20] this sender will actually be passed to prepare for segue method.
    func goToPostVC(postId: String) {
        performSegue(withIdentifier: "Open_PostSegue", sender: postId)
    }
    
}


