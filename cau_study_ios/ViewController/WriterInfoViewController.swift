//
//  WriterInfoViewController.swift
//  cau_study_ios
//
//  Created by CAUAD30 on 2018. 7. 30..
//  Copyright © 2018년 신형재. All rights reserved.
//

import UIKit

class WriterInfoViewController: UIViewController {
    
    var user: User!
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var username: UILabel!
    
    var posts = [Post]()
    var selectedCellId: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        textField.isEditable = false
        fetchUser()
        makeProfileImageCircle()
        fetchUserPosts()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        
        adjustTextViewHeight(textView: textField)

       
    }
    func makeProfileImageCircle() {
        self.profileImage.layer.cornerRadius = self.profileImage.bounds.size.width / 2.0
        profileImage.clipsToBounds = true
        
    }
    
    
    func fetchUser() {
        self.username.text = user.username
        self.textField.text = user.introduceMyself
        if let photoUrlString = user.profileImageUrl {
            let photoUrl = URL(string: photoUrlString)
            self.profileImage.sd_setImage(with: photoUrl)
        }
    }
    
    
    func fetchUserPosts() {
        Api.MyPosts.REF_MYPOSTS.child(user.uid!).observe(.childAdded, with: {snapshot in
            Api.Post.observeMyPosts(withId: snapshot.key, completion: {post in
                self.posts.insert(post, at:0)
                self.tableView.reloadData()
                
            })
        })
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
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PostViewController" {
            let vc = segue.destination as! PostViewController
            vc.postId = self.selectedCellId
        }
    }

}

extension WriterInfoViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WriterPostsTableViewCell", for: indexPath) as! WriterPostsTableViewCell
        let post = posts[indexPath.row]
        cell.post = post
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = posts[indexPath.row]
        print("cellTouched")
        if let selectedCellId = selectedCell.id {
            self.selectedCellId = selectedCellId
            performSegue(withIdentifier: "PostViewController", sender: self)
        
        }
    }
    
    
    
}

