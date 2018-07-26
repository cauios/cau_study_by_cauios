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
    @IBOutlet weak var cancelTextButton: UIButton!
    
    
    var selectedImage: UIImage?
    
    var user: User!
    var userId = ""
    var userIntroduce:String = ""
    
    var posts = [Post]()
    var selectedCellId: String?
    
    let ref = Database.database().reference()
    
    //자기소개 글자수 제한
    let textLimitLength = 100
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 100
        textField.isUserInteractionEnabled = false
        
        
        fetchUser()
        fetchMyPosts()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectProfileImage))
        profileImage.addGestureRecognizer(tapGesture)
        profileImage.isUserInteractionEnabled = true
        
        let bottomLayer = CALayer()
        bottomLayer.frame = CGRect(x: 0, y: -10, width: 1000, height: 0.6)
         bottomLayer.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
        
        
        adjustTextViewHeight(textView: textField)
        textField.isEditable = true
        disableTextFieldChanged()
 
        
    }
    
    //다이나믹 헤더뷰
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let dynamicHeaderView = tableView.tableHeaderView else {
            return
        }
        let size = dynamicHeaderView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        if dynamicHeaderView.frame.size.height != size.height {
            dynamicHeaderView.frame.size.height = size.height
        }
        tableView.tableHeaderView = dynamicHeaderView
        tableView.layoutIfNeeded()
    }
    

    
    //다이나믹 텍스트뷰
    func adjustTextViewHeight(textView: UITextView) {
        let newSize = textView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat.greatestFiniteMagnitude))
        textView.frame.size = CGSize(width: max(newSize.width, textView.frame.width), height: newSize.height)
        textView.isScrollEnabled = false
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
        //추가된 포스트 리로드
        Api.MyPosts.REF_MYPOSTS.child(currentUser.uid).observe(.childAdded, with: {snapshot in
            print(snapshot.key)
            Api.Post.observeMyPosts(withId: snapshot.key, completion: {post in
                self.posts.append(post)
                self.tableView.reloadData()
                
            })
            
        
        })
        //삭제된 포스트 리로드
        Api.MyPosts.REF_MYPOSTS.child(currentUser.uid).observe(.childRemoved, with: {snap in
            let snapId = snap.key
            if let index = self.posts.index(where: {(item)-> Bool in item.id == snapId}) {
                self.posts.remove(at: index)
                self.tableView.reloadData()
            }
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
    //프로필 이미지 변경
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
    
    //자기소개 변경
    @IBAction func changeText_Button(_ sender: Any) {
        enableTextFieldChanged()
        
    }
    
    //자기소개 저장
    @IBAction func saveText_Button(_ sender: Any) {
        self.userIntroduce = self.textField.text
        user.introduceMyself = self.userIntroduce
        let usersReference = self.ref.child("users")
        let newUserReference = usersReference.child(user.uid!)
        newUserReference.updateChildValues(["introduceMyself": user.introduceMyself!])
        
        disableTextFieldChanged()
        adjustTextViewHeight(textView: textField)
        
        
    }
    //자기소개 취소
    @IBAction func cancel_Button(_ sender: Any) {
        disableTextFieldChanged()
        self.textField.text = self.userIntroduce
        adjustTextViewHeight(textView: textField)
        
    }
    
    
    func enableTextFieldChanged() {
        textField.isUserInteractionEnabled = true
        changeTextButton.isUserInteractionEnabled = false
        changeTextButton.backgroundColor = .white
        saveTextButton.backgroundColor = .lightGray
        cancelTextButton.backgroundColor = .lightGray
        saveTextButton.isUserInteractionEnabled = true
        cancelTextButton.isUserInteractionEnabled = true
    }
    func disableTextFieldChanged() {
        textField.isUserInteractionEnabled = false
        changeTextButton.backgroundColor = .lightGray
        changeTextButton.isUserInteractionEnabled = true
        saveTextButton.backgroundColor = .white
        cancelTextButton.backgroundColor = .white
        saveTextButton.isUserInteractionEnabled = false
        cancelTextButton.isUserInteractionEnabled = false
    }
    
    @IBAction func logOut_Button(_ sender: Any) {
        do{
            try Auth.auth().signOut()
        } catch let logoutError{
            print(logoutError)
        }
        
        let storyboard = UIStoryboard(name: "Start", bundle: nil)
        let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
        self.present(signInVC, animated: true, completion: nil)
    }
    
    @IBAction func testBtn(_ sender: Any) {

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PostViewController" {
            let cell = sender as? MyPostsTableViewCell
            let vc = segue.destination as! PostViewController
            vc.postId = self.selectedCellId
        }
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
            print("profileImage",user.profileImageUrl)
            
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
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyPostsTableViewCell", for: indexPath) as! MyPostsTableViewCell
        let post = posts[indexPath.row]
        cell.post = post
        return cell
    }
    
    //delete post
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            let deleteCell = posts[indexPath.row]
            Api.Post.REF_POSTS.child(deleteCell.id!).removeValue()
            Api.MyPosts.REF_MYPOSTS.child(self.user.uid!).child(deleteCell.id!).removeValue()
            
        }
    }
    
    
    //detail view
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = posts[indexPath.row]
        if let selectedCellId = selectedCell.id {
            self.selectedCellId = selectedCellId
            performSegue(withIdentifier: "PostViewController", sender: self)
        }
        
        
        
    }
    
}

//글자 수 제한
extension ProfileViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textField.text!
        guard let stringRange = Range(range, in: currentText) else {
            return false
        }
        let changedText = currentText.replacingCharacters(in: stringRange, with: text)
        return changedText.count <= textLimitLength
    }
}


