//
//  MusicPlayViewController.swift
//  iOS-phone-test
//
//  Created by li haonan on 2024/1/26.
//

import UIKit
import AVFoundation
import SnapKit
import YYWebImage

class MusicPlayerViewController: UIViewController {
    
    // 封面图片
    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        // 圆形封面
        imageView.layer.cornerRadius = 100
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // 进度条
    private let progressSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 1
        return slider
    }()
    
    // 倒计时标签
    private let countDownTimeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    // 播放时间标签
    private let playTimeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    // 歌名标签
    let songLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 25)
        return label
    }()
    
    // 暂停与继续按钮
    private let playPauseButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    // 播放模式标签
    private let modeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    // 音乐效果标签
    private let effectLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    // 播放器
    private var player: AVAudioPlayer?
    
    // 倒计时数默认值
    var countdownDuration: Double = 100.00
    
    var playMode: String? {
        didSet {
            modeLabel.text = "播放模式： \(playMode ?? "")"
        }
    }
    
    var musicEffect: String? {
        didSet {
            effectLabel.text = "音乐效果： \(musicEffect ?? "")"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        player?.play()
    }
    
    private func setupViews() {
        
        
        // 根据当前外观模式更新背景颜色
        if traitCollection.userInterfaceStyle == .dark {
            view.backgroundColor = .black
        } else {
            view.backgroundColor = .white
        }
        
        // 添加子视图到 MusicPlayerView
        view.addSubview(coverImageView)
        view.addSubview(progressSlider)
        view.addSubview(countDownTimeLabel)
        view.addSubview(playPauseButton)
        view.addSubview(modeLabel)
        view.addSubview(effectLabel)
        view.addSubview(playTimeLabel)
        view.addSubview(songLabel)
        
        // 设置子视图的约束
        
        songLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(65)
        }
        
        
        coverImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(150)
            make.width.height.equalTo(200)
        }
        
        progressSlider.snp.makeConstraints { make in
            make.top.equalTo(coverImageView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        playPauseButton.snp.makeConstraints { make in
            make.top.equalTo(progressSlider.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        playTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(playPauseButton.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        countDownTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(playTimeLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        modeLabel.snp.makeConstraints { make in
            make.top.equalTo(countDownTimeLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        effectLabel.snp.makeConstraints { make in
            make.top.equalTo(modeLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        // 添加按钮点击事件
        playPauseButton.addTarget(self, action: #selector(playPauseButtonTapped), for: .touchUpInside)
        
        
        // 初始化音频播放器
        if let audioFilePath = Bundle.main.path(forResource: "TestMusic", ofType: "mp3") {
            let audioFileURL = URL(fileURLWithPath: audioFilePath)
            do {
                player = try AVAudioPlayer(contentsOf: audioFileURL)
                player?.prepareToPlay()
            } catch {
                print("Error initializing audio player: \(error.localizedDescription)")
            }
        }
        
        
        // 设置播放进度更新事件
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
            self?.updateUI()
        }
    }
    
    // 播放暂停按钮点击事件
    @objc private func playPauseButtonTapped() {
        if player?.isPlaying ?? false {
            player?.pause()
        } else {
            player?.play()
        }
        playPauseButton.isSelected = player?.isPlaying ?? false
    }
    
    // 更新播放进度和时间显示
    private func updateUI() {
        guard let player = player else { return }
        
        //let progress = Float(player.currentTime / player.duration)
        //progressSlider.value = progress
        // 进度条跟随
        let progress = Float(player.currentTime / countdownDuration)
        progressSlider.value = progress
        
        // 倒计时跟随
        let countDownMinutes = Int(countdownDuration - player.currentTime) / 60
        let countDownSeconds = Int(countdownDuration - player.currentTime) % 60
        countDownTimeLabel.text = String("倒计时剩余时间： \(countDownMinutes)分\(countDownSeconds)秒")
        
        // 播放时间跟随
        let playMinutes = Int(player.currentTime) / 60
        let playSeconds = Int(player.currentTime) % 60
        playTimeLabel.text = String("播放时间： \(playMinutes)分\(playSeconds)秒")
        
        // 按钮形态跟随
        let buttonImage: UIImage?
        if player.isPlaying {
            buttonImage = UIImage(systemName: "pause.fill")
        } else {
            buttonImage = UIImage(systemName: "play.fill")
        }
        playPauseButton.setImage(buttonImage, for: .normal)
        
        // 判断是否倒计时结束
        if countdownDuration - player.currentTime <= 0 {
            player.stop()
            playPauseButton.isSelected = false
            navigationController?.popViewController(animated: true)
        } else {
            
        }
    }
    
    func configure(imageUrl: String) {
        let placeholderImage = UIImage(named: "IMG_PlaceHolder")
        if let url = URL(string: imageUrl) {
            coverImageView.yy_setImage(with: url, placeholder: placeholderImage, options: YYWebImageOptions.setImageWithFadeAnimation)
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateInterfaceForCurrentTheme()
        }
    }

    func updateInterfaceForCurrentTheme() {
        // 在这里执行更新界面的操作
        if traitCollection.userInterfaceStyle == .dark {
            // 暗色模式
            view.backgroundColor = .black
        } else {
            // 亮色模式
            view.backgroundColor = .white
        }
    }
}
