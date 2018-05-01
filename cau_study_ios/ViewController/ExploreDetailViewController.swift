//
//  ExploreDetailViewController.swift
//  cau_study_ios
//
//  Created by 강호현 on 2018. 3. 21..
//  Copyright © 2018년 신형재. All rights reserved.
//

import UIKit


class ExploreDetailViewController: UIViewController {

    var idDetail: String?
    var titleDetail: String?
    var profileDetail: UIImage?
    var categoryDetail: String?
    var eligibilityDetail: String?
    var objectivesDetail: String?
    var durationDetail: String?
    var locationDetail: String?
    var numofVacanDetail: String?
    var contactDetail: String?
    var descriptionDetail: String?
    
    @IBOutlet weak var titleTextField: UILabel!
    @IBOutlet weak var Id: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var categoryTextField: UILabel!
    @IBOutlet weak var eligibilityTextField: UILabel!
    @IBOutlet weak var durationTextField: UILabel!
    @IBOutlet weak var locationTextField: UILabel!
    @IBOutlet weak var numOfVacanTextField: UILabel!
    @IBOutlet weak var contactTextField: UITextField!
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var objectiveTextField: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let id = self.idDetail {
            self.Id.text = id
        }
        
        if let titleVal = self.titleDetail {
            self.titleTextField.text = titleVal
        }
        
        if let objectVal = self.objectivesDetail {
            self.objectiveTextField.text = objectVal
        }
        
        if let profileImageVal = self.profileDetail {
            self.profileImage.image = profileImageVal
        }
        
        if let categoryVal = self.categoryDetail {
            self.categoryTextField.text = categoryVal
        }
        
        if let eligibilityVal = self.eligibilityDetail {
            self.eligibilityTextField.text = eligibilityVal
        }
        
        if let durationVal = self.durationDetail {
            self.durationTextField.text = durationVal
        }
        
        if let locationVal = self.locationDetail {
            self.locationTextField.text = locationVal
        }
        
        if let numVal = self.numofVacanDetail {
            self.numOfVacanTextField.text = numVal
        }
        
        if let contactVal = self.contactDetail {
            self.contactTextField.text = contactVal
        }
        
        
        if let descriptionVal = self.descriptionDetail {
            self.descTextView.text = descriptionVal
        }
    }

        
        
        // Do any additional setup after loading the view.

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}

