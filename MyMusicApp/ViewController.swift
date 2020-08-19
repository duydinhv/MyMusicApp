//
//  ViewController.swift
//  MyMusicApp
//
//  Created by DUY on 8/16/20.
//  Copyright © 2020 DUY. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
    @IBOutlet weak var table: UITableView!
    var songs = [Song]()
    lazy var songName = ""
    lazy var album = ""
    lazy var artist = ""
    lazy var image = NSData()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        getSong()
        table.dataSource = self
        table.delegate = self
    }

    func getSong() {
        let fileURL = URL(fileURLWithPath: Bundle.main.resourcePath!)
        do {
            let filePath = try FileManager.default.contentsOfDirectory(at: fileURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            for file in filePath {
                var fileString = file.absoluteString
                if fileString.contains(".mp3") {
                    let findString = fileString.components(separatedBy: "/")
                    fileString = findString[findString.count - 1]
                    fileString = fileString.replacingOccurrences(of: "%20", with: " ")
                    fileString = fileString.replacingOccurrences(of: ".mp3", with: "")
                    getDataSong(fileString)
                    songs.append(Song(name: songName, albumName: album, artistName: artist, imageName: image, trackName: fileString))
                }
            }
        } catch {
            print(error)
        }
    }
    
    func getDataSong(_ fileString: String) {
        let filePath = Bundle.main.path(forResource: fileString, ofType: "mp3")
        let fileUrl = URL(fileURLWithPath: filePath!)
        let playerItem = AVPlayerItem(url: fileUrl)
        let metadataList = playerItem.asset.metadata
        for metadata in metadataList {
            guard let key = metadata.commonKey?.rawValue, let value = metadata.value else { continue }
            switch key {
                case "title" :
                    songName = value as! String
                case "artist":
                    artist = value as! String
                case "albumName" :
                    album = value as! String
                case "artwork" :
                    image = value as! NSData
                default:
                    continue
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
      
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let song = songs[indexPath.row]
        cell.textLabel?.text = song.name
        cell.detailTextLabel?.text = song.albumName
        cell.accessoryType = .disclosureIndicator
        cell.imageView?.image = UIImage(data: song.imageName as Data)
        
        cell.textLabel?.font = UIFont(name: "Helvetica-Bold", size: 18)
        cell.detailTextLabel?.font = UIFont(name: "Helvetica", size: 17)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // present the player
        let position = indexPath.row
        // songs
        guard let vc = storyboard?.instantiateViewController(identifier: "player") as? PlayerViewController
            else {
            return
        }
        vc.songs = songs
        vc.position = position 
        
        present(vc, animated: true)
    }
    
}

struct Song {
    var name: String
    var albumName: String
    var artistName: String
    var imageName: NSData
    var trackName: String
}
