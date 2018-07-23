//
//  ChangePasswordViewController.swift
//  cau_study_ios
//
//  Created by CAUAD19 on 2018. 7. 23..
//  Copyright © 2018년 신형재. All rights reserved.
//

import UIKit
import FirebaseAuth
class ChangePasswordViewController: UIViewController {
    
    @IBOutlet var configureUserView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var doneBtn: UIButton!
    
    @IBOutlet weak var changePasswordView: UIView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.delegate = self
        
        doneBtn.isUserInteractionEnabled = false
        doneBtn.backgroundColor = .lightGray
        
        
        
    }
    
    @IBAction func configureBtn(_ sender: Any) {
        let passwordInput = passwordTextField.text
        reauthentication(password: passwordInput!)
    }
    
    func reauthentication(password: String) {
        let currentUser = Auth.auth().currentUser
        let email = currentUser?.email
        let credential = EmailAuthProvider.credential(withEmail: email!, password: password)
        Auth.auth().currentUser?.reauthenticate(with: credential, completion: {error in
            if error != nil {
                ProgressHUD.showError(error?.localizedDescription)
                return
            } else {
                self.configureUserView.addSubview(self.changePasswordView)
            }
        })
    }

}

extension ChangePasswordViewController: UITextFieldDelegate {
    //비밀번호 글자 수 제한
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newLength = (textField.text?.count)! + string.count - range.length
        if newLength > 0 {
            doneBtn.isUserInteractionEnabled = true
            doneBtn.backgroundColor = .black
        } else {
            doneBtn.isUserInteractionEnabled = false
            doneBtn.backgroundColor = .lightGray
        }
        return newLength <= 15
    }
    
}
