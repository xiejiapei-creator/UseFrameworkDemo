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

class ReplacesUIElement: UIViewController, UIScrollViewDelegate
{
    var disposeBag = DisposeBag()
    var button: UIButton = UIButton(frame: CGRect(x: 130, y: 200, width: 200, height: 50));
    var textFiled: UITextField = UITextField(frame: CGRect(x: 130, y: 300, width: 200, height: 50))
    var scrollView: UIScrollView = UIScrollView(frame: CGRect(x: 130, y: 400, width: 200, height: 300))
    var label: UILabel = UILabel(frame: CGRect(x: 130, y: 620, width: 200, height: 50))
    var timer: Observable<Int>!
    var traditionTimer = Timer()
    var gcdTimer: DispatchSourceTimer!
    var displayLink: CADisplayLink!
    
    var usernameTextFiled: UITextField! = UITextField(frame: CGRect(x: 50, y: 150, width: 300, height: 50))
    var usernameValidLabel: UILabel! = UILabel(frame: CGRect(x: 50, y: 220, width: 200, height: 50))
    var passwordTextFiled: UITextField! = UITextField(frame: CGRect(x: 50, y: 350, width: 300, height: 50))
    var passwordValidLabel: UILabel! = UILabel(frame: CGRect(x: 50, y: 420, width: 300, height: 50))
    var loginBtn: UIButton! = UIButton(frame: CGRect(x: 100, y: 550, width: 200, height: 50))
    
    var timeLabel: UILabel! = UILabel(frame: CGRect(x: 150, y: 200, width: 300, height: 100))
    var countLable: UILabel!
    var tableView: UITableView!
    var playButton: UIButton! = UIButton(frame: CGRect(x: 100, y: 320, width: 50, height: 50))
    var splitUpButton: UIButton! = UIButton(frame: CGRect(x: 180, y: 320, width: 100, height: 50))
    var stopButton: UIButton! = UIButton(frame: CGRect(x: 300, y: 320, width: 50, height: 50))
    
    
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
        
        // 传统控制定时器的方式
        //setupTraditionTimer()
        
        // 使用RxSwift来控制timer定时器
        //setupTimer()
        
        // 传统的网络请求方式
        //traditionNetwork()
        
        // 使用RxSwift来控制网络请求
        //setupNextwork()
        
        // 创建按钮是否可以点击视图
        //createButtonEnableSubview()
        // 使用RxSwift来控制按钮是否可以点击
        //setupButtonEnable()
        
        // 使用RxSwift来控制Table视图
        createTableView()
        setUpTableView()
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
                //print(content.y)
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
    
    func setupTraditionTimer()
    {
        // 方案一
        self.traditionTimer = Timer.init(timeInterval: 1, target: self, selector: #selector(timerFire), userInfo: nil, repeats: true)
        // 只会打印一次
        //self.traditionTimer.fire()
        
        // 会打印多次，但是和滚动视图冲突，在滚动时计时器停止
        RunLoop.current.add(self.traditionTimer, forMode: .default)
        
        // 会打印多次，在滚动时计时器继续运行
        RunLoop.current.add(self.traditionTimer, forMode: .common)

        // 方案二
        // 会打印多次，但是和滚动视图冲突，在滚动时计时器停止
        self.traditionTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            print("喝点小酒")
        })

        // 方案三
        // 会打印多次，在滚动时计时器继续运行
        gcdTimer = DispatchSource.makeTimerSource()
        gcdTimer.schedule(deadline: DispatchTime.now(), repeating: DispatchTimeInterval.seconds(1))
        gcdTimer.setEventHandler {
            print("脑袋晕晕的")
        }
        gcdTimer.resume()// 开始
        gcdTimer.suspend()// 暂停
        gcdTimer.cancel()// 取消
        gcdTimer = nil// 销毁

        // 方案四
        // 会打印多次，但是和滚动视图冲突，在滚动时计时器停止
        displayLink = CADisplayLink(target: self, selector: #selector(timerFire))
        displayLink.preferredFramesPerSecond = 1
        displayLink.add(to: .current, forMode: .default)
        displayLink.isPaused = true // 暂停
    }
    
    @objc func timerFire()
    {
        print("漫游在云海的鲸鱼")
    }
    
