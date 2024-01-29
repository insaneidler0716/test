//
//  ViewController.swift
//  iOS-phone-test
//
//  Created by li haonan on 2024/1/18.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    var singerData: [ImageData] = []
    
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CellView.self, forCellReuseIdentifier: "cell")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        MusicDatabaseManager.shared.MusicDatabaseManagerInit()
        singerData = MusicDatabaseManager.shared.getAllSingers()
    
        view.addSubview(tableView)
        tableView.rowHeight = 60
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return singerData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CellView
        let item = singerData[indexPath.row]
        cell.configure(text: item.label, imageUrl: item.remoteImageUrl)
        return cell
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         tableView.deselectRow(at: indexPath, animated: true)
         let detailViewController = DetailViewController()
         let item = singerData[indexPath.row]
         detailViewController.configure(text: item.label, imageUrl: item.remoteImageUrl)
         navigationController?.pushViewController(detailViewController, animated: true)
     }
}

