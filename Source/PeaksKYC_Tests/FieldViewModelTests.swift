import Testing
import Foundation
@testable import PeaksKYC

@Suite("FieldViewModel")
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

    @Test("isReadOnly when value provided")
    func testIsReadOnly() {
        let config = makeConfig()
        let service = ValidationService()
        let vm = FieldViewModel<String>(config: config, preFilledValue: "A", validationService: service)
        #expect(vm.isReadOnly == true)
    }

    @Test("displayValue for string and nil")
    func testDisplayValueString() {
        let config = makeConfig()
        let service = ValidationService()
        let vm = FieldViewModel<String>(config: config, validationService: service)
        #expect(vm.displayValue == "N/A")
        vm.value = "John"
        #expect(vm.displayValue == "John")
    }

    @Test("displayValue for date components")
    func testDisplayValueDate() {
        let config = makeConfig(type: .date)
        let service = ValidationService()
        let comps = DateComponents(year: 2024, month: 7, day: 25)
        let vm = FieldViewModel<DateComponents>(config: config, preFilledValue: comps, validationService: service)
        let expected = DateFormatterHolder.medium.string(from: Calendar.current.date(from: comps)!)
        #expect(vm.displayValue == expected)
    }

    @Test("validate sets error")
    func testValidate() {
        let validation = FieldConfig.ValidationConfig(regex: "^[A-Z]+$", message: "Only capital letters", minLength: nil, maxLength: nil, minValue: nil, maxValue: nil)
        let config = FieldConfig(id: "id", label: "Label", required: true, type: .text, validation: validation)
        let service = ValidationService()
        let vm = FieldViewModel<String>(config: config, validationService: service)
        vm.value = "abc"
        vm.validate()
        #expect(vm.error == "Only capital letters")
        vm.value = "ABC"
        vm.validate()
        #expect(vm.error == nil)
    }
}
