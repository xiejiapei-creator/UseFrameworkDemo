//
//  Client.swift
//  UseMoya
//
//  Created by 谢佳培 on 2021/1/30.
//

import Foundation

// HTTP方法
enum HTTPMethod: String
{
    case GET
    case POST
}

// 客户端协议：提供基地址属性和发送请求方法
protocol ClientProtocol
{
    // 基地址属性
    var host: String { get }
    
    // 发送请求方法：T是遵守请求协议的范型 request是请求 handler是请求完成后的回调闭包 Response是遵守解码协议的关联类型
    func send<T: Requestable>(_ request: T, handler: @escaping (T.Response?) -> Void)
}

// 客户端遵守客户端协议
class URLSessionClient: ClientProtocol
{
    // 创建客户端管理者
    static let manager = URLSessionClient()
    
    // 给基地址赋值
    let host: String = "http://127.0.0.1:5000"
    
    // 实现发送请求方法
    func send<T>(_ request: T, handler: @escaping (T.Response?) -> Void) where T : Requestable
    {
        // 请求地址 = 基地址 + request的传入路径
        let url = URL(string: host.appending(request.path))!
        
        // 根据url创建URLRequest
        var urlRequest = URLRequest(url: url)
       
        // 设置请求方法
        urlRequest.httpMethod = request.method.rawValue
        
        // 根据request创建dataTask并启动
        let task = URLSession.shared.dataTask(with: urlRequest)
        { (data, response, error) in
            // 调用Response里面的解码方法将请求到的数据解码成model后从主线程传递出去
            if let data = data, let model = T.Response.parse(data: data)
            {
                DispatchQueue.main.async { handler(model) }
            }
            else
            {
                DispatchQueue.main.async { handler(nil) }
            }
        }
        task.resume()
    }
}

struct LocalFileClient: ClientProtocol
{
    // 为了满足 ClientProtocol 的要求，实际上我们不会发送请求
    let host = ""
    
    func send<T : Requestable>(_ request: T, handler: @escaping (T.Response?) -> Void)
    {
        switch request.path
        {
        case "/users/xiejiapei":
            // 获取fileURL
            guard let fileURL = Bundle.main.url(forResource: "usersXiejiapei", withExtension: "")  else { fatalError() }
            // 根据fileURL获取data
            guard let data = try? Data(contentsOf: fileURL) else { fatalError() }
            // 将data传递出去
            handler(T.Response.parse(data: data))
        default:
            fatalError("Unknown path")
        }
    }
}
 
 
