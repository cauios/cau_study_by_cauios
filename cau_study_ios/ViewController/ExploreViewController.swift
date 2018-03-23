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
    
    var appDelegate:AppDelegate? = nil
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavBarImage()
        exploreTableView.dataSource = self as? UITableViewDataSource
        loadPost()
    }
    
    func loadPost() {
        Database.database().reference().child("posts").observe(.childAdded) { (snapshot: DataSnapshot) in
            print(Thread.isMainThread)
            // do this, because many types of value can be stored in the DB
            if let dict = snapshot.value as? [String: Any] {
                let newPost = Post.transformPost(dicr: dict)
                self.posts.append(newPost)
                print(self.posts)
                self.exploreTableView.reloadData()
            }

            
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
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as? ExploreDetailViewController
        let contentIndex = self.exploreTableView.indexPath(for: sender as! UITableViewCell)
  

        
        if let ExploreDetailViewController = vc {
            let posts = self.posts
            
            ExploreDetailViewController.titleDetail = posts[contentIndex!.row].title
            ExploreDetailViewController.categoryDetail = posts[contentIndex!.row].category
            ExploreDetailViewController.objectivesDetail = posts[contentIndex!.row].objectives
            ExploreDetailViewController.titleDetail = posts[contentIndex!.row].title
            ExploreDetailViewController.durationDetail = posts[contentIndex!.row].duration
            ExploreDetailViewController.locationDetail = posts[contentIndex!.row].location
            ExploreDetailViewController.numofVacanDetail = posts[contentIndex!.row].numOfVacan
            ExploreDetailViewController.contactDetail = posts[contentIndex!.row].contact
            ExploreDetailViewController.descriptionDetail = posts[contentIndex!.row].description
            ExploreDetailViewController.writtingDetail =
                posts[contentIndex!.row].photoUrl
           
            }
//        var title: String?
//        var category: String?
//        var objectives: String?
//        var eligibility: String?
//        var duration: String?
//        var location: String?
//        var numOfVacan: String?
//        var contact: String?
//        var photoUrl: String?
//        var description: String?
        
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
        let cell = exploreTableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! ExploreTableViewCell
        let post = posts[indexPath.row]
        cell.post = post
        return cell
    }
}
