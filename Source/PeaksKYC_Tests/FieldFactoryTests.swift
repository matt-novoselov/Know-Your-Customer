//
//  FieldFactoryTests.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 23/07/25.
//

import Testing
@testable import PeaksKYC
import SwiftUI

@Suite("Field Factory")
struct FieldFactoryTests {
    // Covers logic that turns configs into field views.

    final class SpyBuilder: FieldBuilder {
        var capturedConfig: FieldConfig?
        var capturedValue: Any?
        func build(config: FieldConfig, prefilledValue: Any?, validationService: ValidationService) -> FormField {
            capturedConfig = config
            capturedValue = prefilledValue
            let viewModel = DummyFieldVM(config: config)
            return FormField(view: AnyView(EmptyView()), viewModel: viewModel)
        }
    }

    struct DummyFieldVM: FieldViewModelProtocol {
        var id = UUID()
        var config: FieldConfig
        var error: String?
        var hasErrors: Bool { error != nil }
        var isReadOnly: Bool = false
        var displayValue: String = ""
        func validate() {}
    }

    @Test("Uses Correct Builder and Passes Vales")
    func testMakeFields() {
        let config = FieldConfig(id: "id", label: "Label", required: false, type: .text, validation: nil)
        let factory = FieldFactory(validationService: ValidationService())
        let value = APIUserProfile.FieldEntries(id: "id", value: "abc")
        let fields = factory.makeFields(from: [config], prefilledValues: [value])
        #expect(fields.count == 1)
    }
}
