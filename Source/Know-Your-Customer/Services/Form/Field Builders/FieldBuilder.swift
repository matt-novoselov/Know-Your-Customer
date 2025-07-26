//
//  FieldBuilder.swift
//  Know Your Customer
//
//  Created by Matt Novoselov on 21/07/25.
//

import SwiftUI

// Factory interface used to create concrete form fields.
protocol FieldBuilder {
    func build(
        config: FieldConfig,
        prefilledValue: Any?,
        validationService: ValidationService
    ) -> FormField
}
