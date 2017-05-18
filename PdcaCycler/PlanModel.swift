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
    dynamic var id = ""// id
    dynamic var status = 0// ステータス
        // plan作成時
    dynamic var name = ""// Plan名
    dynamic var startDate: NSDate!// 開始日
    dynamic var endDate: NSDate!// 終了日
        // check振り返り時
    dynamic var memo = ""
    dynamic var keep = ""
    dynamic var problem = ""
    dynamic var nextPlan = ""
    dynamic var lookBackDate: NSDate!
    
    // アソシエーション
    dynamic var owner: GoalModel?// GoalModelに紐付いている

    // プライマリーキーの設定
    override static func primaryKey() -> String? {
        return "id"
    }
    
    // auto increment
    func getLastID() -> Int{
        let realm = try! Realm()
        let planModel: NSArray = Array(realm.objects(PlanModel.self).sorted(byKeyPath: "id")) as NSArray
        let last = planModel.lastObject
        if planModel.count > 0 {
            let lastID = (last as AnyObject).value(forKey: "id") as? Int
            return lastID! + 1
        } else {
            return 1
        }
    }
    
}
