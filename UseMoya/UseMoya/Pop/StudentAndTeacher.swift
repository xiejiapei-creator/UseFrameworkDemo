//
//  StudentAndTeacher.swift
//  UseMoya
//
//  Created by 谢佳培 on 2021/2/1.
//

import UIKit
import Alamofire

class StudentAndTeacher: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // 解决问题
        solveProblem()
        
        // 网络请求
        useAlamofire()
    }
    
    func solveProblem()
    {
        let teacher = Teacher(name: "蒋红")
        let student = Student(name: "谢佳培")
        teacher.sayHello()
        student.sayHello()
        teacher.canNotThink()
    }
    
    func useAlamofire()
    {
        AF.request("http://127.0.0.1:5000/pythonJson/")
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData
            { response in
                switch response.result
                {
                case .success:
                    print(response)
                    //let _ = LoginClient.json(data: response.data)
                case .failure(let error):
                    print(error)
                }
            }
    }
}

protocol PersonProtocl
{
    // 协议属性
    var name: String { get }
    
    // 协议方法
    func sayHello()
}

protocol AnimalProtocl
{
    // 协议属性
    var name: String { get }
    
    // 协议方法
    func sayHello()
    
    func canNotThink()
}

extension PersonProtocl
{
    var name: String { return "default name" }
    
    func sayHello()
    {
        print("hello! boy")
    }
}

extension AnimalProtocl
{
    var name: String { return "another default name" }
}

struct Teacher: PersonProtocl, AnimalProtocl
{
    var name: String

    func sayHello()
    {
        print("同学们好，请把周末的作业交上来")
    }
    
    func canNotThink()
    {
        print("动物无法思考，仅仅凭借生存本能行动")
    }
}

struct Student: PersonProtocl
{
    var name: String
    
    func sayHello()
    {
        print("老师你好，我作业放在家里忘带了")
    }
}


