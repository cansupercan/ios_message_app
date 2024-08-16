//
//  MainViewController.swift
//  text
//
//  Created by imac 1682's MacBook Pro on 2024/8/6.
//

import UIKit
import RealmSwift
class MainViewController: UIViewController {
    var isAscending = true
    let realm = try! Realm()
    var table = [dog]()
    var isedit=false
    var editrow=1
    @IBOutlet weak var btnsend: UIButton!
    @IBOutlet weak var btnsort: UIButton!
    @IBOutlet weak var txvsay: UITextView!
    @IBOutlet weak var txfperson: UITextField!
    @IBOutlet weak var tbvsee: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        table = Array(realm.objects(dog.self).sorted(byKeyPath: "time", ascending: isAscending))
        print(Realm.Configuration.defaultConfiguration.fileURL!)

        
    }
    
    @IBAction func sorted(_ sender: Any) {
     
        let controller = UIAlertController(title: "排列方法", message: "選擇排列方法", preferredStyle: .actionSheet)
        let names = ["far to close", "close to far"]
        for name in names {
           let action = UIAlertAction(title: name, style: .default) { action in
               if  action.title == "far to close"{
                   self.isAscending=true
               }else{
                   self.isAscending=false
                   
               }
               self.sor()
           }
           controller.addAction(action)
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel)
        controller.addAction(cancelAction)
        present(controller, animated: true)
        
    }
    func sor() {
        let realm = try! Realm()
        
        
        table = Array(realm.objects(dog.self).sorted(byKeyPath: "time", ascending: isAscending))
        
        tbvsee.reloadData()
    }
        
      
    /*func sor(){
        let realm = try! Realm()
        if isAscending {
               table = realm.objects(dog.self).sorted(byKeyPath: "time", ascending: true)
           } else {
               table = realm.objects(dog.self).sorted(byKeyPath: "time", ascending: false)
           }
           
           //
           try! realm.write {
               for (index, dog) in table!.enumerated() {
                   dog.numbers = index + 1
               }
           }

        tbvsee.reloadData()

    }*/
    func sendm(){
        if(isedit){
            let myDog = dog()
            if let name = txfperson.text, !name.isEmpty {
                    myDog.name = name
                }
            if let say = txvsay.text, !say.isEmpty {
                    myDog.say = say
                }
            myDog.time = Date()
            let realm = try! Realm()
            let dogToEdit = realm.objects(dog.self)[editrow]
            try! realm.write {
                dogToEdit.name = myDog.name
                dogToEdit.say = myDog.say
                dogToEdit.time = myDog.time
            }
        }else{
        let myDog = dog()
        if let name = txfperson.text, !name.isEmpty {
                myDog.name = name
            }
        if let say = txvsay.text, !say.isEmpty {
                myDog.say = say
            }
        myDog.time = Date()
        let realm = try! Realm()
 
        if let maxNumber = realm.objects(dog.self).max(ofProperty: "numbers") as Int? {
                myDog.numbers = maxNumber + 1
            } else {
                // 預設為1
                myDog.numbers = 1
            }
        // 儲存 Dog 對象
        try! realm.write {
            realm.add(myDog)
        }
            
        }
    }
    func send(){
        let realm = try! Realm()
        let todos = realm.objects(dog.self)
        txfperson.text=todos[editrow].name
        txvsay.text = todos[editrow].say
        btnsend.setTitle("edit", for: .normal)
    }
    @IBAction func sendmes(_ sender: Any) {
            sendm()
            sor()
            btnsend.setTitle("send", for: .normal)
            isedit = false
            }
    func setUI(){
          tableSet()
      }
      func tableSet(){
          tbvsee.register(UINib(nibName: "TableViewCell", bundle: nil),
                          forCellReuseIdentifier: TableViewCell.identifier)
          tbvsee.delegate = self
          tbvsee.dataSource = self
          
      }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let realm = try! Realm()
        let dogCount = realm.objects(dog.self).count
        return dogCount
    }
    //更新畫面
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tbvsee.dequeueReusableCell(withIdentifier: "TableViewCell",for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        let currentDog = table[indexPath.row]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd h:m:s"
        let tt=dateFormatter.string(from: currentDog.time)
        // 設定文本
        cell.lbseetb.text = "\(tt) \(currentDog.name)  \(currentDog.say)"
        return cell
    }
    //右滑功能
        // 配置 UISwipeActionsConfiguration
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        // 創建一個 "移除" 操作
        let removeAction = UIContextualAction(style: .normal, title: "移除") { (_, _, completionHandler) in

            // 移除數據（這裡簡單地使用一個數組作為示例）
            let realm = try! Realm()
            let todos = realm.objects(dog.self)
            let dd=todos[indexPath.row]
            try! realm.write {
                        realm.delete(dd)
                    }

            // 刪除行並添加刪除動畫
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            // 完成操作
            completionHandler(true)
        }

        // 設定操作的背景顏色
        removeAction.backgroundColor = UIColor.red

        // 返回配置
        return UISwipeActionsConfiguration(actions: [removeAction])
    }
    //左滑功能
    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // 創建功能
        let editAction = UIContextualAction(style: .normal, title: "編輯") { (_, _, completionHandler) in
            
            self.isedit=true
            self.editrow=indexPath.row
            //
            self.send()
            // 完成
            completionHandler(true)
        }
        
        // 背景顏色
        editAction.backgroundColor = UIColor.blue
        
        // 返回配置
        return UISwipeActionsConfiguration(actions: [editAction])
    }

    
}
