//
//  SongsSelectionCellViewController.swift
//  iOS-phone-test
//
//  Created by li haonan on 2024/1/25.
//

import Foundation
import UIKit
import SnapKit

class SelectionCellViewController: UITableViewCell {
    
    var selectionView: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // selectionIeftLabel
        addSubview(selectionView)
        selectionView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(30)
        }
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
