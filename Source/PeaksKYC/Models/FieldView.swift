import SwiftUI

/// Lightweight type-erased wrapper around a SwiftUI view
struct FieldView: View {
    private let content: AnyView

    init<V: View>(_ view: V) {
        self.content = AnyView(view)
    }

    var body: some View {
        content
    }
}
