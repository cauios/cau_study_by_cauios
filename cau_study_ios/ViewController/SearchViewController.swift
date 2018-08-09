//
//  SearchViewController.swift
//  cau_study_ios
//
//  Created by Dahye on 2018. 8. 3..
//  Copyright © 2018년 신형재. All rights reserved.
// [0803 Dahye] Lectures from 59 are helpful to implement this
// [Dahye] Other exception handlers for . [ ] $ should be implemented in the future

import UIKit
import FirebaseDatabase
import FirebaseAuth
import SDWebImage

class SearchViewController: UIViewController {
    
    
    
    
    @IBOutlet weak var searchTableView: UITableView!
    
    
    
    var searchBar = UISearchBar()
    var posts = [Post]()
    var users = [User]()
    var post: Post?
    var selectedSeg: Int?
    var timer = Timer()
    let delay = 0.2
    
    //[0804]
    
    
    @IBOutlet weak var searchAllCateButton: UIButton!
    @IBOutlet weak var searchAcaCateButton: UIButton!
    @IBOutlet weak var searchEmpCateButton: UIButton!
    @IBOutlet weak var searchLanCateButton: UIButton!
    
    // [0808 Dahye]
    
    @IBOutlet weak var searchAllLineView: UIView!
    @IBOutlet weak var searchAcaLineView: UIView!
    
    @IBOutlet weak var searchEmpLineView: UIView!
    
    @IBOutlet weak var searchLanLineView: UIView!
    
    
    @IBAction func searchAllCateTUI(_ sender: Any) {
        selectedSeg = 1
        searchAllCateButton.setTitleColor(UIColor.black, for: .normal)
        searchAcaCateButton.setTitleColor(UIColor.lightGray, for: .normal)
        searchEmpCateButton.setTitleColor(UIColor.lightGray, for: .normal)
        searchLanCateButton.setTitleColor(UIColor.lightGray, for: .normal)
        searchAllLineView.backgroundColor = UIColor.darkGray
        searchAcaLineView.backgroundColor = UIColor.clear
        searchEmpLineView.backgroundColor = UIColor.clear
        searchLanLineView.backgroundColor = UIColor.clear
        posts = [Post]()
        
        let inputTag = searchBar.text!.lowercased()
        
        if inputTag == "" {
            return
        }
        // [0809 Dahye] exception handlers for "" and "#"
        if inputTag.contains("#") {
            let replacedTag = inputTag.replacingOccurrences(of: "#", with: "")
            if replacedTag == "" {
                return
            } else {
                Api.HashTag.REF_HASHTAG.child(replacedTag).observe(.childAdded, with: {
                    snapshot in
                    print(snapshot.key)
                    Api.Post.observePost(withId: snapshot.key, completion: { post in
                        
                        self.posts.insert(post, at: 0)
                        self.searchTableView.reloadData()
                    })
                })
            }
        }
            
        else {
            Api.HashTag.REF_HASHTAG.child(inputTag).observe(.childAdded, with: {
                snapshot in
                print(snapshot.key)
                Api.Post.observePost(withId: snapshot.key, completion: { post in
                    
                    self.posts.insert(post, at: 0)
                    self.searchTableView.reloadData()
                })
            })
        }
        
        searchTableView.reloadData()
        
    }
    
    
    
    @IBAction func searchAcaCateTUI(_ sender: Any) {
        selectedSeg = 2
        searchAllCateButton.setTitleColor(UIColor.lightGray, for: .normal)
        searchAcaCateButton.setTitleColor(UIColor.black, for: .normal)
        searchEmpCateButton.setTitleColor(UIColor.lightGray, for: .normal)
        searchLanCateButton.setTitleColor(UIColor.lightGray, for: .normal)
        searchAllLineView.backgroundColor = UIColor.clear
        searchAcaLineView.backgroundColor = UIColor.darkGray
        searchEmpLineView.backgroundColor = UIColor.clear
        searchLanLineView.backgroundColor = UIColor.clear
        posts = [Post]()
        self.searchTableView.reloadData()
        loadAcaPost()
    }
    
    
    @IBAction func searchEmpCateTUI(_ sender: Any) {
        selectedSeg = 3
        searchAllCateButton.setTitleColor(UIColor.lightGray, for: .normal)
        searchAcaCateButton.setTitleColor(UIColor.lightGray, for: .normal)
        searchEmpCateButton.setTitleColor(UIColor.black, for: .normal)
        searchLanCateButton.setTitleColor(UIColor.lightGray, for: .normal)
        searchAllLineView.backgroundColor = UIColor.clear
        searchAcaLineView.backgroundColor = UIColor.clear
        searchEmpLineView.backgroundColor = UIColor.darkGray
        searchLanLineView.backgroundColor = UIColor.clear
        posts = [Post]()
        self.searchTableView.reloadData()
        loadEmpPost()
    }
    
    
    
