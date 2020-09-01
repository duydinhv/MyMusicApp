//
//  PlayViewController.swift
//  MyMusicApp
//
//  Created by DUY on 8/16/20.
//  Copyright © 2020 DUY. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class PlayerViewController: UIViewController {

    public var position: Int = 0
    public var songs: [Song] = []
    
    // MARK: user interface elements
    let playPauseButton = UIButton()
    var progressBar = UIProgressView()
    let currentTimeLabel = UILabel()
    let remainTimeLabel = UILabel()
    @IBOutlet weak var holder: UIView!
    
    private let albumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private let songNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .red
        label.numberOfLines = 0
        return label
    }()
    private let albumNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .red
        label.numberOfLines = 0
        return label
    }()
    
    var player: AVAudioPlayer?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if holder.subviews.count == 0 {
            configure()
        }
    }
    
    func configure() {
        // set up player
        let song = songs[position]
        let urlString = Bundle.main.path(forResource: song.trackName, ofType: "mp3")
        do {
            try AVAudioSession.sharedInstance().setMode(.default)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            
            guard let urlString = urlString else { return }
            player = try AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: urlString) as URL)

            guard let player = player else {
                print("error")
                return
            }
            player.play()
            
            Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateAudioProgressView), userInfo: nil, repeats: true)
            progressBar.setProgress(Float(player.currentTime / player.duration), animated: true)
            currentTimeLabel.text = String(player.currentTime.stringFromTimeInterval())
            remainTimeLabel.text = String("-\((player.duration - player.currentTime).stringFromTimeInterval())")
        } catch {
            print("Error Occurred")
        }
        
        // album cover
        albumImageView.frame = CGRect(x: 10,
                                      y: 10,
                                      width: holder.frame.size.width - 20,
                                      height: holder.frame.size.width - 20)
        albumImageView.image = UIImage(data: song.imageName as Data)
        holder.addSubview(albumImageView)
        
        // labels
        songNameLabel.frame = CGRect(x: 10,
                                     y: albumImageView.frame.size.height + 10,
                                     width: holder.frame.size.width - 20,
                                     height: 70)
        artistNameLabel.frame = CGRect(x: 10,
                                       y: albumImageView.frame.size.height + 10 + 50,
                                    width: holder.frame.size.width - 20,
                                    height: 70)
        albumNameLabel.frame = CGRect(x: 10,
                                      y: albumImageView.frame.size.height + 10 + 90,
                                      width: holder.frame.size.width - 20,
                                      height: 70)
        
        songNameLabel.text = song.name
        artistNameLabel.text = song.artistName
        albumNameLabel.text = song.albumName
        
        holder.addSubview(songNameLabel)
        holder.addSubview(artistNameLabel)
        holder.addSubview(albumNameLabel)
        
        // progress bar
        self.progressBar = UIProgressView(frame: CGRect(x: 50,
                                                    y: albumNameLabel.frame.origin.y + 75,
                                                    width: holder.frame.size.width - 100,
                                                    height: 30))
        self.progressBar.tintColor = .gray
        currentTimeLabel.frame = CGRect(x: 50,
                                        y: progressBar.frame.origin.y - 5,
                                        width: 50,
                                        height: 50)
        currentTimeLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        currentTimeLabel.textColor = .gray
        
        remainTimeLabel.frame = CGRect(x: holder.frame.size.width - 85,
                                       y: progressBar.frame.origin.y - 5,
                                       width: 50,
                                       height: 50)
        remainTimeLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        remainTimeLabel.textColor = .gray
        
        holder.addSubview(currentTimeLabel)
        holder.addSubview(remainTimeLabel)
        holder.addSubview(progressBar)
        
        // player controls
        let nextButton = UIButton()
        let backButton = UIButton()
        
        let yPosition = artistNameLabel.frame.origin.y + 175
        let size: CGFloat = 35
        playPauseButton.frame = CGRect(x: (holder.frame.size.width - size) / 2.0,
                                       y: yPosition,
                                       width: size,
                                       height: size)
        nextButton.frame = CGRect(x: playPauseButton.frame.origin.x + 100,
                                  y: yPosition,
                                  width: size,
                                  height: size)
        backButton.frame = CGRect(x: playPauseButton.frame.origin.x - 100,
                                  y: yPosition,
                                  width: size,
                                  height: size)

        playPauseButton.addTarget(self, action: #selector(didTappedPlayButton), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didTappedNextButton), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(didTappedBackButton), for: .touchUpInside)
        
        playPauseButton.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
        nextButton.setBackgroundImage(UIImage(systemName: "forward.fill"), for: .normal)
        backButton.setBackgroundImage(UIImage(systemName: "backward.fill"), for: .normal)
        
        playPauseButton.tintColor = .black
        backButton.tintColor = .black
        nextButton.tintColor = .black
        
        holder.addSubview(playPauseButton)
        holder.addSubview(nextButton)
        holder.addSubview(backButton)
        
        // slider
        let slider = UISlider(frame: CGRect(x: progressBar.frame.origin.x,
                                            y: holder.frame.size.height - 100,
                                            width: progressBar.frame.size.width,
                                            height: 50))
        slider.tintColor = .lightGray
        slider.value = 1.0
        slider.addTarget(self, action: #selector(didSliderSlide(_:)), for: .valueChanged)
        holder.addSubview(slider)
        
        let minVolumeImage = UIImageView(image: UIImage(systemName: "speaker.fill"))
        minVolumeImage.frame = CGRect(x: slider.frame.origin.x - 30,
                                      y: slider.frame.origin.y + 17,
                                      width: 15, height: 15)
        minVolumeImage.tintColor = .gray
        
        let maxVolumeImage = UIImageView(image: UIImage(systemName: "speaker.3.fill"))
        maxVolumeImage.frame = CGRect(x: slider.frame.origin.x + slider.frame.size.width + 10,
                                      y: slider.frame.origin.y + 17,
                                      width: 15, height: 15)
        maxVolumeImage.tintColor = .gray
        
        holder.addSubview(minVolumeImage)
        holder.addSubview(maxVolumeImage)
    }
    
    @objc func didTappedPlayButton() {
        if player?.isPlaying == true {
            player?.pause()
            playPauseButton.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
            // shrink image
            UIView.animate(withDuration: 0.2, animations: {
                self.albumImageView.frame = CGRect(x: 45,
                                                   y: 45,
                                                   width: self.holder.frame.size.width - 90,
                                                   height: self.holder.frame.size.width - 90)
            })
        } else {
            player?.play()
            playPauseButton.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
            // increase image size
            UIView.animate(withDuration: 0.2, animations: {
                self.albumImageView.frame = CGRect(x: 10,
                                                   y: 10,
                                                   width: self.holder.frame.size.width - 20,
                                                   height: self.holder.frame.size.width - 20)
            })
        }
    }
    @objc func didTappedNextButton() {
        if position < (songs.count - 1) {
            position = position + 1
            player?.stop()
            for subview in holder.subviews {
                subview.removeFromSuperview()
            }
            configure()
        } else {
            position = 0
            player?.stop()
            for subview in holder.subviews {
                subview.removeFromSuperview()
            }
            configure()
        }
    }
    @objc func didTappedBackButton() {
        if position > 0 {
            position = position - 1
            player?.stop()
            for subview in holder.subviews {
                subview.removeFromSuperview()
            }
            configure()
        } else {
            position = songs.count - 1
            player?.stop()
            for subview in holder.subviews {
                subview.removeFromSuperview()
            }
            configure()
        }
    }
    @objc func didSliderSlide(_ slider: UISlider) {
        let value = slider.value
        // adjust player volume
        player?.volume = value
    }
    
    @objc func updateAudioProgressView()
    {
       if player!.isPlaying {
            // Update progress
            progressBar.setProgress(Float(player!.currentTime / player!.duration), animated: true)
            currentTimeLabel.text = String(player!.currentTime.stringFromTimeInterval())
            remainTimeLabel.text = String("-\((player!.duration - player!.currentTime).stringFromTimeInterval())")
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if let player = player {
            player.stop()
        }
    }
    
}

extension TimeInterval{
    func stringFromTimeInterval() -> String {

        let time = NSInteger(self)

        let seconds = time % 60
        let minutes = (time / 60) % 60

        return String(format: "%0.2d:%0.2d",minutes,seconds)
    }
}

