//
//  PlanTableViewController.swift
//  PdcaCycler
//
//  Created by sel on 2017/05/18.
//  Copyright © 2017年 sel. All rights reserved.
//

import UIKit
import RealmSwift

class PlanTableViewController: UITableViewController {
    var willGoalId:Int?
    let realm = try! Realm()
    var plans: [PlanModel] = []
    var plan: PlanModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let rightAddBarButtonItem:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(self.onTapAddPlan))
        self.navigationItem.setRightBarButtonItems([rightAddBarButtonItem], animated: true)
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.attributedTitle = NSAttributedString(string: "更新")
        self.refreshControl?.addTarget(self, action: #selector(self.refresh), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(refreshControl!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.fetchPlans(goalId: self.willGoalId!)
    }
    
    func refresh(goalId: Int) {
        self.fetchPlans(goalId: self.willGoalId!)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.refreshControl?.endRefreshing()
        }
    }

    
    func fetchPlans(goalId: Int) {
        plans = PlanModel.getPlansByGoalId(goalId: goalId)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return plans.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // sample
        let cell: UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        let item = plans[indexPath.row]
        cell.textLabel?.text = item.name
        return cell
    }
    
    // Addボタンタップした時
    func onTapAddPlan(){
        performSegue(withIdentifier: "toAddPlan",sender: nil)
//        let storyboard: UIStoryboard = self.storyboard!
//        let nextView = storyboard.instantiateViewController(withIdentifier: "AddPlanVC")
//        present(nextView, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toAddPlan") {
            let addPlanVC: AddPlanViewController = segue.destination as! AddPlanViewController
            addPlanVC.tmpGoalId = self.willGoalId!
            
            //ナビゲーションバーを作る
            let navBar = UINavigationBar()
            navBar.frame = CGRect(x:0, y:0, width:self.view.bounds.width, height:60)
            let navItem: UINavigationItem = UINavigationItem(title:"計画をつくる")
            navItem.rightBarButtonItem = UIBarButtonItem(title: "作成",style:UIBarButtonItemStyle.plain, target: addPlanVC, action: #selector(addPlanVC.tapSaveBtn(_:)))
            navItem.leftBarButtonItem = UIBarButtonItem(title: "<戻る",style:UIBarButtonItemStyle.plain, target: addPlanVC, action: #selector(addPlanVC.tapCloseBtn(_:)))
            navBar.pushItem(navItem, animated:true)
            segue.destination.view.addSubview(navBar)
        }
    }
}
