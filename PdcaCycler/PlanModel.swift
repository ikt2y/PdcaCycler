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
        let goal = realm.object(ofType: GoalModel.self, forPrimaryKey: tmpGoalId)
        let plan = PlanModel()
        plan.name = name
        plan.endDate = endDate
        plan.startDate = Date()
        plan.id = self.getLastID()
        plan.owner = goal
        goal?.plans.append(plan)
        return plan
    }
    
    // save
    func save() {
        try! PlanModel.realm.write {
            PlanModel.realm.add(self)
        }
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
    
    
}
