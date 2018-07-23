//
//  UserSettingViewController.swift
//  cau_study_ios
//
//  Created by CAUAD19 on 2018. 7. 22..
//  Copyright © 2018년 신형재. All rights reserved.
//

import UIKit

class UserSettingViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var list = ["비밀번호 변경","계정 탈퇴"]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "DeleteUserViewController" {
//
//        }
//    }


}
extension UserSettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserSettingTableViewCell", for: indexPath) as! UserSettingTableViewCell
        let labelList = list[indexPath.row]
        cell.function.text = labelList
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = list[indexPath.row]
        if selectedCell == "계정 탈퇴" {
            performSegue(withIdentifier: "DeleteUserViewController", sender: selectedCell)
        }
    }

}
