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
    var fromPlanId:Int?
    let realm = try! Realm()
    
    var plan: PlanModel!
    var plans: [PlanModel] = []
    // status毎の配列
    var doArray: [PlanModel] = []
    var checkArray: [PlanModel] = []
    var actArray: [PlanModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let rightAddBarButtonItem:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(self.onTapAddPlan))
        self.navigationItem.setRightBarButtonItems([rightAddBarButtonItem], animated: true)
        self.navigationItem.title = "計画一覧"
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.attributedTitle = NSAttributedString(string: "更新")
        self.refreshControl?.addTarget(self, action: #selector(self.refresh), for: UIControlEvents.valueChanged)
        self.tableView.separatorColor = .clear
        self.tableView.addSubview(refreshControl!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.fetchPlans(goalId: self.willGoalId!)
    }
    
    func refresh(goalId: Int) {
        self.fetchPlans(goalId: self.willGoalId!)
        self.tableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.refreshControl?.endRefreshing()
        }
    }

    
    func fetchPlans(goalId: Int) {
        doArray = PlanModel.getPlansByStatus(goalId: goalId,status: 0)
        self.tableView.reloadData()
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
        return doArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create
        if let cell = tableView.dequeueReusableCell(withIdentifier: "planCell", for: indexPath) as? PlanCell {
            let plan = doArray[indexPath.row]
            cell.defaultColor = .lightGray
            cell.firstTrigger = 0.25;
            cell.selectionStyle = .gray
            cell.titleLabel.text = plan.name
            cell.endDateLabel.text = plan.endDate.dateToString()
            cell.BackView.backgroundColor = colorForIndex(index: indexPath.row)
            
            // まだ手をつけていない時はスワイプで完了できる
            switch plan.status {
            case 0:
                cell.setSwipeGestureWith(UIImageView(image: UIImage(named: "check")), color: UIColor.green, mode: .exit, state: .state1, completionBlock: { [weak self] (cell, state, mode) in
                    // ステータスの変更
                    PlanModel.changeStatus(plan: plan, status: 1)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        self?.fetchPlans(goalId: (self?.willGoalId!)!)
                    }
                })
            case 1:
                cell.setSwipeGestureWith(UIImageView(image: UIImage(named: "pen")), color: UIColor.orange, mode: .exit, state: .state1, completionBlock: { [weak self] (cell, state, mode) in
                    // アクションを加えたPlanのidを取得し代入
                    self?.fromPlanId = plan.id
                    // 振り返り画面に遷移
                    self?.performSegue(withIdentifier: "toCheckVC",sender: nil)
                })
            case 2:
                cell.setSwipeGestureWith(UIImageView(image: UIImage(named: "view")), color: UIColor.brown, mode: .exit, state: .state1, completionBlock: { [weak self] (cell, state, mode) in
                    // アクションを加えたPlanのidを取得し代入
                    self?.fromPlanId = plan.id
                    // 振り返り画面に遷移
                    self?.performSegue(withIdentifier: "toDetailView",sender: nil)
                })
                
            default:
                break
            }
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let plan = doArray[indexPath.row]
        // 0の配列だが念のため
        switch plan.status {
        case 0:
            PlanModel.changeStatus(plan: plan, status: 1)
        case 1:
            self.fromPlanId = plan.id
            self.performSegue(withIdentifier: "toCheckVC",sender: nil)
        case 2:
            self.fromPlanId = plan.id
            // 振り返り画面に遷移
            self.performSegue(withIdentifier: "toDetailView",sender: nil)
        default:
            break
        }

    }
    
    
    func colorForIndex(index: Int) -> UIColor {
        let planCount = doArray.count - 1
        let color = (CGFloat(index) / CGFloat(planCount))
        return UIColor(red: 32/255.0, green: color, blue: 255/255.0, alpha: 1.0)
    }
    
    // Addボタンタップした時
    @IBAction func onTapAddPlan(){
        performSegue(withIdentifier: "toAddPlan",sender: nil)
    }
    
    // Addボタンタップした時
    @IBAction func onTapClose(){
        self.dismiss(animated: true, completion: nil)
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
            
        } else if(segue.identifier == "toCheckVC") {
            
            let checkVC: CheckViewController = segue.destination as! CheckViewController
            checkVC.toPlanId = self.fromPlanId!
            
            //ナビゲーションバーを作る
            let navBar = UINavigationBar()
            navBar.frame = CGRect(x:0, y:0, width:self.view.bounds.width, height:60)
            let navItem: UINavigationItem = UINavigationItem(title:"振り返りをする")
            navItem.rightBarButtonItem = UIBarButtonItem(title: "作成",style:UIBarButtonItemStyle.plain, target: checkVC, action: #selector(checkVC.tapSaveBtn(_:)))
            navItem.leftBarButtonItem = UIBarButtonItem(title: "<戻る",style:UIBarButtonItemStyle.plain, target: checkVC, action: #selector(checkVC.tapCloseBtn(_:)))
            navBar.pushItem(navItem, animated:true)
            segue.destination.view.addSubview(navBar)
            
        } else if(segue.identifier == "toDetailView") {
            
            let detailView: DetailViewController = segue.destination as! DetailViewController
            detailView.toPlanId = self.fromPlanId!
            
            //ナビゲーションバーを作る
            let navBar = UINavigationBar()
            navBar.frame = CGRect(x:0, y:0, width:self.view.bounds.width, height:60)
            let navItem: UINavigationItem = UINavigationItem(title:"詳細")
            navItem.leftBarButtonItem = UIBarButtonItem(title: "<戻る",style:UIBarButtonItemStyle.plain, target: detailView, action: #selector(detailView.tapCloseBtn(_:)))
            navBar.pushItem(navItem, animated:true)
            segue.destination.view.addSubview(navBar)
            
        }
    }
}
