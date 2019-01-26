//
//  MusicManager.swift
//  Dots
//
//  Created by Bjarte Sjursen on 30.07.2016.
//  Copyright © 2016 Sjursen Software. All rights reserved.
//

import Foundation
import AVFoundation

class MusicManager {
    
    var audioPlayer : AVAudioPlayer
    let queue = DispatchQueue(label: "musicQueue", attributes: [])
    
    init(nameOfSong : String, withExtension : String){
        
        let song = Bundle.main.url(forResource: nameOfSong, withExtension: withExtension)
        
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: song!)
            audioPlayer.numberOfLoops = -1
        } catch {
            fatalError("Error initalizing musicManager")
        }
    }
    
    func changeSong(_ nameOfSong : String, withExtension : String){
        
        if audioPlayer.isPlaying {
            audioPlayer.stop()
        }
        
        let song = Bundle.main.url(forResource: nameOfSong, withExtension: withExtension)
        
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: song!)
            audioPlayer.numberOfLoops = -1
        } catch {
            fatalError("Error initalizing musicManager")
        }
        
    }
    
    func pause(){
        
        if audioPlayer.isPlaying {
            queue.async(execute: {
                self.audioPlayer.pause()
            })
        }
        
    }
    
    func play(){
        
        
        //Check to see the users game music preference
        let isMusicOn = UserDefaults.standard.bool(forKey: isMusicOnString)
        
        if !audioPlayer.isPlaying && isMusicOn {
            let queue = DispatchQueue(label: "musicQueue", attributes: [])
            queue.async(execute: {
                self.audioPlayer.play()
            })
        }
        
    }
    
    
    
    
}
