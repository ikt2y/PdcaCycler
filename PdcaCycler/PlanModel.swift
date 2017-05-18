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
    dynamic var owner: GoalModel?// GoalModelに紐付いている

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
    
}
