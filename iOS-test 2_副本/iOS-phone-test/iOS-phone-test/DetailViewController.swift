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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = .white
            
            
            view.addSubview(backgroundView)
            backgroundView.addSubview(detailRemoteImageView)
            backgroundView.addSubview(detailLabel)
            
            backgroundView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            detailRemoteImageView.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.centerX.equalToSuperview()
                make.width.equalToSuperview().multipliedBy(0.8)
                make.height.equalTo(detailRemoteImageView.snp.width).multipliedBy(detailRemoteImageView.image!.size.height / detailRemoteImageView.image!.size.width)
            }
            
            detailLabel.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.top.equalToSuperview().offset(200)
            }
        }

    func configure(text: String, imageUrl: String) {
        let placeholderImage = UIImage(named: "IMG_PlaceHolder")
        detailLabel.text = text
        if let url = URL(string: imageUrl) {
            detailRemoteImageView.yy_setImage(with: url, placeholder: placeholderImage, options: YYWebImageOptions.setImageWithFadeAnimation)
        }
    }
}

