//
//  UserPreferences.swift
//  UseRxSwift
//
//  Created by 谢佳培 on 2021/1/15.
//

import UIKit
import RxSwift
import RxCocoa

enum Gender
{
    case notSelcted
    case male
    case female
}

class DataPickerValidator: NSObject
{
    // 选择的日期是否小于当天
    class func isValidDate(date: Date) -> Bool
    {
        let calendar = Calendar.current
        let compare = calendar.compare(date, to: Date.init(), toGranularity: .day)
        return compare == .orderedAscending
    }
}



class UserPreferences: UIViewController
{
    var birthdayPicker: UIDatePicker!
    var maleButton: UIButton!
    var femaleButton: UIButton!
    var knowSwiftSwitch: UISwitch!
    var swiftLevelSlider: UISlider!
    var passionToLearnStepper: UIStepper!
    var heartImageView: UIImageView!
    static var heartHeight: CGFloat!
    var updateButton: UIButton!
    var disposeBag = DisposeBag()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        createSubviews()
        
        useMap()
    }
    
    func useMap()
    {
        // 必选项：出生日期不能早于今天否则边框变色
        let birthdayObservable = birthdayPicker.rx.date.map
        {
            DataPickerValidator.isValidDate(date: $0)
        }
        birthdayObservable.map { $0 ? UIColor.orange : UIColor.blue}
            .subscribe(onNext: { color in self.birthdayPicker.layer.borderColor = color.cgColor} )
            .disposed(by: disposeBag)
        
        // 必选项：选择性别
        // 创建性别选择序列
        let genderSelectObservable = BehaviorSubject<Gender>(value: .notSelcted)
        
        // 男生按钮和性别选择序列进行绑定
        maleButton.rx.tap
            .map { Gender.male }
            .bind(to: genderSelectObservable)
            .disposed(by: disposeBag)
        // 女生按钮和性别选择序列进行绑定
        femaleButton.rx.tap
            .map { Gender.female }
            .bind(to: genderSelectObservable)
            .disposed(by: disposeBag)
        
        // 根据选择的性别更改显示的图片
        genderSelectObservable.subscribe(onNext: { (gender) in
            switch gender
            {
            case .male:
                self.maleButton.setImage(UIImage(named: "check"), for: .normal)
                self.femaleButton.setImage(UIImage(named: "uncheck"), for: .normal)
            case .female:
                self.femaleButton.setImage(UIImage(named: "check"), for: .normal)
                self.maleButton.setImage(UIImage(named: "uncheck"), for: .normal)
            default:
                break;
            }
        })
        .disposed(by: disposeBag)
        
        // 性别是否已经选择
        let genderHasSelected = genderSelectObservable.map { $0 != .notSelcted ? true : false }

        // 出生日期和性别都选择后更新按钮才可以点击
        Observable.combineLatest(birthdayObservable, genderHasSelected) { $0 && $1 }
            .bind(to: updateButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        // 当UISwitch为ON时，可以把UISlider设置在1/4的位置作为默认值，表示面试者了解一点皮毛
        knowSwiftSwitch.rx.value
            .map{ $0 ? 0.25 : 0}
            .bind(to: swiftLevelSlider.rx.value)
            .disposed(by: disposeBag)
        
        // 当UISlider不为0时，应该自动把UISwitch设置为ON，即面试者有了解过
        swiftLevelSlider.rx.value
            .map { $0 != 0 ? true : false}
            .bind(to: knowSwiftSwitch.rx.isOn)
            .disposed(by: disposeBag)
        
        // 通过计数器更改心跳的大小
        passionToLearnStepper.rx.value
            .skip(1)
            .subscribe(onNext: { (value) in
                UserPreferences.heartHeight = UserPreferences.heartHeight + 10
                self.heartImageView.frame = CGRect(x: 150, y: 750, width: UserPreferences.heartHeight, height: UserPreferences.heartHeight)
                self.heartImageView.setNeedsLayout()
            })
            .disposed(by: disposeBag)
    }

    // 下次在Demo遇见这么长的UI搭建鬼才用代码
    // 在Storyboard中几分钟搞定的事，用代码简直浪费生命
    func createSubviews()
    {
        let titleLabel = UILabel(frame: CGRect(x: 150, y: 50, width: 150, height: 100))
        titleLabel.text = "用户偏好设置"
        titleLabel.font = .systemFont(ofSize: 20)
        view.addSubview(titleLabel)
        
        let birthdayLabel = UILabel(frame: CGRect(x: 20, y: 100, width: 50, height: 50))
        birthdayLabel.text = "生日"
        view.addSubview(birthdayLabel)
        birthdayPicker = UIDatePicker(frame: CGRect(x: 20, y: 180, width: 300, height: 50))
        birthdayPicker.layer.borderWidth = 1
        view.addSubview(birthdayPicker)
        
        let sexLabel = UILabel(frame: CGRect(x: 20, y: 300, width: 50, height: 50))
        sexLabel.text = "性别"
        view.addSubview(sexLabel)
        maleButton = UIButton(frame: CGRect(x: 200, y: 300, width: 80, height: 50))
        maleButton.setImage(UIImage(named: "uncheck"), for: .normal)
        maleButton.setTitle("Male", for: .normal)
        maleButton.setTitleColor(.black, for: .normal)
        view.addSubview(maleButton)
        femaleButton = UIButton(frame: CGRect(x: 310, y: 300, width: 80, height: 50))
        femaleButton.setImage(UIImage(named: "uncheck"), for: .normal)
        femaleButton.setTitle("Female", for: .normal)
        femaleButton.setTitleColor(.black, for: .normal)
        view.addSubview(femaleButton)
        
        let knowLabel = UILabel(frame: CGRect(x: 20, y: 480, width: 50, height: 50))
        knowLabel.text = "swift"
        view.addSubview(knowLabel)
        knowSwiftSwitch = UISwitch(frame: CGRect(x: 350, y: 480, width: 50, height: 50))
        view.addSubview(knowSwiftSwitch)
        
        let swiftLevelLabel = UILabel(frame: CGRect(x: 20, y: 530, width: 200, height: 50))
        swiftLevelLabel.text = "Swift 掌握程度"
        view.addSubview(swiftLevelLabel)
        swiftLevelSlider = UISlider(frame: CGRect(x: 20, y: 600, width: 300, height: 50))
        view.addSubview(swiftLevelSlider)
        
        let passionToLearnLabel = UILabel(frame: CGRect(x: 20, y: 680, width: 200, height: 50))
        passionToLearnLabel.text = "Swift 热衷程度"
        view.addSubview(passionToLearnLabel)
        passionToLearnStepper = UIStepper(frame: CGRect(x: 300, y: 680, width: 100, height: 50))
        view.addSubview(passionToLearnStepper)
        
        UserPreferences.heartHeight = 50
        heartImageView = UIImageView(frame: CGRect(x: 150, y: 750, width: UserPreferences.heartHeight, height: UserPreferences.heartHeight))
        heartImageView.image = UIImage(named: "heart")
        view.addSubview(heartImageView)
        
        updateButton = UIButton(frame: CGRect(x: 50, y: 840, width: 300, height: 50))
        updateButton.setTitle("更新", for: .normal)
        updateButton.setTitleColor(.red, for: .normal)
        updateButton.setTitleColor(.gray, for: .disabled)
        updateButton.backgroundColor = .orange
        view.addSubview(updateButton)
    }
}








