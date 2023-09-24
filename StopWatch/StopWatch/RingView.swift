//
//  RingView.swift
//  StopWatch
//
//  Created by iOSCoderAbhimanyuDaspan on 20/05/23.
//

import SwiftUI

struct RingView: View {
    @StateObject var viewModel:RingViewModel
    
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        //Top Progress View (Circle)
        ZStack {
            Circle()
                .stroke(lineWidth: 35)
                .opacity(0.5)
                .foregroundColor(Color(uiColor: UIColor(red: CGFloat(Int.random(in: 0...255))/255.0,
                                                        green:CGFloat(Int.random(in: 0...255))/255.0,
                                                        blue:  CGFloat(Int.random(in: 0...255))/255.0,
                                                        alpha: 1.0)))
            
            Circle()
                .trim(from: 0.0, to: CGFloat(viewModel.percentage))
                .stroke(style: StrokeStyle(lineWidth: 35, lineCap: .round, lineJoin: .round))
                .foregroundColor(.red)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.easeOut, value: CGFloat(viewModel.percentage))
                

            
            Text("\(viewModel.timeTextDisplay)")
                .foregroundColor((viewModel.stopWatchState == .playing) ?  Color.green: Color.red)
                .font(.system(size: 34).weight(.heavy))

        }
        .frame(width: UIScreen.main.bounds.size.width*0.80,
               height: UIScreen.main.bounds.size.width*0.80)
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 30, trailing: 0))
        
        
        //Actions (Play/Pause  & Stop if exist)
        VStack(spacing: 10) {
            //Play/Pause
            Button {
                viewModel.playOrPaused()
            } label: {
                HStack(spacing: 15) {
                    Image(systemName: (viewModel.stopWatchState == .playing) ? "pause.fill"   : "play.fill"    ).foregroundColor(.white)
                    Text( (viewModel.stopWatchState == .playing) ?   "Pause": "Play").foregroundColor(.white)
                }
                .padding(.vertical)
                .frame(width: (UIScreen.main.bounds.size.width/2)-55)
                .background((viewModel.stopWatchState == .playing) ?  Color.yellow: Color.green  )
                .clipShape(Capsule())
            }
            
            //Stop(Show only after start)
            Button {
                viewModel.stop()
            } label: {
                HStack(spacing: 15) {
                    Image(systemName: "stop.fill").foregroundColor(.white)
                    Text("Stop").foregroundColor(.white)
                }
                .padding(.vertical)
                .frame(width: (UIScreen.main.bounds.size.width/2)-55)
                .background(.red)
                .clipShape(Capsule())
            }.opacity(viewModel.percentage > 0.0 ? 1.0 : 0.0 )
        }.onChange(of: scenePhase) { newPhase in
            if newPhase == .inactive {
                print("Inactive")
            } else if newPhase == .active {
                print("Active")
                viewModel.bgTimeManager.appCameAliveAt = Date().timeIntervalSince1970
                if viewModel.bgTimeManager.appReachedInBackgroundAt != nil {
                    viewModel.syncBackgroundTime()
                }
            } else if newPhase == .background {
                print("Background")
                viewModel.bgTimeManager.appReachedInBackgroundAt = Date().timeIntervalSince1970
            }
        }
    }
}

struct RingView_Previews: PreviewProvider {
    static var previews: some View {
        RingView(viewModel: RingViewModel(niddle: StopWatchNiddle()))
    }
}
