//
//  DeleteUserViewController.swift
//  cau_study_ios
//
//  Created by CAUAD19 on 2018. 7. 23..
//  Copyright © 2018년 신형재. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
class DeleteUserViewController: UIViewController {

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var agreeBtn: UIImageView!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    var currenterUser: User?
    var uid: String?
    var state = false
    var posts = [String]()
    var currentUser = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.tabBarController?.tabBar.isHidden = true
        passwordTextField.delegate = self
        Api.User.observeCurrentUser(completion: {user in
            self.emailLabel.text = user.email
            self.currenterUser = user
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
        agreeBtn.image = UIImage(named: "unactiveCheck")
        
    }
    
    func configureDisagree() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.disagree))
        agreeBtn.addGestureRecognizer(tapGesture)
        agreeBtn.isUserInteractionEnabled = true
        agreeBtn.image = UIImage(named: "activeCheck")
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
    
    //delete
    @IBAction func deletaUserButton(_ sender: Any) {
        
        reauthentication(password: passwordTextField.text!)
        
    }
    
    func deleteDatabase() {
        if let userId = currenterUser?.uid {
            self.uid = userId
            Api.MyPosts.REF_MYPOSTS.child(userId).observe(.childAdded, with: { snapshot in
                Api.Post.REF_POSTS.child(snapshot.key).removeValue()
                // post id 관련해서 지워야할 목록들
                
            })
            Api.MyPosts.REF_MYPOSTS.child(userId).removeValue()
            Api.User.REF_USERS.child(userId).removeValue()
        }
    }
    func deleteStroage() {
        Api.User.deleteUserProfile(userId: uid!, onSuccess: {
            let user = self.currentUser
            user?.delete(completion: {error in
                if error != nil {
                    ProgressHUD.showError(error?.localizedDescription)
                    return
                } else {
                    print("delete successfully")
                }
            })
        }, onError: {errorMessage in
            ProgressHUD.showError(errorMessage)
            
        })
        do{
            try Auth.auth().signOut()
        } catch let logoutError{
            print(logoutError)
        }
        let storyboard = UIStoryboard(name: "Start", bundle: nil)
        let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
        self.present(signInVC, animated: true, completion: nil)
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
                self.deleteDatabase()
                self.deleteStroage()
            }
        })
    }
    //touch anywhere, keyboard dismissed
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
extension DeleteUserViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newLength = (textField.text?.count)! + string.count - range.length
//        if newLength > 1 {
//
//        }
        return newLength <= 15
    }
    
    //키보드 return 클릭시 키보드 사라짐
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
