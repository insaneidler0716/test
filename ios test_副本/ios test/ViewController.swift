//
//  ViewController.swift
//  ios test
//
//  Created by li haonan on 2024/1/16.
//

import UIKit
import SnapKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    let data = [("正门", "IMG_door"), ("教5楼", "IMG_jiao5"), ("逸夫楼", "IMG_yifu")]
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
        
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

            // 清除 cell 中已有的内容，以防止重用带来的影响
            for subview in cell.contentView.subviews {
                subview.removeFromSuperview()
            }

            let (text, imageName) = data[indexPath.row]

            // 添加文本标签
            let label = UILabel()
            label.text = text
            label.frame = CGRect(x: 70, y: 10, width: 200, height: 30)
            cell.contentView.addSubview(label)

            // 添加图片视图
            let imageView = UIImageView(image: UIImage(named: imageName))
            imageView.frame = CGRect(x: 20, y: 10, width: 35, height: 35)
            cell.contentView.addSubview(imageView)

            return cell
        }
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 在用户点击单元格时调用此方法
        tableView.deselectRow(at: indexPath, animated: true)

        // 创建新的视图控制器
        let detailViewController = DetailViewController()

        // 传递数据给新的视图控制器
        detailViewController.selectedItem = data[indexPath.row]

        // 执行跳转操作
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}


class DetailViewController: UIViewController {

    var selectedItem: (String, String)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let selectedItem = selectedItem {
            let text = selectedItem.0
            let imageName = selectedItem.1
        
            let backgroundView = UIView()
            backgroundView.backgroundColor = .white
        
            let label = UILabel()
                label.text = text// 设置文本内容
                label.textAlignment = .center // 设置文本居中对齐
                label.textColor = .black // 设置文本颜色
        
            let imageView = UIImageView()
            imageView.image = UIImage(named: imageName )
            
            view.addSubview(backgroundView)
            backgroundView.addSubview(imageView)
            backgroundView.addSubview(label)
        
            backgroundView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            imageView.snp.makeConstraints { make in
                make.center.equalToSuperview()  // 居中于父视图
                make.centerX.equalToSuperview() // X轴居中
                //make.centerY.equalToSuperview() // Y轴居中
                make.width.equalToSuperview().multipliedBy(0.8) // 设置宽度为父视图宽度的80%
                make.height.equalTo(imageView.snp.width).multipliedBy(imageView.image!.size.height / imageView.image!.size.width) // 使用.aspectRatio设置宽高比
            }
            label.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview() // 居中
                make.top.equalToSuperview().offset(200)
            }
        }
    }
}



