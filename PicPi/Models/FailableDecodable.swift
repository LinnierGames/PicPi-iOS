//
//  FailableDecodable.swift
//  PicPi
//
//  Created by Erick Sanchez on 12/29/20.
//

import Foundation

struct FailableDecodable<Base: Decodable>: Decodable {

  let base: Base?

  init(from decoder: Decoder) throws {
    self.base = try? Base(from: decoder)
  }
}
