//
//  StopWatchNiddle.swift
//  StopWatch
//
//  Created by iOSCoderAbhimanyuDaspan on 20/05/23.
//

import Foundation
import Combine
class StopWatchNiddle {
    
    var timeTextDisplay:String
    
    var hours:Int {
        didSet {}
    }
    
    var minutes:Int {
        didSet {}
    }
    
    var seconds:Int {
        didSet {
            //project need
            if seconds > 60 {
                seconds = 0
            }
        }
    }
    
    var miliSeconds:Int {
        didSet {
             timeTextDisplay =  timeText()
        }
    }
    
    init( hours:Int = 0, minutes: Int = 0 , seconds: Int = 0 , miliSeconds: Int = 0,timeTextDisplay:String = "") {
        self.hours = hours
        self.minutes = minutes
        self.seconds = seconds
        self.miliSeconds = miliSeconds
        self.timeTextDisplay = String(format:"%02i:%02i:%02i", minutes, seconds,(miliSeconds/10))
    }
    
    //MARK: Show time to USER in proper  formate.
    func timeText() -> String {
        //right now till minutes , seconds, miliseconds is suffiecient as per  project need.
        return String(format:"%02i:%02i:%02i", minutes, seconds,miliSeconds)
    }
}