    @IBAction func searchLanCateTUI(_ sender: Any) {
        selectedSeg = 4
        searchAllCateButton.setTitleColor(UIColor.lightGray, for: .normal)
        searchAcaCateButton.setTitleColor(UIColor.lightGray, for: .normal)
        searchEmpCateButton.setTitleColor(UIColor.lightGray, for: .normal)
        searchLanCateButton.setTitleColor(UIColor.black, for: .normal)
        searchAllLineView.backgroundColor = UIColor.clear
        searchAcaLineView.backgroundColor = UIColor.clear
        searchEmpLineView.backgroundColor = UIColor.clear
        searchLanLineView.backgroundColor = UIColor.darkGray
        posts = [Post]()
        self.searchTableView.reloadData()
        loadLanPost()
    }
    
    override func viewDidLoad() {
        selectedSeg = 1
        searchAllCateButton.setTitleColor(UIColor.black, for: .normal)
        searchAcaCateButton.setTitleColor(UIColor.lightGray, for: .normal)
        searchEmpCateButton.setTitleColor(UIColor.lightGray, for: .normal)
        searchLanCateButton.setTitleColor(UIColor.lightGray, for: .normal)
        searchAllLineView.backgroundColor = UIColor.darkGray
        searchAcaLineView.backgroundColor = UIColor.clear
        searchEmpLineView.backgroundColor = UIColor.clear
        searchLanLineView.backgroundColor = UIColor.clear
        super.viewDidLoad()
        searchTableView.dataSource = self
        
        
        // create and customize saerchBar
        searchBar.delegate = self // set the SearchViewController as a delegate of the searchBar, so that those implementations apply to our searchBar object.
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "관심있는 해시태그를 입력해주세요!"
        searchBar.frame.size.width = view.frame.size.width - 60
        
        let searchPost = UIBarButtonItem(customView: searchBar)
        self.navigationItem.rightBarButtonItem = searchPost
        searchTableView.reloadData()
        
        
        
    }
    
    // [Dahye comment] When user finished with typing, hide the keyboard right away. This method detects the touch on the view, then resgin the first responder if there is a touch.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    
    //[0728 Dahye] load Academic Posts
    func loadAcaPost() {
        
        let inputTag = searchBar.text!.lowercased()
        if inputTag == "" {
            return
        }
        
        if inputTag.contains("#") {
            let replacedTag = inputTag.replacingOccurrences(of: "#", with: "")
            if replacedTag == "" {
                return
            } else {
                Api.HashTag.REF_HASHTAG.child(replacedTag).observe(.childAdded, with: {
                    snapshot in
                    print(snapshot.key)
                    Api.Post.observePost(withId: snapshot.key, completion: { post in
                        if post.category == "학업" {
                            self.posts.insert(post, at: 0)
                            self.searchTableView.reloadData()
                        } else {
                            self.searchTableView.reloadData()
                        }
                    })
                })
            }
        }
            
        else {
            Api.HashTag.REF_HASHTAG.child(inputTag).observe(.childAdded, with: {
                snapshot in
                print(snapshot.key)
                Api.Post.observePost(withId: snapshot.key, completion: { post in
                    if post.category == "학업" {
                        self.posts.insert(post, at: 0)
                        self.searchTableView.reloadData()
                    } else {
                        self.searchTableView.reloadData()
                    }
                })
            })
        }
        
    }
    //
    
