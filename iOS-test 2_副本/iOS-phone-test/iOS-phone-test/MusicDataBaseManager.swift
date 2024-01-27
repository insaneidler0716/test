//
//  MusicDataBaseManager.swift
//  iOS-phone-test
//
//  Created by li haonan on 2024/1/25.
//

import Foundation
import FMDB


import FMDB

class MusicDatabaseManager {
    static let shared = MusicDatabaseManager()
    var database: FMDatabase?

    private init() {
        openDatabase()
        createTables()
    }

    private func openDatabase() {
        // 获取应用沙盒中的 Documents 目录
        let documentsDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let databaseURL = documentsDirectory.appendingPathComponent("MusicDatabase.sqlite")

        // 初始化 FMDatabase 对象
        database = FMDatabase(url: databaseURL)

        // 打开数据库连接
        if !(database?.open() ?? false) {
            print("无法打开数据库")
        }
    }

    private func createTables() {
        // 创建歌手表
        let createSingerTableQuery = "CREATE TABLE IF NOT EXISTS Singer (singerID INTEGER PRIMARY KEY AUTOINCREMENT, singerName TEXT, singerImageURL TEXT)"
        executeQuery(createSingerTableQuery)

        // 创建专辑表
        let createAlbumTableQuery = "CREATE TABLE IF NOT EXISTS Album (albumID INTEGER PRIMARY KEY AUTOINCREMENT, albumName TEXT, singerID INTEGER, albumImageURL TEXT, FOREIGN KEY (singerID) REFERENCES Singer(singerID))"
        executeQuery(createAlbumTableQuery)
    }

    private func executeQuery(_ query: String, values: [Any]? = nil) {
        do {
            try database?.executeUpdate(query, values: values)
        } catch {
            print("执行查询时出错: \(error.localizedDescription)")
        }
    }
}

// 添加专辑或歌手
extension MusicDatabaseManager {
    func insertSinger(singerName: String, singerImageURL: String) {
        let insertSingerQuery = "INSERT INTO Singer (singerName, singerImageURL) VALUES (?, ?)"
        executeQuery(insertSingerQuery, values: [singerName, singerImageURL])
    }

    // 修改插入专辑信息的函数
    func insertAlbum(albumName: String, singerName: String, albumImageURL: String) {
        // 查询歌手的ID
        guard let singerID = getSingerID(singerName: singerName) else {
            print("未找到歌手: \(singerName)")
            return
        }

        // 插入专辑信息
        let insertAlbumQuery = "INSERT INTO Album (albumName, singerID, albumImageURL) VALUES (?, ?, ?)"
        executeQuery(insertAlbumQuery, values: [albumName, singerID, albumImageURL])
    }

    // 添加查询歌手ID的函数
    private func getSingerID(singerName: String) -> Int? {
        let selectSingerIDQuery = "SELECT singerID FROM Singer WHERE singerName = ?"

        do {
            let resultSet = try database?.executeQuery(selectSingerIDQuery, values: [singerName])
            if resultSet?.next() ?? false, let singerID = resultSet?.int(forColumn: "singerID") {
                return Int(singerID)
            }
        } catch {
            print("查询歌手ID时出错: \(error.localizedDescription)")
        }

        return nil
    }

}
// 查询所有歌手
extension MusicDatabaseManager {
    func getAllSingers() -> [ImageData] {
        var singers: [ImageData] = []

        let selectSingersQuery = "SELECT singerName, singerImageURL FROM Singer"

        do {
            let resultSet = try database?.executeQuery(selectSingersQuery, values: nil)
            while resultSet?.next() ?? false {
                if let singerName = resultSet?.string(forColumn: "singerName"),
                    let singerImageURL = resultSet?.string(forColumn: "singerImageURL") {
                    let singerData = ImageData(label: singerName, remoteImageUrl: singerImageURL)
                    singers.append(singerData)
                }
            }
        } catch {
            print("查询歌手数据时出错: \(error.localizedDescription)")
        }

        return singers
    }
}

