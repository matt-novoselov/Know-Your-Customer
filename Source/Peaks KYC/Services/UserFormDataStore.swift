//
//  InMemoryFormDataStore.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 20/07/25.
//

protocol FormDataStore {
  /// Store a raw user‐entered value (String, Number, Date…)
  func setValue(_ value: Any, for fieldId: String)
  /// Retrieve whatever’s been stored so far
  func value(for fieldId: String) -> Any?
  /// Dump everything as a `[fieldId: value]` dictionary
  func allValues() -> [String: Any]
  /// Reset (e.g. after submission or cancel)
  func clear()
}


final class UserFormDataStore: FormDataStore {
  private var storage: [String: Any] = [:]

  func setValue(_ value: Any, for fieldId: String) {
    storage[fieldId] = value
  }

  func value(for fieldId: String) -> Any? {
    storage[fieldId]
  }

  func allValues() -> [String: Any] {
    storage
  }

  func clear() {
    storage.removeAll()
  }
}
