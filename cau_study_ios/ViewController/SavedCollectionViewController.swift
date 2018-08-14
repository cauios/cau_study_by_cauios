//
//  Saved2ViewController.swift
//  cau_study_ios
//
//  Created by 강호현 on 2018. 7. 31..
//  Copyright © 2018년 신형재. All rights reserved.
//

import UIKit
import FirebaseAuth
import XLPagerTabStrip
import TBEmptyDataSet


class SavedCollectionViewController: UIViewController,IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "전체")
    }
    
    @IBOutlet weak var collectionView: UICollectionView!

    var postId: String?
    var posts = [Post]()
    var user: User!
    var selectedCellId: String?
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.emptyDataSetDataSource = self
        collectionView.emptyDataSetDelegate = self
        

        

        collectionView.delegate = self
        collectionView.dataSource = self
        fetchUser()
        fetchSaved()

        
       
    }
    // whenever saved tabbar item clicked, badge will remove!!
    override func viewDidAppear(_ animated: Bool) {
        self.removeRedDotAtTabBarItemIndex(index: 2)
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
}

extension SavedCollectionViewController: TBEmptyDataSetDataSource {
    
    func imageForEmptyDataSet(in scrollView: UIScrollView) -> UIImage? {
        return resizeImage(image: UIImage(named: "saved_placeholder")!, newWidth: 200)
    }
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage? {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }

    func descriptionForEmptyDataSet(in scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: "첫 블록으로\n나만의 컬렉션을\n시작해보세요.")

    }
    
    func verticalSpacesForEmptyDataSet(in scrollView: UIScrollView) -> [CGFloat] {
        return [50]
    }
 
 
    
}

extension SavedCollectionViewController: TBEmptyDataSetDelegate {
    func emptyDataSetShouldDisplay(in scrollView: UIScrollView) -> Bool {
        return posts.count == 0
    }
    
}




extension SavedCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    


    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SavedCollectionViewCell", for: indexPath) as! SavedCollectionViewCell
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


extension SavedCollectionViewController: UICollectionViewDelegateFlowLayout {
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
