//
//  PostCollectionViewController.swift
//  
//
//  Created by 강호현 on 2018. 7. 31..
//

import UIKit
import XLPagerTabStrip


class PostCollectionViewController: UIViewController,IndicatorInfoProvider {
    
    
    @IBOutlet weak var lanBtn: UIButton!
    @IBOutlet weak var stuBtn: UIButton!
    @IBOutlet weak var jobBtn: UIButton!
    @IBOutlet weak var finBtn: UIButton!
    
    var postId: String?
    var posts = [Post]()
    var user: User!
    
    
    @IBAction func sendText1(_ sender: UIButton) {
        performSegue(withIdentifier: "lanBtn", sender: self)
    }
    
    @IBAction func sendText2(_ sender: UIButton) {
        performSegue(withIdentifier: "stuBtn", sender: self)
    }
    @IBAction func sendText3(_ sender: UIButton) {
        performSegue(withIdentifier: "jobBtn", sender: self)
    }
    @IBAction func sendText4(_ sender: UIButton) {
        performSegue(withIdentifier: "finBtn", sender: self)
    }
    
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "컬렉션")
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
