import Testing
@testable import Peaks_KYC

@Suite("Validators")
struct ValidatorsTests {
    @Test("LengthValidator")
    func testLength() {
        let v = LengthValidator(minLength: 2, maxLength: 4)
        #expect(try? v.validate(value: "aa") == nil)
        #expect(try? v.validate(value: "a") == nil ? false : true)
        #expect(try? v.validate(value: "aaaaa") == nil ? false : true)
    }

    @Test("RegexValidator")
    func testRegex() {
        let v = RegexValidator(pattern: "^[0-9]+$", errorMessage: "num")
        #expect((try? v.validate(value: "123")) == nil)
        #expect({ do { try v.validate(value: "abc"); return false } catch { return true } }())
    }

    @Test("RequiredFieldValidator")
    func testRequired() {
        let v = RequiredFieldValidator()
        #expect({ do { try v.validate(value: "") ; return false } catch { return true } }())
        #expect(try? v.validate(value: "a") == nil)
    }

    @Test("ValueRangeValidator")
    func testRange() {
        let v = ValueRangeValidator(minValue: 1, maxValue: 3)
        #expect(try? v.validate(value: "2") == nil)
        #expect({ do { try v.validate(value: "0"); return false } catch { return true } }())
        #expect({ do { try v.validate(value: "5"); return false } catch { return true } }())
    }
}
