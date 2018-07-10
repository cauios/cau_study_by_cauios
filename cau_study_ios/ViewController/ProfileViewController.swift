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
    @IBOutlet weak var myListLabel: UILabel!
    @IBOutlet weak var saveTextButton: UIButton!
    
    var selectedImage:UIImage?
    
    var user: User!
    var userId = ""
    var userIntroduce:String = ""
    
    var posts: [Post]!
    
    let ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUser()
        fetchMyPosts()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectProfileImage))
        profileImage.addGestureRecognizer(tapGesture)
        profileImage.isUserInteractionEnabled = true
        
        let bottomLayer = CALayer()
        bottomLayer.frame = CGRect(x: 0, y: -10, width: 1000, height: 0.6)
         bottomLayer.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
        myListLabel.layer.addSublayer(bottomLayer)
        textField.isEditable = true
        //saveTextButton.isEnabled = false;
    }
    
    func fetchUser() {
        Api.User.observeCurrentUser { (user) in
                self.user = user
                self.navigationItem.title = user.username
                self.userIntroduce = user.introduceMyself!
                self.textField.text = self.userIntroduce
                self.updateView()
            }
        
        
        }
    
    
    func fetchMyPosts() {
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        
        Api.MyPosts.REF_MYPOSTS.child(currentUser.uid).observe(.childAdded, with: {snapshot in
            Api.Post.observePost(withId: snapshot.key, completion: {post in
                self.posts.append(post)
                // 데이터 리로드 필요한데... 벗 그 뭐냐 테이블뷰를 잡아야해
            })
        
        })
        
    }
    
    func updateView() {
        self.idLabel.text = user.email
        if let photoUrlString = user.profileImageUrl {
            let photoUrl = URL(string: photoUrlString)
            self.profileImage.sd_setImage(with: photoUrl)
        }
    }
    
    @objc func handleSelectProfileImage() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
        
        
        
        
        /* 사진 업데이트 부분 문제 발생
        let newProfileImg = selectedImage
        if let imageData = UIImageJPEGRepresentation(newProfileImg!, 0.1){
            let storageRef = Storage.storage().reference(forURL: Config.STORAGE_ROOF_REF).child("profile_image").child(user.id!)
         
                storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        return
                    }
                    let profileImageUrl = metadata?.downloadURL()?.absoluteString
                    let usersReference = self.ref.child("users")
                    let newUserReference = usersReference.child(self.user.id!)
                    newUserReference.updateChildValues(["profileImageUrl": profileImageUrl!])
         })
        }*/
    }
    
    @IBAction func viewListAllButton(_ sender: Any) {
        //내가 쓴글 전체보기
    }
    
    @IBAction func saveText_Button(_ sender: Any) {
        self.userIntroduce = self.textField.text
        user.introduceMyself = self.userIntroduce
        let usersReference = self.ref.child("users")
        let newUserReference = usersReference.child(user.id!)
        newUserReference.updateChildValues(["introduceMyself": user.introduceMyself!])
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
