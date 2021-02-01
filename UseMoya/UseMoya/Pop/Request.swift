//
//  Request.swift
//  UseMoya
//
//  Created by 谢佳培 on 2021/1/30.
//

import Foundation

// 请求协议
protocol Requestable
{
    // 请求路径
    var path: String { get }
    // 请求方法
    var method: HTTPMethod { get }
    // 请求参数
    var parameter: [String: Any] { get }
    
    // 遵守解码协议的关联类型
    associatedtype Response: DecodableProtocol
}

// 遵守请求协议，不需要到应用层再去传值
struct PersonRequest: Requestable
{
    typealias Response = Person
    
    let name: String
    var path: String
    {
        return "/users/\(name)"
    }
    let method: HTTPMethod = .GET
    let parameter: [String: Any] = [:]
}
