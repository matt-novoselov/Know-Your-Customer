//
//  FieldViewModelTests.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 23/07/25.
//

import Testing
import Foundation
@testable import PeaksKYC

@Suite("Field View Model")
struct FieldViewModelTests {
    // Unit tests for the FieldViewModel behaviour.

    private func makeConfig(required: Bool = false, type: FieldConfig.FieldDataType = .text) -> FieldConfig {
        FieldConfig(
            id: "id",
            label: "Label",
            required: required,
            type: type,
            validation: nil
        )
    }

    @Test("Is ReadOnly When Value Provided")
    func testIsReadOnly() {
        let config = makeConfig()
        let service = ValidationService()
        let viewModel = FieldViewModel<String>(config: config, preFilledValue: "A", validationService: service)
        #expect(viewModel.isReadOnly == true)
    }

    @Test("Display Value For String And Nil")
    func testDisplayValueString() {
        let config = makeConfig()
        let service = ValidationService()
        let viewModel = FieldViewModel<String>(config: config, validationService: service)
        #expect(viewModel.displayValue == "N/A")
        viewModel.value = "John"
        #expect(viewModel.displayValue == "John")
    }

    @Test("Display Value For Date Components")
    func testDisplayValueDate() {
        let config = makeConfig(type: .date)
        let service = ValidationService()
        let comps = DateComponents(year: 2024, month: 7, day: 25)
        let viewModel = FieldViewModel<DateComponents>(
            config: config,
            preFilledValue: comps,
            validationService: service
        )
        let expected = DateFormatterHolder.medium.string(from: Calendar.current.date(from: comps)!)
        #expect(viewModel.displayValue == expected)
    }

    @Test("Validate Sets Error")
    func testValidate() {
        let validation = FieldConfig.ValidationConfig(
            regex: "^[A-Z]+$",
            message: "Only capital letters",
            minLength: nil,
            maxLength: nil,
            minValue: nil,
            maxValue: nil
        )
        let config = FieldConfig(id: "id", label: "Label", required: true, type: .text, validation: validation)
        let service = ValidationService()
        let viewModel = FieldViewModel<String>(config: config, validationService: service)
        viewModel.value = "abc"
        viewModel.validate()
        #expect(viewModel.error == "Only capital letters")
        viewModel.value = "ABC"
        viewModel.validate()
        #expect(viewModel.error == nil)
    }
}
