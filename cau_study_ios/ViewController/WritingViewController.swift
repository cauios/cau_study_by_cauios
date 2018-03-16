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

class WritingViewController: UIViewController {


    // Outlets
    
    @IBOutlet weak var writingScrollView: UIScrollView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var objectivesTextField: UITextField!
    @IBOutlet weak var eligibilityTextField: UITextField!
    @IBOutlet weak var durationTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var numOfVacanTextField: UITextField!
    @IBOutlet weak var contactTextField: UITextField!
    @IBOutlet weak var writingImageView: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    
    // Buttons
    @IBAction func uploadButton_Click(_ sender: Any) {
        view.endEditing(true) // [Dahye Comment] dismiss the keyboard right away, after users hit the upload button. If the keyboard doesn't cover the share button.
        ProgressHUD.show("Waiting...", interaction: false)
        if let profileImg = self.selectedImage, let imageData = UIImageJPEGRepresentation(profileImg, 0.1) {
            let photoIdString = NSUUID().uuidString
            print(photoIdString)
            let storageRef = Storage.storage().reference(forURL: Config.STORAGE_ROOF_REF).child("posts").child(photoIdString)
            storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    ProgressHUD.showError(error!.localizedDescription)
                    return
                }
                let photoUrl = metadata?.downloadURL()?.absoluteString
                self.sendDataToDatabase(photoUrl: photoUrl!)
                
            })
        } else {
            ProgressHUD.showError("Profile Image can't be empty")
        }
    }
    
    func sendDataToDatabase(photoUrl: String) {
        let ref = Database.database().reference()
        let postsReference = ref.child("posts")
        let newPostId = postsReference.childByAutoId().key
        let newPostReference = postsReference.child(newPostId)
        newPostReference.setValue(["title": titleTextField.text!, "category": categoryTextField.text!, "objectives": objectivesTextField.text!, "eligibility": eligibilityTextField.text!, "duration": durationTextField.text!, "location": locationTextField.text!, "numOfVacan": numOfVacanTextField.text!, "contact": contactTextField.text!, "photoUrl": photoUrl, "description": descriptionTextView.text! ], withCompletionBlock: {
            (error, ref) in
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            ProgressHUD.showSuccess("Sucess")
            
            // [Dahye comment] after successfully push the writing data into the DB, change the imageview into the placeholder image and remove the texts in the textview
            self.descriptionTextView.text = ""
            self.writingImageView.image = UIImage(named: "Placeholder-image")
            
            // [Dahye comment] after successfully push the writing data into the DB, switch to the explore view. In this case I just used the 'dimiss method'. Note that 'self.tabBarController?.selectedIndex = 0' can not switch to the explore because the connection here is 'modally'. 'self.tabBarController?.selectedIndex = 0' could work when the view is contained in the tabController.
            
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    @IBAction func cancelButtonClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectWritingImageView))
        writingImageView.addGestureRecognizer(tapGesture)
        writingImageView.isUserInteractionEnabled = true
    
        
        // Do any additional setup after loading the view.
    }
    
    
    
    // [Dahye comment] When user finished with typing, hide the keyboard right away. This method detects the touch on the view, then resgin the first responder if there is a touch.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    @objc func handleSelectWritingImageView() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension WritingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("did Finish Picking Media")
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImage = image
            writingImageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}
