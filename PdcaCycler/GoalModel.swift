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
    dynamic var id = ""// id
    dynamic var name = ""// Goal名
    dynamic var text = ""// 説明
    dynamic var startDate: NSDate!// 開始日
    dynamic var endDate: NSDate!// 終了予定日
    
    // アソシエーション
    let plans = List<PlanModel>()// PlanModelを複数持っている
    
    // プライマリーキーの設定
    override static func primaryKey() -> String? {
        return "id"
    }
    
    // auto increment
    func getLastID() -> Int{
        let realm = try! Realm()
        let goalModel: NSArray = Array(realm.objects(GoalModel.self).sorted(byKeyPath: "id")) as NSArray
        let last = goalModel.lastObject
        if goalModel.count > 0 {
            let lastID = (last as AnyObject).value(forKey: "id") as? Int
            return lastID! + 1
        } else {
            return 1
        }
    }
    
}
