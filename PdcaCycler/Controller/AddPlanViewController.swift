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
    @IBOutlet weak var kasetsuTextField: UITextField!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    let realm = try! Realm()
    var tmpGoalId:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // キーボード閉じるためdelegate設定
        nameTextField.delegate = self
        kasetsuTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // textFieldの見た目の設定
        nameTextField.placeholder = "1週間野菜しか食べない"
        nameTextField.addBorderBottom(height: 1.0, color: .lightGray)
        kasetsuTextField.placeholder = "野菜は健康的だし栄養価も高いから"
        kasetsuTextField.addBorderBottom(height: 1.0, color: .lightGray)
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
        let p = PlanModel.createPlan(tmpGoalId: self.tmpGoalId!, name: nameTextField.text!, kasetsu: kasetsuTextField.text! ,endDate: endDatePicker.date as Date!)
        p.save()
        self.dismiss(animated: true, completion: nil)
    }

}
