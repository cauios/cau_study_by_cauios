//
//  WritingViewController.swift
//  cau_study_ios
//
//  Created by Davee on 2018. 3. 10..
//  Copyright © 2018년 신형재. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth


// [0729 Dahye] For set allCate after dismiss
protocol dismissHandler {
    func showAllCateAfterDismiss()
}

//
class WritingViewController: UIViewController, dismissHandler {
    
    // [0729 Dahye]
    let segSelected = 1
    var delegate: dismissHandler?

    
    // [0729 Dahye]
    func showAllCateAfterDismiss() {
  
    }
    
    
    // Outlets
    

    @IBOutlet weak var titleTextField: UITextField!
    //@IBOutlet weak var categoryTextField: UITextField!

    @IBOutlet weak var tagsTextField: UITextField!
    @IBOutlet weak var numOfVacanTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var uploadButton: UIBarButtonItem!
    
    // [0731 Dahye] About category buttons
    var selectedCate = 1
    
    @IBOutlet weak var acaCateWtButton: UIButton!
    @IBOutlet weak var empCateWtButton: UIButton!
    @IBOutlet weak var lanCateWtButton: UIButton!
    
    @IBAction func acaCateWtTouchUpInside(_ sender: Any) {
        selectedCate = 1
        acaCateWtButton.setBackgroundImage(UIImage(named: "bluebutton"), for: .normal)
        empCateWtButton.setBackgroundImage(UIImage(named: "greybutton"), for: .normal)
        lanCateWtButton.setBackgroundImage(UIImage(named: "greybutton"), for: .normal)
    }
    @IBAction func empCateWtTouchUpInside(_ sender: Any) {
        selectedCate = 2
        acaCateWtButton.setBackgroundImage(UIImage(named: "greybutton"), for: .normal)
        empCateWtButton.setBackgroundImage(UIImage(named: "pinkbutton"), for: .normal)
        lanCateWtButton.setBackgroundImage(UIImage(named: "greybutton"), for: .normal)
    }
    @IBAction func lanCateWtTouchUpInside(_ sender: Any) {
        selectedCate = 3
        acaCateWtButton.setBackgroundImage(UIImage(named: "greybutton"), for: .normal)
        empCateWtButton.setBackgroundImage(UIImage(named: "greybutton"), for: .normal)
        lanCateWtButton.setBackgroundImage(UIImage(named: "yellowbutton"), for: .normal)
    }
    
    // Declare this to show the timestamp
    let timestamp = Int(Date().timeIntervalSince1970)
    
    // Buttons
    @IBAction func uploadButton_Click(_ sender: Any) {
        print("Uploaded")
        view.endEditing(true) // [Dahye Comment] dismiss the keyboard right away, after users hit the upload button. If the keyboard doesn't cover the share button.
        ProgressHUD.show("Waiting...", interaction: false) // [D.C] when user hit the button, this message will show up first to present it's in the middle of processing
        self.sendDataToDatabase()
        // [0807] Mute this function call because it works with viewWillDisappear too.
//        if delegate != nil {
//            delegate?.showAllCateAfterDismiss()
//        }
        self.dismiss(animated: true, completion: nil)
        

    }
    
