//
//  DateBaseManager.swift
//  iOS-phone-test
//
//  Created by li haonan on 2024/1/22.
//

import FMDB

class DatabaseManager {
    static let shared = DatabaseManager()
    var database: FMDatabase?

    private init() {
        openDatabase()
        createTable()
    }

    private func openDatabase() {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("ImageDatabase.sqlite")

        database = FMDatabase(url: fileURL)
        if database?.open() == false {
            print("Unable to open database")
        }
    }

    private func createTable() {
        let createTableQuery = "CREATE TABLE IF NOT EXISTS ImageTable (id INTEGER PRIMARY KEY AUTOINCREMENT, label TEXT, remoteImageUrl TEXT)"
        
        do {
            try database?.executeUpdate(createTableQuery, values: nil)
        } catch {
            print("Error creating table: \(error.localizedDescription)")
        }
    }
    
    //插入新数据
    func insertImageData(label: String, remoteImageUrl: String) {
        
        let insertQuery = "INSERT INTO ImageTable (label, remoteImageUrl) VALUES (?, ?)"
        let values: [Any] = [label, remoteImageUrl]

        do {
            try database?.executeUpdate(insertQuery, values: values)
        } catch {
            print("Error inserting data: \(error.localizedDescription)")
        }
    }
    
    //删除指定标签的数据
    func deleteImageData(withLabel label: String) {
        let deleteQuery = "DELETE FROM ImageTable WHERE label = ?"
        let values: [Any] = [label]

        do {
            try database?.executeUpdate(deleteQuery, values: values)
        } catch {
            print("Error deleting data: \(error.localizedDescription)")
        }
    }
    
    //根据标签查找返回到数组
    func findImageData(withLabel label: String) -> [ImageData] {
        var imageDataArray: [ImageData] = []

        let selectQuery = "SELECT * FROM ImageTable WHERE label = ?"
        let values: [Any] = [label]

        do {
            let resultSet = try database?.executeQuery(selectQuery, values: values)
            while resultSet?.next() ?? false {
                if let label = resultSet?.string(forColumn: "label"),
                   let remoteImageUrl = resultSet?.string(forColumn: "remoteImageUrl") {
                    let imageData = ImageData(label: label, remoteImageUrl: remoteImageUrl)
                    imageDataArray.append(imageData)
                }
            }
        } catch {
            print("Error querying data: \(error.localizedDescription)")
        }
        return imageDataArray
    }
    
    //根据标签修改网络地址
    func updateRemoteImageUrl(withLabel label: String, newRemoteImageUrl: String) {
        let updateQuery = "UPDATE ImageTable SET remoteImageUrl = ? WHERE label = ?"
        let values: [Any] = [newRemoteImageUrl, label]

        do {
            try database?.executeUpdate(updateQuery, values: values)
        } catch {
            print("Error updating data: \(error.localizedDescription)")
        }
    }
    
    //取出所有数据存放到数组
    func getAllImageData() -> [(label: String, remoteImageUrl: String)] {
        var dataArray: [(label: String, remoteImageUrl: String)] = []

        guard let database = database else {
            print("Error: Database not initialized")
            return dataArray
        }

        let selectQuery = "SELECT label, remoteImageUrl FROM ImageTable"

        do {
            let resultSet = try database.executeQuery(selectQuery, values: nil)
            while resultSet.next() {
                if let label = resultSet.string(forColumn: "label"),
                    let remoteImageUrl = resultSet.string(forColumn: "remoteImageUrl") {
                    let imageData = (label: label, remoteImageUrl: remoteImageUrl)
                    dataArray.append(imageData)
                }
            }
        } catch {
            print("Error querying data: \(error.localizedDescription)")
        }

        return dataArray
    }

    //清空数据库
    func clearAllData() {
        let deleteAllQuery = "DELETE FROM ImageTable"

        do {
            try database?.executeUpdate(deleteAllQuery, values: nil)
        } catch {
            print("Error clearing data: \(error.localizedDescription)")
        }
    }
}

// 初始化数据库
func DataBaseMangerInit() {
    DatabaseManager.shared.clearAllData()
    
    DatabaseManager.shared.insertImageData(label: "东门", remoteImageUrl: "https://img0.baidu.com/it/u=953406266,1697631948&fm=253&fmt=auto&app=138&f=JPEG?w=569&h=315")
    DatabaseManager.shared.insertImageData(label: "逸夫楼", remoteImageUrl: "https://img1.baidu.com/it/u=4061477052,1450312856&fm=253&fmt=auto&app=120&f=PNG?w=746&h=500")
    DatabaseManager.shared.insertImageData(label: "I love CUGB", remoteImageUrl: "https://p3.itc.cn/images01/20210608/19b0c5567e3a4d77aa21816f7630ee25.jpeg")
    DatabaseManager.shared.insertImageData(label: "教5楼", remoteImageUrl: "https://5b0988e595225.cdn.sohucs.com/images/20180307/024022f6d48f412397d8bdf47947bf4c.jpeg")
    DatabaseManager.shared.insertImageData(label: "摇篮石", remoteImageUrl: "https://img0.baidu.com/it/u=1012787430,386486834&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500")
    DatabaseManager.shared.insertImageData(label: "操场", remoteImageUrl: "https://www.zhonzhuan.com/UploadFiles/EditImage/202110/06f8ebceae6b69004684ae43f14e3b3e.jpg")
    DatabaseManager.shared.insertImageData(label: "体育馆", remoteImageUrl: "https://img-blog.csdnimg.cn/img_convert/ff474e93251bc779735188fdf6f6a130.png")
    DatabaseManager.shared.insertImageData(label: "地大国际会议中心", remoteImageUrl: "https://att01.zjut.cc/attachment/college/album/big/yzy/img1/p00029010_800.jpeg")
    DatabaseManager.shared.insertImageData(label: "校徽", remoteImageUrl: "https://inews.gtimg.com/newsapp_bt/0/14149626711/641")
    DatabaseManager.shared.insertImageData(label: "校徽和校名", remoteImageUrl: "https://www.niegobrand.com/uploads/image/20211110/1636515660.png")
    DatabaseManager.shared.insertImageData(label: "70周年校庆", remoteImageUrl: "https://n.sinaimg.cn/spider20211107/560/w1080h1080/20211107/785c-05c6b8d3e097902157535c0917113dea.jpg")
    
    
    //这里可以用于测试其他函数
    //DatabaseManager.shared.updateRemoteImageUrl(withLabel: "教5楼", newRemoteImageUrl: "https://p9.itc.cn/images01/20210121/74bf0af0bcda4cbaaf854261bd626459.jpeg")
    //DatabaseManager.shared.deleteImageData(withLabel:"逸夫楼")
}