// 查询歌手的专辑
extension MusicDatabaseManager {
    func getAlbumsForSinger(singerName: String) -> [ImageData] {
        var albums: [ImageData] = []

        let selectAlbumQuery = "SELECT Album.albumName, Album.albumImageURL FROM Album JOIN Singer ON Album.singerID = Singer.singerID WHERE Singer.singerName = ?"

        do {
            let resultSet = try database?.executeQuery(selectAlbumQuery, values: [singerName])
            while resultSet?.next() ?? false {
                if let albumName = resultSet?.string(forColumn: "albumName"),
                    let albumImageURL = resultSet?.string(forColumn: "albumImageURL") {
                    let imageData = ImageData(label: albumName, remoteImageUrl: albumImageURL)
                    albums.append(imageData)
                }
            }
        } catch {
            print("查询专辑数据时出错: \(error.localizedDescription)")
        }
        return albums
    }
}
// 删除专辑或歌手
extension MusicDatabaseManager {
    func deleteSinger(singerName: String) {
        let deleteSingerQuery = "DELETE FROM Singer WHERE singerName = ?"
        let deleteAlbumsQuery = "DELETE FROM Album WHERE singerID IN (SELECT singerID FROM Singer WHERE singerName = ?)"

        do {
            try database?.executeUpdate(deleteSingerQuery, values: [singerName])
            try database?.executeUpdate(deleteAlbumsQuery, values: [singerName])

            print("成功删除歌手及其所有专辑: \(singerName)")
        } catch {
            print("删除歌手时出错: \(error.localizedDescription)")
        }
    }

    // 删除专辑
    func deleteAlbum(albumName: String) {
        let deleteAlbumQuery = "DELETE FROM Album WHERE albumName = ?"

        do {
            try database?.executeUpdate(deleteAlbumQuery, values: [albumName])
            print("成功删除专辑: \(albumName)")
        } catch {
            print("删除专辑时出错: \(error.localizedDescription)")
        }
    }
}

// 根据歌手或专辑名称修改图片的网络地址
extension MusicDatabaseManager {
    func updateImageUrl(forArtist artistName: String, newImageUrl: String) {
        let updateSingerQuery = "UPDATE Singer SET singerImageURL = ? WHERE singerName = ?"
        let updateAlbumQuery = "UPDATE Album SET albumImageURL = ? WHERE albumName = ?"

        do {
            try database?.executeUpdate(updateSingerQuery, values: [newImageUrl, artistName])
            try database?.executeUpdate(updateAlbumQuery, values: [newImageUrl, artistName])

            print("成功更新 \(artistName) 的网络地址为: \(newImageUrl)")
        } catch {
            print("更新网络地址时出错: \(error.localizedDescription)")
        }
    }
}

// 清空数据库
extension MusicDatabaseManager {
    func clearDatabase() {
        let clearSingerTableQuery = "DELETE FROM Singer"
        let clearAlbumTableQuery = "DELETE FROM Album"

        do {
            try database?.executeUpdate(clearSingerTableQuery, values: nil)
            try database?.executeUpdate(clearAlbumTableQuery, values: nil)
            print("成功清空数据库中的所有内容")
        } catch {
            print("清空数据库内容时出错: \(error.localizedDescription)")
        }
    }
}
// 查询专辑网络地址
extension MusicDatabaseManager{
    func getAlbumImageUrl(forAlbum albumName: String) -> String? {
        let selectAlbumQuery = "SELECT albumImageURL FROM Album WHERE albumName = ?"

        do {
            let resultSet = try database?.executeQuery(selectAlbumQuery, values: [albumName])
            if resultSet?.next() ?? false, let albumImageURL = resultSet?.string(forColumn: "albumImageURL") {
                return albumImageURL
            }
        } catch {
            print("查询专辑网络地址时出错: \(error.localizedDescription)")
        }

        return nil
    }
}

