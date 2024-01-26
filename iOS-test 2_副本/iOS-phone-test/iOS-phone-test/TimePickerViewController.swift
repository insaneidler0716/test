//
//  TimePikerViewController.swift
//  iOS-phone-test
//
//  Created by li haonan on 2024/1/25.
//

import UIKit
import SnapKit
import YYWebImage
import Foundation

class TimePickerViewController: UIViewController {
    
    // 顶部标签
    let detailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25)
        return label
    }()
    
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
    let tableData: [String] = ["播放模式", "音乐效果"]
    
    // 播放模式和音乐效果全部会保存在这里，初始值设置为无
    var tableSelectData: [String] = ["无", "无"]
    
    
    // 底部按钮
    var selectedButton: UIButton?
    
    // 开关
    let MVPlaySwitch = UISwitch()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 读取歌曲播放模式和音乐效果选项保存值
        if let saveTableSelectData = UserDefaults.standard.array(forKey: "tableSelectData") as? [String] {
            tableSelectData = saveTableSelectData
        }
        
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
        setupTimePicker()
        
        // 开关
        setupSwitch()
        MVPlaySwitch.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
        backgroundView.addSubview(MVPlaySwitch)
        MVPlaySwitch.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-30)
            make.top.equalToSuperview().offset(150)
            
        }
        // 开关标签
        let buttonLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 16)
            label.text = "播放MV"
            return label
        }()
        backgroundView.addSubview(buttonLabel)
        buttonLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(30)
            make.centerY.equalTo(MVPlaySwitch.snp.centerY)
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
            make.top.equalToSuperview().offset(850)
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
        
        // 顶部标签
        backgroundView.addSubview(detailLabel)
        detailLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(65)
        }
        
    }
    // MV播放开关
    @objc func switchValueChanged(_ sender: UISwitch) {
        if sender.isOn {
            print("MV播放开启")
            // 保存开关状态到 UserDefaults
            UserDefaults.standard.set(true, forKey: "MVPlayEnabled")
        } else {
            print("MV播放关闭")
            // 保存开关状态到 UserDefaults
            UserDefaults.standard.set(false, forKey: "MVPlayEnabled")
        }
    }
    // MV播放开关初始化
    func setupSwitch() {
        // 从 UserDefaults 中读取开关状态，默认为关闭
        let isMVEanbled = UserDefaults.standard.bool(forKey: "MVPlayEnabled")
        // 设置开关状态
        MVPlaySwitch.isOn = isMVEanbled
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
            // 保存选中的时间到 UserDefaults
            UserDefaults.standard.set(selectedHour, forKey: "SelectedHour")
            UserDefaults.standard.set(selectedMinute, forKey: "SelectedMinute")
            UserDefaults.standard.set(selectedAMPM, forKey: "SelectedAMPM")
        } else {
            let selectedHour = hours[pickerView.selectedRow(inComponent: 0)]
            let selectedMinute = minutes[pickerView.selectedRow(inComponent: 1)]
            let selectedTime = String(format: "%02d:%02d", selectedHour, selectedMinute)
            print("Selected time: \(selectedTime)")
            // 保存选中的时间到 UserDefaults
            UserDefaults.standard.set(selectedHour, forKey: "SelectedHour")
            UserDefaults.standard.set(selectedMinute, forKey: "SelectedMinute")
        }
    }
    // 时间选择器初始化
    func setupTimePicker() {
        // 从 UserDefaults 中读取保存的小时、分钟和AM/PM，默认为空字符串
        let savedHour = UserDefaults.standard.string(forKey: "SelectedHour") ?? ""
        let savedMinute = UserDefaults.standard.string(forKey: "SelectedMinute") ?? ""
        let savedAMPM = UserDefaults.standard.string(forKey: "SelectedAMPM") ?? ""

        // 将保存的小时和分钟转换为整数
        if let hour = Int(savedHour), let minute = Int(savedMinute) {
            // 设置 pickerView 的初始选中行
            timePicker.selectRow(hour, inComponent: 0, animated: false)
            timePicker.selectRow(minute, inComponent: 1, animated: false)

            // 如果是12小时制，设置 AM/PM 初始选中行
            if timeSystem {
                let ampmRow = savedAMPM.uppercased() == "AM" ? 0 : 1
                timePicker.selectRow(ampmRow, inComponent: 2, animated: false)
            }
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
        timePickerCell.selectionRightLabel.text = tableSelectData[indexPath.row]
        return timePickerCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // 声明一个变量保存当前选中的 indexPath.row
        let selectedRow = indexPath.row
        let selectionViewController = SelectionViewController()
        selectionViewController.selectMode = selectedRow
        // 设置闭包
        selectionViewController.didSelectDataClosure = { [weak self] selectedData in
            // 处理闭包中传递过来的数据，使用保存的 selectedRow
            self?.tableSelectData[selectedRow] = selectedData
            self?.timePickerTableView.reloadData()
            // 将数据存入 UserDefaults
            UserDefaults.standard.set(self?.tableSelectData, forKey: "tableSelectData")
        }
        navigationController?.pushViewController(selectionViewController, animated: true)
    }

}



