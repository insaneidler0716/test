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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(collectionRemoteImageView)
        addSubview(collectionLabel)

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
