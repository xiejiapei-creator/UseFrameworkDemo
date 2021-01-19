//
//  NotUseSubjectViewController.swift
//  UseRxSwift
//
//  Created by 谢佳培 on 2021/1/18.
//

import UIKit
import RxSwift

// 底部的安全距离
let bottomSafeAreaHeight =  UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0.0
// 顶部的安全距离
let topSafeAreaHeight = CGFloat(bottomSafeAreaHeight == 0 ? 0 : 24)
// 状态栏高度
let statusBarHeight = UIApplication.shared.statusBarFrame.height;
// 导航栏高度
let navigationHeight = CGFloat(bottomSafeAreaHeight == 0 ? 64 : 88)
// tabbar高度
let tabBarHeight = CGFloat(bottomSafeAreaHeight + 49)
// 屏幕宽度
let kScreenWidth = UIScreen.main.bounds.width
// 屏幕高度
let kScreenHeight = UIScreen.main.bounds.height
// 底部视图高度
let bottomViewHeight = CGFloat(124)
// 底部按钮的大小
let buttonSize = CGFloat(64)
// 底部按钮布局空隙
let buttonMargin = CGFloat(36)


class NotUseSubjectViewController: UIViewController
{
    let resuseID = "NotUseSubjectViewController"
    var modelItems: [SubjectModel] = []
    var modelsSub: BehaviorSubject<[SubjectModel]>?
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
        
        // 从数据库中获取到所有数据
        modelItems = SubjectCacheManager.manager.fetachSubjectModelData()
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
        // 新行的index
        let newRowIndex = modelItems.count
        // 将index转化为IndexPath
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        // 根据IndexPath在table中插入新行
        tableView.insertRows(at: [indexPath], with: .automatic)
        
        // 创建新行的数据
        let model = SubjectModel(title:"多喝牛奶可以长高哦：\(Date().timeIntervalSince1970)", isFinished: false)
        // 将新行的数据添加到数据列表中
        modelItems.append(model)
        // 将新行的数据添加到数据库中
        SubjectCacheManager.manager.insertModelToTable(models: [model])
    }
    
}

extension NotUseSubjectViewController: UITableViewDataSource
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

extension NotUseSubjectViewController: UITableViewDelegate
{
    // 删除cell
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        // 从数据库中删除数据
        SubjectCacheManager.manager.deleteSubjectModelData(model: modelItems[indexPath.row])
        
        // 从数据列中删除数据
        modelItems.remove(at: indexPath.row)
        
        // 从table中删除cell
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // 修改cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let model = modelItems[indexPath.row]
        // 将是否完成状态进行反转
        model.toggleFinished()
        // 将完成状态反转后到model更新到数据库中
        SubjectCacheManager.manager.updataSubjectModelData(model: model)
        // 刷新table中状态反转的cell
        tableView.reloadRows(at: [indexPath], with: .fade)
        
        // 获取数据库中的所有数据打印出来
        let array = SubjectCacheManager.manager.fetachSubjectModelData()
        for item in array
        {
            print("\(item.title) --- \(item.isFinished)")
        }
    }
}





