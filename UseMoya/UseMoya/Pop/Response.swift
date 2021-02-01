//
//  Response.swift
//  UseMoya
//
//  Created by 谢佳培 on 2021/1/30.
//

import Foundation
 
// 解码协议
protocol DecodableProtocol
{
    static func parse(data: Data) -> Self?
}


