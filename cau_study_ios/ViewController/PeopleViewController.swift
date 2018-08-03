//
//  PeopleViewController.swift
//  cau_study_ios
//
//  Created by 신형재 on 14/07/2018.
//  Copyright © 2018 신형재. All rights reserved.
//
import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import SnapKit

//현재 사용하지 않는 기능임...참고용
class PeopleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    var tableview : UITableView!
    var userModels = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableview = UITableView()
        tableview.delegate=self
        tableview.dataSource=self
        tableview.register(PeopleViewTableViewCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(tableview)
        tableview.snp.makeConstraints{ (m) in
            m.top.equalTo(view)
            m.bottom.left.right.equalTo(view)
        }

        /* Database.database().reference().child("users").observeSingleEvent(of: DataEventType.value, with: {
         snapshot in
         self.array.removeAll() //중복되는 데이터 막기위해서 지우고 다시시작

         for _ in snapshot.children{
         if let dict = snapshot.value as? [String:Any]{
         let userModel = User.transformUser(dict: dict, key: snapshot.key)
         self.array.append(userModel) //데이터가 쌓인다
         }
         }
         DispatchQueue.main.async {//갱신되게 하는 코드
         self.tableview.reloadData()
         }

         })
         삭제할코드*/
        //let myUid = Auth.auth().currentUser?.uid

        Api.User.observeUsers(completion: {
            user in
            //if(user.uid == myUid){ 대화창에 내가 안떠야하는데 코드를 수정했더니 이부분 구현이 곤란한 상황!
            //   continue
            //}
            self.userModels.append(user)
            //print(user.username)//디버그용
            //completion()
            DispatchQueue.main.async {//갱신되게 하는 코드
                self.tableview.reloadData()
            }
        })

    }
    /*
    func fetchUser(uid: String, completed: @escaping() -> Void) {
        Api.User.observeUser(withId: uid, completion: {
            user in
            self.array.append(user)
            completed()})
    }*/

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userModels.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let view = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as? ChatViewController
        view?.destinationUid = self.userModels[indexPath.row].uid
        self.navigationController?.pushViewController(view!, animated: true)
    }//셀이 눌렸을때 동작 정의

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "Cell", for :indexPath) as! PeopleViewTableViewCell


        let imageview = cell.imageview!
        imageview.snp.makeConstraints{ (m) in
            m.centerY.equalTo(cell)
            m.left.equalTo(cell).offset(10)
            m.height.width.equalTo(50)
        }


        URLSession.shared.dataTask(with: URL(string: userModels[indexPath.row].profileImageUrl!)!) {
            (data, response, err) in
            DispatchQueue.main.async {
                imageview.image = UIImage(data: data!)

                imageview.layer.cornerRadius = imageview.frame.size.width/2
                imageview.clipsToBounds = true
                //동그랗게 사진만들기
            }
            }.resume() //일시중단된경우 task를 다시 시작합니다.

        let label = cell.label!
        label.snp.makeConstraints{ (m) in
            m.centerY.equalTo(cell)
            m.left.equalTo(imageview.snp.right).offset(30)
        }
        label.text = userModels[indexPath.row].username
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }//테이블당 높이








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
