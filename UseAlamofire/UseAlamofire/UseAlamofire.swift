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
    var cancelButton = UIButton(frame: CGRect(x: 100, y: 450, width: 100, height: 50))
    var downloadButton = UIButton(frame: CGRect(x: 100, y: 380, width: 100, height: 50))
    let download = AF.download("https://httpbin.org/image/png")
    
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
        
        // 身份验证
        //authenticateChallenge()
        
        // 下载文件
        //downloadFile()
        //downloadToDestination()
        //useResumeData()
        
        // 上传数据到服务器
        uploadData()
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
    
    // 身份验证
    func authenticateChallenge()
    {
        let user = "user"
        let password = "password"
        
        let credential = URLCredential(user: user, password: password, persistence: .forSession)

//        AF.request("https://httpbin.org/basic-auth/\(user)/\(password)")
//            .authenticate(username: user, password: password)
//            .responseJSON
//            { response in
//                debugPrint(response)
//            }
        
        AF.request("https://httpbin.org/basic-auth/\(user)/\(password)")
            .authenticate(with: credential)
            .responseJSON
            { response in
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
    
    let destination: DownloadRequest.Destination =
    { _, _ in
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent("image.png")

        return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
    }
    
    func downloadToDestination()
    {
        AF.download("https://httpbin.org/image/png", to: destination).response
        { response in
            debugPrint(response)

            if response.error == nil, let imagePath = response.fileURL?.path
            {
                let image = UIImage(contentsOfFile: imagePath)
                self.imageView.image = image!
            }
        }

        // 还可以使用建议的文件存储位置
        let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
        AF.download("https://httpbin.org/image/png", to: destination).response
        { response in
            debugPrint(response)

            if response.error == nil, let imagePath = response.fileURL?.path
            {
                let image = UIImage(contentsOfFile: imagePath)
                self.imageView.image = image!
            }
        }
        
        let utilityQueue = DispatchQueue.global(qos: .utility)

        AF.download("https://httpbin.org/image/png")
            .downloadProgress(queue: utilityQueue)
            { progress in
                print("下载进度: \(progress.fractionCompleted)")
            }
            .responseData
            { response in
                if let data = response.value
                {
                    let image = UIImage(data: data)
                    self.imageView.image = image!
                }
            }
    }
    
    func useResumeData()
    {
        var resumeData: Data!

        // 正常下载
        download.responseData
        { response in
            if let data = response.value
            {
                let image = UIImage(data: data)
                self.imageView.image = image!
            }
        }

        // 从cancel的回调闭包中获得resumeData
        download.cancel
        { data in
            resumeData = data
        }

        // 使用resumeData继续下载
        AF.download(resumingWith: resumeData).responseData
        { response in
            if let data = response.value
            {
                let image = UIImage(data: data)
                self.imageView.image = image!
            }
        }
    }
    
    @objc func cancelDownload()
    {
        download.cancel()
    }
    
    @objc func beginDownload()
    {
        useResumeData()
    }
    
    // 上传数据到服务器
    func uploadData()
    {
        let data = Data("XieJiaPei".utf8)

        AF.upload(data, to: "https://httpbin.org/post").responseJSON
        { response in
            debugPrint(response)
        }
        
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(Data("Boy".utf8), withName: "JiaPei")
            multipartFormData.append(Data("Girl".utf8), withName: "YuQing")
        }, to: "https://httpbin.org/post")
        .responseJSON { response in
            debugPrint(response)
        }
        
        let fileURL = Bundle.main.url(forResource: "girl", withExtension: "mp4")!

        if FileManager.default.fileExists(atPath: fileURL.path)
        {
            AF.upload(fileURL, to: "https://httpbin.org/post")
                .uploadProgress
                { progress in
                    print("上传进度: \(progress.fractionCompleted)")
                }
                .responseJSON
                { response in
                    print("上传完成")
                    print(response)
                }
        }
        else
        {
            print("没有找到文件")
        }
    }
    
    // 网络可达性
    func reachability()
    {
        let manager = NetworkReachabilityManager(host: "www.apple.com")

        manager?.startListening
        { status in
            print("网络状态发生改变: \(status)")
        }
    }
    
    func createSubview()
    {
        imageView.backgroundColor = .orange
        view.addSubview(imageView)
        
        cancelButton.backgroundColor = .orange
        cancelButton.setTitle("取消下载", for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelDownload), for: .touchUpInside)
        view.addSubview(cancelButton)
        
        downloadButton.backgroundColor = .orange
        downloadButton.setTitle("开始下载", for: .normal)
        downloadButton.addTarget(self, action: #selector(beginDownload), for: .touchUpInside)
        view.addSubview(downloadButton)
    }
    
    
}











