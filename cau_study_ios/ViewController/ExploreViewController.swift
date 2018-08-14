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

//[0802]
    var timer = Timer()
    let delay = 0.2
    
    // [0729 Dahye] Outlets for buttons

    @IBOutlet weak var allCateButton: UIButton!
    @IBOutlet weak var acaCateButton: UIButton!
    @IBOutlet weak var empCateButton: UIButton!
    @IBOutlet weak var lanCateButton: UIButton!
    
    // [0807 Dahye]
    
    @IBOutlet weak var allLineView: UIView!
    @IBOutlet weak var acaLineView: UIView!
    @IBOutlet weak var empLineView: UIView!
    @IBOutlet weak var lanLineView: UIView!
    
     // [0729 Dahye] Actions for buttons
    @IBAction func allCateTouchUpInside(_ sender: Any) {
        selectedSeg = 1
        allCateButton.setTitleColor(UIColor.black, for: .normal)
        acaCateButton.setTitleColor(UIColor.lightGray, for: .normal)
        empCateButton.setTitleColor(UIColor.lightGray, for: .normal)
        lanCateButton.setTitleColor(UIColor.lightGray, for: .normal)
        allLineView.backgroundColor = UIColor.darkGray
        acaLineView.backgroundColor = UIColor.clear
        empLineView.backgroundColor = UIColor.clear
        lanLineView.backgroundColor = UIColor.clear
        posts = [Post]()
        Api.Post.REF_POSTS.observe(.childAdded, with: {
            snapshot in
            Api.Post.observePost(withId: snapshot.key, completion: { post in
                self.posts.insert(post, at: 0)
                self.exploreTableView.reloadData()
            })
            
        })
           // self.exploreTableView.reloadData()

    }
    @IBAction func acaCateTouchUpInside(_ sender: Any) {
        selectedSeg = 2
        allCateButton.setTitleColor(UIColor.lightGray, for: .normal)
        acaCateButton.setTitleColor(UIColor.black, for: .normal)
        empCateButton.setTitleColor(UIColor.lightGray, for: .normal)
        lanCateButton.setTitleColor(UIColor.lightGray, for: .normal)
        allLineView.backgroundColor = UIColor.clear
        acaLineView.backgroundColor = UIColor.darkGray
        empLineView.backgroundColor = UIColor.clear
        lanLineView.backgroundColor = UIColor.clear
        posts = [Post]()
        self.exploreTableView.reloadData()
        loadAcaPost()
        
    }
    
    @IBAction func empCateTouchUpInside(_ sender: Any) {
        selectedSeg = 3
        allCateButton.setTitleColor(UIColor.lightGray, for: .normal)
        acaCateButton.setTitleColor(UIColor.lightGray, for: .normal)
        empCateButton.setTitleColor(UIColor.black, for: .normal)
        lanCateButton.setTitleColor(UIColor.lightGray, for: .normal)
        allLineView.backgroundColor = UIColor.clear
        acaLineView.backgroundColor = UIColor.clear
        empLineView.backgroundColor = UIColor.darkGray
        lanLineView.backgroundColor = UIColor.clear
        posts = [Post]()
        self.exploreTableView.reloadData()
        loadEmpPost()
    }
    @IBAction func lanCateTouchUpInside(_ sender: Any) {
        selectedSeg = 4
        allCateButton.setTitleColor(UIColor.lightGray, for: .normal)
        acaCateButton.setTitleColor(UIColor.lightGray, for: .normal)
        empCateButton.setTitleColor(UIColor.lightGray, for: .normal)
        lanCateButton.setTitleColor(UIColor.black, for: .normal)
        allLineView.backgroundColor = UIColor.clear
        acaLineView.backgroundColor = UIColor.clear
        empLineView.backgroundColor = UIColor.clear
        lanLineView.backgroundColor = UIColor.darkGray
        posts = [Post]()
        self.exploreTableView.reloadData()
        loadLanPost()
}

    
    override func viewDidLoad() {
        selectedSeg = 1
        allCateButton.setTitleColor(UIColor.black, for: .normal)
        acaCateButton.setTitleColor(UIColor.lightGray, for: .normal)
        empCateButton.setTitleColor(UIColor.lightGray, for: .normal)
        lanCateButton.setTitleColor(UIColor.lightGray, for: .normal)
        allLineView.backgroundColor = UIColor.darkGray
        acaLineView.backgroundColor = UIColor.clear
        empLineView.backgroundColor = UIColor.clear
        lanLineView.backgroundColor = UIColor.clear
        super.viewDidLoad()
        addNavBarImage()
        exploreTableView.dataSource = self

        loadPost()
       // self.exploreTableView.reloadData()
    }
    
    
    func loadPost() {
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        Api.Post.REF_POSTS.observe(.childAdded, with: {
            snapshot in
            Api.Post.observePost(withId: snapshot.key, completion: { post in
                self.posts.insert(post, at: 0)
                self.exploreTableView.reloadData()
            })

        })
        //self.exploreTableView.reloadData()

        
     //    Dahye: reload posts after deletion of post in profileView is operated
        Api.Post.REF_POSTS.observe(.childRemoved, with: {snap in
            let snapId = snap.key
            if let index = self.posts.index(where: {(item)-> Bool in item.id == snapId}) {
                self.posts.remove(at: index)
                self.exploreTableView.reloadData()
        }
        })

     //  saved에서 하트를 두번 눌러서 제거되면 saved api에서 확인해서 바로 explore 하트에도 이를 반영한다.
        Api.Saved.REF_SAVED.child(currentUser.uid).observe(.childRemoved, with: {snap in
            self.exploreTableView.reloadData()
            self.removeRedDotAtTabBarItemIndex(index: 2)
            
            

        })

        Api.Saved.REF_SAVED.child(currentUser.uid).observe(.childAdded, with: {snap in
            self.exploreTableView.reloadData()
            self.addRedDotAtTabBarItemIndex(index: 2)

        })
    }
    //hohyun: badge saved item
    func addRedDotAtTabBarItemIndex(index: Int) {
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
        
        self.tabBarController?.tabBar.addSubview(redDot)
        
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
       // timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: delay, target: self, selector: #selector(delayedAction), userInfo: nil, repeats: false)
        print("Connected with writingView")
    }
    
    @objc func delayedAction() {
        allCateButton.sendActions(for: .touchUpInside)
    }

}

