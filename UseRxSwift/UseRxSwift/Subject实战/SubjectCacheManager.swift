//
//  SubjectCacheManager.swift
//  UseRxSwift
//
//  Created by 谢佳培 on 2021/1/18.
//

import UIKit
import WCDBSwift

class SubjectCacheManager: NSObject
{
    static let manager = SubjectCacheManager()
    var database: Database
    let tableName = "SubjectTable"
    
    override init()
    {
        // 沙盒路径
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last?.appendingPathComponent("subject.db")
        
        // 创建数据库对象
        database = Database(withFileURL: path!)
        
        // 创建数据库表
        do
        {
            try database.create(table: tableName, of: SubjectModel.self)
        }
        catch
        {
            print("创建数据库表失败")
        }
    }
    
    /// 增加数据
    func insertModelToTable(models:[SubjectModel])
    {
        do
        {
            try database.insert(objects: models, intoTable: tableName)
        }
        catch
        {
            print("增加数据失败")
        }
    }
    
    /// 更新数据
    func updataModelData(model:SubjectModel)
    {
        do
        {
            try database.update(table: tableName, on: SubjectModel.Properties.isFinished, with: model, where: SubjectModel.Properties.title == model.title)
        }
        catch
        {
            print("更新数据失败")
        }
    }
    
    /// 删除数据
    func deleteModelData(model:SubjectModel)
    {
        do
        {
            try database.delete(fromTable: tableName, where: SubjectModel.Properties.title == model.title)
        }
        catch
        {
            print("删除数据失败")
        }
    }
    
    /// 查找数据
    func fetachModelData() -> [SubjectModel]
    {
        var objects = [SubjectModel]()
        do
        {
            objects = try database.getObjects(fromTable: tableName)
        }
        catch
        {
            print("查找数据失败")
        }
        return objects
    }
    
    /// 覆盖更新
    func updataAllData(models:[SubjectModel])
    {
        do
        {
            try database.delete(fromTable: tableName)
            let array = fetachModelData()
            print(array)
            self.insertModelToTable(models: models)
        }
        catch let error
        {
            debugPrint("覆盖更新错误：\(error.localizedDescription)")
        }
    }
}
