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

        //키보드 화면 가릴때
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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
    
    //content showing when keyboard showed
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    

}
