//
//  UseURLSession.swift
//  UseAlamofire
//
//  Created by 谢佳培 on 2021/1/21.
//

import UIKit

class UseURLSession: UIViewController
{
    let downloadUrlString = "https://pic.ibaotu.com/00/48/71/79a888piCk9g.mp4"
    
    lazy var downloadUrl: URL =
    {
        return URL(string: downloadUrlString)!
    }()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // 请求网络
        //requestNetwork()
        
        // 区别Configuration中的default与ephemeral
        //distinguishConfiguration()
        
        // 切换到后台停止下载问题
        backgroundDownload()
    }
    
    // 请求网络
    func requestNetwork()
    {
        let url = URL(string: "https://www.baidu.com")!
        URLSession.shared.dataTask(with: url)
        { (data, response, error) in
            if error == nil
            {
                print("请求网络成功：\(String(describing: response))" )
            }
        }.resume()
    }

    // 区别Configuration中的default与ephemeral
    func distinguishConfiguration()
    {
        let defaultConfiguration = URLSessionConfiguration.default
        let ephemeralConfiguration = URLSessionConfiguration.ephemeral
        print("default 沙盒大小: \(String(describing: defaultConfiguration.urlCache?.diskCapacity))")
        print("default 内存大小: \(String(describing: defaultConfiguration.urlCache?.memoryCapacity))")
        print("ephemeral 沙盒大小: \(String(describing: ephemeralConfiguration.urlCache?.diskCapacity))")
        print("ephemeral 内存大小: \(String(describing: ephemeralConfiguration.urlCache?.memoryCapacity))")
    }
    
    // 切换到后台停止下载问题
    func backgroundDownload()
    {
        // 配置Configuration
        let backgroundConfiguration = URLSessionConfiguration.background(withIdentifier: "xie")
        
        
        
        // 创建URLSession
        let backgroundURLSession = URLSession.init(configuration: backgroundConfiguration, delegate: self, delegateQueue: OperationQueue.main)
        
        // 开始下载
        backgroundURLSession.downloadTask(with: downloadUrl).resume()
    }
}

// MARK: - 返回数据调用代理

extension UseURLSession: URLSessionDownloadDelegate
{
    // 下载完成后进行沙盒迁移，拷贝下载完成的文件到用户目录（文件名以时间戳命名）
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL)
    {
        print("下载完成后文件位置：\(location)")
        let originalLocationPath = location.path
        let destinationPath = NSHomeDirectory() + "/Documents/" + currentDateTurnString() + ".mp4"
        print("文件移动后的位置：\(destinationPath)")
        let fileManager = FileManager.default
        try! fileManager.moveItem(atPath: originalLocationPath, toPath: destinationPath)
    }
    
    // 计算下载进度
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64)
    {
        print("bytesWritten: \(bytesWritten)\n totalBytesWritten: \(totalBytesWritten)\n totalBytesExpectedToWrite: \(totalBytesExpectedToWrite)")
        
        print("下载进度条：\( Double(totalBytesWritten) / Double(totalBytesExpectedToWrite) )")
    }
    
    // 调用保存的后台下载回调，告诉系统及时更新屏幕
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession)
    {
        print("让后台任务保持下载")
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate, let backgroundHandle = appDelegate.backgroundSessionCompletionHandler else { return }
            backgroundHandle()
        }
    }
}

// MARK: - 时间格式处理

extension UseURLSession
{
    // 创建唯一标识ID
    func createID() -> String
    {
        let date: Date = Date.init()
        let timeInterval:TimeInterval = date.timeIntervalSince1970
        return "\(timeInterval)"
    }
    
    // 当前日期转化为字符串
    func currentDateTurnString() -> String
    {
        return dateTurnString(Date(), dateFormat: "yyyyMMddHHmmss")
    }
    
    func dateTurnString(_ date: Date, dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> String
    {
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = dateFormat
        let dateString = formatter.string(from: date)
        return dateString
    }
}
