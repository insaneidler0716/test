//
//  ViewControllerExtension.swift
//  iOS-phone-test
//
//  Created by li haonan on 2024/1/18.
//

import UIKit
import SnapKit
import YYWebImage

class CellViewController: UITableViewCell {
    
    
    private let cellLabel: UILabel = {
        let label = UILabel()
        return label
    }()
        
    private let cellRemoteImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        
        addSubview(cellRemoteImageView)
        addSubview(cellLabel)

        cellRemoteImageView.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
        }

        cellLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(100)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configure(text: String, imageUrl: String) {
        let placeholderImage = UIImage(named: "IMG_PlaceHolder")
        cellLabel.text = text
        if let url = URL(string: imageUrl) {
            cellRemoteImageView.yy_setImage(with: url, placeholder: placeholderImage, options: YYWebImageOptions.setImageWithFadeAnimation)
        }
    }
}
