//
//  LoginClient.swift
//  UseMoya
//
//  Created by 谢佳培 on 2021/2/2.
//

import Foundation
import Moya

class LoginClient: NSObject
{
    static let manager = LoginClient()
    
    // 进行登录
    func login(username:String,password:String,smscode:String)
    {
        let provide = MoyaProvider<LoginAPI>()
        provide.request(.login(username, password, smscode))
        { (result) in
            switch result
            {
            case let .success(response):
                let _ = LoginClient.lgJson(data: response.data)
            case let .failure(error):
                print(error)
            }
        }
    }
    
    // 发送验证码
    func smscode(username:String,complete:@escaping ((String) -> Void))
    {
        let provide = MoyaProvider<LoginAPI>()
        provide.request(.smscode(username))
        { (result) in
            switch result
            {
            case let .success(response):
                let dict = LoginClient.lgJson(data: response.data)
                complete(dict["smscode"] as! String)
            case let .failure(error):
                print(error)
                complete("")
            }
        }
    }

    // 其他事件 - 比如注册
    func otherRequest()
    {
        let provide = MoyaProvider<LoginAPI>()
        provide.request(.otherRequest)
        { (result) in
            switch result
            {
            case let .success(response):
                let _ = LoginClient.lgJson(data: response.data)
            case let .failure(error):
                print(error)
            }
        }
    }

    // 序列化
    static func lgJson(data:Data?)->([String: Any])
    {
         guard let data = data else
         {
             print("data 为空")
             return [:]
         }
         do
         {
             let dict = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
             print("序列化字典: \(dict)")
             return dict as! ([String : Any])
         }
         catch
         {
             print("序列化失败")
             return [:]
         }
     }
}
