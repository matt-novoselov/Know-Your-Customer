import Testing
@testable import PeaksKYC
import SwiftUI

@Suite("FieldFactory")
struct FieldFactoryTests {

    final class SpyBuilder: FieldBuilder {
        var capturedConfig: FieldConfig?
        var capturedValue: Any?
        func build(config: FieldConfig, prefilledValue: Any?, validationService: ValidationService) -> FormField {
            capturedConfig = config
            capturedValue = prefilledValue
            let vm = DummyFieldVM(config: config)
            return FormField(view: AnyView(EmptyView()), viewModel: vm)
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

    @Test("uses correct builder and passes value")
    func testMakeFields() {
        let config = FieldConfig(id: "id", label: "Label", required: false, type: .text, validation: nil)
        let builder = SpyBuilder()
        let factory = FieldFactory(validationService: ValidationService(), builders: [.text: builder])
        let value = APIUserProfile.FieldEntries(id: "id", value: "abc")
        let fields = factory.makeFields(from: [config], prefilledValues: [value])
        #expect(fields.count == 1)
        #expect(builder.capturedConfig?.id == "id")
        #expect(builder.capturedValue as? String == "abc")
    }
}
