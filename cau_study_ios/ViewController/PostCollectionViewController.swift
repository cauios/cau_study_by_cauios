//
//  PostCollectionViewController.swift
//  
//
//  Created by 강호현 on 2018. 7. 31..
//

import UIKit
import XLPagerTabStrip


class PostCollectionViewController: UIViewController,IndicatorInfoProvider {
    

    
    var postId: String?
    var posts = [Post]()
    var user: User!
    
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "lanBtn":
            let secondVC = segue.destination as! PostRoomViewController
             secondVC.data = "lanBtn"
        case "stuBtn":
            let secondVC = segue.destination as! PostRoomViewController
            secondVC.data = "stuBtn"
        case "jobBtn":
            let secondVC = segue.destination as! PostRoomViewController
            secondVC.data = "jobBtn"
        case "finBtn":
            let secondVC = segue.destination as! PostRoomViewController
            secondVC.data = "finBtn"
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        removeRedDotAtTabBarItemIndex(index: 2)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "컬렉션")
    }
    func removeRedDotAtTabBarItemIndex(index: Int) {
        for subview in (tabBarController?.tabBar.subviews)! {
            
            if let subview = subview as? UIView {
                
                if subview.tag == 1234 {
                    subview.removeFromSuperview()
                    
                }
            }
        }
        
        let RedDotRadius: CGFloat = 5
        let RedDotDiameter = RedDotRadius * 2
        
        let TopMargin:CGFloat = 5
        
        let TabBarItemCount = CGFloat(self.tabBarController!.tabBar.items!.count)
        
        let screenSize = UIScreen.main.bounds
        let HalfItemWidth = (screenSize.width) / (TabBarItemCount * 2)
        
        let  xOffset = HalfItemWidth * CGFloat(index * 2 + 1)
        
        let imageHalfWidth: CGFloat = (self.tabBarController!.tabBar.items![index] ).selectedImage!.size.width / 2
        
        let redDot = UIView(frame: CGRect(x: xOffset + imageHalfWidth - 7, y: TopMargin, width: RedDotDiameter, height: RedDotDiameter))
        
        redDot.tag = 1234
        redDot.backgroundColor = UIColor.red
        redDot.layer.cornerRadius = RedDotRadius
        
        self.tabBarController?.tabBar.willRemoveSubview(redDot)
        
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
