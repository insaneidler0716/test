//
//  CollectionViewController.swift
//  iOS-phone-test
//
//  Created by li haonan on 2024/1/24.
//

import UIKit
import SnapKit
import YYWebImage

class CollectionViewController: UICollectionViewCell {
    
    private let collectionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
        
    private let collectionRemoteImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
     // 对勾图标
    private let markImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(collectionRemoteImageView)
        addSubview(collectionLabel)
        addSubview(markImageView)

        collectionRemoteImageView.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.centerY.equalToSuperview().offset(-10)
            make.width.equalTo(60)
        }

        collectionLabel.snp.makeConstraints { make in
            make.centerX.equalTo(collectionRemoteImageView.snp.centerX)
            make.centerY.equalTo(collectionRemoteImageView.snp.centerY).offset(70)
            make.height.equalTo(10)
        }
    }
    override var isSelected: Bool {
        didSet {
            super.isSelected = isSelected
            // 当 isSelected 发生变化时，更新 UI
            updateUI()
        }
    }
    private func updateUI() {
        if isSelected {
            // 高亮边框
            collectionRemoteImageView.layer.borderColor = UIColor.blue.cgColor
            collectionRemoteImageView.layer.borderWidth = 1.0
            // 添加对勾图标
            markImageView.image = UIImage(systemName: "checkmark.circle.fill")
            markImageView.tintColor = UIColor.blue
            // 调整对勾图标位置
            markImageView.snp.makeConstraints { make in
                make.trailing.equalToSuperview().offset(-5)
                make.bottom.equalToSuperview().offset(-5)
                make.width.height.equalTo(20)
                // 添加淡入动画
                UIView.animate(withDuration: 0.3) {
                    self.markImageView.alpha = 1.0
                }
            }
        }else {
            // 添加淡出动画
            UIView.animate(withDuration: 0.3) {
            self.markImageView.alpha = 0.0
            }
    
            // 恢复默认边框
            collectionRemoteImageView.layer.borderColor = UIColor.lightGray.cgColor
            // 移除对勾图标
            markImageView.image = nil
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
            
    }
    func configure(text: String, imageUrl: String) {
        let placeholderImage = UIImage(named: "IMG_PlaceHolder")
        collectionLabel.text = text
        if let url = URL(string: imageUrl) {
            collectionRemoteImageView.yy_setImage(with: url, placeholder: placeholderImage, options: YYWebImageOptions.setImageWithFadeAnimation)
        }
    }
}
