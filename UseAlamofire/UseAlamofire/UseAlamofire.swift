//
//  UseAlamofire.swift
//  UseAlamofire
//
//  Created by 谢佳培 on 2021/1/22.
//

import UIKit
import Alamofire

class UseAlamofire: UIViewController
{
    override func viewDidLoad()
    {
        super .viewDidLoad()
     
        // 请求网络
        requestNetwork()
    }
    
    // 请求网络
    func requestNetwork()
    {
        let urlString = "https://www.baidu.com"

        AF.request(urlString).response
        { (response) in
            debugPrint(response)
        }
    }
}

