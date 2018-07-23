//
//  DeleteUserViewController.swift
//  cau_study_ios
//
//  Created by CAUAD19 on 2018. 7. 23..
//  Copyright © 2018년 신형재. All rights reserved.
//

import UIKit

class DeleteUserViewController: UIViewController {

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var agreeBtn: UIImageView!
    @IBOutlet weak var deleteBtn: UIButton!
    
    var state = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Api.User.observeCurrentUser(completion: {user in
            self.emailLabel.text = user.email
        })
        deleteBtn.isUserInteractionEnabled = false
        deleteBtn.backgroundColor = .lightGray
        
        if state {
            configureAgree()
        } else {
            configureDisagree()
        }
    }
    
    func configureAgree() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.agree))
        agreeBtn.addGestureRecognizer(tapGesture)
        agreeBtn.isUserInteractionEnabled = true
        agreeBtn.image = UIImage(named: "checkmark")
        
    }
    
    func configureDisagree() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.disagree))
        agreeBtn.addGestureRecognizer(tapGesture)
        agreeBtn.isUserInteractionEnabled = true
        agreeBtn.image = UIImage(named: "uncheckmark")
    }
    
    @objc func agree() {
        deleteBtn.isUserInteractionEnabled = false
        deleteBtn.backgroundColor = .lightGray
        state = true
        configureDisagree()
    }
    
    @objc func disagree() {
        deleteBtn.isUserInteractionEnabled = true
        deleteBtn.backgroundColor = .black
        state = false
        configureAgree()
    }

    
}