    func sendDataToDatabase() {
        let ref = Database.database().reference()
        let postsReference = ref.child("posts") // DB location to reference all the post
        let newPostId = postsReference.childByAutoId().key // all posts child 들의 string description. To uniquely identify child location of the all post reference. key property of this child FB reference produces sort of its relative path or id in string format.
        let newPostReference = postsReference.child(newPostId) // child node of the location of posts
        // 여기까지 함으로써, we can tell the system that the new post location will be a child node of the all post location with this string id.
        // DB location 확보 완료!!
        // we will simply put data on the location 'newPostId'
        // the stored data should be dict
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        let currentUserId = currentUser.uid
        
        
        let words = tagsTextField.text?.components(separatedBy: CharacterSet.whitespacesAndNewlines)
        
        for var word in words! {
            if word.hasPrefix("#"){
                word = word.trimmingCharacters(in: CharacterSet.punctuationCharacters)
                let newHasfTagReF = Api.HashTag.REF_HASHTAG.child(word.lowercased())
                newHasfTagReF.updateChildValues([newPostId: true])
            }
        }
        // [0728 Dahye] constants for adding newPostId into ecah category node
        let postIntoCateAca = Api.Category.REF_CATEGORY_ACADEMIC
        let postIntoCateEmpl = Api.Category.REF_CATEGORY_EMPLPREP
        let postIntoCateLan = Api.Category.REF_CATEGORY_LANGUAGE
        
        
        var categoryText = ""
        

        if selectedCate == 1 {
            categoryText = "학업"
            postIntoCateAca.updateChildValues([newPostId: true]) // [0728 Dahye] Add info of postId into Category node on DB
            
        }
        else if selectedCate == 2 {
            categoryText = "취업"
            postIntoCateEmpl.updateChildValues([newPostId: true]) // [0728 Dahye] Add info of postId into Category node on DB
        }
        else if selectedCate == 3 {
            categoryText = "어학"
            postIntoCateLan.updateChildValues([newPostId: true]) // [0728 Dahye] Add info of postId into Category node on DB
        }

        
        // [0726] Dahye: Codes related to the timestamp are added this moment
        // value of "timestamp" would be self.timestamp or timestamp
        
        newPostReference.setValue(["uid": currentUserId, "title": titleTextField.text!, "category": categoryText, "tags": tagsTextField.text!, "numOfVacan": numOfVacanTextField.text!, "time": timeTextField.text!, "location": locationTextField.text!, "description": descriptionTextView.text!, "timestamp": timestamp, "wanted": true ], withCompletionBlock: {
            (error, ref) in
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                return // withCompletionBlock closure에서 한 것은, if we failed to push this url on the DB, we'll recieve a non zero error object. If we catch the error, we can simply report that to the user as we did before using ProgressHUD.showError method.
            }
            
            
            //민정
            let myPostRef = Api.MyPosts.REF_MYPOSTS.child(currentUserId).child(newPostId)
            myPostRef.setValue(true, withCompletionBlock: {(error,ref) in
                if error != nil {
                    ProgressHUD.showError(error!.localizedDescription)
                    return
                }
            
            })
            
            
            ProgressHUD.showSuccess("Sucess")
            
            // [Dahye comment] after successfully push the writing data into the DB, change the imageview into the placeholder image and remove the texts in the textview
            self.descriptionTextView.text = ""
            
            // [Dahye comment] after successfully push the writing data into the DB, switch to the explore view. In this case I just used the 'dimiss method'. Note that 'self.tabBarController?.selectedIndex = 0' can not switch to the explore because the connection here is 'modally'. 'self.tabBarController?.selectedIndex = 0' could work when the view is contained in the tabController.
            
        })
    }
    
    @IBAction func cancelButtonClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    var selectedImage: UIImage?
    //var selectedTitle: UITextField?
    
    override func viewDidLoad() {
        navigationController?.navigationBar.barTintColor = UIColor(red: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1.0)
        super.viewDidLoad()
        uploadButton.isEnabled = false
        handleTextField()
        
        acaCateWtButton.setBackgroundImage(UIImage(named: "bluebutton"), for: .normal)
        empCateWtButton.setBackgroundImage(UIImage(named: "greybutton"), for: .normal)
        lanCateWtButton.setBackgroundImage(UIImage(named: "greybutton"), for: .normal)
    }
    
    // [Dahye comment] The great place to call the method 'handlePost()'(the one implemented right below) is 'viewWillAppear' method. Note that this 'viewWillAppear' method is repeatable, thus it can be re-called whenever the view will appear.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barTintColor = UIColor(red: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1.0)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if delegate != nil {
            delegate?.showAllCateAfterDismiss()
        }
    }
    
    // [Dahye comment] Implement this method, to set the condtion where the 'upload' button can be activated. I set only when all components of the writing view have to be filled in, users can upload the post. When the button is light blue, it means it's activated and when it is lightgray it means it's disabled. Using handleTextField() method and textFieldDidChange introduced in Lec.34(from 5:28 ~). ***Note that*** description hasn't been contained here. We should fix it later.
    


    
    func handleTextField() {
        titleTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControlEvents.editingChanged)
        tagsTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControlEvents.editingChanged)
        numOfVacanTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControlEvents.editingChanged)
        timeTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControlEvents.editingChanged)
        locationTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControlEvents.editingChanged)
    }
    
    @objc func textFieldDidChange() {
         guard let titleText = titleTextField.text, !titleText.isEmpty, let tagsText = tagsTextField.text, !tagsText.isEmpty, let numOfVacanText = numOfVacanTextField.text, !numOfVacanText.isEmpty, let timeText = timeTextField.text, !timeText.isEmpty, let locationText = locationTextField.text, !locationText.isEmpty
            else {
            uploadButton.tintColor = .lightGray
            uploadButton.isEnabled = false
            return
        }
        uploadButton.tintColor = UIColor(red: 0.0, green: 122/255, blue: 1.0, alpha: 1)
        uploadButton.isEnabled = true
        //ProgressHUD.showError("All blanks must be filled in2")
        
    }
    

    
    // [Dahye comment] When user finished with typing, hide the keyboard right away. This method detects the touch on the view, then resgin the first responder if there is a touch.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension WritingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

}