    func setupTimer()
    {
        timer = Observable<Int>.interval(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
        timer.subscribe(onNext: { num in print("下雪了❄️")})
            .disposed(by: disposeBag)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        // 旧的垃圾袋里面含有计时器，所以计时器也同时被销毁掉了
        self.disposeBag = DisposeBag()
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
    
    func setUpTableView()
    {
        var timer: Observable<Int>!
        
        // 正在运行
        let isRunning = Observable
            .merge([playButton.rx.tap.map({ return true }), stopButton.rx.tap.map({ return false })])
            .startWith(false)
            .share(replay: 1, scope: .whileConnected)
        
        // 打印是否正在运行
        isRunning
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        // 正在运行序列和停止按钮是否能够点击进行绑定
        isRunning
            .bind(to: stopButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        // 没有运行
        let isNotRunning = isRunning
            .map({ running -> Bool in
                    print(running)
                    return !running })
            .share(replay: 1, scope: .whileConnected)
       
        // 将没有运行和运行按钮能够点击事件绑定，和割裂按钮隐藏事件绑定
        isNotRunning
            .bind(to: splitUpButton.rx.isHidden)
            .disposed(by: disposeBag)
        isNotRunning
            .bind(to: playButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        // 创建计时器
        timer = Observable<Int>
            .interval(DispatchTimeInterval.milliseconds(100), scheduler: MainScheduler.instance)
            .withLatestFrom(isRunning, resultSelector: {_, running in running})
            .filter({running in running})
            .scan(0, accumulator: {(acc, _) in
                return acc+1
            })
            .startWith(0)
            .share(replay: 1, scope: .whileConnected)
        
        // 打印计时器中的时间
        timer
            .subscribe { (milliseconds) in print("\(milliseconds)00ms") }
            .disposed(by: disposeBag)
        
        // 将格式化后的日期展示到Label上
        timer.map(stringFromTimeInterval)
            .bind(to: timeLabel.rx.text)
            .disposed(by: disposeBag)
        
        // 以计时器的当前时间为准割开作为片段
        let lapsSequence = timer
            .sample(splitUpButton.rx.tap)
            .map(stringFromTimeInterval)
            .scan([String](), accumulator: { lapTimes, newTime in
                return lapTimes + [newTime]
            })
            .share(replay: 1, scope: .whileConnected)
        
        // 将割开的片段展示到Table中
        lapsSequence
            .bind(to: tableView.rx.items (cellIdentifier: "Cell", cellType: UITableViewCell.self))
            { (row, element, cell) in
                cell.textLabel?.text = "\(row+1)) \(element)"
            }
            .disposed(by: disposeBag)
        
        // 设置tableview的delegate
        tableView
            .rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        // 更新Tableview的headview里面的计数
        lapsSequence.map({ laps -> String in
            return "\t\(laps.count) laps"
        })
            .startWith("\tno laps")
            .bind(to: countLable.rx.text)
            .disposed(by: disposeBag)
        
    }
    
    func createTableView()
    {
        view.backgroundColor = .white
        countLable = UILabel(frame: CGRect(x: 0, y: 400, width: view.frame.size.width, height: 80))
        countLable.backgroundColor = UIColor(white: 0.85, alpha: 1.0)
        tableView = UITableView(frame: CGRect(x: 0, y: 500, width: view.frame.size.width, height: 300))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        playButton.setTitle("▷", for: .normal)
        playButton.setTitleColor(.blue, for: .normal)
        playButton.titleLabel!.font = UIFont.systemFont(ofSize: 24)
        playButton.backgroundColor = .orange
        stopButton.setTitle("◻", for: .normal)
        stopButton.setTitleColor(.gray, for: .normal)
        stopButton.titleLabel!.font = UIFont.systemFont(ofSize: 24)
        stopButton.backgroundColor = .red
        splitUpButton.setTitle("Split Lap", for: .normal)
        splitUpButton.setTitleColor(.blue, for: .normal)
        splitUpButton.titleLabel!.font = UIFont.systemFont(ofSize: 24)
        splitUpButton.backgroundColor = .brown
        timeLabel.font = UIFont.systemFont(ofSize: 50)
        view .addSubview(tableView)
        view .addSubview(playButton)
        view .addSubview(splitUpButton)
        view .addSubview(stopButton)
        view .addSubview(timeLabel)
        view .addSubview(countLable)
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

func stringFromTimeInterval(_ ms: NSInteger) -> String
{
    return String(format: "%0.2d:%0.2d.%0.1d",arguments: [(ms / 600) % 600, (ms % 600 ) / 10, ms % 10])
}














