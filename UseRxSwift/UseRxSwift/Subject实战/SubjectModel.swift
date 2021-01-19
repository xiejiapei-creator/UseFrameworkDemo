//
//  SubjectModel.swift
//  UseRxSwift
//
//  Created by 谢佳培 on 2021/1/18.
//

import UIKit
import WCDBSwift

class SubjectModel: TableCodable
{
    var tittle: String = ""
    var isFinished: Bool = false
    
    init(tittle: String, isFinished: Bool)
    {
        self.tittle = tittle
        self.isFinished = isFinished
    }
    
    // 将是否完成状态进行反转
    func toggleFinished()
    {
        isFinished = !isFinished
    }
    
    enum CodingKeys: String, CodingTableKey
    {
        typealias Root = SubjectModel
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        case tittle
        case isFinished
    }
}
