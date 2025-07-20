//
//  FormFieldViewModel.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 20/07/25.
//

import SwiftUI

// MARK: –– 1. Your protocol
protocol AnyFormFieldViewModel: Observable, Identifiable {
  var config: FieldConfig { get }
  var valueAsAny: Any { get }
  var error: String? { get }
  func validate()
}


@Observable
final class FormFieldViewModel<Value>: AnyFormFieldViewModel {
  let config: FieldConfig
  var value: Value
  var error: String? = nil

  init(config: FieldConfig) {
    self.config = config
    self.value = config.type.initialValue as! Value
  }

  func validate() {
      let service = ValidationService()
      let error = service.validate(field: config, value: value)
      self.error = error
  }

  var valueAsAny: Any { value }
  var id: String { config.id }
}