    //[0728 Dahye] load Employment Preperation Posts
    func loadEmpPost() {
        let inputTag = searchBar.text!.lowercased()
        if inputTag == "" {
            return
        }
        
        if inputTag.contains("#") {
            let replacedTag = inputTag.replacingOccurrences(of: "#", with: "")
            if replacedTag == "" {
                return
            } else {
                Api.HashTag.REF_HASHTAG.child(replacedTag).observe(.childAdded, with: {
                    snapshot in
                    print(snapshot.key)
                    Api.Post.observePost(withId: snapshot.key, completion: { post in
                        if post.category == "취업" {
                            self.posts.insert(post, at: 0)
                            self.searchTableView.reloadData()
                        } else {
                            self.searchTableView.reloadData()
                        }
                    })
                })
            }
        }
            
        else {
            Api.HashTag.REF_HASHTAG.child(inputTag).observe(.childAdded, with: {
                snapshot in
                print(snapshot.key)
                Api.Post.observePost(withId: snapshot.key, completion: { post in
                    if post.category == "취업" {
                        self.posts.insert(post, at: 0)
                        self.searchTableView.reloadData()
                    } else {
                        self.searchTableView.reloadData()
                    }
                })
            })
        }
    }
    
    //[0728 Dahye] load Language Posts
    func loadLanPost() {
        let inputTag = searchBar.text!.lowercased()
        if inputTag == "" {
            return
        }
        
        if inputTag.contains("#") {
            let replacedTag = inputTag.replacingOccurrences(of: "#", with: "")
            if replacedTag == "" {
                return
            } else {
                Api.HashTag.REF_HASHTAG.child(replacedTag).observe(.childAdded, with: {
                    snapshot in
                    print(snapshot.key)
                    Api.Post.observePost(withId: snapshot.key, completion: { post in
                        if post.category == "어학" {
                            self.posts.insert(post, at: 0)
                            self.searchTableView.reloadData()
                        } else {
                            self.searchTableView.reloadData()
                        }
                    })
                })
            }
        }
            
        else {
            Api.HashTag.REF_HASHTAG.child(inputTag).observe(.childAdded, with: {
                snapshot in
                print(snapshot.key)
                Api.Post.observePost(withId: snapshot.key, completion: { post in
                    if post.category == "어학" {
                        self.posts.insert(post, at: 0)
                        self.searchTableView.reloadData()
                    } else {
                        self.searchTableView.reloadData()
                    }
                })
            })
        }
    }
    
    
    
    
    func fetchUser(uid: String, completed: @escaping() -> Void) {
        Api.User.observeUser(withId: uid, completion: {
            user in
            //self.users.append(user)
            self.users.insert(user, at: 0)
            completed()})
    }
    
