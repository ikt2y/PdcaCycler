//
//  AddPlanViewController.swift
//  PdcaCycler
//
//  Created by sel on 2017/05/18.
//  Copyright © 2017年 sel. All rights reserved.
//

import UIKit
import RealmSwift

class AddPlanViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    let realm = try! Realm()
    var tmpGoalId:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // キーボード閉じるためdelegate設定
        nameTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        nameTextField.placeholder = "1週間野菜しか食べない"
        nameTextField.addBorderBottom(height: 1.0, color: .lightGray)
    }
    
    // Returnを押した時にキーボード閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tapCloseBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapSaveBtn(_ sender: Any) {
        let p = PlanModel.createPlan(tmpGoalId: self.tmpGoalId!, name: nameTextField.text!, endDate: endDatePicker.date as Date!)
        p.save()
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
