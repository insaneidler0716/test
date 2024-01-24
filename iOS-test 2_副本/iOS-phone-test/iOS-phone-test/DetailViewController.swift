//
//  DetailView.swift
//  ios test
//
//  Created by li haonan on 2024/1/17.
// 

import UIKit
import SnapKit
import YYWebImage

class DetailViewController: UIViewController {
    
    
    private let detailLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let detailRemoteImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(60,100)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = false
        collectionView.register(CollectionViewController.self, forCellWithReuseIdentifier: "collection")
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    //按钮
    var radioButtons: [UIButton] = []
    
    //时间
    let hours: [Int] = Array(0...12)
    let minutes: [Int] = Array(0...59)
    
    let timePicker: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       

        //背景视图
        let backgroundView = UIView()
        backgroundView.backgroundColor = .white
        
        //开关
        let detailSwitch = UISwitch()
        detailSwitch.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
        
        //添加视图
        view.addSubview(backgroundView)
        //backgroundView.addSubview(detailRemoteImageView)
        backgroundView.addSubview(detailLabel)
        backgroundView.addSubview(detailSwitch)
        backgroundView.addSubview(collectionView)
        backgroundView.addSubview(timePicker)
        
        
        createRadioButton(title: "选项1", tag: 1)
        createRadioButton(title: "选项2", tag: 2)
        createRadioButton(title: "选项3", tag: 3)
        createRadioButton(title: "选项4", tag: 4)
        createRadioButton(title: "选项5", tag: 5)

        // 按钮约束
        for (index, button) in radioButtons.enumerated() {
            backgroundView.addSubview(button)

            button.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(20)
                make.top.equalToSuperview().offset(400 + index * 40)
            }
        }
        
        //背景约束
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        //开关约束
        detailSwitch.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-30)
            make.top.equalToSuperview().offset(150)
            
        }
        
        //collectionView约束
        collectionView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(200)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(200)
        }
        
        //时间选择器约束
        timePicker.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(550)
        }
        timePicker.dataSource = self
        timePicker.delegate = self
        
        //图片约束
        /*detailRemoteImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(500)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(detailRemoteImageView.snp.width).multipliedBy(detailRemoteImageView.image!.size.height / detailRemoteImageView.image!.size.width)
        }*/
        
        //标签约束
        detailLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(65)
        }
    }
    
    func configure(text: String, imageUrl: String) {
        let placeholderImage = UIImage(named: "IMG_PlaceHolder")
        detailLabel.text = text
        if let url = URL(string: imageUrl) {
            detailRemoteImageView.yy_setImage(with: url, placeholder: placeholderImage, options: YYWebImageOptions.setImageWithFadeAnimation)
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
    
    func createRadioButton(title: String, tag: Int) {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.setImage(UIImage(systemName: "largecircle.fill.circle"), for: .selected)
        button.tag = tag
        button.addTarget(self, action: #selector(radioButtonTapped(_:)), for: .touchUpInside)

        radioButtons.append(button)
    }

    // 处理按钮点击事件
    @objc func radioButtonTapped(_ sender: UIButton) {
        // 如果点击的按钮已经是选中状态，则不做任何处理
        guard !sender.isSelected else {
            return
        }
        // 取消之前选中的按钮的选中状态
        for button in radioButtons {
            button.isSelected = false
        }
        // 更新当前选中的按钮
        sender.isSelected = true
        // 在这里执行选中后的操作，比如处理选中的选项
        let selectedOption = sender.tag
        print("Selected option: \(selectedOption)")
    }
    
    
    
}

extension DetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let data = DatabaseManager.shared.getAllImageData()
        return data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collection = collectionView.dequeueReusableCell(withReuseIdentifier: "collection", for: indexPath) as! CollectionViewController
        let data = DatabaseManager.shared.getAllImageData()
        let item = data[indexPath.row]
        collection.configure(text: item.label, imageUrl: item.remoteImageUrl)
        return collection
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected item at index: \(indexPath.item)")
    }
}

extension DetailViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    //组建数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0: return hours.count
        case 1: return minutes.count
        case 2: return 2
        default: return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0: return "\(hours[row])"
        case 1: return String(format: "%02d", minutes[row])
        case 2: return row == 0 ? "AM" : "PM"
        default: return nil
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedHour = hours[pickerView.selectedRow(inComponent: 0)]
        let selectedMinute = minutes[pickerView.selectedRow(inComponent: 1)]
        let selectedAMPM = pickerView.selectedRow(inComponent: 2) == 0 ? "AM" : "PM"
        let selectedTime = String(format: "%02d:%02d %@", selectedHour, selectedMinute, selectedAMPM)
        print("Selected time: \(selectedTime)")
    }
}
