//
//  UseAlamofire.swift
//  UseAlamofire
//
//  Created by 谢佳培 on 2021/1/22.
//

import UIKit
import Alamofire

struct HTTPBinResponse: Decodable
{
    let url: String
}

class UseAlamofire: UIViewController
{
    var imageView = UIImageView(frame: CGRect(x: 100, y: 150, width: 200, height: 200))
    
    
    override func viewDidLoad()
    {
        super .viewDidLoad()
        createSubview()
     
        // 发起请求
        //requestNetwork()
        //postRequestNetwork()
        
        // 请求参数和参数编码器
        //getURLEncoded()
        //postURLEncoded()
        //JSONParameterEncoder()
        
        // HTTP Headers
        //customHTTPHeaders()
        
        // 响应验证
        //responseVerification()
        
        // 响应处理
        //responseHandlers()
        
        // 下载文件
        //downloadFile()
    }
    
    // 发起请求
    func requestNetwork()
    {
        AF.request("https://httpbin.org/get").response
        { response in
            debugPrint(response)
        }
    }
    
    func postRequestNetwork()
    {
        struct Login: Encodable
        {
            let email: String
            let password: String
        }

        let login = Login(email: "2170928274@qq.com", password: "19970118")

        AF.request("https://httpbin.org/post", method: .post, parameters: login, encoder: Alamofire.JSONParameterEncoder.default).response
        { response in
            debugPrint(response)
        }
    }
    
    // 请求参数和参数编码器
    func getURLEncoded()
    {
        // https://httpbin.org/get?foo=bar
        let parameters = ["foo": "bar"]

        AF.request("https://httpbin.org/get", parameters: parameters).response
        { response in
            debugPrint(response)
        }
    }
    
    func postURLEncoded()
    {
        let parameters: [String: [String]] =
        [
            "foo": ["bar"],
            "baz": ["a", "b"],
            "qux": ["x", "y", "z"]
        ]
        
        AF.request("https://httpbin.org/post", method: .post, parameters: parameters).response
        { response in
            debugPrint(response)
        }
    }
    
    func JSONParameterEncoder()
    {
        let parameters: [String: [String]] =
        [
            "foo": ["bar"],
            "baz": ["a", "b"],
            "qux": ["x", "y", "z"]
        ]

        AF.request("https://httpbin.org/post", method: .post, parameters: parameters, encoder: Alamofire.JSONParameterEncoder.default).response
        { response in
            debugPrint(response)
        }
    }
    
    // HTTP Headers
    func customHTTPHeaders()
    {
        let _: HTTPHeaders =
        [
            "Authorization": "Basic VXNlcm5hbWU6UGFzc3dvcmQ=",
            "Accept": "application/json"
        ]
        
        let anotherHeaders: HTTPHeaders =
        [
            .authorization(username: "Username", password: "Password"),
            .accept("application/json")
        ]

        AF.request("https://httpbin.org/headers", headers: anotherHeaders).responseJSON
        { response in
            debugPrint(response)
        }
    }
    
    // 响应验证
    func responseVerification()
    {
        AF.request("https://httpbin.org/get").validate().responseJSON
        { response in
            debugPrint(response)
        }
        
        AF.request("https://httpbin.org/get")
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData
            { response in
                switch response.result
                {
                case .success:
                    print("Validation Successful")
                case let .failure(error):
                    print(error)
                }
            }
    }
    
    func manualVerification()
    {

    }
    
    // 响应处理
    func responseHandlers()
    {
        AF.request("https://httpbin.org/get").response
        { response in
            debugPrint("Response: \(response)")
        }
        
        AF.request("https://httpbin.org/get").responseData
        { response in
            debugPrint("Response: \(response)")
        }
        
        AF.request("https://httpbin.org/get").responseString
        { response in
            debugPrint("Response: \(response)")
        }
        
        AF.request("https://httpbin.org/get").responseJSON
        { response in
            debugPrint("Response: \(response)")
        }

        AF.request("https://httpbin.org/get").responseDecodable(of: HTTPBinResponse.self)
        { response in
            debugPrint("Response: \(response)")
        }
        
        AF.request("https://httpbin.org/get")
            .responseString
            { response in
                print("Response String: \(String(describing: response.value) )")
            }
            .responseJSON
            { response in
                print("Response JSON: \(String(describing: response.value))")
            }
        
        let utilityQueue = DispatchQueue.global(qos: .utility)
        AF.request("https://httpbin.org/get").responseJSON(queue: utilityQueue)
        { response in
            print("在全局队列上执行此网络请求：\(Thread.current)")
            debugPrint(response)
        }
    }
    
    // 下载文件
    func downloadFile()
    {
        AF.download("https://httpbin.org/image/png").responseData
        { response in
            if let data = response.value
            {
                let image = UIImage(data: data)
                self.imageView.image = image!
            }
        }
    }
    
    func createSubview()
    {
        imageView.backgroundColor = .orange
        view.addSubview(imageView)
    }
}


















