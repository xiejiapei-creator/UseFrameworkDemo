//
//  OrderViewController.swift
//  UseMoya
//
//  Created by 谢佳培 on 2021/2/2.
//

import UIKit
import SwiftyJSON

class OrderViewController: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        orderProvider.request(OrderApi.findOne(sn: "DJKRE3248DFHJEW23"))
        { (result) in
            print(result)
        }
    }
}



