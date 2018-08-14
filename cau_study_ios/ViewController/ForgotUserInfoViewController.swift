//
//  ForgotUserInfoViewController.swift
//  cau_study_ios
//
//  Created by CAUAD19 on 2018. 7. 20..
//  Copyright © 2018년 신형재. All rights reserved.
//

import UIKit
import FirebaseAuth

class ForgotUserInfoViewController: UIViewController {

    @IBOutlet weak var ForgotBgImageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        self.view.insertSubview(ForgotBgImageView, at: 0)
        super.viewDidLoad()
        emailTextField.isUserInteractionEnabled = true

    }

   
    @IBAction func sendEmailBtn(_ sender: Any) {
        if let emailStr = emailTextField.text {
            Auth.auth().sendPasswordReset(withEmail: emailStr, completion: {error in
                if error != nil {
                    ProgressHUD.showError(error?.localizedDescription)
                }
                
            })
            
            self.dismiss(animated: true, completion: {ProgressHUD.showSuccess("메일을 확인해주세요.")})
        }
        
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //touch anywhere, keyboard dismissed
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
  

}
