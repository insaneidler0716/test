//
//  SelectionAlertController.swift
//  iOS-phone-test
//
//  Created by li haonan on 2024/1/26.
//

import Foundation
import SnapKit
import UIKit

// 此处专门添加底部弹窗相关内容
extension TimePickerViewController {

    func showPlayModeOptions() {
        let playModeSheet = UIAlertController(title: "选择播放模式", message: nil, preferredStyle: .actionSheet)
        // 添加单曲循环选项
        
        let singleLoopAction = UIAlertAction(title: "单曲循环", style: .default) { _ in
            // 处理选择单曲循环的操作
            self.savePlayModeSelection("单曲循环")
        }
        playModeSheet.addAction(singleLoopAction)
        
        // 添加循环播放选项
        let loopAction = UIAlertAction(title: "循环播放", style: .default) { _ in
            // 处理选择循环播放的操作
            self.savePlayModeSelection("循环播放")
        }
        playModeSheet.addAction(loopAction)
        
        // 添加随机播放选项
        let randomAction = UIAlertAction(title: "随机播放", style: .default) { _ in
            // 处理选择随机播放的操作
            self.savePlayModeSelection("随机播放")
        }
        playModeSheet.addAction(randomAction)

        // 添加取消按钮
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        playModeSheet.addAction(cancelAction)

        // 弹出播放模式选项 Action Sheet
        present(playModeSheet, animated: true, completion: nil)
    }

    func showMusicEffectOptions() {
        let musicEffectSheet = UIAlertController(title: "选择音乐效果", message: nil, preferredStyle: .actionSheet)

        // 添加经典选项
        let classicAction = UIAlertAction(title: "经典", style: .default) { _ in
            // 处理选择经典音乐效果的操作
            self.saveMusicEffectSelection("经典")
        }
        musicEffectSheet.addAction(classicAction)

        // 添加黑胶选项
        let vinylAction = UIAlertAction(title: "黑胶", style: .default) { _ in
            // 处理选择黑胶音乐效果的操作
            self.saveMusicEffectSelection("黑胶")
        }
        musicEffectSheet.addAction(vinylAction)

        // 添加取消按钮
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        musicEffectSheet.addAction(cancelAction)

        // 弹出音乐效果选项 Action Sheet
        present(musicEffectSheet, animated: true, completion: nil)
    }

    func savePlayModeSelection(_ selectedMode: String) {
        // 保存选择到 UserDefaults
        UserDefaults.standard.set(selectedMode, forKey: "SelectedPlayMode")
        // 刷新页面的显示
        timePickerTableView.reloadData()
    }

    func saveMusicEffectSelection(_ selectedEffect: String) {
        // 保存选择到 UserDefaults
        UserDefaults.standard.set(selectedEffect, forKey: "SelectedMusicEffect")
        // 刷新页面的显示
        timePickerTableView.reloadData()
    }
}
