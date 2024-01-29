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
        label.font = UIFont.systemFont(ofSize: 25)
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
        layout.itemSize = CGSizeMake(80,100)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = false
        collectionView.register(CollectionCellView.self, forCellWithReuseIdentifier: "collection")
        return collectionView
    }()
    
    // 专辑数据
    var albumData: [ImageData] = []
    
    // 单选按钮
    var singleSeclectionRadioButton: [UIButton] = []
    
    // 底部按钮
    var selectedButton: UIButton?
    
    // 开关
    let detailSwitch = UISwitch()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //专辑数据写入
        albumData = MusicDatabaseManager.shared.getAlbumsForSinger(singerName: detailLabel.text!)
        
        // 根据当前外观模式更新背景颜色
        if traitCollection.userInterfaceStyle == .dark {
            view.backgroundColor = .black
        } else {
            view.backgroundColor = .white
        }
        
        
        // 开关
        setupBackgroundKeepSwitch()
        detailSwitch.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
        view.addSubview(detailSwitch)
        detailSwitch.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-30)
            make.top.equalToSuperview().offset(150)
            
        }
        // 开关标签
        let buttonLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 16)
            label.text = "后台保持"
            return label
        }()
        view.addSubview(buttonLabel)
        buttonLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(30)
            make.centerY.equalTo(detailSwitch.snp.centerY)
        }
        
        // collectionView
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(200)
            make.centerX.equalToSuperview()
            make.top.equalTo(buttonLabel.snp.bottom).offset(20)
        }
        
        // 单选按钮标签
        let singleSeclectionRadioButtonLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 16)
            label.text = "请选择播放时间"
            return label
        }()
        view.addSubview(singleSeclectionRadioButtonLabel)
        singleSeclectionRadioButtonLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(30)
            make.top.equalTo(collectionView.snp.bottom).offset(20)
        }
        
        // 单选按钮创建
        createSingleSelectionRadioButton(title: "10 seconds", tag: 1)
        createSingleSelectionRadioButton(title: "20 seconds", tag: 2)
        createSingleSelectionRadioButton(title: "30 seconds", tag: 3)
        createSingleSelectionRadioButton(title: "60 seconds", tag: 4)
        createSingleSelectionRadioButton(title: "120 seconds", tag: 5)
        // 单选按钮约束
        for (index, button) in singleSeclectionRadioButton.enumerated() {
            view.addSubview(button)

            button.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(30)
                make.top.equalTo(singleSeclectionRadioButtonLabel.snp.bottom).offset(20 + index * 40)
            }
        }
        setupSingleSelectionRadioButtons()
        
        // 底部按钮背景
        let buttonBackgroundView = UIView()
        buttonBackgroundView.backgroundColor = .gray
        view.addSubview(buttonBackgroundView)
        buttonBackgroundView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-30)
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
        
        
        // 图片
        view.addSubview(detailRemoteImageView)
        detailRemoteImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(650)
            make.width.equalToSuperview().multipliedBy(0.3)
            make.height.equalTo(detailRemoteImageView.snp.width).multipliedBy(detailRemoteImageView.image!.size.height / detailRemoteImageView.image!.size.width)
        }
        
        // 顶部标签
        view.addSubview(detailLabel)
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
            print("后台保持开启")
            // 保存后台保持开关状态到 UserDefaults
            UserDefaults.standard.set(true, forKey: kBackgroundKeepEnabled)
        } else {
            print("后台保持关闭")
            // 保存后台保持开关状态到 UserDefaults
            UserDefaults.standard.set(false, forKey: kBackgroundKeepEnabled)
        }
    }
    func setupBackgroundKeepSwitch() {
        // 从 UserDefaults 中读取后台保持开关状态，默认为关闭
        let isBackgroundKeepEnabled = UserDefaults.standard.bool(forKey: kBackgroundKeepEnabled)
        // 设置后台保持开关状态
        detailSwitch.isOn = isBackgroundKeepEnabled
    }
    
    func createSingleSelectionRadioButton(title: String, tag: Int) {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        if traitCollection.userInterfaceStyle == .dark {
            button.setTitleColor(UIColor.white, for: .normal)

        } else {
            button.setTitleColor(UIColor.black, for: .normal)
        }
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.setImage(UIImage(systemName: "largecircle.fill.circle"), for: .selected)
        button.tag = tag
        button.addTarget(self, action: #selector(singleSelectionRadioButtonTapped(_:)), for: .touchUpInside)

        singleSeclectionRadioButton.append(button)
    }

    // 处理单选按钮点击事件
    @objc func singleSelectionRadioButtonTapped(_ sender: UIButton) {
        // 如果点击的按钮已经是选中状态，则取消选中并保存状态
        if sender.isSelected {
            sender.isSelected = false
            UserDefaults.standard.set(false, forKey: kRadioButtonSelected.appending("(\(sender.tag))"))
            print("你取消了选择")
            UserDefaults.standard.setValue( 0 , forKey: kRadioButtonSelectedValue)
            return
        }
        // 取消之前选中的按钮的选中状态
        for button in singleSeclectionRadioButton {
            button.isSelected = false
            // 保存取消选择的按钮状态
            UserDefaults.standard.set(false, forKey: kRadioButtonSelected.appending("(\(button.tag))"))
        }
        // 更新当前选中的按钮
        sender.isSelected = true
        // 保存选中的按钮状态
        UserDefaults.standard.set(true, forKey: kRadioButtonSelected.appending("(\(sender.tag))"))
        UserDefaults.standard.setValue(sender.tag , forKey: kRadioButtonSelectedValue)

        // 在这里执行选中后的操作，比如处理选中的选项
        let selectedOption = sender.tag
        print("你选择了 \(selectedOption)")
    }
    // 单选初始化
    func setupSingleSelectionRadioButtons() {
        // 设置单选按钮的初始状态
        for button in singleSeclectionRadioButton {
            let isSelected = UserDefaults.standard.bool(forKey: kRadioButtonSelected.appending("(\(button.tag))"))
            button.isSelected = isSelected
        }
    }


    
    func createOptionButton(title: String, tag: Int) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
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
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            // 主题模式发生变化，执行相应的更新操作
            updateInterfaceForCurrentTheme()
            
        }
    }

    func updateInterfaceForCurrentTheme() {
        // 在这里执行更新界面的操作
        if traitCollection.userInterfaceStyle == .dark {
            // 暗色模式
            view.backgroundColor = .black
            for button in singleSeclectionRadioButton {
                button.setTitleColor(UIColor.white, for: .normal)
            }
        } else {
            // 亮色模式
            view.backgroundColor = .white
            for button in singleSeclectionRadioButton {
                button.setTitleColor(UIColor.black, for: .normal)
            }
        }
    }

}

extension DetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collection = collectionView.dequeueReusableCell(withReuseIdentifier: "collection", for: indexPath) as! CollectionCellView
        let item = albumData[indexPath.row]
        collection.configure(text: item.label, imageUrl: item.remoteImageUrl)
        return collection
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.item
        print(albumData[index].label)
        let timePickerViewController = TimePickerViewController()
        timePickerViewController.detailLabel.text = albumData[index].label
        navigationController?.pushViewController(timePickerViewController, animated: true)
    }
}

