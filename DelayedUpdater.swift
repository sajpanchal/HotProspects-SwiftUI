//
//  DelayedUpdater.swift
//  HotProspects
//
//  Created by saj panchal on 2021-08-23.
//

import Foundation

class DelayedUpdater: ObservableObject {
    var value = 0 {
        willSet {
            objectWillChange.send()
        }
    }
    init() {
        for i in 1...10 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i)) {
                self.value += 1
            }
        }
    }
}
