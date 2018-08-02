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
    
    
    var selectedImage: UIImage?
    
    var user: User!
    var userId = ""
    var userIntroduce:String = ""
    
    var posts = [Post]()
    var selectedCellId: String?
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUser()
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 100
        textField.isUserInteractionEnabled = false
        
        
        fetchUser()
        fetchMyPosts()
        
       
        
        let bottomLayer = CALayer()
        bottomLayer.frame = CGRect(x: 0, y: -10, width: 1000, height: 0.6)
         bottomLayer.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
        
        
        adjustTextViewHeight(textView: textField)


 
        
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
                self.posts.insert(post, at:0)
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


    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PostViewController" {
            let vc = segue.destination as! PostViewController
            vc.postId = self.selectedCellId
        }
    }
    
}


extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    //내가 쓴 글 label
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let subview = UIView()
        subview.backgroundColor = .lightGray
        subview.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50)
        let listLabel = UILabel()
        listLabel.text = "내가 쓴 글"
        listLabel.textAlignment = .left
        listLabel.textColor = .black
        listLabel.font = UIFont.systemFont(ofSize: 17)
        
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
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if (editingStyle == UITableViewCellEditingStyle.delete) {
//            let deleteCell = posts[indexPath.row]
//            Api.Post.REF_POSTS.child(deleteCell.id!).removeValue()
//            Api.MyPosts.REF_MYPOSTS.child(self.user.uid!).child(deleteCell.id!).removeValue()
//
//        }
//    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let doNotWanted = doNotWantedAction(at: indexPath)
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [doNotWanted, delete])
    }
    
    
    func doNotWantedAction(at indexPath: IndexPath) -> UIContextualAction {
        let selectedCell = posts[indexPath.row]
        if selectedCell.wanted! {
            let action = UIContextualAction(style: .normal, title: "Do Not Wanted", handler: {(action, view, completion) in
                let cellId = selectedCell.id
                Api.Post.REF_POSTS.child(cellId!).child("wanted").setValue(false, withCompletionBlock: { err,ref  in
                    if err != nil {
                        ProgressHUD.showError(err?.localizedDescription)
                        return
                    }
                    self.posts[indexPath.row].wanted = false
                    self.tableView.reloadRows(at: [indexPath], with: .left)
                    completion(true)
                })

            })
            return action
        } else {
            let action = UIContextualAction(style: .normal, title: "Wanted", handler: {(action, view, completion) in
                let cellId = selectedCell.id
                Api.Post.REF_POSTS.child(cellId!).child("wanted").setValue(true, withCompletionBlock: { err,ref  in
                    if err != nil {
                        ProgressHUD.showError(err?.localizedDescription)
                        return
                    }
                    self.posts[indexPath.row].wanted = true
                    self.tableView.reloadRows(at: [indexPath], with: .left)
                    completion(true)
                })
                
            })
            return action
        }
    
    }
    
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let deleteCell = posts[indexPath.row]
        let action = UIContextualAction(style: .destructive, title: "Delete", handler: {(action, view, completion) in
            Api.Post.REF_POSTS.child(deleteCell.id!).removeValue()
            Api.MyPosts.REF_MYPOSTS.child(self.user.uid!).child(deleteCell.id!).removeValue()
            completion(true)
            })
        return action
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

