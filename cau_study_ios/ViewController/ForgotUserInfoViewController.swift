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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendEmailBtn(_ sender: Any) {
        if let emailStr = emailTextField.text {
            Auth.auth().sendPasswordReset(withEmail: emailStr, completion: {error in
                if error != nil {
                    ProgressHUD.showError(error?.localizedDescription)
                }
                
            })
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
