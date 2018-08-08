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
    
    
    @IBOutlet weak var changePasswordView: UIView!
    @IBOutlet weak var newPasswordTextField: UITextField!

    @IBOutlet weak var confirmNewPasswordTextField: UITextField!
    @IBOutlet weak var changeBtn: UIButton!
    
    var configureTextFieldisFilled = false
    var firstTextFieldisFilled = false
    var secondTextFieldisFilled = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        changePasswordView.backgroundColor = UIColor(patternImage: UIImage(named: "2-3bg")!)
        
        passwordTextField.delegate = self
        newPasswordTextField.delegate = self
        confirmNewPasswordTextField.delegate = self
        //텍스트필드 태그
        passwordTextField.tag = 0
        newPasswordTextField.tag = 1
        confirmNewPasswordTextField.tag = 2
        
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        
        //키보드 화면 가릴때
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
  
        
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
            }
            self.changeNewPassword()
            
        })
    }
    
    func checkTextField() {
        if firstTextFieldisFilled && secondTextFieldisFilled && configureTextFieldisFilled {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            
        }
    }
    
    func checkEqual() -> Bool{
        if newPasswordTextField.text == confirmNewPasswordTextField.text {
            return true
        } else {
            return false
        }
    }
    
    @IBAction func changePsswrdBtn(_ sender: Any) {
        let passwordInput = passwordTextField.text
        reauthentication(password: passwordInput!)
        
        
    }
    func changeNewPassword() {
        if checkEqual() {
            let password = newPasswordTextField.text
            Auth.auth().currentUser?.updatePassword(to: password!, completion: {error in
                if error != nil {
                    ProgressHUD.showError(error?.localizedDescription)
                    return
                }
                _ = self.navigationController?.popToRootViewController(animated: true)
            })
        } else {
            let image = UIImageView(image: UIImage(named: "unactiveCheck"))
            image.translatesAutoresizingMaskIntoConstraints = false
            
            let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            let alertController = UIAlertController(title: "\n\n", message: "변경할 비밀번호가 일치하지 않습니다", preferredStyle: .alert)
            alertController.addAction(alertAction)
            alertController.view.addSubview(image)
            alertController.view.addConstraint(NSLayoutConstraint(item: image, attribute: .centerX, relatedBy: .equal, toItem: alertController.view, attribute: .centerX, multiplier: 1, constant: 0))
            alertController.view.addConstraint(NSLayoutConstraint(item: image, attribute: .centerY, relatedBy: .equal, toItem: alertController.view, attribute: .centerY, multiplier: 0.45, constant: 0))
            alertController.view.addConstraint(NSLayoutConstraint(item: image, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 30.0))
            alertController.view.addConstraint(NSLayoutConstraint(item: image, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 30.0))
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
   
    //touch anywhere, keyboard dismissed
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //content showing when keyboard showed
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }


}

extension ChangePasswordViewController: UITextFieldDelegate {
    //비밀번호 글자 수 제한
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newLength = (textField.text?.count)! + string.count - range.length
        if newLength > 1 {
            if textField.tag == 0 {
                configureTextFieldisFilled = true
                checkTextField()
            } else if textField.tag == 1 {
                firstTextFieldisFilled = true
                checkTextField()
            } else {
                secondTextFieldisFilled = true
                checkTextField()
            }
        } else {
            if textField.tag == 0 {
                configureTextFieldisFilled = false
                checkTextField()
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
    
    //키보드 return 클릭시 키보드 사라짐
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
