//
//  Subject.swift
//  UseRxSwift
//
//  Created by 谢佳培 on 2021/1/18.
//

import UIKit
import RxCocoa
import RxSwift

class Subject: UIViewController
{
    let disposeBag = DisposeBag()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        //publishSubject()
        
        //behaviorSubject()
        
        //replaySubject()
        
        //asyncSubject()
        
        behaviorRelay()
    }
    
    func publishSubject()
    {
        // 1:初始化序列
        let publishSubject = PublishSubject<Int>()
        
        // 2:发送信号（这里信号就是响应序列）
        // 订阅之前的消息都会被忽略掉，所以不会输出发送的1
        publishSubject.onNext(1)
        
        // 3:订阅信号
        publishSubject.subscribe { print("订阅到了:",$0)}
            .disposed(by: disposeBag)
        // 4:再次发送信号（响应序列）
        publishSubject.onNext(2)
        publishSubject.onNext(3)
    }
    
    func behaviorSubject()
    {
        // 1:创建序列
        // 当没有信号的时候，会默认发送信号：100
        let behaviorSubject = BehaviorSubject.init(value: 100)
        
        // 2:发送信号
        // 还没有订阅信号，这里只是保存
        // 保存的时候后面的信号会覆盖掉前面的，导致前面的信号不再发送
        behaviorSubject.onNext(2)
        behaviorSubject.onNext(3)
        
        // 3:订阅信号
        behaviorSubject.subscribe{ print("过年 订阅到了:",$0)}
            .disposed(by: disposeBag)
        
        // 再次发送
        behaviorSubject.onNext(4)
        behaviorSubject.onNext(5)
        
        // 再次订阅，此时订阅到的信号是最后一次发出的信号
        behaviorSubject.subscribe{ print("回家 订阅到了:",$0)}
            .disposed(by: disposeBag)
    }
    
    func replaySubject()
    {
        // 1:创建序列
        // 2表示能够保存订阅序列之前的两个信号
        let replaySubject = ReplaySubject<Int>.create(bufferSize: 2)

        // 2:发送信号
        replaySubject.onNext(1)
        replaySubject.onNext(2)
        replaySubject.onNext(3)
        replaySubject.onNext(4)

        // 3:订阅信号
        replaySubject.subscribe{ print("订阅到了:",$0)}
            .disposed(by: disposeBag)
        
        // 再次发送
        replaySubject.onNext(7)
        replaySubject.onNext(8)
        replaySubject.onNext(9)
    }
    
    func asyncSubject()
    {
        // 1:创建序列
        let asyncSubject = AsyncSubject<Int>.init()
        
        // 2:发送信号
        asyncSubject.onNext(1)
        asyncSubject.onNext(2)
        
        // 3:订阅信号
        asyncSubject.subscribe{ print("订阅到了:",$0)}
            .disposed(by: disposeBag)
        
        // 再次发送
        asyncSubject.onNext(3)
        asyncSubject.onNext(4)
        //asyncSubject.onError(NSError.init(domain: "大学压迫", code: 10086, userInfo: nil))
        asyncSubject.onCompleted()
    }
    
    func behaviorRelay()
    {
        let behaviorRelay = BehaviorRelay(value: 100)
        print("不写闭包了:\(behaviorRelay.value)")
        behaviorRelay.accept(1000)
        print("天妒英才:\(behaviorRelay.value)")
    }

}

