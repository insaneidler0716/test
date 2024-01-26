//
//  SongsSelectionViewController.swift
//  iOS-phone-test
//
//  Created by li haonan on 2024/1/25.
//

import Foundation
import SnapKit
import UIKit
import YYWebImage

class SelectionViewController: UIViewController {
    
    // 单元格索引
    var selectMode: Int = 0
    
    //闭包传参
    var didSelectDataClosure: ((String) -> Void)?
    
    
    lazy var selectionTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 40
        tableView.register(SelectionCellViewController.self, forCellReuseIdentifier: "selectionCell")
        return tableView
    }()
    
    let playMode: [String] = ["无", "顺序播放", "随机播放", "单曲循环", "循环播放"]
    let playEffect: [String] = ["无", "3d环绕","重金属","黑胶唱片"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(selectionTableView)
        selectionTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension SelectionViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectMode == 0 {
            return playMode.count
        }else {
            return playEffect.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let selectCell = tableView.dequeueReusableCell(withIdentifier: "selectionCell", for: indexPath) as! SelectionCellViewController
        if selectMode == 0 {
            selectCell.selectionView.text = playMode[indexPath.row]
        }else {
            selectCell.selectionView.text = playEffect[indexPath.row]
        }
        return selectCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var selectedData: String
        if selectMode == 0 {
            selectedData = playMode[indexPath.row]
        } else {
            selectedData = playEffect[indexPath.row]
        }
        didSelectDataClosure?(selectedData)
        navigationController?.popViewController(animated: true)
    }
}
