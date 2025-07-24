import Testing
@testable import PeaksKYC
import SwiftUI
import Foundation

@Suite("FormManagerViewModel")
struct FormManagerViewModelTests {
    private let profileYAML = """
    fields:
      - id: first_name
        value: Jan
      - id: last_name
        value: Jansen
      - id: birth_date
        value: "1990-07-23"
    """


    final class SpyBuilder: FieldBuilder {
        var called = false
        func build(config: FieldConfig, prefilledValue: Any?, validationService: ValidationService) -> FormField {
            called = true
            return FormField(view: AnyView(EmptyView()), viewModel: FieldViewModel<String>(config: config, validationService: validationService))
        }
    }

    @Test("state transitions to loaded")
    func testLoadSuccess() async throws {
        let yaml = """
country: NL
fields:
  - id: first_name
    label: First
    type: text
    required: false
"""
        let bundle = try makeTemporaryBundle(yamlFiles: [
            "NL.yaml": yaml,
            "MockUserProfile.yaml": profileYAML
        ])
        let loader = YAMLFileDecoder(bundle: bundle)
        let spy = SpyBuilder()
        let factory = FieldFactory(validationService: ValidationService(), builders: [.text: spy])
        let apiService = APIRequestService(loader: loader)
        let service = ConfigLoaderService(configurationLoader: loader, apiRequestService: apiService)
        let vm = FormViewModel(validationService: ValidationService(), formBuildingService: FormFactoryService(configLoader: service, fieldFactory: factory))
        await vm.loadDataForSelectedCountry()

        if case .loaded(let form) = vm.state {
            #expect(form.fields.count == 1)
            #expect(spy.called)
        } else {
            fatalError("not loaded")
        }
    }

    @Test("state becomes error on failure")
    func testLoadError() async throws {
        let bundle = try makeTemporaryBundle(yamlFiles: [
            "NL.yaml": "invalid:",
            "MockUserProfile.yaml": profileYAML
        ])
        let loader = YAMLFileDecoder(bundle: bundle)
        let factory = FieldFactory(validationService: ValidationService())
        let apiService = APIRequestService(loader: loader)
        let service = ConfigLoaderService(configurationLoader: loader, apiRequestService: apiService)
        let vm = FormViewModel(validationService: ValidationService(), formBuildingService: FormFactoryService(configLoader: service, fieldFactory: factory))
        await vm.loadDataForSelectedCountry()
        if case .error(let msg) = vm.state {
            #expect(msg.contains("Failed to load configuration"))
        } else {
            fatalError("state should be error")
        }
    }

    @Test("validateAll triggers field validation")
    func testValidateAll() async throws {
        let yaml = """
        country: NL
        fields:
          - id: first_name
            label: First
            type: text
            required: false
        """
        let bundle = try makeTemporaryBundle(yamlFiles: [
            "NL.yaml": yaml,
            "MockUserProfile.yaml": profileYAML
        ])
        let loader = YAMLFileDecoder(bundle: bundle)
        final class VM: FieldViewModelProtocol {
            var config: FieldConfig
            var error: String?
            var hasErrors: Bool { error != nil }
            var isReadOnly: Bool = false
            var displayValue: String = ""
            var validated = false
            init(config: FieldConfig) { self.config = config }
            func validate() { validated = true }
        }
        let customVM = VM(config: FieldConfig(id: "first_name", label: "", required: false, type: .text, validation: nil))
        struct Builder: FieldBuilder {
            var vm: VM
            func build(config: FieldConfig, prefilledValue: Any?, validationService: ValidationService) -> FormField {
                FormField(view: AnyView(EmptyView()), viewModel: vm)
            }
        }
        let builder = Builder(vm: customVM)
        let factory = FieldFactory(validationService: ValidationService(), builders: [.text: builder])
        let apiService = APIRequestService(loader: loader)
        let service = ConfigLoaderService(configurationLoader: loader, apiRequestService: apiService)
        let vmManager = FormViewModel(validationService: ValidationService(), formBuildingService: FormFactoryService(configLoader: service, fieldFactory: factory))
        await vmManager.loadDataForSelectedCountry()
        vmManager.validateAll()
        #expect(customVM.validated)
    }

    @Test("getSummaryItems and first error")
    func testSummaryAndFirstError() async throws {
        let yaml = """
        country: NL
        fields:
          - id: a
            label: L
            type: text
            required: false
          - id: b
            label: L2
            type: text
            required: false
        """
        let bundle = try makeTemporaryBundle(yamlFiles: [
            "NL.yaml": yaml,
            "MockUserProfile.yaml": profileYAML
        ])
        let loader = YAMLFileDecoder(bundle: bundle)
        final class VM: FieldViewModelProtocol {
            var config: FieldConfig
            var error: String?
            var hasErrors: Bool { error != nil }
            var isReadOnly: Bool = false
            var displayValue: String
            init(id: String, display: String, error: String?) {
                self.config = FieldConfig(id: id, label: id, required: false, type: .text, validation: nil)
                self.displayValue = display
                self.error = error
            }
            func validate() {}
        }
        let vm1 = VM(id: "a", display: "1", error: nil)
        let vm2 = VM(id: "b", display: "2", error: "e")
        struct B1: FieldBuilder {
            let vm: VM
            func build(config: FieldConfig, prefilledValue: Any?, validationService: ValidationService) -> FormField {
                FormField(view: AnyView(EmptyView()), viewModel: vm)
            }
        }
        let factory = FieldFactory(validationService: ValidationService(), builders: [.text: B1(vm: vm1)])
        let factory2 = FieldFactory(validationService: ValidationService(), builders: [.text: B1(vm: vm2)])
        // We'll run manually, building 2 fields sequentially
        let apiService = APIRequestService(loader: loader)
        let service = ConfigLoaderService(configurationLoader: loader, apiRequestService: apiService)
        var vm = FormViewModel(validationService: ValidationService(), formBuildingService: FormFactoryService(configLoader: service, fieldFactory: factory))
        await vm.loadDataForSelectedCountry()
        // After first call, state loaded with first field
        if case .loaded(let form) = vm.state {
            #expect(form.fields.count == 2)
        }
        // Now we use second factory to load again with two fields
        vm = FormViewModel(validationService: ValidationService(), formBuildingService: FormFactoryService(configLoader: service, fieldFactory: factory2))
        await vm.loadDataForSelectedCountry()
        if case .loaded(let fields) = vm.state {
            let items = vm.getSummaryItems()
            #expect(items.count == fields.fields.count)
        }
        let index = vm.getFirstErrorIndex()
        #expect(index == 0)
    }
}
