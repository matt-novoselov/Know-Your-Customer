import Foundation

/// Represents a value entered in any of the supported input fields.
/// Only text and date values are currently used.
enum FieldValue {
    case empty
    case text(String)
    case date(DateComponents)
}

extension FieldValue: CustomStringConvertible {
    private static let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .medium
        return f
    }()

    var description: String {
        switch self {
        case .empty:
            return ""
        case .text(let string):
            return string
        case .date(let components):
            if let date = Calendar.current.date(from: components) {
                return Self.dateFormatter.string(from: date)
            } else {
                return ""
            }
        }
    }
}
