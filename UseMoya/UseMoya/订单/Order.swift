//
//  Order.swift
//  UseMoya
//
//  Created by 谢佳培 on 2021/2/2.
//

import Foundation
import Moya

// 生成请求封装类
let orderProvider = MoyaProvider<OrderApi>()

// 订单相关api
enum OrderApi
{
    case list(pageNO: Int = 1, pageSize: Int = 10)
    case findOne(sn: String)
}

// 实现TargetType协议
extension OrderApi: TargetType
{
    // url
    var baseURL: URL
    {
        return URL(string: "http://127.0.0.1:8080/order")!
    }
    
    /// 请求路径
    var path: String {
        switch self {
        case .list:
            return "list"
        case .findOne(_):
            return "findById"
        }
    }
    
    /// 请求方式
    var method: Moya.Method {
        return .post
    }
    
    /// 解析格式
    var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        // 公共参数
        var params: [String: Any] = ["token": "Gz1qYLXeBW8MZuUfDlr9wsAYuVS1cZFMJY9BbaF842L2gRps747o4w=="]
        
        // 收集参数
        switch self {
        case let .list(pageNO, pageSize):
            params["pageNO"] = pageNO
            params["pageSize"] = pageSize
        case .findOne(let sn):
            params["sn"] = sn
        }
        
        // 发起请求
        return .requestParameters(parameters: params, encoding: URLEncoding.default)
    }
    
    /// 公共请求头
    var headers: [String : String]? {
        return ["devtype": "iOS", "devid": UIDevice().identifierForVendor?.uuidString ?? "unknow"]
    }

}


