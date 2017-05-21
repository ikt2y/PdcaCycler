
//
//  CheckViewController.swift
//  PdcaCycler
//
//  Created by sel on 2017/05/19.
//  Copyright © 2017年 sel. All rights reserved.
//

import UIKit
import RealmSwift

class CheckViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var keepTextField: UITextField!
    @IBOutlet weak var problemTextField: UITextField!
    @IBOutlet weak var tryTextField: UITextField!
    @IBOutlet weak var memoTextField: UITextField!
    let realm = try! Realm()
    var toPlanId: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        let textFieldArray:[UITextField] = [self.keepTextField, self.problemTextField, self.tryTextField, self.memoTextField]
        for textField in textFieldArray {
            textField.delegate = self
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Returnを押した時にキーボード閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
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
