//
//  CollectionViewController.swift
//  iOS-phone-test
//
//  Created by li haonan on 2024/1/24.
//

import UIKit
import SnapKit
import YYWebImage

class AlbumCollectionViewCell: UICollectionViewCell {
    
    let collectionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
        
    let collectionRemoteImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // 对勾图标
    let markImageView: UIImageView = {
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
        
        if let selectedAlbum: Int = UserDefaults.standard.value(forKey: kSelectedAlbum) as? Int {
            print(selectedAlbum)
            //collectionView.reloadData()
            
        }

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
        
        markImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-5)
            make.bottom.equalToSuperview().offset(-5)
            make.width.height.equalTo(20)
        }
        
    }
    override var isSelected: Bool {
        didSet {
            super.isSelected = isSelected
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
        }else {
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
