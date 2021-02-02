//
//  LoginViewController.swift
//  UseMoya
//
//  Created by 谢佳培 on 2021/2/2.
//

import UIKit

class LoginViewController: UIViewController
{
    var usernameTF: UITextField! = UITextField(frame: CGRect(x: 100, y: 100, width: 200, height: 50))
    var passwordTF: UITextField! = UITextField(frame: CGRect(x: 100, y: 200, width: 200, height: 50))
    var smscodeTF: UITextField! = UITextField(frame: CGRect(x: 100, y: 300, width: 200, height: 50))
    var codeButton: UIButton! = UIButton(frame: CGRect(x: 100, y: 400, width: 200, height: 50))
    var loginButton: UIButton! = UIButton(frame: CGRect(x: 100, y: 500, width: 200, height: 50))
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        createSubview()
    }
    
    func createSubview()
    {
        usernameTF.backgroundColor = .orange
        passwordTF.backgroundColor = .orange
        smscodeTF.backgroundColor = .orange
        view.addSubview(usernameTF)
        view.addSubview(passwordTF)
        view.addSubview(smscodeTF)
        
        codeButton.backgroundColor = .orange
        codeButton.setTitle("发送验证码", for: .normal)
        codeButton.addTarget(self, action: #selector(didClickCodeButton), for: .touchUpInside)
        loginButton.setTitle("登录", for: .normal)
        loginButton.backgroundColor = .orange
        loginButton.addTarget(self, action: #selector(didClickLoginButton), for: .touchUpInside)
        view.addSubview(codeButton)
        view.addSubview(loginButton)
    }
    
    @objc func didClickCodeButton()
    {
        guard let username = usernameTF.text else
        {
            print("账户不可为空")
            return
        }
        
        LoginClient.manager.smscode(username: username)
        { [weak self](smscode) in
            self?.smscodeTF.text = smscode
        }
    }

    @objc func didClickLoginButton()
    {
        LoginClient.manager.login(username:usernameTF.text!, password: passwordTF.text!, smscode: smscodeTF.text!)
    }
}