    // [Dahye 5.20] prepare method will be called right before the transition which is a perfect place to send the data on the destination view controller. prepare method should be implemented in the file where the performSegue is implemented. We should note that the data passed along is a string Id. So we need to convert the sender parameter of type any into string.
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchToPostSegue" {
            let postVC = segue.destination as! PostViewController
            let postId = sender as! String
            postVC.postId = postId
        }
        
    }
    
    
    func searchPost() {
        if let input = searchBar.text?.lowercased() {
            querySearchTags(searchInput: input)
        }
    }
    
    
    func querySearchTags(searchInput: String) {
        selectedSeg = 1
        posts = [Post]()
        // [0809 Dahye] exception handlers for "" and "#"
        // other exception handlers for . [ ] $ should be implemented in the future
        if searchInput == "" {
            return }
        if searchInput.contains("#") {
            let replacedInput = searchInput.replacingOccurrences(of: "#", with: "")
            if replacedInput == "" {
                return
            } else {
                Api.HashTag.REF_HASHTAG.child(replacedInput).observe(.childAdded, with: {
                    snapshot in
                    print(snapshot.key)
                    Api.Post.observePost(withId: snapshot.key, completion: { post in
                        
                        self.posts.insert(post, at: 0)
                        self.searchTableView.reloadData()
                    })
                })
            }
            
        }
            /*
             if searchInput.contains(".") {
             let replacedInput2 = searchInput.replacingOccurrences(of: ".", with: "")
             if replacedInput2 == "" {
             return
             } else {
             Api.HashTag.REF_HASHTAG.child(replacedInput2).observe(.childAdded, with: {
             snapshot in
             print(snapshot.key)
             Api.Post.observePost(withId: snapshot.key, completion: { post in
             
             self.posts.insert(post, at: 0)
             self.searchTableView.reloadData()
             })
             })
             }
             
             } */
            /*
             if searchInput.contains("[") {
             let replacedInput = searchInput.replacingOccurrences(of: "[", with: "")
             if replacedInput == "" {
             return
             } else {
             Api.HashTag.REF_HASHTAG.child(replacedInput).observe(.childAdded, with: {
             snapshot in
             print(snapshot.key)
             Api.Post.observePost(withId: snapshot.key, completion: { post in
             
             self.posts.insert(post, at: 0)
             self.searchTableView.reloadData()
             })
             })
             }
             
             }
             
             if searchInput.contains("]") {
             let replacedInput = searchInput.replacingOccurrences(of: "]", with: "")
             if replacedInput == "" {
             return
             } else {
             Api.HashTag.REF_HASHTAG.child(replacedInput).observe(.childAdded, with: {
             snapshot in
             print(snapshot.key)
             Api.Post.observePost(withId: snapshot.key, completion: { post in
             
             self.posts.insert(post, at: 0)
             self.searchTableView.reloadData()
             })
             })
             }
             
             }
             
             if searchInput.contains("$") {
             let replacedInput = searchInput.replacingOccurrences(of: "$", with: "")
             if replacedInput == "" {
             return
             } else {
             Api.HashTag.REF_HASHTAG.child(replacedInput).observe(.childAdded, with: {
             snapshot in
             print(snapshot.key)
             Api.Post.observePost(withId: snapshot.key, completion: { post in
             
             self.posts.insert(post, at: 0)
             self.searchTableView.reloadData()
             })
             })
             }
             
             } */
        else {
            Api.HashTag.REF_HASHTAG.child(searchInput).observe(.childAdded, with: {
                snapshot in
                print(snapshot.key)
                Api.Post.observePost(withId: snapshot.key, completion: { post in
                    
                    self.posts.insert(post, at: 0)
                    self.searchTableView.reloadData()
                })
            })
        }
        searchTableView.reloadData()
    }
    
}

// adopt searchBar protocol
extension SearchViewController: UISearchBarDelegate {
    
    // handle search request after users hit the search button
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchAllCateButton.sendActions(for: .touchUpInside)
        //  searchPost()
    }
    
    // using this method, we'll be able to be aware of what users type in so we can query seach in real time.
    // any time user type in or delete letter, textDidChange is called so it's very good for real time query
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // searchPost()
        searchAllCateButton.sendActions(for: .touchUpInside)
    }
}

extension SearchViewController: SearchTableViewCellDelegate {
    
    // [Dahye 05.20] this sender will actually be passed to prepare for segue method.
    func openPostVC(postId: String) {
        performSegue(withIdentifier: "SearchToPostSegue", sender: postId)
        
    }
    
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedSeg == 1 {
            print(posts.count, "count all")
            return posts.count
        }
        if selectedSeg == 2 {
            
            print(posts.count, "count aca")
            return posts.count
        }
        if selectedSeg == 3 {
            print(posts.count, "count emp")
            return posts.count
        }
        if selectedSeg == 4 {
            print(posts.count, "count lan")
            return posts.count
        } else {
            print("return nothing")
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchTableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchTableViewCell
        let cell2 = searchTableView.dequeueReusableCell(withIdentifier: "SearchAcaCell", for: indexPath) as! SearchTableViewCell
        let cell3 = searchTableView.dequeueReusableCell(withIdentifier: "SearchEmpCell", for: indexPath) as! SearchTableViewCell
        let cell4 = searchTableView.dequeueReusableCell(withIdentifier: "SearchLanCell", for: indexPath) as! SearchTableViewCell
        let post = posts[indexPath.row]
        
        
        
        if selectedSeg == 1 {
            cell.post = post
            print("cell")
            cell.delegate = self
            print("cell.deleg")
            return cell
        }
        if selectedSeg == 2 {
            cell2.post = post
            print("cell2")
            cell2.delegate = self
            print("cell2.deleg")
            return cell2
        }
        if selectedSeg == 3 {
            cell3.post = post
            print("cell3")
            cell3.delegate = self
            print("cell3,deleg")
            return cell3
        } else {
            cell4.post = post
            print("cell4")
            cell4.delegate = self
            print("cell4.deleg")
            return cell4
        }
    }
    
    
}
