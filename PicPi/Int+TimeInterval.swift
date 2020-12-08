//
//  Int+TimeInterval.swift
//  PicPi
//
//  Created by Erick Sanchez on 12/7/20.
//

import Foundation

extension Int {
  var mintues: TimeInterval {
    return TimeInterval(self * 60)
  }
}
