//
//  ProfileViewController.swift
//  cau_study_ios
//
//  Created by 신형재 on 13/03/2018.
//  Copyright © 2018 신형재. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
   
    var selectedImage:UIImage?
    
    var user: User!
    var userId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print("userId: \(userId)")
        fetchUser()
        
        if(textField.isEditable == true)
        {
            textField.isEditable = false
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectProfileImage))
        profileImage.addGestureRecognizer(tapGesture)
        profileImage.isUserInteractionEnabled = true
        // Do any additional setup after loading the view.
    }
    
    func fetchUser() {
        Api.User.observeCurrentUser { (user) in
                self.user = user
                self.navigationItem.title = user.username
                self.updateView()
            }
        }
    
    func updateView() {
        self.nameLabel.text = user.username
        self.idLabel.text = user.email
        if let photoUrlString = user.profileImageUrl {
            if let photoUrl = URL(string: photoUrlString) //if 빼야함
            {
                print(photoUrl)
            } //photo부분 아직 덜함
            //self.profileImage.image(with: photoUrl)
        }
    }
    
    @objc func handleSelectProfileImage() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func edit_Button(_ sender: Any) {
        textField.isEditable = true
    }
    @IBAction func changeImage_Button(_ sender: Any) {
    }
    @IBAction func saveText_Button(_ sender: Any) {
    }
    
    @IBAction func logOut_Button(_ sender: Any) {
        //print(Auth.auth().currentUser)
        do{
            try Auth.auth().signOut()
        } catch let logoutError{
            print(logoutError)
        }
        //print(Auth.auth().currentUser)
        
        let storyboard = UIStoryboard(name: "Start", bundle: nil)
        let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
        self.present(signInVC, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
}

    extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
            print("did Finish Picking Media")
            if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage{
                selectedImage = image
                profileImage.image = image
            }
            dismiss(animated: true, completion: nil)
        }
    }
