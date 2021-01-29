//
//  UseAdvancedAlamofire.swift
//  UseAlamofire
//
//  Created by 谢佳培 on 2021/1/26.
//

import UIKit
import Alamofire

class UseAdvancedAlamofire: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //session()

        //security()
        
        //createURLConvertibleRequest()
        //createURLRequestConvertibleRequest()
        //progress()
        //redirector()
    }
    
    func session()
    {
        AF.request("https://httpbin.org/get").responseJSON
        { response in
            debugPrint(response)
        }

        let session = Session.default
        session.request("https://httpbin.org/get").responseJSON
        { response in
            debugPrint(response)
        }
        
        let configuration = URLSessionConfiguration.af.default
        configuration.allowsCellularAccess = false
        let customConfigurationSession = Session(configuration: configuration)
        customConfigurationSession.request("https://httpbin.org/get").responseJSON
        { response in
            debugPrint(response)
        }
        
        let immediatelySession = Session(startRequestsImmediately: true)
        immediatelySession.request("https://httpbin.org/get").resume().responseJSON
        { response in
            debugPrint(response)
        }
        
        let rootQueue = DispatchQueue(label: "com.app.session.rootQueue")
        let requestQueue = DispatchQueue(label: "com.app.session.requestQueue")
        let serializationQueue = DispatchQueue(label: "com.app.session.serializationQueue")

        let dispatchSession = Session(
            rootQueue: rootQueue,
            requestQueue: requestQueue,
            serializationQueue: serializationQueue
        )
        dispatchSession.request("https://httpbin.org/get").responseJSON
        { response in
            debugPrint(response)
        }

        let policy = RetryPolicy()
        let policySession = Session(interceptor: policy)
        policySession.request("https://httpbin.org/get").responseJSON
        { response in
            debugPrint(response)
        }
        
        let manager = ServerTrustManager(evaluators: ["httpbin.org": PinnedCertificatesTrustEvaluator()])
        let managerSession = Session(serverTrustManager: manager)
        managerSession.request("https://httpbin.org/get").responseJSON
        { response in
            debugPrint(response)
        }
        
        let redirector = Redirector(behavior: .follow)
        let redirectorSession = Session(redirectHandler: redirector)
        redirectorSession.request("https://httpbin.org/get").responseJSON
        { response in
            debugPrint(response)
        }
        
        let cacher = ResponseCacher(behavior: .cache)
        let cacherSession = Session(cachedResponseHandler: cacher)
        cacherSession.request("https://httpbin.org/get").responseJSON
        { response in
            debugPrint(response)
        }
        
        let monitor = ClosureEventMonitor()
        monitor.requestDidCompleteTaskWithError =
        { (request, task, error) in
            debugPrint(request)
        }
        let monitorSession = Session(eventMonitors: [monitor])
        monitorSession.request("https://httpbin.org/get").responseJSON
        { response in
            debugPrint(response)
        }
        
        let urlSessionRootQueue = DispatchQueue(label: "org.alamofire.customQueue")
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        queue.underlyingQueue = rootQueue
        let delegate = SessionDelegate()
        let urlSessionConfiguration = URLSessionConfiguration.af.default
        let urlSession = URLSession(configuration: urlSessionConfiguration,
                                    delegate: delegate,
                                    delegateQueue: queue)
        let URLSession = Session(session: urlSession, delegate: delegate, rootQueue: urlSessionRootQueue)
        URLSession.request("https://httpbin.org/get").responseJSON
        { response in
            debugPrint(response)
        }
    }
    
    func createURLConvertibleRequest()
    {
        let urlString = "https://httpbin.org/get"
        AF.request(urlString)
            .responseJSON
            { response in
                debugPrint(response)
            }

        let url = URL(string: urlString)!
        AF.request(url)
            .responseJSON
            { response in
                debugPrint(response)
            }

        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        AF.request(urlComponents)
            .responseJSON
            { response in
                debugPrint(response)
            }
    }
    
    func createURLRequestConvertibleRequest()
    {
        let postUrl = URL(string: "https://httpbin.org/post")!
        var urlRequest = URLRequest(url: postUrl)
        urlRequest.method = .post

        let parameters = ["foo": "bar"]
        
        do
        {
            urlRequest.httpBody = try JSONEncoder().encode(parameters)
        }
        catch
        {
            // Handle error.
            print("出错了")
        }

        urlRequest.headers.add(.contentType("application/json"))

        AF.request(urlRequest)
            .responseJSON
            { response in
                debugPrint(response)
            }
    }
    
    func progress()
    {
        AF.request("https://httpbin.org/get")
            .uploadProgress
            { progress in
                print("上传进度: \(progress.fractionCompleted)")
            }
            .downloadProgress
            { progress in
                print("下载进度: \(progress.fractionCompleted)")
            }
            .responseJSON
            { response in
                debugPrint(response)
            }
    }
    
    func redirector()
    {
        let redirector = Redirector(behavior: .follow)
        AF.request("https://httpbin.org/get")
            .redirect(using: redirector)
            .responseJSON
            { response in
                debugPrint(response)
            }
        



    }
    
    func security()
    {
        let logger = Logger()
        let session = Session(eventMonitors: [logger])
        session.request("https://httpbin.org/get").responseJSON
        { response in
            debugPrint(response)
        }
    }
}

final class Logger: EventMonitor
{
    let queue = DispatchQueue(label: "xiejiapei")

    // Event called when any type of Request is resumed.
    func requestDidResume(_ request: Request)
    {
        print("Resuming: \(request)")
    }

    // Event called whenever a DataRequest has parsed a response.
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>)
    {
        debugPrint("Finished: \(response)")
    }
}

 

