//
//  RingViewModel.swift
//  StopWatch
//
//  Created by iOSCoderAbhimanyuDaspan on 20/05/23.
//

import Foundation
import Combine
import UIKit

enum StopWatchState {
    case playing, paused , stoped
}

@MainActor class RingViewModel:ObservableObject {
    
    //UI Update
    @Published var niddle:StopWatchNiddle
    @Published var stopWatchState:StopWatchState = .stoped
    @Published var timeTextDisplay:String
    @Published var percentage:Double = 0.0
    
    //Logic use
    var timerCancellable: AnyCancellable?
    //background time management logic
    var bgTimeManager:BGTimeManager =  BGTimeManager()
    var startTime: TimeInterval?
    var time: TimeInterval?
    var pausedSavedTime:(seconds:Int,milliSeconds:Int)?
    
    //MARK: Initializer with DI
    init(niddle: StopWatchNiddle) {
        self.niddle = niddle
        self.timeTextDisplay = niddle.timeTextDisplay
        self.percentage = ( Double(self.niddle.seconds)+(Double(self.niddle.miliSeconds)*Double(0.001))  )  / Double(60)
        
    }
    
    
    //MARK: Sync with  background time
    func syncBackgroundTime(){
        let finalTimeInSeconds = (bgTimeManager.appCameAliveAt! - bgTimeManager.appReachedInBackgroundAt!)
        if stopWatchState == .paused {
            return
        }
        
        if NeedleConstant.stopWatchProjectLimit <= self.getTimerInformation().seconds  || stopWatchState == .stoped{
            //stop timer & reset everything
            self.stop()
        }else{
            if stopWatchState != .stoped || stopWatchState != .paused {
                self.niddle.miliSeconds = 0
                self.niddle.seconds  = self.niddle.seconds + Int(finalTimeInSeconds)
                self.updateInformationOnUI()
            }
        }
    }
    
    
    //MARK: Play / Pause logic
    func playOrPaused(){
        if timerCancellable == nil {
            //fresh start timer
            start()
        }else{
            
            //check play pause situation and then take actions
            switch self.stopWatchState {
            case .playing:
                self.stopWatchState = .paused
                self.pausedSavedTime = (getTimerInformation().seconds,getTimerInformation().miliseconds)
            case .paused:
                startTime = Date.timeIntervalSinceReferenceDate
                
                //Start the timer
                self.stopWatchState = .playing
            case .stoped:  break
            }
        }
    }
    
    //MARK: Start Timer
    func start(){
        stopWatchState = .playing
        //Start the timer
        startTime = Date.timeIntervalSinceReferenceDate
        
        timerCancellable = Timer.publish(every: NeedleConstant.milliSecondsRange, on: .main, in: .common)
            .autoconnect().sink(receiveValue: { [weak self] _ in
                guard let `self` = self else { return  }
                
                switch self.stopWatchState {
                case .playing:
                    //Total time since timer started, in seconds
                    // print(self.niddle.miliSeconds)
                    print("Curent counter time in Miliseconds :\(self.getTimerInformation().miliseconds)")
                    print("Curent counter time in Seconds :\(self.getTimerInformation().seconds)")
                    //percentage
                    if NeedleConstant.stopWatchProjectLimit <= self.getTimerInformation().seconds {
                        //stop timer & reset everything
                        self.stop()
                    }else{
                        self.niddle.seconds = self.getTimerInformation().seconds
                        self.niddle.miliSeconds = self.getTimerInformation().miliseconds
                        self.updateInformationOnUI()
                    }
                case .paused, .stoped:
                    break
                }
            })
        notifyUserThroughLocalNotificationInBackgroundMode()
    }
    
    func getTimerInformation()->(seconds:Int,miliseconds: Int){
        guard let startTime  = self.startTime else {
            return (0,0)
        }
        self.time = Date.timeIntervalSinceReferenceDate  - startTime
        guard let time  = self.time else {
            return  (0,0)
        }
        if  let pausedSavedTime = pausedSavedTime{
            return (time.seconds+pausedSavedTime.seconds,time.miliseconds)
        } else {
            return (time.seconds,time.miliseconds)
        }
        
    }
    
    func updateInformationOnUI(){
        self.timeTextDisplay  = self.niddle.timeTextDisplay
        self.percentage =  (  Double(self.niddle.seconds) + (Double(self.niddle.miliSeconds) * Double(0.01))  ) / Double(NeedleConstant.stopWatchProjectLimit)
        
    }
    
    //MARK: Stop Timer
    func stop(){
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        stopWatchState = .stoped
        timerCancellable = nil
        startTime = nil
        time = nil
        pausedSavedTime = nil
        niddle = StopWatchNiddle()
        self.updateInformationOnUI()
    }
}




//MARK: Local Notification
extension RingViewModel {
    //MARK: Notify User by Local Notification in background mode only
    func notifyUserThroughLocalNotificationInBackgroundMode(){
        let content = UNMutableNotificationContent()
        content.title = " One Minute Over"
        content.body = "Stop Watch finished one minute journey"
        content.sound = UNNotificationSound.default //you can play with it
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
}
