//
//  DateFieldBuilder.swift
//  Know Your Customer
//
//  Created by Matt Novoselov on 21/07/25.
//

import SwiftUI

// Builds a date input field.
struct DateFieldBuilder: FieldBuilder {
    private static let isoFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate]
        return formatter
    }()

    func build(
        config: FieldConfig,
        prefilledValue: Any?,
        validationService: ValidationService
    ) -> FormField {
        let date = (prefilledValue as? String)
            .flatMap { Self.isoFormatter.date(from: $0) }
            .map { $0.yearMonthDay }
        let viewModel = FieldViewModel<Date>(
            config: config,
            preFilledValue: date,
            validationService: validationService
        )
        let view = DateInputField().environment(viewModel)
        return FormField(view: AnyView(view), viewModel: viewModel)
    }
}
