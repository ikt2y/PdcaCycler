//
//  GoalModel.swift
//  PdcaCycler
//
//  Created by sel on 2017/05/17.
//  Copyright © 2017年 sel. All rights reserved.
//

import UIKit
import RealmSwift

// Goalモデル
class GoalModel: Object {
    
    // Realmのインスタンス化
    static let realm = try! Realm()
    
    // プロパティ
    dynamic var id = 0// id
    dynamic var name = ""// Goal名
    dynamic var text = ""// 説明
    dynamic var startDate: Date!// 開始日
    dynamic var endDate: Date!// 終了予定日
    
    // アソシエーション
    let plans = List<PlanModel>()// PlanModelを複数持っている
    
    // プライマリーキーの設定
    override static func primaryKey() -> String? {
        return "id"
    }
    
    // auto increment
    static func getLastID() -> Int{
        if let goal = realm.objects(GoalModel.self).last {
            return goal.id + 1
        } else {
            return 1
        }
    }
    
    // create
    static func create(name: String, text: String, endDate: Date) -> GoalModel {
        let goal = GoalModel()
        goal.name = name
        goal.text = text
        goal.startDate = Date()
        goal.endDate = endDate
        goal.id = self.getLastID()
        return goal
    }

    // save
    func save() {
        try! GoalModel.realm.write {
            GoalModel.realm.add(self)
        }
    }
    
    // fetch
    static func getAllGoals() -> [GoalModel] {
        let goals = realm.objects(GoalModel.self).sorted(byKeyPath: "id", ascending: true)
        var goalList: [GoalModel] = []
        for goal in goals {
            goalList.append(goal)
        }
        return goalList
    }
}
