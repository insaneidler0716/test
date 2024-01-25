//
//  TimePikerViewController.swift
//  iOS-phone-test
//
//  Created by li haonan on 2024/1/25.
//

import UIKit
import SnapKit
import YYWebImage

class TimePickerViewController: UIViewController {
    
    // 时间
    let hours: [Int] = Array(0...23)
    let minutes: [Int] = Array(0...59)
    
    let timePicker: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()
    
    // 时间制度标识符，false为24时制，true为12时制
    var timeSystem: Bool = false
    
    // 列表
    lazy var timePickerTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 40
        tableView.register(TimePickerCellViewController.self, forCellReuseIdentifier: "timePickerCell")
        return tableView
    }()
    
    // 单元格标签
    let tableData: [String] = ["标签1", "标签2"]
    let tableSelectData: [String] = ["标签3", "标签4"]
    
    // 底部按钮
    var selectedButton: UIButton?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 背景
        let backgroundView = UIView()
        backgroundView.backgroundColor = .white
        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // 时间选择器
        // 获取系统时间的表示形式
        _ = DateFormatter()
        let dateFormat = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: Locale.current)
        // 判断时间制度
        if let format = dateFormat, format.contains("a") {
            print("系统时间制度：12 小时制")
            timeSystem = true
        } else {
            print("系统时间制度：24 小时制")
            timeSystem = false
        }
        backgroundView.addSubview(timePicker)
        timePicker.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(250)
        }
        timePicker.dataSource = self
        timePicker.delegate = self
        
        // 开关
        let detailSwitch = UISwitch()
        detailSwitch.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
        backgroundView.addSubview(detailSwitch)
        detailSwitch.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-30)
            make.top.equalToSuperview().offset(150)
            
        }
        // 开关标签
        let buttonLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 16)
            label.text = "开关标签"
            return label
        }()
        backgroundView.addSubview(buttonLabel)
        buttonLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(30)
            make.centerY.equalTo(detailSwitch.snp.centerY)
        }
        
        // 列表
        backgroundView.addSubview(timePickerTableView)
        //view.addSubview(timePickerTableView)
        timePickerTableView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            //make.edges.equalToSuperview()
            make.top.equalToSuperview().offset(500)
            make.width.equalToSuperview()
            make.height.equalTo(100)
        }
        
        // 按钮背景
        let buttonBackgroundView = UIView()
        buttonBackgroundView.backgroundColor = .gray
        backgroundView.addSubview(buttonBackgroundView)
        buttonBackgroundView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(800)
            make.centerX.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(50)
        }
        
        // 底部按钮创建
        let button = createOptionButton(title: "返回", tag: 1)
        buttonBackgroundView.addSubview(button)
        // 底部按钮约束
        button.snp.makeConstraints { make in
            make.center.equalTo(buttonBackgroundView)
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
        
    }
    @objc func switchValueChanged(_ sender: UISwitch) {
        if sender.isOn {
            print("开关打开了")
            // 在这里执行打开开关时的操作
        } else {
            print("开关关闭了")
            // 在这里执行关闭开关时的操作
        }
    }
    func createOptionButton(title: String, tag: Int) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.tag = tag
        button.addTarget(self, action: #selector(optionButtonTapped(_:)), for: .touchUpInside)
        return button
    }
    
    @objc func optionButtonTapped(_ sender: UIButton) {
        // 取消之前选中的按钮的选中状态
        selectedButton?.isSelected = false
        // 更新当前选中的按钮
        selectedButton = sender
        selectedButton?.isSelected = true
        // 在这里执行选中后的操作，比如处理选中的选项
        let selectedOption = sender.tag
        print("Selected option: \(selectedOption)")
        self.navigationController?.popViewController(animated: true)

        
    }
}

extension TimePickerViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    // 组建数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        // 12时制
        if timeSystem {
            return 3
        } else {
            return 2
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if timeSystem {
            switch component {
            case 0: return hours.count/2
            case 1: return minutes.count
            case 2: return 2
            default: return 0
            }
        } else {
            switch component {
            case 0: return hours.count
            case 1: return minutes.count
            default: return 0
            }
        }
    }
        
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if timeSystem {
            switch component {
            case 0: return "\(hours[row])"
            case 1: return String(format: "%02d", minutes[row])
            case 2: return row == 0 ? "AM" : "PM"
            default: return nil
            }
        } else {
            switch component {
            case 0: return "\(hours[row])"
            case 1: return String(format: "%02d", minutes[row])
            default: return nil
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if timeSystem {
            let selectedHour = hours[pickerView.selectedRow(inComponent: 0)]
            let selectedMinute = minutes[pickerView.selectedRow(inComponent: 1)]
            let selectedAMPM = pickerView.selectedRow(inComponent: 2) == 0 ? "AM" : "PM"
            let selectedTime = String(format: "%02d:%02d %@", selectedHour, selectedMinute, selectedAMPM)
            print("Selected time: \(selectedTime)")
        } else {
            let selectedHour = hours[pickerView.selectedRow(inComponent: 0)]
            let selectedMinute = minutes[pickerView.selectedRow(inComponent: 1)]
            let selectedTime = String(format: "%02d:%02d", selectedHour, selectedMinute)
            print("Selected time: \(selectedTime)")
        }
    }
}

extension TimePickerViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let timePickerCell = tableView.dequeueReusableCell(withIdentifier: "timePickerCell", for: indexPath) as! TimePickerCellViewController
        timePickerCell.accessoryType = .disclosureIndicator
        timePickerCell.titleLabel.text = tableData[indexPath.row]
        timePickerCell.rightLabel.text = tableSelectData[indexPath.row]
        return timePickerCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         tableView.deselectRow(at: indexPath, animated: true)
    }
}

