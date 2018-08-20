//
//  WebViewController.swift
//  cau_study_ios
//
//  Created by CAUAD28 on 2018. 8. 20..
//  Copyright © 2018년 신형재. All rights reserved.
//

import UIKit
import WebKit
class WebViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let url = URL(string: "https://cauios.github.io/cau_study_by_cauios/")
        let request = URLRequest(url: url!)
        webView.load(request)

    }

   

}
