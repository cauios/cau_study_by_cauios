//
//  MasterViewController.swift
//  cau_study_ios
//
//  Created by 강호현 on 2018. 7. 31..
//  Copyright © 2018년 신형재. All rights reserved.
//

import UIKit
import XLPagerTabStrip


class ParentViewController: ButtonBarPagerTabStripViewController {
    
    let purpleInspireColor = UIColor(red:0.13, green:0.03, blue:0.25, alpha:1.0)
//    weak var currentViewController: UIViewController?
    // change selected bar color
    
    //    @IBOutlet weak var navi: UINavigationBar!
//    @IBOutlet weak var segmentedControl: UISegmentedControl!
//    @IBOutlet weak var buttonBar: UIView!

    
    override func viewDidLoad() {
//        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        navigationItem.titleView = UIImageView.init(image: UIImage(named:"logo"))
        
        settings.style.buttonBarBackgroundColor = UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1.0)
        settings.style.buttonBarItemBackgroundColor = UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1.0)
        settings.style.selectedBarBackgroundColor = purpleInspireColor
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
    
        
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            
            oldCell?.label.textColor = .gray
            newCell?.label.textColor = .black
            
            if animated {
                UIView.animate(withDuration: 0.1, animations: { () -> Void in
                    newCell?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    oldCell?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                })
            }
            else {
                newCell?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                oldCell?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }
        }
        super.viewDidLoad()

            }

    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child_1 = UIStoryboard(name: "Saved", bundle: nil).instantiateViewController(withIdentifier: "전체")
        let child_2 = UIStoryboard(name: "Saved", bundle: nil).instantiateViewController(withIdentifier: "컬렉션")
        return [child_1, child_2]
    }

}
