//
//  ChangeProfileViewController.swift
//  cau_study_ios
//
//  Created by CAUAD30 on 2018. 7. 30..
//  Copyright © 2018년 신형재. All rights reserved.
//

import UIKit

class ChangeProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextView!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var changeProfileBtn: UIBarButtonItem!
    var currentUser: User?
    var selectedImage: UIImage?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        fetchUser()
        changeProfileImage()
        
        //텍스트 뷰 태그
        usernameTextField.tag = 0
        descriptionTextField.tag = 1
        
        usernameTextField.delegate = self
        descriptionTextField.delegate = self
        
        //키보드 화면 가릴때
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
    }
    
    func fetchUser() {
        Api.User.observeCurrentUser(completion: { user in
            self.currentUser = user
            self.emailLabel.text = user.email
            self.usernameTextField.text = user.username
            self.descriptionTextField.text = user.introduceMyself
            self.updateProfileImage()
        })
        
    }
    func updateProfileImage() {
        if let photoUrlString = currentUser?.profileImageUrl {
            let photoUrl = URL(string: photoUrlString)
            self.profileImage.sd_setImage(with: photoUrl)
        }
    }
    
    //프로필 이미지 픽커 컨트롤러
    @objc func handleSelectProfileImage() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
        
    }
    //프로필 이미지 변경
    func profileImageChange() {
        ProgressHUD.show("Waiting...", interaction: false)
        
        if let newProfileImg = selectedImage, let currentUserUid = self.currentUser?.uid, let imageData = UIImageJPEGRepresentation(newProfileImg, 0.1) {
            
            Api.User.changeProfileImage(currentUserUid: currentUserUid, imageData: imageData, onSuccess: {
                ProgressHUD.showSuccess("Success")
            }, onError: {(errorString) in
                ProgressHUD.showError(errorString!)
            })
            
        }
    }
    
    func changeProfileImage() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectProfileImage))
        profileImage.addGestureRecognizer(tapGesture)
        profileImage.isUserInteractionEnabled = true
    }
    
    @IBAction func changeProfileText(_ sender: Any) {
        if self.usernameTextField.text.count >= 4 {
            currentUser?.username = self.usernameTextField.text
            currentUser?.introduceMyself = self.descriptionTextField.text
            
            Api.User.changeProfileInfo(currentUserUid: (currentUser?.uid)!, introduceString: (currentUser?.introduceMyself)!, username: (currentUser?.username)!, onSuccess: {
                ProgressHUD.showSuccess()
                _ = self.navigationController?.popToRootViewController(animated: true)
                
                }, onError: {errorStr in
                ProgressHUD.showError(errorStr)
            })
            
        } else {
            ProgressHUD.showError("유저 닉네임은 4글자 이상이어야 합니다.")
        }
    }
    
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


extension ChangeProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("did Finish Picking Media")
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            self.selectedImage = image
            self.profileImage.image = image
            
        }
        dismiss(animated: true, completion: nil)
        profileImageChange()
        
    }
}

extension ChangeProfileViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if textView.tag == 0 {
            let currentText = usernameTextField.text!
            guard let stringRange = Range(range, in: currentText) else {
                return false
            }
            let changedText = currentText.replacingCharacters(in: stringRange, with: text)
            return changedText.count <= 15
        } else {
            let currentText = descriptionTextField.text!
            guard let stringRange = Range(range, in: currentText) else {
                return false
            }
            let changedText = currentText.replacingCharacters(in: stringRange, with: text)
            return changedText.count <= 100
        }
        
    }
}

