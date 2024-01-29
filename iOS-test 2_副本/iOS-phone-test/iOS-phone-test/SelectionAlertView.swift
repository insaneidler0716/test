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
// 播放模式的枚举
enum PlayMode: String, CaseIterable {
    case singleLoop = "单曲循环"
    case loop = "循环播放"
    case random = "随机播放"
}

// 音乐效果的枚举
enum MusicEffect: String, CaseIterable {
    case classic = "经典"
    case vinyl = "黑胶"
}

extension TimePickerViewController {

    // 弹出选择播放模式的选项
    func showPlayModeOptions() {
        let playModeSheet = UIAlertController(title: "选择播放模式", message: nil, preferredStyle: .actionSheet)

        // 添加每种播放模式的选项
        for mode in PlayMode.allCases {
            let action = UIAlertAction(title: mode.rawValue, style: .default) { _ in
                self.savePlayModeSelection(mode)
            }
            playModeSheet.addAction(action)
        }

        // 添加取消按钮
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        playModeSheet.addAction(cancelAction)

        // 弹出播放模式选项 Action Sheet
        present(playModeSheet, animated: true, completion: nil)
    }

    // 弹出选择音乐效果的选项
    func showMusicEffectOptions() {
        let musicEffectSheet = UIAlertController(title: "选择音乐效果", message: nil, preferredStyle: .actionSheet)

        // 添加每种音乐效果的选项
        for effect in MusicEffect.allCases {
            let action = UIAlertAction(title: effect.rawValue, style: .default) { _ in
                self.saveMusicEffectSelection(effect)
            }
            musicEffectSheet.addAction(action)
        }

        // 添加取消按钮
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        musicEffectSheet.addAction(cancelAction)

        // 弹出音乐效果选项 Action Sheet
        present(musicEffectSheet, animated: true, completion: nil)
    }

    // 保存选择的播放模式
    func savePlayModeSelection(_ selectedMode: PlayMode) {
        UserDefaults.standard.set(selectedMode.rawValue, forKey: kSelectedPlayMode)
        // 刷新页面的显示
        timePickerTableView.reloadData()
    }

    // 保存选择的音乐效果
    func saveMusicEffectSelection(_ selectedEffect: MusicEffect) {
        UserDefaults.standard.set(selectedEffect.rawValue, forKey: kSelectedMusicEffect)
        // 刷新页面的显示
        timePickerTableView.reloadData()
    }
}
