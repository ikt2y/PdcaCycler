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
    dynamic var status = 0// ステータス(0:まだ始めてない,1:途中,2:期限切れ,3:完了)
    dynamic var keepDays:Int = 0// 継続日数
    dynamic var bestKeepDays:Int = 0// 最高継続日数
    // アソシエーション
    dynamic var owner: GoalModel?
    
    // plan作成時
    dynamic var name = ""// アクション名
    dynamic var endDate: Date!// 終了日
    
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
    static func createPlan(tmpGoalId: Int, name: String, kasetsu: String, endDate: Date) -> PlanModel {
        let plan = PlanModel()
        let goal = realm.object(ofType: GoalModel.self, forPrimaryKey: tmpGoalId)!
        plan.name = name
        plan.endDate = endDate
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
            // 継続日数を更新
            plan.keepDays += 1
            // 最高継続日数を更新
            if (plan.keepDays > plan.bestKeepDays) {
                plan.bestKeepDays = plan.keepDays
            }
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
    
    // ステータス(0:まだ始めてない,1:はじめた,2:途中,3:期限切れ,4:完了)
    
    
    // GoalIdとstatusで絞り込んでオブジェクトの配列を取得する
    static func getPlansByStatus(goalId:Int, status:Int) -> [PlanModel] {
        // タップしたGoalオブジェクトをidから取得
        let goal = realm.objects(GoalModel.self).filter("id == \(goalId)").first!
        // Goalオブジェクトに紐づくPlanオブジェクトを取得
        let plans = goal.plans
        // statusで条件分岐
        switch status {
        // まだ始めてないリストの取得
        case 0:
            var notStartList: [PlanModel] = []
            for plan in plans {
                if plan.status == 0 {
                    notStartList.append(plan)
                }
            }
            return notStartList
        // 実行中リストの取得
        case 1:
            var wipList: [PlanModel] = []
            for plan in plans {
                if plan.status == 1 {
                    wipList.append(plan)
                }
            }
            return wipList
        // 期限切れリストの取得
        case 2:
            var actList: [PlanModel] = []
            for plan in plans {
                if plan.status == 2 {
                    actList.append(plan)
                }
            }
            return actList
        // 完了リストの取得
        case 3:
            var doneList: [PlanModel] = []
            for plan in plans {
                if plan.status == 3 {
                    doneList.append(plan)
                }
            }
            return doneList
        // その他
        default:
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
