//
//  StopWatchView.swift
//  StopWatch
//
//  Created by iOSCoderAbhimanyuDaspan on 20/05/23.
//

import SwiftUI
import UserNotifications

struct StopWatchView: View {
    @StateObject var viewModel:StopWatchViewModel
    var body: some View {
    
        VStack {
            RingView(viewModel: RingViewModel(niddle: viewModel.niddle))
        }
        .onAppear {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
               if success {
                   print("User Accepted")
               } else if let error = error {
                   print(error.localizedDescription)
              }
            }
        }
    }
}

struct StopWatchView_Previews: PreviewProvider {
    static var previews: some View {
        StopWatchView(viewModel: StopWatchViewModel.init(niddle: StopWatchNiddle()))
    }
}
