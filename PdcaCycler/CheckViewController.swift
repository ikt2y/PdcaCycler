
//
//  CheckViewController.swift
//  PdcaCycler
//
//  Created by sel on 2017/05/19.
//  Copyright © 2017年 sel. All rights reserved.
//

import UIKit
import RealmSwift

class CheckViewController: UIViewController {
    @IBOutlet weak var keepTextField: UITextField!
    @IBOutlet weak var problemTextField: UITextField!
    @IBOutlet weak var tryTextField: UITextField!
    @IBOutlet weak var memoTextField: UITextField!
    let realm = try! Realm()
    var toPlanId: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //戻る
    @IBAction func tapCloseBtn(_ sender: Any?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // 保存
    @IBAction func tapSaveBtn(_ sender: Any?) {
        
        // IDからPlanオブジェクト取得
        let plan = PlanModel.getPlanById(id: toPlanId!)
        
        // Planオブジェクトに振り返り情報を上書き
        PlanModel.addActInfo(plan: plan, keep: self.keepTextField.text!, problem: self.problemTextField.text!, nextPlan: self.tryTextField.text!, memo: self.memoTextField.text!, status: 2)
        
        // 閉じる
        self.dismiss(animated: true, completion: nil)
        
    }
}
