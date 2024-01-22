//
//  ViewController.swift
//  iOS-phone-test
//
//  Created by li haonan on 2024/1/18.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    var data: [(label: String, remoteImageUrl: String)] = []
    
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CellViewController.self, forCellReuseIdentifier: "cell")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataBaseMangerInit()
        data = DatabaseManager.shared.getAllImageData()
    
        view.addSubview(tableView)
        tableView.rowHeight = 60.0 
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CellViewController
        let item = data[indexPath.row]
        cell.configure(text: item.label, imageUrl: item.remoteImageUrl)
        return cell
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         tableView.deselectRow(at: indexPath, animated: true)
         let detailViewController = DetailViewController()
         let item = data[indexPath.row]
         detailViewController.configure(text: item.label, imageUrl: item.remoteImageUrl)
         navigationController?.pushViewController(detailViewController, animated: true)
     }
}

