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
    var serviceList = ["공지사항","FAQ 도움말","문의 피드백 보내기"]
    var list = ["프로필 변경","비밀번호 변경","로그아웃","계정 탈퇴"]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }

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
    
    //how many sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    // how many cells in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return serviceList.count
        } else {
            return list.count
        }
    }
 
    // cell contents
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserSettingTableViewCell", for: indexPath) as! UserSettingTableViewCell
            let labelList = serviceList[indexPath.row]
            cell.function.text = labelList
            return cell
        } else  {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserSettingTableViewCell", for: indexPath) as! UserSettingTableViewCell
            let labelList = list[indexPath.row]
            cell.function.text = labelList
            return cell
        }

    }
    // section header
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "서비스 이용"
        } else {
            return "계정 설정"
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = list[indexPath.row]
        if selectedCell == "계정 탈퇴" {
            performSegue(withIdentifier: "DeleteUserViewController", sender: selectedCell)
        } else if selectedCell == "비밀번호 변경" {
            performSegue(withIdentifier: "ChangePasswordViewController", sender: selectedCell)
        } else if selectedCell == "프로필 변경" {
            performSegue(withIdentifier: "ChangeProfileViewController", sender: selectedCell)
            
        } else if selectedCell == "로그아웃" {
            
        }
    }

}
