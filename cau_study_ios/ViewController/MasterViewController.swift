//
//  MasterViewController.swift
//  cau_study_ios
//
//  Created by 강호현 on 2018. 7. 31..
//  Copyright © 2018년 신형재. All rights reserved.
//

import UIKit

class Responder: NSObject {
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {

    }
}


class MasterViewController: UIViewController {

    @IBOutlet weak var navi: UINavigationBar!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var buttonBar: UIView!

    @IBOutlet weak var postCollectionView: UIView!
    @IBOutlet weak var savedCollectionView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchNavi()
        fetchSegment()


        // Do any additional setup after loading the view.
    }
    
    @IBAction func showComponent(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            UIView.animate(withDuration: 0.5, animations: {
                self.savedCollectionView.alpha = 1
                self.postCollectionView.alpha = 0
            })
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.savedCollectionView.alpha = 0
                self.postCollectionView.alpha = 1
            })
        }
    }
    
    func fetchNavi() {
        let logo = UIImage(named: "logo.png")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView

        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
    }
    
    func fetchSegment() {
       
        segmentedControl.backgroundColor = .clear
        segmentedControl.tintColor = .clear
        
        
        segmentedControl.setTitleTextAttributes([
            NSAttributedStringKey.foregroundColor: UIColor.lightGray
            ], for: .normal)
        
        
        segmentedControl.setTitleTextAttributes([
            NSAttributedStringKey.foregroundColor: UIColor.black
            ], for: .selected)
        
        // This needs to be false since we are using auto layout constraints
        buttonBar.translatesAutoresizingMaskIntoConstraints = false
        buttonBar.backgroundColor = UIColor.gray
        
        view.addSubview(navi)
        view.addSubview(buttonBar)
        
        buttonBar.topAnchor.constraint(equalTo: navi.bottomAnchor).isActive = true
        buttonBar.heightAnchor.constraint(equalToConstant: 2).isActive = true
        // Constrain the button bar to the left side of the segmented control
        buttonBar.leftAnchor.constraint(equalTo: navi.leftAnchor).isActive = true
        // Constrain the button bar to the width of the segmented control divided by the number of segments
        buttonBar.widthAnchor.constraint(equalTo: navi.widthAnchor, multiplier: 1 / CGFloat(segmentedControl.numberOfSegments)).isActive = true
        
        let responder = Responder()
        // Above the PlaygroundPage.current.liveView = view statement at the bottom
        segmentedControl.addTarget(responder, action: #selector(responder.segmentedControlValueChanged(_:)), for: UIControlEvents.valueChanged)
    }
    
    //hohyun comment segmentcontrol size and animation control
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        //        let postCollectVC = PostCollectionViewController()
        UIView.animate(withDuration: 0.3) {
            self.buttonBar.frame.origin.x = (self.navi.frame.width / CGFloat(self.segmentedControl.numberOfSegments)) * CGFloat(self.segmentedControl.selectedSegmentIndex)
            
            
        }
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
