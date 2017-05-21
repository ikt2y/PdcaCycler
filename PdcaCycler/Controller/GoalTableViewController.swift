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
        self.tableView.separatorColor = .clear
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
        self.tableView.reloadData()
    }
    
    func refresh() {
        goals = GoalModel.getAllGoals()
        self.tableView.reloadData()
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
        cell.endDate.text = item.endDate.dateToString()
        cell.cycleLabel.text = String(item.plans.count) + "回"
        cell.sideView.backgroundColor = colorForIndex(index: indexPath.row)
        return cell
    }
    
    func colorForIndex(index: Int) -> UIColor {
        let itemCount = goals.count - 1
        let color = (CGFloat(index) / CGFloat(itemCount))
        return UIColor(red: 32/255.0, green: color, blue: 255/255.0, alpha: 1.0)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tmpItem = goals[indexPath.row]
        self.passGoalId = tmpItem.id
        performSegue(withIdentifier: "toPlanTableVC",sender: nil)
    }
    
    // Addボタンタップした時
    func onTapAddGoal(){
        performSegue(withIdentifier: "toAddGoal", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toPlanTableVC") {
            let nextVC: PlanTableViewController = segue.destination as! PlanTableViewController
            nextVC.willGoalId = self.passGoalId!
        } else if(segue.identifier == "toAddGoal")  {
            let addGoalVC: AddGoalViewController = segue.destination as! AddGoalViewController
            //ナビゲーションバーを作る
            let navBar = UINavigationBar()
            navBar.frame = CGRect(x:0, y:0, width:self.view.bounds.width, height:60)
            let navItem: UINavigationItem = UINavigationItem(title:"目標を決める")
            navItem.rightBarButtonItem = UIBarButtonItem(title: "作成",style:UIBarButtonItemStyle.plain, target: addGoalVC, action: #selector(addGoalVC.tapSaveBtn(_:)))
            navItem.leftBarButtonItem = UIBarButtonItem(title: "<戻る",style:UIBarButtonItemStyle.plain, target: addGoalVC, action: #selector(addGoalVC.tapCloseBtn(_:)))
            navBar.pushItem(navItem, animated:true)
            segue.destination.view.addSubview(navBar)
        }
    }
}
