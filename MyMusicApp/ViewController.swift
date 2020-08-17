//
//  ViewController.swift
//  MyMusicApp
//
//  Created by DUY on 8/16/20.
//  Copyright © 2020 DUY. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
    @IBOutlet weak var table: UITableView!
    var songs = [Song]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        configureSongs()
        table.dataSource = self
        table.delegate = self
    }

    func configureSongs() {
        songs.append(Song(name: "Bac Phan", albumName: "Jack's song", artistName: "Jack", imageName: "cover 1", trackName: "Bac Phan"))
        songs.append(Song(name: "Mot Buoc Yeu Van Dam Dau", albumName: "something", artistName: "Mr.Siro", imageName: "cover 2", trackName: "Mot Buoc Yeu Van Dam Dau"))
        songs.append(Song(name: "Mot Dem Say (X)", albumName: "something", artistName: "Thinh Suy", imageName: "cover 3", trackName: "Mot Dem Say (X)"))
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
        cell.imageView?.image = UIImage(named: song.imageName)
        
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
    var imageName: String
    var trackName: String
    
//    func getSong() {
//        let folderURL = URL(fileURLWithPath: Bundle.main.resourcePath!)
//        do {
//            let songPath = try FileManager.default.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
//            for songItem in songPath {
//                var song = songItem.absoluteString
//                if song.contains(".mp3") {
//                    let
//                }
//            }
//        }
//    }
}
