//
//  SubjectDetailViewController.swift
//  UseRxSwift
//
//  Created by 谢佳培 on 2021/1/18.
//

import UIKit
import RxCocoa
import RxSwift 

class SubjectDetailViewController: UIViewController
{
    var todoNameTextField: UITextField! = UITextField(frame: CGRect(x: 20, y: 150, width: 200, height: 50))
    var isFinishedSwitch: UISwitch! = UISwitch(frame: CGRect(x: 20, y: 300, width: 150, height: 50))
    var done: Bool = false
    var model: SubjectModel!
    let disposeBag = DisposeBag()
    
    // 创建序列，由列表订阅，在详情里发起响应
    // todoSubject只在这个文件可用，因为只有在详情界面才更改待办事项的名字
    fileprivate let todoSubject = PublishSubject<SubjectModel>()
    // todoObservable提供给外界订阅详情中的待办事项获取其数据，但是不能对其进行更改
    var todoObservable: Observable<SubjectModel>
    {
        return todoSubject.asObservable()
    }

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        todoNameTextField.becomeFirstResponder()
        
        // 点击列表面里的cell进入详情界面需要显示数据
        if let model = model
        {
            todoNameTextField.text = model.title
            isFinishedSwitch.isOn = model.isFinished
        }
        // 点击新增cell进入详情界面无数据
        else
        {
            model = SubjectModel(title: "", isFinished: false)
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupUI()
        done = false
    }

    func setupUI()
    {
        self.title = "新增待办事项详情"
        self.view.backgroundColor = .white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .done, target: self, action: #selector(didClickDoneAction))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .cancel, target: self, action: #selector(didClickCancelAction))
        
        let todoNameLabel = UILabel(frame: CGRect(x: 20, y: 100, width: 100, height: 50))
        todoNameLabel.text = "待办事项"
        
        let stateLabel = UILabel(frame: CGRect(x: 20, y: 250, width: 150, height: 50))
        stateLabel.text = "事项状态"
        
        todoNameTextField.backgroundColor = .lightGray
        view.addSubview(todoNameTextField)
        view.addSubview(isFinishedSwitch)
        view.addSubview(todoNameLabel)
        view.addSubview(stateLabel)
    }
    
    @objc func didClickCancelAction()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func didClickDoneAction()
    {
        // 点击完成按钮后将model作为信号发送到上一个列表界面
        model.title = todoNameTextField.text ?? ""
        model.isFinished = isFinishedSwitch.isOn
        todoSubject.onNext(model)
        self.navigationController?.popViewController(animated: true)
    }
}

