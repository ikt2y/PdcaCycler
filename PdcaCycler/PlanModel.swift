//
//  PlanModel.swift
//  PdcaCycler
//
//  Created by sel on 2017/05/17.
//  Copyright © 2017年 sel. All rights reserved.
//

import UIKit
import RealmSwift

// PlanModel
class PlanModel: Object {
    
    // Realmのインスタンス化
    static let realm = try! Realm()
    
    // プロパティ
    dynamic var id = 0// id
    dynamic var status = 0// ステータス
        // plan作成時
    dynamic var name = ""// Plan名
    dynamic var startDate: Date!// 開始日
    dynamic var endDate: Date!// 終了日
        // check振り返り時
    dynamic var memo = ""
    dynamic var keep = ""
    dynamic var problem = ""
    dynamic var nextPlan = ""
    dynamic var lookBackDate: Date!

    // アソシエーション
    dynamic var owner: GoalModel?
    
    
    // プライマリーキーの設定
    override static func primaryKey() -> String? {
        return "id"
    }
    
    // auto increment
    static func getLastID() -> Int{
        if let plan = realm.objects(PlanModel.self).last {
            return plan.id + 1
        } else {
            return 1
        }
    }
    
    // create plan
    static func createPlan(tmpGoalId: Int, name: String, endDate: Date) -> PlanModel {
        let plan = PlanModel()
        let goal = realm.object(ofType: GoalModel.self, forPrimaryKey: tmpGoalId)!
        plan.name = name
        plan.endDate = endDate
        plan.startDate = Date()
        plan.id = self.getLastID()
        plan.owner = goal
        try! realm.write {
            goal.plans.append(plan)
        }
        return plan
    }
    
    // 振り返り時の上書き
    static func addActInfo(plan: PlanModel,keep: String, problem: String, nextPlan: String, memo: String, status: Int) {
        try! realm.write({
            plan.keep = keep
            plan.problem = problem
            plan.nextPlan = nextPlan
            plan.lookBackDate = Date()
            plan.status = status
        })
    }
    
    // save
    func save() {
        try! PlanModel.realm.write {
            PlanModel.realm.add(self)
        }
    }
    
    // idから取得
    static func getPlanById(id:Int) -> PlanModel {
        let plan = realm.objects(PlanModel.self).filter("id == \(id)").first!
        return plan
    }
    
    // GoalIdに紐づくPlanの配列を取得
    static func getPlansByGoalId(goalId:Int) -> [PlanModel] {
        // タップしたGoalオブジェクトをidから取得
        let goal = realm.objects(GoalModel.self).filter("id == \(goalId)").first!
        // Goalオブジェクトに紐づくPlanオブジェクトを取得
        let plans = goal.plans
        var planList: [PlanModel] = []
        for plan in plans {
            planList.append(plan)
        }
        // 配列で返す
        return planList
    }
    
    // GoalIdとstatusで絞り込んでオブジェクトの配列を取得する
    static func getPlansFilteredByStatus(goalId:Int, status:Int) -> [PlanModel] {
        // タップしたGoalオブジェクトをidから取得
        let goal = realm.objects(GoalModel.self).filter("id == \(goalId)").first!
        // Goalオブジェクトに紐づくPlanオブジェクトを取得
        let plans = goal.plans
        // statusで条件分岐
        switch status {
        // 未完リストの取得
        case 0:
            var doList: [PlanModel] = []
            for plan in plans {
                if plan.status == 0 {
                    doList.append(plan)
                }
            }
            return doList
        // 完了リストの取得
        case 1:
            var checkList: [PlanModel] = []
            for plan in plans {
                if plan.status == 1 {
                    checkList.append(plan)
                }
            }
            return checkList
        // 振り返り済リストの取得
        case 2:
            var actList: [PlanModel] = []
            for plan in plans {
                if plan.status == 2 {
                    actList.append(plan)
                }
            }
            return actList
        default:
            let plans = goal.plans
            var planList: [PlanModel] = []
            for plan in plans {
                planList.append(plan)
            }
            return planList
        }
    }
    
    // status変更
    static func changeStatus(plan:PlanModel,status:Int) {
        try! realm.write({
            plan.status = status
        })
    }
    
}
