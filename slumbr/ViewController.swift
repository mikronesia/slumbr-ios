//
//  ViewController.swift
//  slumbr
//
//  Created by Michael McDermott on 12/2/16.
//  Copyright © 2016 Mikronesia. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class ViewController: UIViewController {
    
    @IBOutlet weak var butSettings: UIButton!
    @IBOutlet weak var butPlayPause: UIButton!
    @IBOutlet weak var butFF: UIButton!
    @IBOutlet weak var butRW: UIButton!
    @IBOutlet weak var lblTrackName: UILabel!
    @IBOutlet weak var lblSettings: UILabel!
    var updater : CADisplayLink! = nil
    var player = AVPlayer()
    var playerItem : AVPlayerItem! = nil
    var arrTracks = [String]()
    var isPlaying : Bool = false
    var startedPlaying : Bool = false
    var timer:Timer!
    var timerSleep:Timer!
    var sleepTime : Float = -1
    var vPlayer: AVPlayer?
    override func viewDidLoad() {
        super.viewDidLoad()
        loadVideo()
        loadJSON();
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //video intro
    private func loadVideo() {
        //this line is important to prevent background music stop
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
        } catch { }
        let path = Bundle.main.path(forResource: "animation", ofType:"mp4")
        vPlayer = AVPlayer(url: NSURL(fileURLWithPath: path!) as URL)
        let playerLayer = AVPlayerLayer(player: vPlayer)
        playerLayer.frame = self.view.frame
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        playerLayer.zPosition = -1
        self.view.layer.addSublayer(playerLayer)
        vPlayer?.seek(to: kCMTimeZero)
        vPlayer?.play()
    }
    
    func loadJSON() {
        let requestURL: NSURL = NSURL(string: "http://earsnake.com/quiescent/tracks.json")!
        //let requestURL: NSURL = NSURL(string: "http://localhost/quiescent/tracks.json")!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL as URL)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest as URLRequest) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                print("Everyone is fine, file downloaded successfully.")
                do {
                    let parsedData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
                    if let jtracks = parsedData["tracks"] as? [[String: AnyObject]] {
                        for jtrack in jtracks {
                            for (_,value) in jtrack {
                                self.arrTracks.append(value as! String)
                            }
                        }
                    }
                    print(self.arrTracks)
                }
                catch {
                    print("Error with Json: \(error)")
                }
            }
        }
        
        task.resume()
    }
    
    //Timer(s)
    func updateTime() {
        /*let currentTime = Float(CMTimeGetSeconds(player.currentTime()))
        seekInTrack.value = currentTime
        let minutes = Int(currentTime) / 60 % 60
        let seconds = Int(currentTime) % 60
        currTime.text = String(format: "%02i:%02i", minutes,seconds) as String*/
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let aSleepValue = Float(appDelegate.sleepTime)
        lblSettings.text = String(aSleepValue)
    }
    
    func updateSleepTimer() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if (appDelegate.sleepTime>0) {
            appDelegate.sleepTime -= 1
        } else if (appDelegate.sleepTime==0){
            pauseTrack()
        }
    }
    
    
    //Player Controls
    @IBAction func butPlayPause(_ sender: Any) {
        if (startedPlaying == false) {
            startedPlaying = true
            getTrack()
        } else {
            if (isPlaying) {
                pauseTrack()
                butPlayPause.setTitle("Play", for: UIControlState.normal)
                isPlaying = false
            } else {
                playTrack()
                butPlayPause.setTitle("Pause", for: UIControlState.normal)
                isPlaying = true
            }
        }
    }
    
    @IBAction func butFF(_ sender: Any) {
        getTrack()
    }
    
    @IBAction func butRW(_ sender: Any) {
        getTrack()
    }
    
    func playTrack() {
        player.play()
        butPlayPause.setTitle("Pause", for: UIControlState.normal)
    }
    
    func pauseTrack() {
        player.pause()
        butPlayPause.setTitle("Play", for: UIControlState.normal)
    }
    
    func getTrack () {
        let randomIndex = Int(arc4random_uniform(UInt32(arrTracks.count)))
        //let url = "http://earsnake.com/quiescent/"+arrTracks[randomIndex]+".mp3"
        let url = "http://localhost/quiescent/"+arrTracks[randomIndex]+".mp3"
        lblTrackName.text = arrTracks[randomIndex]
        let playerItem = AVPlayerItem( url:NSURL( string:url ) as! URL )
        player = AVPlayer(playerItem:playerItem)
        player.rate = 1.0
        lblSettings.text = String(CMTimeGetSeconds(playerItem.currentTime()))
        playTrack()
        butPlayPause.setTitle("Pause", for: UIControlState.normal)
        isPlaying = true
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        timerSleep = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(updateSleepTimer), userInfo: nil, repeats: true)
    }
}

