//
//  LoginAPI.swift
//  UseMoya
//
//  Created by 谢佳培 on 2021/2/2.
//
import Moya
import UIKit

public enum LoginAPI
{
    case login(String, String, String)  // 登录接口
    case smscode(String)                // 登录，发送验证码
    case otherRequest                   // 其他接口，没有参数
}

extension LoginAPI: TargetType
{
    // 服务器地址
    public var baseURL: URL
    {
        return URL(string:"http://127.0.0.1:5000/")!
    }
    
    // 各个请求的具体路径
    public var path: String
    {
        switch self
        {
        case .login:
            return "login/"
        case .smscode:
            return "login/smscode/"
        case .otherRequest:
            return "login/otherRequest/"
        }
    }
    
    // 请求方式
    public var method: Moya.Method
    {
        switch self
        {
        case .login:
            return .post
        case .smscode:
            return .post
        default:
            return .get
        }
    }
    
    // 这个就是做单元测试模拟的数据，只会在单元测试文件中有作用
    public var sampleData: Data
    {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    // 请求任务事件（这里附带上参数）
    public var task: Task
    {
        var param:[String:Any] = [:]

        switch self
        {
        case .login(let username,let password,let smscode):
            param["username"] = username
            param["password"] = password
            param["smscode"] = smscode
        case .smscode(let username):
            param["username"] = username
        default:
            return .requestPlain
        }
        return .requestParameters(parameters: param, encoding: URLEncoding.default)
    }
    
    // 设置请求头
    public var headers: [String: String]?
    {
        return nil
    }
}





