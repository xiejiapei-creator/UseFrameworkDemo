//
//  ReplacesUIElement.swift
//  UseRxSwift
//
//  Created by 谢佳培 on 2021/1/13.
//

import UIKit
import RxCocoa
import RxSwift

fileprivate let minUsernameLength = 5
fileprivate let minPasswordLength = 6

class ReplacesUIElement: UIViewController
{
    let disposeBag = DisposeBag()
    var button: UIButton = UIButton(frame: CGRect(x: 130, y: 200, width: 200, height: 50));
    var textFiled: UITextField = UITextField(frame: CGRect(x: 130, y: 300, width: 200, height: 50))
    var scrollView: UIScrollView = UIScrollView(frame: CGRect(x: 130, y: 400, width: 200, height: 300))
    var label: UILabel = UILabel(frame: CGRect(x: 130, y: 620, width: 200, height: 50))
    var timer: Observable<Int>!
    
    var usernameTextFiled: UITextField! = UITextField(frame: CGRect(x: 50, y: 150, width: 300, height: 50))
    var usernameValidLabel: UILabel! = UILabel(frame: CGRect(x: 50, y: 220, width: 200, height: 50))
    var passwordTextFiled: UITextField! = UITextField(frame: CGRect(x: 50, y: 350, width: 300, height: 50))
    var passwordValidLabel: UILabel! = UILabel(frame: CGRect(x: 50, y: 420, width: 300, height: 50))
    var loginBtn: UIButton! = UIButton(frame: CGRect(x: 100, y: 550, width: 200, height: 50))
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // 使用RxSwift来控制button响应
        //setupButton()
        
        // 传统的textfiled文本响应的方式
        //traditionTextFiled()
        
        // 使用RxSwift来控制textfiled文本响应
        //setupTextFiled()
        
        // 使用RxSwift来控制scrollView滚动效果
        //setupScrollerView()
        
        // 使用RxSwift来控制手势响应
        //setupGestureRecognizer()
        
        // 使用RxSwift来控制通知事件
        //setupNotification()
        
        // 使用RxSwift来控制timer定时器
        //setupTimer()
        
        // 传统的网络请求方式
        //traditionNetwork()
        
        // 使用RxSwift来控制网络请求
        //setupNextwork()
        
        // 创建按钮是否可以点击视图
        createButtonEnableSubview()
        // 使用RxSwift来控制按钮是否可以点击
        setupButtonEnable()
    }

    func setupButton()
    {
        button.backgroundColor = .black
        button.setTitle("Button", for: .normal)
        self.button.rx.tap
            .subscribe(onNext: { () in print("点击了按钮")})
            .disposed(by: disposeBag)
        self.view.addSubview(button)
    }
    
    func traditionTextFiled()
    {
        self.textFiled.delegate = self
        textFiled.backgroundColor = .orange
        self.view.addSubview(textFiled)
    }
    
    func setupTextFiled()
    {
        textFiled.backgroundColor = .orange
        self.view.addSubview(textFiled)
        
        self.textFiled.rx.text.orEmpty.changed
            .subscribe(onNext: { (text) in print("监听到用户输入的文本为：\(text)") })
            .disposed(by: disposeBag)
        
        self.textFiled.rx.text
            .bind(to: self.button.rx.title())
            .disposed(by: disposeBag)
    }
    
    func setupScrollerView()
    {
        scrollView.backgroundColor = .yellow
        scrollView.contentSize = CGSize(width: 200, height: 300 * 4)
        self.view.addSubview(scrollView)

        scrollView.rx.contentOffset
            .subscribe(onNext: { [weak self] (content) in
                self?.view.backgroundColor = UIColor.init(red: content.y/255.0*0.8, green: content.y/255.0*0.3, blue: content.y/255.0*0.6, alpha: 1.0)
                print(content.y)
            })
            .disposed(by: disposeBag)
    }
    
    func setupGestureRecognizer()
    {
        let tap = UITapGestureRecognizer()
        self.label.addGestureRecognizer(tap)
        self.label.isUserInteractionEnabled = true
        self.label.text = "手势"
        self.label.backgroundColor = .brown
        view.addSubview(self.label)
        tap.rx.event
            .subscribe(onNext: { tap in print(tap.view!)})
            .disposed(by: disposeBag)
    }
    
    func setupNotification()
    {
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .subscribe(onNext: { notification in print(notification)})
            .disposed(by: disposeBag)
    }
    
    func setupTimer()
    {
        timer = Observable<Int>.interval(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
        timer.subscribe(onNext: { num in print("下雪了❄️")})
            .disposed(by: disposeBag)
    }
    
    func traditionNetwork()
    {
        let url = URL(string: "https://www.baidu.com")
        URLSession.shared.dataTask(with: url!)
        { (data, response, error) in
            print(String.init(data: data!, encoding: .utf8)!)
        }.resume()
    }
    
    func setupNextwork()
    {
        let url = URL(string: "https://www.baidu.com")
        URLSession.shared.rx.response(request: URLRequest(url: url!))
            .subscribe(onNext: { (response, data) in print(data)})
            .disposed(by: disposeBag)
    }
    
    func createButtonEnableSubview()
    {
        usernameTextFiled.backgroundColor = .yellow
        passwordTextFiled.backgroundColor = .orange
        usernameValidLabel.text = "用户名长度不小于5"
        passwordValidLabel.text = "密码提示文本长度不小于6"
        usernameValidLabel.textColor = .red
        passwordValidLabel.textColor = .red
        loginBtn.setTitle("登录", for: .normal)
        loginBtn.backgroundColor = .red
        view.addSubview(usernameTextFiled)
        view.addSubview(usernameValidLabel)
        view.addSubview(passwordTextFiled)
        view.addSubview(passwordValidLabel)
        view.addSubview(loginBtn)
    }
    
    func setupButtonEnable()
    {
        // 用户名是否有效
        let usernameVaild = usernameTextFiled.rx.text.orEmpty
            .map { (text) -> Bool in return text.count >= minUsernameLength }
            
        // 根据用户名是否有效来判断用户名有效提示框是否需要隐藏，密码输入框是否允许输入
        usernameVaild.bind(to: usernameValidLabel.rx.isHidden)
            .disposed(by: disposeBag)
        usernameVaild.bind(to: passwordTextFiled.rx.isEnabled)
            .disposed(by: disposeBag)
        
        // 密码是否有效
        let passwordVaild = passwordTextFiled.rx.text.orEmpty
            .map { (text) -> Bool in return text.count >= minPasswordLength }
                
        // 根据密码是否有效来判断密码有效提示框是否需要隐藏
        passwordVaild.bind(to: passwordValidLabel.rx.isHidden)
            .disposed(by: disposeBag)

        // 密码和用户名同时有效才允许按钮点击
        Observable.combineLatest(usernameVaild, passwordVaild){ $0 && $1}
            .bind(to: loginBtn.rx.isEnabled)
            .disposed(by: disposeBag)

        // 点击按钮打印文本
        loginBtn.rx.tap.subscribe(onNext: { () in
            print("源代码分析好恶心，头都绕晕了")
        }).disposed(by: disposeBag)
    }
}


extension ReplacesUIElement: UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if let num = Int(string)
        {
            if num % 2 == 1
            {
                print("打印输入的奇数:\(num)")
            }
        }
        return true
    }
}

 




