//
//  AddGoalViewController.swift
//  PdcaCycler
//
//  Created by sel on 2017/05/17.
//  Copyright © 2017年 sel. All rights reserved.
//

import UIKit
import RealmSwift

class AddGoalViewController: UIViewController {
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var text: UITextField!
    @IBOutlet weak var endDate: UIDatePicker!
    var tmpDate:NSDate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        name.addBorderBottom(height: 1.0, color: .lightGray)
        text.addBorderBottom(height: 1.0, color: .lightGray)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tapCloseBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapSaveBtn(_ sender: Any) {
        // 登録
        let g = GoalModel.create(name: name.text!, text: text.text!, endDate: endDate.date as Date!)
        // 保存
        g.save()
        // モーダル閉じる
        self.dismiss(animated: true, completion: nil)
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
