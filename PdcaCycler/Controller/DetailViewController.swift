//
//  DetailViewController.swift
//  PdcaCycler
//
//  Created by sel on 2017/05/19.
//  Copyright © 2017年 sel. All rights reserved.
//

import UIKit
import RealmSwift

class DetailViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var lookBackDate: UILabel!
    @IBOutlet weak var keepLabel: UILabel!
    @IBOutlet weak var problemLabel: UILabel!
    @IBOutlet weak var tryLabel: UILabel!
    @IBOutlet weak var memoLabel: UILabel!
    let realm = try! Realm()
    var toPlanId:Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // IDからPlanオブジェクト取得
        let plan = PlanModel.getPlanById(id: toPlanId!)
        
        // 取得した中身を出力
        self.nameLabel.text = plan.name
        self.startDateLabel.text = plan.startDate.dateToString()
        self.endDateLabel.text = plan.endDate.dateToString()
        self.lookBackDate.text = plan.lookBackDate.dateToString()
        self.keepLabel.text = plan.keep
        self.problemLabel.text = plan.problem
        self.tryLabel.text = plan.nextPlan
        self.memoLabel.text = plan.memo
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tapCloseBtn(_ sender: Any?) {
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
