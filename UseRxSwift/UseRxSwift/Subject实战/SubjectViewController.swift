//
//  SubjectViewController.swift
//  UseRxSwift
//
//  Created by 谢佳培 on 2021/1/18.
//

import UIKit
import RxSwift

class SubjectViewController: UIViewController
{
    let resuseID = "SubjectViewController"
    var modelItems: [SubjectModel] = []
    var modelsSubject: BehaviorSubject<[SubjectModel]>?
    let disposeBag = DisposeBag()
    
    lazy var tableView: UITableView =
    {
        let table = UITableView.init(frame: CGRect(x: 0, y: navigationHeight, width: kScreenWidth, height: kScreenHeight-navigationHeight-bottomViewHeight), style: .plain)
        table.delegate = self
        table.dataSource = self
        table.rowHeight = 50
        table.tableFooterView = UIView()
        table.register(SubjectCell.classForCoder(), forCellReuseIdentifier: resuseID)
        return table
    }()
    
    lazy var deleteButton: UIButton =
    {
        let button = UIButton(frame: CGRect(x: buttonMargin, y: kScreenHeight-bottomViewHeight+buttonMargin, width: buttonSize, height: buttonSize))
        button.setBackgroundImage(UIImage.init(named: "Delete"), for: .normal)
        return button
    }()
    
    lazy var saveButton: UIButton =
    {
        let button = UIButton(frame: CGRect(x: kScreenWidth-buttonMargin-buttonSize, y: kScreenHeight-bottomViewHeight+buttonMargin, width: buttonSize, height: buttonSize))
        button.setBackgroundImage(UIImage.init(named: "Save"), for: .normal)
        return button
    }()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        setupUI()
        
        // 将从数据库中获取到的所有数据作为modelsSubject的初始值
        modelsSubject = BehaviorSubject(value: SubjectCacheManager.manager.fetachModelData())
        modelsSubject?.subscribe(onNext:
        { [weak self](items) in
            self?.modelItems = items// 将获取的所有数据赋值给列表
            self?.tableView.reloadData()// 刷新表视图
            self?.deleteButton.isEnabled = !items.isEmpty// items非空的话删除按钮便可点击
            SubjectCacheManager.manager.updataAllData(models: items)// 根据items更新数据库
            
            // 列表中没有完成的待办事项的数量
            let num = items.filter(
            { (model) -> Bool in
                return !model.isFinished
            }).count
            // 待办事项的数量小于6，导航栏的添加按钮便可点击
            self?.navigationItem.rightBarButtonItem?.isEnabled = num <= 6
            // 更新标题
            self?.title = num == 0 ? "Subject实战" : "还有 \(num) 条待办事项"
        }).disposed(by: disposeBag)
    }
    

    func setupUI()
    {
        self.title = "Subject实战"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(didClickAddAction))
        
        self.view.backgroundColor = UIColor.lightGray
        self.view.addSubview(tableView)
        self.view.addSubview(deleteButton)
        self.view.addSubview(saveButton)
    }
    
    @objc func didClickAddAction()
    {
//        let newRowIndex = modelItems.count
//        let indexPath = IndexPath(row: newRowIndex, section: 0)
//        let model = SubjectModel(title:"多喝牛奶可以长高哦：\(Date().timeIntervalSince1970)", isFinished: false)
//        modelItems.append(model)
//        tableView.insertRows(at: [indexPath], with: .automatic)
//
//        // 将添加新行后的列表作为信号发送出去
//        modelsSubject?.onNext(modelItems)

        // 进入详情界面添加cell
        pushToDetailVC(model: nil)
    }
    
    fileprivate func pushToDetailVC(model:SubjectModel?)
    {
        let detailVC = SubjectDetailViewController.init()
        if let model = model
        {
            detailVC.model = model
        }
        
        // 订阅信号后在回调闭包中更新UI
        detailVC.todoObservable.subscribe(onNext:
        { [weak self](model) in
            self?.modelItems.append(model)
            self?.modelsSubject?.onNext(self?.modelItems ?? [])
        }).disposed(by: disposeBag)
        
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
}

extension SubjectViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return modelItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = SubjectCell.init(style: .default, reuseIdentifier: resuseID)
        cell.upDataUIWithModle(model: modelItems[indexPath.row])
        return cell
    }
}

extension SubjectViewController: UITableViewDelegate
{
    // 删除cell
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        // 将删除cell后的列表作为信号发送出去
        modelItems.remove(at: indexPath.row)
        modelsSubject?.onNext(modelItems)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // 修改cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let model = modelItems[indexPath.row]
//
//        // 将完成状态反转后的列表作为信号发送出去
//        model.toggleFinished()
//        modelsSubject?.onNext(modelItems)
        
        // 进入详情界面修改cell
        pushToDetailVC(model: model)
    }
}
