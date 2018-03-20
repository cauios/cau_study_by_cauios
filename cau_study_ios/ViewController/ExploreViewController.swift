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

class ExploreViewController: UIViewController {

    @IBOutlet weak var exploreTableView: UITableView!
    var posts = [Post]()
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavBarImage()
        exploreTableView.dataSource = self
        loadPost()
//        var post = Post(titleText: "test1", categoryText: "test2", objectivesText: "test3", eligibilityText: "test4", durationText: "test5", locationText: "test6", numOfVacanText: "test7", contactText: "test8", photoUrlString: "url", descriptionText: "test9")
//
//        print(post.title)
//        print(post.category)
//        print(post.objectives)
//        print(post.eligibility)
//        print(post.duration)
//        print(post.location)
//        print(post.numOfVacan)
//        print(post.contact)
//        print(post.photoUrl)
//        print(post.description)
    }
    
    func loadPost() {
        Database.database().reference().child("posts").observe(.childAdded) { (snapshot: DataSnapshot) in
            print(Thread.isMainThread)
            // do this, because many types of value can be stored in the DB
            if let dict = snapshot.value as? [String: Any] {
                let newPost = Post.transformPost(dicr: dict)
//                let titleText = dict["title"] as! String
//                let categoryText = dict["category"] as! String
//                let objectivesText = dict["objectives"] as! String
//                let eligibilityText = dict["eligibility"] as! String
//                let durationText = dict["duration"] as! String
//                let locationText = dict["location"] as! String
//                let numOfVacanText = dict["numOfVacan"] as! String
//                let contactText = dict["contact"] as! String
//                let photoUrlString = dict["photoUrl"] as! String
//                let descriptionText = dict["description"] as! String
//                let post = Post(titleText: titleText, categoryText: categoryText, objectivesText: objectivesText, eligibilityText: eligibilityText, durationText: durationText, locationText: locationText, numOfVacanText: numOfVacanText, contactText: contactText, photoUrlString: photoUrlString, descriptionText: descriptionText)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


// [Dahye Comment] With extension, we let the exploreViewController promise to implement a few methods in the UItableViewDataSource. This protocol declares some methods that can be adopted to provide some information to tableview object. Basically, those methods can be implemented to decide how our small pieces of papare there are. What info? how the appreance of scene and so on. ExploreViewController must implement these methods.

extension ExploreViewController: UITableViewDataSource {
    // [Dahye Comment] how many cells?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    // [Dahye Comment] What does the each cell look like?
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = exploreTableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)
        cell.textLabel?.text = posts[indexPath.row].title
        return cell
    }
}
