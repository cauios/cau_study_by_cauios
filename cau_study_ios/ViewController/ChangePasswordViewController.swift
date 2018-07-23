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
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmNewPasswordTextField: UITextField!
    @IBOutlet weak var changeBtn: UIButton!
    
    var firstTextFieldisFilled = false
    var secondTextFieldisFilled = false

    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.delegate = self
        newPasswordTextField.delegate = self
        confirmNewPasswordTextField.delegate = self
        newPasswordTextField.tag = 1
        confirmNewPasswordTextField.tag = 2
        
        doneBtn.isUserInteractionEnabled = false
        doneBtn.backgroundColor = .lightGray
        changeBtn.isUserInteractionEnabled = false
        changeBtn.backgroundColor = .lightGray
        
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
    func checkTextField() {
        if firstTextFieldisFilled == true && secondTextFieldisFilled == true {
            changeBtn.isUserInteractionEnabled = true
            changeBtn.backgroundColor = .black
        } else {
            changeBtn.isUserInteractionEnabled = false
            changeBtn.backgroundColor = .lightGray
        }
    }
    func checkEqual() -> Bool{
        if newPasswordTextField.text == confirmNewPasswordTextField.text {
            return true
        } else {
            return false
        }
    }
    
    @IBAction func changPasswordBtn(_ sender: Any) {
        if checkEqual() {
            let password = newPasswordTextField.text
            Auth.auth().currentUser?.updatePassword(to: password!, completion: {error in
                if error != nil {
                    ProgressHUD.showError(error?.localizedDescription)
                }
            })
        } else {
            let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            let alertController = UIAlertController(title: "??", message: "비밀번호가 일치하지 않습니다", preferredStyle: .alert)
            alertController.addAction(alertAction)
            self.present(alertController, animated: true, completion: nil)
            
        }

    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }


}

extension ChangePasswordViewController: UITextFieldDelegate {
    //비밀번호 글자 수 제한
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newLength = (textField.text?.count)! + string.count - range.length
        if newLength > 1 {
            if textField.tag == 0 {
                doneBtn.isUserInteractionEnabled = true
                doneBtn.backgroundColor = .black
            } else if textField.tag == 1 {
                firstTextFieldisFilled = true
                checkTextField()
            } else {
                secondTextFieldisFilled = true
                checkTextField()
            }
        } else {
            if textField.tag == 0 {
                doneBtn.isUserInteractionEnabled = false
                doneBtn.backgroundColor = .lightGray
            } else if textField.tag == 1 {
                firstTextFieldisFilled = false
                checkTextField()
            } else {
                secondTextFieldisFilled = false
                checkTextField()
            }
        }
        return newLength <= 15
    }
    
}
