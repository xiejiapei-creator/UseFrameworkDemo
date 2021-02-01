//
//  UsePop.swift
//  UseMoya
//
//  Created by 谢佳培 on 2021/1/30.
//

import Foundation
import UIKit

class UsePop: UIViewController
{
    var nickName: UILabel! = UILabel(frame: CGRect(x: 100, y: 350, width: 200, height: 50))
    var ageLabel: UILabel! = UILabel(frame: CGRect(x: 100, y: 450, width: 200, height: 50))
    var hobbyLabel: UILabel! = UILabel(frame: CGRect(x: 100, y: 550, width: 200, height: 50))
    var petPhraseLabel: UILabel! = UILabel(frame: CGRect(x: 100, y: 650, width: 300, height: 50))
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        createSubviews()
        
        //requestNetwork()
        
        requestLocalFile()
    }
    
    func createSubviews()
    {
        nickName.backgroundColor = .orange
        ageLabel.backgroundColor = .orange
        hobbyLabel.backgroundColor = .orange
        petPhraseLabel.backgroundColor = .orange
        view.addSubview(nickName)
        view.addSubview(ageLabel)
        view.addSubview(hobbyLabel)
        view.addSubview(petPhraseLabel)
    }
    
    // 请求网络
    func requestNetwork()
    {
        // 根据传入的name创建request
        let request = PersonRequest(name: "Xiejiapei")
        
        // 客户端发送request
        URLSessionClient().send(request)
        { [weak self](person) in
            // 根据服务端返回的数据更新UI
            if let person = person
            {
                // 更新UI
                print("\(person.hobby) from \(person.name)")
                self?.updataUI(person: person)
            }
        }
    }
    
    // 请求本地文件
    func requestLocalFile()
    {
        let client = LocalFileClient()
        client.send(PersonRequest(name: "xiejiapei"))
        { [weak self](person) in
            if let person = person
            {
                print("\(person.hobby) from \(person.name)")
                self?.updataUI(person: person)
            }
        }
    }
    
    // 更新UI
    func updataUI(person:Person)
    {
        nickName.text   = person.name
        ageLabel.text   = person.age
        hobbyLabel.text = person.hobby
        petPhraseLabel.text = person.petPhrase
    }
}





