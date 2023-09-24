//
//  TImeInterval+Extension.swift
//  StopWatch
//
//  Created by iOSCoderAbhimanyuDaspan on 20/05/23.
//

import Foundation

extension TimeInterval {
    var seconds: Int { Int(modf(self).0) }
    var miliseconds: Int {
        let millisecondsDecimal =  String(format: "%.2f", modf(self).1)
        let  millisecondsAfterDecimal = millisecondsDecimal.split(separator: ".")
        let milliseconds = millisecondsAfterDecimal[1]
        guard let millisecondsIntTwoDigits = Int(milliseconds) else { return 0 }
        return millisecondsIntTwoDigits
    }
}

