//
//  Person.swift
//  UseMoya
//
//  Created by 谢佳培 on 2021/1/30.
//

import Foundation

struct Person
{
    // 属性
    let name: String
    let age: String
    let hobby: String
    let petPhrase: String

    // 初始化方法
    init?(data: Data)
    {
        // [String: Any] 表示是字典类型
        guard let person = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else { return nil }
        
        // 获取person中的数据
        guard let name = person["name"] as? String else { return nil }
        guard let age = person["age"] as? String else { return nil }
        guard let hobby = person["hobby"] as? String else { return nil }
        guard let petPhrase = person["petPhrase"] as? String else { return nil }

        // 给Person结构体的属性赋值
        self.name = name
        self.age = age
        self.hobby = hobby
        self.petPhrase = petPhrase
    }
}

// 遵守解码协议实现解码方法
extension Person: DecodableProtocol
{
    static func parse(data: Data) -> Person?
    {
        // 传入data获取到Person，调用Person的初始化方法
        return Person(data: data)
    }
}
