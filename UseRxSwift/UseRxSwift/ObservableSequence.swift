//
//  ObservableSequence.swift
//  UseRxSwift
//
//  Created by 谢佳培 on 2021/1/15.
//

import UIKit
import RxCocoa
import RxSwift

class ObservableSequence: UIViewController
{
    var disposeBag = DisposeBag()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // 产生空序列
        //empty()
        
        // 产生单个信号序列
        //just()
        
        // 可以接受同类型的数量可变的参数
        //of()
        
        // 将可选序列转换为可观察序列
        //from()
        
        // 根据外界条件产生不同序列
        //deferred()
        
        // 生成指定范围的可观察序列
        //rang()
        
        // 整数累加和数组遍历
        //generate()
        
        // 生成重复给定元素的可观察序列
        //repeatElement()
        
        // 返回一个以错误信息结束的可观察序列
        //error()
        
        // 永远不会发出事件的可观察序列
        //never()
        
        // 最常用的方法
        create()
    }
    
    func empty()
    {
        let emptyObservable = Observable<Int>.empty()

        _ = emptyObservable.subscribe(onNext: { (number) in
            print("订阅：",number)
        }, onError: { (error) in
            print("错误：",error)
        }, onCompleted: {
            print("完成")
        }) {
            print("释放回调")
        }
    }
    
    func just()
    {
        // 方式一
        let array = ["天地玄黄","宇宙洪荒"]
        Observable<[String]>.just(array)
            .subscribe { (number) in print(number)}
            .disposed(by: disposeBag)

        // 方式二
        _ = Observable<[String]>.just(array).subscribe(onNext: { (number) in
            print("订阅:",number)
        }, onError: { (error) in
            print("错误:",error)
        }, onCompleted: {
            print("完成回调")
        }) {
            print("释放回调")
        }
    }
    
    func of()
    {
        // 多个元素
        Observable<String>.of("百尺竿头","更进一步")
            .subscribe { (event) in print(event) }
            .disposed(by: disposeBag)

        // 字典
        Observable<[String: Any]>.of(["name":"谢佳培","age":23])
            .subscribe { (event) in
                print(event)
            }.disposed(by: disposeBag)

        // 数组
        Observable<[String]>.of(["瑞幸咖啡","神州优车集团"])
            .subscribe { (event) in print(event)}
            .disposed(by: disposeBag)
    }
    
    func from()
    {
        Observable<[String]>.from(optional: ["华东师范大学","厦门大学","华侨大学"])
            .subscribe { (event) in print(event) }
            .disposed(by: disposeBag)
    }
    
    func deferred()
    {
        let isOdd = true// 是否是奇数
        _ = Observable<Int>.deferred
        { () -> Observable<Int> in
            if isOdd
            {
                return Observable.of(1,3,5,7,9)
            }
            else
            {
                return Observable.of(0,2,4,6,8)
            }
            
        }
        .subscribe { (event) in print(event) }
    }
    
    func rang()
    {
        Observable.range(start: 2, count: 5)
            .subscribe { (event) in print(event) }
            .disposed(by: disposeBag)
    }
    
    func generate()
    {
        // 整数累加
        Observable.generate(initialState: 0,// 初始值
                            condition: { $0 < 10}, // 条件 直到小于10
                            iterate: { $0 + 2 })  // 迭代 每次+2
            .subscribe { (event) in print(event) }
            .disposed(by: disposeBag)

        // 数组遍历
        let array = ["女孩1","女孩2","女孩3","女孩4","女孩5"]
        Observable.generate(initialState: 0,
            condition: { $0 < array.count},
            iterate: { $0 + 1 })
            .subscribe(onNext: { print("遍历数组结果:",array[$0])})
            .disposed(by: disposeBag)
    }
    
    func repeatElement()
    {
        Observable<Int>.repeatElement(5)
            .subscribe { (event) in print("酒量:",event)}
            .disposed(by: disposeBag)
    }
    
    func error()
    {
        Observable<String>.error(NSError.init(domain: "error", code: 1997, userInfo: ["reason":"薪资太低"]))
            .subscribe { (event) in print("订阅:",event) }
            .disposed(by: disposeBag)
    }
    
    func never()
    {
        Observable<String>.never()
            .subscribe { (event) in print("兔子🐰，我保证永远都不变心，可以把屠龙宝刀放下了吗？",event) }
            .disposed(by: disposeBag)
    }
    
    func create()
    {
        // 1.创建序列
        let observable = Observable<String>.create
        { observer in
            // 3.发送消息
            // 对订阅者发出.next事件，且携带了一个数据"这是一篇富有..."
            observer.onNext("这是一篇富有启发性的有趣文章，希望你们喜欢")
            // 对订阅者发出.completed事件
            observer.onCompleted()
            // 因为一个订阅行为会有一个Disposable类型的返回值，所以在结尾一定要返回一个Disposable
            return Disposables.create()
        }
         
        // 2.订阅消息
        _ = observable.subscribe{ print("粉丝阅读了公众号（漫游在云海的鲸鱼）发来的消息：\($0)") }
    }
}
















