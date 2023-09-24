//
//  StopWatchViewModel.swift
//  StopWatch
//
//  Created by iOSCoderAbhimanyuDaspan on 20/05/23.
//

import Foundation
import Combine

@MainActor class StopWatchViewModel:ObservableObject {
    @Published var niddle:StopWatchNiddle
    
    init(niddle: StopWatchNiddle) {
        self.niddle = niddle
    }
    
}

