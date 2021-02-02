//
//  LearnMoyaViewController.swift
//  UseMoya
//
//  Created by 谢佳培 on 2021/2/1.
//

import UIKit
import SwiftyJSON
 
class DouBanViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    // 显示频道列表的tableView
    var tableView:UITableView!
     
    // 频道列表数据
    var channels:Array<JSON> = []
     
    override func viewDidLoad()
    {
        super.viewDidLoad()
         
        // 创建表视图
        self.tableView = UITableView(frame:self.view.frame, style:.plain)
        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        
        // 创建一个重用的单元格
        self.tableView!.register(UITableViewCell.self,forCellReuseIdentifier: "SwiftCell")
        self.view.addSubview(self.tableView!)
         
        // 使用我们的provider进行网络请求（获取频道列表数据）
        DouBanProvider.request(.channels)
        { result in
            if case let .success(response) = result
            {
                // 解析数据
                let data = try? response.mapJSON()
                let json = JSON(data!)
                self.channels = json["channels"].arrayValue
                 
                // 刷新表格数据
                DispatchQueue.main.async
                {
                    self.tableView.reloadData()
                }
            }
        }
    }
     
    // 返回表格分区数
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
     
    // 返回表格行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return channels.count
    }
     
    // 创建各单元显示内容(创建参数indexPath指定的单元）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell
    {
            // 为了提供表格显示性能，已创建完成的单元需重复使用
            let identify:String = "SwiftCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: identify, for: indexPath)
            cell.accessoryType = .disclosureIndicator
            // 设置单元格内容
            cell.textLabel?.text = channels[indexPath.row]["name"].stringValue
            return cell
    }
     
    // 处理列表项的选中事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        // 获取选中项信息
        let channelName = channels[indexPath.row]["name"].stringValue
        let channelId = channels[indexPath.row]["channel_id"].stringValue
         
        // 使用我们的provider进行网络请求（根据频道ID获取下面的歌曲）
        DouBanProvider.request(.playlist(channelId))
        { result in
            if case let .success(response) = result
            {
                // 解析数据，获取歌曲信息
                let data = try? response.mapJSON()
                let json = JSON(data!)
                let music = json["song"].arrayValue[0]
                let artist = music["artist"].stringValue
                let title = music["title"].stringValue
                let message = "歌手：\(artist)\n歌曲：\(title)"
                 
                // 将歌曲信息弹出显示
                self.showAlert(title: channelName, message: message)
            }
        }
    }
     
    // 显示消息
    func showAlert(title:String, message:String)
    {
        let alertController = UIAlertController(title: title,message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}


