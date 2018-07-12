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
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var idLabel: UILabel!
    
    @IBOutlet weak var changeTextButton: UIButton!
    @IBOutlet weak var saveTextButton: UIButton!
    
    var selectedImage: UIImage?
    
    var user: User!
    var userId = ""
    var userIntroduce:String = ""
    
    var posts: [Post]!
    var test: [String] = ["1","2"]
    
    let ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableHeaderView = headerView
        textField.isUserInteractionEnabled = false
        
        fetchUser()
        fetchMyPosts()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectProfileImage))
        profileImage.addGestureRecognizer(tapGesture)
        profileImage.isUserInteractionEnabled = true
        
        let bottomLayer = CALayer()
        bottomLayer.frame = CGRect(x: 0, y: -10, width: 1000, height: 0.6)
         bottomLayer.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
        
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

    }
    
    func profileImageChange() {
        ProgressHUD.show("Waiting...", interaction: false)
        
        if let newProfileImg = selectedImage, let currentUserUid = Auth.auth().currentUser?.uid, let imageData = UIImageJPEGRepresentation(newProfileImg, 0.1) {
            
            Api.User.changeProfileImage(currentUserUid: currentUserUid, imageData: imageData, onSuccess: {
                ProgressHUD.showSuccess("Success")
                print("서비스")
            }, onError: {(errorString) in
                ProgressHUD.showError(errorString!)
            })
            
        }

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
                self.selectedImage = image
                self.profileImage.image = image
                
            }
            dismiss(animated: true, completion: nil)
            profileImageChange()
            //profileImage.image = selectedImage
            
            //fetchUser()
            print("profileImage",user.profileImageUrl)
            //error-> 처음 변경시도 했을때 안됨. 두번째 변경하고 나서 이전에 선택했던 이미지가 들어가있음 => 뷰로드 문제인듯!!!!!!!!!!!!!!!! 시간 차인가....
        }
    }


extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    //내가 쓴 글 label
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let subview = UIView()
        subview.backgroundColor = .red
        subview.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50)
        let listLabel = UILabel()
        listLabel.text = "내가 쓴 글"
        listLabel.textAlignment = .left
        listLabel.textColor = .black
        listLabel.font = UIFont.systemFont(ofSize: 15)
        
        subview.addSubview(listLabel)
        listLabel.translatesAutoresizingMaskIntoConstraints = false
        listLabel.heightAnchor.constraint(equalToConstant: 200).isActive = true
        listLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        listLabel.centerXAnchor.constraint(equalTo: listLabel.superview!.centerXAnchor).isActive = true
        listLabel.centerYAnchor.constraint(equalTo: listLabel.superview!.centerYAnchor).isActive = true

        
        return subview
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyPostsTableViewCell", for: indexPath) //as! MyPostsTableViewCell
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
}
