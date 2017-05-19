//
//  GoalTableViewController.swift
//  PdcaCycler
//
//  Created by sel on 2017/05/17.
//  Copyright © 2017年 sel. All rights reserved.
//

import UIKit
import RealmSwift

class GoalTableViewController: UITableViewController{
    let realm = try! Realm()
    var goals: [GoalModel] = []
    var goal: GoalModel!
    var passGoalId:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // xibファイルの紐付け
        let nib = UINib(nibName: "GoalTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "goalCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.attributedTitle = NSAttributedString(string: "更新")
        self.refreshControl?.addTarget(self, action: #selector(GoalTableViewController.refresh), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(refreshControl!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // cellの高さの設定
        self.tableView.estimatedRowHeight = 90
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.navigationItem.title = "目標リスト"
        
        // NavItem
        let rightSearchBarButtonItem:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(self.onTapAddGoal))
        self.navigationItem.setRightBarButtonItems([rightSearchBarButtonItem], animated: true)
        
        // Goalの読み込み
        self.fetchGoals()
        
    }
    
    func refresh() {
        goals = GoalModel.getAllGoals()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.refreshControl?.endRefreshing()
        }
    }
    
    func fetchGoals() {
        goals = GoalModel.getAllGoals()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "goalCell", for: indexPath) as! GoalTableViewCell
        let item = goals[indexPath.row]
        cell.name.text = item.name
        cell.startDate.text = item.startDate.dateToString()
        cell.endDate.text = item.endDate.dateToString()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tmpItem = goals[indexPath.row]
        self.passGoalId = tmpItem.id
        performSegue(withIdentifier: "toPlanTableVC",sender: nil)
    }
    
    // Addボタンタップした時
    func onTapAddGoal(){
        let storyboard: UIStoryboard = self.storyboard!
        let nextView = storyboard.instantiateViewController(withIdentifier: "AddGoalVC")
        present(nextView, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toPlanTableVC") {
            let nextVC: PlanTableViewController = segue.destination as! PlanTableViewController
            print(self.passGoalId!)
            nextVC.willGoalId = self.passGoalId!
        }
    }
}
