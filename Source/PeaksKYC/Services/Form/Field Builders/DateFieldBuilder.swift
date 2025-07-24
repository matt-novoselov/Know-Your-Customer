import SwiftUI

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
        let components = (prefilledValue as? String)
            .flatMap { Self.isoFormatter.date(from: $0) }
            .map { $0.yearMonthDay }
        let viewModel = FieldViewModel<DateComponents>(
            config: config,
            preFilledValue: components,
            validationService: validationService
        )
        let view = DateInputField().environment(viewModel)
        return FormField(view: FieldView(view), viewModel: viewModel)
    }
}
