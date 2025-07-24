import Testing
@testable import Peaks_KYC

@Suite("Validators")
struct ValidatorsTests {
    @Test("LengthValidator")
    func testLength() {
        let v = LengthValidator(minLength: 2, maxLength: 4)
        #expect(throws: Never.self) {
          try v.validate(value: "aa")
        }

        #expect(throws: ValidationError.self) {
            try v.validate(value: "a")
        }

        #expect(throws: ValidationError.self) {
          try v.validate(value: "aaaaa")
        }
    }

    @Test("RegexValidator")
    func testRegex() {
        let v = RegexValidator(pattern: "^[0-9]+$", errorMessage: "num")

        #expect(throws: Never.self) {
            try v.validate(value: "123")
        }

        #expect(throws: ValidationError.self) {
            try v.validate(value: "abc")
        }
    }

    @Test("RequiredFieldValidator")
    func testRequired() {
        let v = RequiredFieldValidator()

        #expect(throws: ValidationError.self) {
            try v.validate(value: "")
        }

        #expect(throws: Never.self) {
            try v.validate(value: "a")
        }
    }

    @Test("ValueRangeValidator")
    func testRange() {
        let v = ValueRangeValidator(minValue: 1, maxValue: 3)

        #expect(throws: Never.self) {
            try v.validate(value: "2")
        }

        #expect(throws: ValidationError.self) {
            try v.validate(value: "0")
        }

        #expect(throws: ValidationError.self) {
            try v.validate(value: "5")
        }
    }
}
