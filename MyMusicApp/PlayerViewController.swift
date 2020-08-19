//
//  PlayViewController.swift
//  MyMusicApp
//
//  Created by DUY on 8/16/20.
//  Copyright © 2020 DUY. All rights reserved.
//

import UIKit
import AVFoundation

class PlayerViewController: UIViewController {

    public var position: Int = 0
    public var songs: [Song] = []
    let playPauseButton = UIButton()
    @IBOutlet weak var holder: UIView!
    
    // user interface elements
    private let albumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private let songNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    private let albumNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
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
        
        // player controls
        let nextButton = UIButton()
        let backButton = UIButton()
        
        // frame
        let yPosition = artistNameLabel.frame.origin.y + 70 + 50
        let size: CGFloat = 35
        playPauseButton.frame = CGRect(x: (holder.frame.size.width - size) / 2.0,
                                       y: yPosition,
                                       width: size,
                                       height: size)
        nextButton.frame = CGRect(x: (holder.frame.size.width - size - 20),
                                  y: yPosition,
                                  width: size,
                                  height: size)
        backButton.frame = CGRect(x: 20,
                                  y: yPosition,
                                  width: size,
                                  height: size)
        // add action
        playPauseButton.addTarget(self, action: #selector(didTappedPlayButton), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didTappedNextButton), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(didTappedBackButton), for: .touchUpInside)
        
        // image
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
        let slider = UISlider(frame: CGRect(x: 20, y: holder.frame.size.height - 40,
                                            width: holder.frame.size.width - 40,
                                            height: 50))
        slider.value = 0.5
        slider.addTarget(self, action: #selector(didSliderSlide(_:)), for: .valueChanged)
        holder.addSubview(slider)
    }
    
    @objc func didTappedPlayButton() {
        if player?.isPlaying == true {
            player?.pause()
            playPauseButton.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
            // shrink image
            UIView.animate(withDuration: 0.2, animations: {
                self.albumImageView.frame = CGRect(x: 30,
                                                   y: 30,
                                                   width: self.holder.frame.size.width - 60,
                                                   height: self.holder.frame.size.width - 60)
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if let player = player {
            player.stop()
        }
    }
}
