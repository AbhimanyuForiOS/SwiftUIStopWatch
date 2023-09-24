//
//  StopWatchApp.swift
//  StopWatch
//
//  Created by iOSCoderAbhimanyuDaspan on 20/05/23.
//

import SwiftUI

@main
struct StopWatchApp: App {
    var body: some Scene {
        WindowGroup {
            StopWatchView(viewModel: StopWatchViewModel(niddle: StopWatchNiddle()))
        }
    }
}
