//
//  ValidationServiceTests.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 23/07/25.
//

import Testing
@testable import PeaksKYC

@Suite("ValidationService")
struct ValidationServiceTests {
    // Tests the field validation helper methods.

    private func config(required: Bool = true, validation: FieldConfig.ValidationConfig? = nil, type: FieldConfig.FieldDataType = .text) -> FieldConfig {
        FieldConfig(id: "id", label: "Label", required: required, type: type, validation: validation)
    }

    @Test("required string fails on empty")
    func testRequiredEmpty() {
        let service = ValidationService()
        let cfg = config()
        let msg = service.validate(fieldConfig: cfg, value: "")
        #expect(msg == "This field is required.")
    }

    @Test("regex validation fails")
    func testRegexFail() {
        let val = FieldConfig.ValidationConfig(regex: "^[A-Z]+$", message: "caps", minLength: nil, maxLength: nil, minValue: nil, maxValue: nil)
        let cfg = config(validation: val)
        let service = ValidationService()
        let msg = service.validate(fieldConfig: cfg, value: "abc")
        #expect(msg == "caps")
    }

    @Test("number range validation")
    func testRangeFail() {
        let val = FieldConfig.ValidationConfig(regex: nil, message: nil, minLength: nil, maxLength: nil, minValue: 1, maxValue: 3)
        let cfg = config(validation: val, type: .number)
        let service = ValidationService()
        let msg1 = service.validate(fieldConfig: cfg, value: "0")
        #expect(msg1 == "Value must be at least 1.")
        let msg2 = service.validate(fieldConfig: cfg, value: "4")
        #expect(msg2 == "Value cannot be more than 3.")
        let msg3 = service.validate(fieldConfig: cfg, value: "2")
        #expect(msg3 == nil)
    }
}
