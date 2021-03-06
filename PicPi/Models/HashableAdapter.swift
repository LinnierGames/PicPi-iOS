//
//  HashableAdapter.swift
//  PicPi
//
//  Created by Erick Sanchez on 12/24/20.
//

import Foundation

/// Wrap a non hashable type and hash via the given id.
struct HashableAdapter<NonHashable> {
  let id: String
  let value: NonHashable
}

extension HashableAdapter: Hashable {
  static func == (lhs: HashableAdapter<NonHashable>, rhs: HashableAdapter<NonHashable>) -> Bool {
    lhs.id == rhs.id
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}