extension MusicDatabaseManager {
    func MusicDatabaseManagerInit() {
        MusicDatabaseManager.shared.clearDatabase()
        MusicDatabaseManager.shared.insertSinger(singerName: "周杰伦", singerImageURL: "https://upload.mnw.cn/2015/0702/1435800859952.jpg")
        MusicDatabaseManager.shared.insertAlbum(albumName: "Jay", singerName: "周杰伦", albumImageURL: "https://5b0988e595225.cdn.sohucs.com/q_70,c_zoom,w_640/images/20180614/362c47beb16943499a05fb694b670f39.jpeg")
        MusicDatabaseManager.shared.insertAlbum(albumName: "范特西", singerName: "周杰伦", albumImageURL: "https://img12.360buyimg.com/imgzone/jfs/t1/97662/34/20411/78984/625ebc5fEa8e29a60/f05c086641ee50eb.jpg")
        MusicDatabaseManager.shared.insertAlbum(albumName: "八度空间", singerName: "周杰伦", albumImageURL: "https://img1.kuwo.cn/star/cafe/upload/33/79/1292842083733.jpg")
        MusicDatabaseManager.shared.insertAlbum(albumName: "叶惠美", singerName: "周杰伦", albumImageURL: "https://img2.baidu.com/it/u=2683650131,2538238931&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=546")
        MusicDatabaseManager.shared.insertAlbum(albumName: "七里香", singerName: "周杰伦", albumImageURL: "https://img1.baidu.com/it/u=2703310692,3238201285&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=554")
        MusicDatabaseManager.shared.insertAlbum(albumName: "11月的萧邦", singerName: "周杰伦", albumImageURL: "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201807%2F12%2F20180712182203_fUkaj.jpeg&refer=http%3A%2F%2Fb-ssl.duitang.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1708783427&t=d29a78d8e1d2a3806f4eef2f98d9bce5")
        MusicDatabaseManager.shared.insertAlbum(albumName: "依然范特西", singerName: "周杰伦", albumImageURL: "https://file.digitaling.com/eImg/uimages/20160607/1465289838950085.jpg")
        MusicDatabaseManager.shared.insertAlbum(albumName: "我很忙", singerName: "周杰伦", albumImageURL: "https://n.sinaimg.cn/sinacn/w580h775/20180213/923e-fyrpeie1595771.jpg")
        MusicDatabaseManager.shared.insertAlbum(albumName: "魔杰座", singerName: "周杰伦", albumImageURL: "https://t11.baidu.com/it/u=2340547619,178592303&fm=30&app=106&f=PNG?w=640&h=855&s=CD741CC7D60200FF9EA7503203005018")
        MusicDatabaseManager.shared.insertAlbum(albumName: "跨时代", singerName: "周杰伦", albumImageURL: "https://hbimg.b0.upaiyun.com/a5940a82ac55eac5b8855cfc2ca1f06c36ccbfd05289b-8uK8kM_fw658")
        MusicDatabaseManager.shared.insertAlbum(albumName: "惊叹号", singerName: "周杰伦", albumImageURL: "https://img2.baidu.com/it/u=801783477,2037607339&fm=253&fmt=auto&app=138&f=JPEG?w=651&h=500")
        MusicDatabaseManager.shared.insertAlbum(albumName: "十二新作", singerName: "周杰伦", albumImageURL: "https://5b0988e595225.cdn.sohucs.com/images/20180614/8637008c1f4241799e3ce82c46309b7f.jpeg")
        MusicDatabaseManager.shared.insertAlbum(albumName: "哎呦，不错哦", singerName: "周杰伦", albumImageURL: "https://n.sinaimg.cn/sinacn09/335/w580h555/20180817/bcba-hhvciiw3880154.jpg")
        MusicDatabaseManager.shared.insertAlbum(albumName: "周杰伦的床边故事", singerName: "周杰伦", albumImageURL: "https://n1.itc.cn/img8/wb/recom/2016/07/10/146816381069873056.JPEG")
        MusicDatabaseManager.shared.insertAlbum(albumName: "最伟大的作品", singerName: "周杰伦", albumImageURL: "https://t10.baidu.com/it/u=358527063,179331498&fm=30&app=106&f=JPEG?w=640&h=596&s=B9C6CB15404F734D54148C440300F0E3")
        
        
        
        
        
        
    }
    
}
