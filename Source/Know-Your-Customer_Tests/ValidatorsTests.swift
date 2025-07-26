//
//  ValidatorsTests.swift
//  Know Your Customer
//
//  Created by Matt Novoselov on 23/07/25.
//

import Testing
@testable import Know_Your_Customer

@Suite("Validators")
struct ValidatorsTests {
    // Unit tests for individual validator implementations.
    @Test("Length Validator")
    func testLength() {
        let validator = LengthValidator(minLength: 2, maxLength: 4)
        #expect(throws: Never.self) {
          try validator.validate(value: "aa")
        }

        #expect(throws: ValidationError.self) {
            try validator.validate(value: "a")
        }

        #expect(throws: ValidationError.self) {
          try validator.validate(value: "aaaaa")
        }
    }

    @Test("Regex Validator")
    func testRegex() {
        let validator = RegexValidator(pattern: "^[0-9]+$", errorMessage: "num")

        #expect(throws: Never.self) {
            try validator.validate(value: "123")
        }

        #expect(throws: ValidationError.self) {
            try validator.validate(value: "abc")
        }
    }

    @Test("Required Field Validator")
    func testRequired() {
        let validator = RequiredFieldValidator()

        #expect(throws: ValidationError.self) {
            try validator.validate(value: "")
        }

        #expect(throws: Never.self) {
            try validator.validate(value: "a")
        }
    }

    @Test("Value Range Validator")
    func testRange() {
        let validator = ValueRangeValidator(minValue: 1, maxValue: 3)

        #expect(throws: Never.self) {
            try validator.validate(value: "2")
        }

        #expect(throws: ValidationError.self) {
            try validator.validate(value: "0")
        }

        #expect(throws: ValidationError.self) {
            try validator.validate(value: "5")
        }
    }
}
