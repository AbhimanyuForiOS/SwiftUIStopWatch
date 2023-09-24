//
//  BGTimeManager.swift
//  StopWatch
//
//  Created by iOSCoderAbhimanyuDaspan on 20/05/23.
//

import Foundation

//When application will go in background we should not relay on static counters or timer values, for perfect result we can calculate user's background time.
class BGTimeManager {
    var appReachedInBackgroundAt: Double?
    var appCameAliveAt: Double?
}
