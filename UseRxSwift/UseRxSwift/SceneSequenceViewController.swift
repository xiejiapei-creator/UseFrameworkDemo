//
//  SceneSequenceViewController.swift
//  UseRxSwift
//
//  Created by 谢佳培 on 2021/1/20.
//

import UIKit
import RxCocoa
import RxSwift

class SceneSequenceViewController: UIViewController
{
    var disposeBag = DisposeBag()
    var button: UIButton = UIButton(frame: CGRect(x: 130, y: 200, width: 200, height: 50));
    var textFiled: UITextField = UITextField(frame: CGRect(x: 130, y: 300, width: 200, height: 50))
    var label: UILabel = UILabel(frame: CGRect(x: 130, y: 380, width: 200, height: 50))
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        createSubview()
        
        //controlEvent()
        bind()
    }
    
    func controlEvent()
    {
        let controlEventObservable = self.button.rx.controlEvent(.touchUpInside)

        controlEventObservable
            .subscribe
            { (reslut) in
                print("订阅:\(reslut) \n \(Thread.current)")
            }
            .disposed(by: disposeBag)
    }
    
    func bind()
    {
        // 将文本框的输入文本和Lable显示的文本绑定
        self.textFiled.rx.text
            .bind(to: self.label.rx.text)
            .disposed(by: disposeBag)
    }
 
    
    func createSubview()
    {
        button.backgroundColor = .black
        button.setTitle("Button", for: .normal)
        self.view.addSubview(button)
        
        textFiled.backgroundColor = .orange
        self.view.addSubview(textFiled)
        
        self.label.text = "Label"
        self.label.backgroundColor = .brown
        view.addSubview(self.label)
    }

}


