//
//  FunctionalResponsiveProgramming.swift
//  RxSwift
//
//  Created by 谢佳培 on 2021/1/13.
//

import UIKit
import RxCocoa
import RxSwift

class Person: NSObject
{
   @objc dynamic var identity:String = "XieJiapei 平民"
}

class FunctionalResponsiveProgramming: UIViewController
{
    var person: Person = Person()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
 
        // 函数式
        functionalExpression()
        
        // 使用KVO实现响应式
        // useKVO()
         
        // 使用RxSwift实现响应式
        useRxSwiftObserver()
    }
    
    // 函数式
    func functionalExpression()
    {
        let array = [1,2,3,4,5,6,7]
        for num in array
        {
            if num > 3
            {
                let number = num + 1
                if (number % 2 == 0)
                {
                    print(number)
                }
            }
        }
        array.filter{ $0 > 3 }
            .filter{ ($0 + 1) % 2 == 0 }
            .forEach{ print($0) }
    }
    
    // 手指点击屏幕更改了人物身份
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        print("敌军发送了一条至关重要的情报")
        person.identity = "\(person.identity)，这个人真实身份是卧底，速速接应"
    }
    
    // 使用KVO实现响应式，为人物身份添加观察者观察该值变化
    func useKVO()
    {
        self.person.addObserver(self, forKeyPath: "identity", options: .new, context: nil)
    }
    
    // KVO中观察到值发生变化时调用的函数
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        print("报告长官，我部已成功截获敌军信息")
        print(change as Any)
    }

    // 销毁KVO中的观察者，不再进行观察该值变化
    deinit
    {
        self.removeObserver(self.person, forKeyPath: "identity")
    }
    
    // 使用RxSwift实现响应式
    func useRxSwiftObserver()
    {
        self.person.rx.observeWeakly(String.self, "identity") // 为该值添加观察者
            .subscribe(onNext: { (value) in print(value as Any)})// 观察到值发生变化时调用输出最新值
            .disposed(by: disposeBag)// 将它放到垃圾袋中等下次出门了一起扔掉
    }
}




