//
//  WritingViewController.swift
//  cau_study_ios
//
//  Created by Davee on 2018. 3. 10..
//  Copyright © 2018년 신형재. All rights reserved.
//

import UIKit

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
    @IBOutlet weak var DescriptionTextView: UITextView!
    
    
    // Buttons
    
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
