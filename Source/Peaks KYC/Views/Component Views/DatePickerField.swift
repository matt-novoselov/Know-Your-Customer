//
//  DatePickerField.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//

import SwiftUI
import Yams

struct CountryPickerField: View {
    @Binding var selectedCountry: Country
    @State private var isPresented = false
    
    var body: some View {
        Button {
            isPresented = true
        } label: {
            HStack {
                selectedCountry.data.flag
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32)
                    .cornerRadius(3)
                
                Text(selectedCountry.data.name)
                
                Spacer()
                
                Image(systemName: "chevron.down")
                    .rotationEffect(.degrees(isPresented ? 180 : 0))
                    .animation(.spring(duration: 0.3), value: isPresented)
            }
        }
        .dynamicStroke(isFocused: isPresented)
        .dynamicSizedSheet(isPresented: $isPresented) {
            VStack(spacing: 20) {
                Text("Select region")
                    .font(.dazzed(style: .title1, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                ForEach(Country.allCases, id: \.self) { country in
                    Button(action: {
                        selectedCountry = country
                        isPresented = false
                    }) {
                        HStack {
                            country.data.flag
                                .resizable()
                                .scaledToFit()
                                .frame(width: 32)
                                .cornerRadius(3)
                            
                            Text(country.data.name)
                            
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .dynamicStroke(isFocused: selectedCountry == country, style: .roundedRect)
                    }
                }
            }
            .padding()
            .padding(.top)
        }
        
    }
}

struct CountrySelectionView: View {
    @State private var path = NavigationPath()
    @State private var selectedCountry: Country = .netherlands
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                CountryPickerField(selectedCountry: $selectedCountry)
                
                Spacer()
                
                Button("Continue") {
                    path.append(Route.status)
                }
                .buttonStyle(.capsule)
            }
            
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .status:
                    StatusScreenView(path: $path, selectedCountry: selectedCountry)
                case .fields:
                    FieldFormView(configs: [], path: $path)
                }
            }
            
            .withHeader("Choose your country")
            
            .padding()
        }
    }
}

enum Route: Hashable { case status, fields }

struct StatusScreenView: View {
    @Binding var path: NavigationPath
    let selectedCountry: Country
    @State var config: ConfigModel?
    
    var body: some View {
        if let config {
            VStack {
                FieldCompletionStateView(isComplete: true, text: "Select your country")
                
                ForEach(config.fields, id: \.id) { field in
                    FieldCompletionStateView(isComplete: false, text: "Fill in \(field.label)")
                }
                
                Spacer()
                
                Button("Continue to the next step") { path.append(Route.fields) }
                    .buttonStyle(.capsule)
            }
            .withHeader("This only takes a few steps")
            .padding()
        } else {
            ProgressView()
                .task {
                    config = try? loadKYCConfig(for: selectedCountry.data.yamlFileName)
                }
        }
    }
}

func loadKYCConfig(for fileName: String) throws -> ConfigModel {
    guard let url = Bundle.main.url(forResource: fileName, withExtension: nil) else {
        throw NSError(domain: "YAML", code: 1, userInfo: [NSLocalizedDescriptionKey: "\(fileName) not found"])
    }
    let yamlString = try String(contentsOf: url, encoding: .utf8)
    let decoder = YAMLDecoder()
    return try decoder.decode(ConfigModel.self, from: yamlString)
}

struct DatePickerField: InputFieldRepresentable {
    var fieldConfig: FieldConfig
    
    @State private var date: Date?
    @State private var isPresented = false
    
    private var dateFormatter: DateFormatter {
        let fmt = DateFormatter()
        fmt.dateStyle = .medium
        return fmt
    }
    
    func inputFieldView() -> some View {
        
        Button {
            isPresented = true
        } label: {
            HStack {
                Text(date.map { dateFormatter.string(from: $0) } ?? "Select your \(fieldConfig.label)")
                    .foregroundColor(date == nil ? .secondary : .primary)
                Spacer()
                Image(systemName: "calendar")
            }
        }
        .dynamicStroke(isFocused: isPresented)
        .dynamicSizedSheet(isPresented: $isPresented) {
            DatePickerSheet(fieldLabel: fieldConfig.label, selectedDate: $date)
        }
        
    }
}

struct DatePickerSheet: View {
    let fieldLabel: String
    @Binding var selectedDate: Date?
    @Environment(\ .dismiss) private var dismiss
    @State private var tempDate: Date = Date()
    
    var body: some View {
        
        VStack {
            ZStack {
                Text(fieldLabel)
                    .font(.dazzed(style: .title1, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Button("Done") {
                    selectedDate = tempDate
                    dismiss()
                }
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            
            DatePicker(
                "Select your \(fieldLabel)",
                selection: $tempDate,
                displayedComponents: [.date]
            )
            .datePickerStyle(.graphical)
        }
        .padding()
        .padding(.top)
        .onAppear {
            tempDate = selectedDate ?? Date()
        }
        
    }
}

struct DynamicSizedSheet<SheetContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    @State private var contentHeight: CGFloat = 400
    let sheetContent: () -> SheetContent
    
    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $isPresented) {
                sheetContent()
                    .onGeometryChange(for: CGSize.self) { geometry in
                        return geometry.size
                    } action: { newValue in
                        contentHeight = newValue.height
                    }
                    .presentationDetents([.height(contentHeight)])
                    .presentationDragIndicator(.visible)
            }
    }
}

extension View {
    func dynamicSizedSheet<Content: View>(
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        modifier(DynamicSizedSheet(isPresented: isPresented, sheetContent: content))
    }
}

struct HeaderModifier: ViewModifier {
    let title: String
    @Environment(\.dismiss) private var dismiss
    
    func body(content: Content) -> some View {
        VStack {
            VStack(alignment: .leading, spacing: 15) {
                Button("Back", systemImage: "chevron.left") {
                    dismiss()
                }
                .labelStyle(.iconOnly)
                .fontWeight(.semibold)
                .imageScale(.large)
                
                Text(title)
                    .font(.dazzed(style: .largeTitle, weight: .heavy))
                    .multilineTextAlignment(.leading)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            content
                .padding(.top)
        }
        .padding(.top)
        .navigationBarBackButtonHidden()
    }
}

extension View {
    func withHeader(_ title: String) -> some View {
        modifier(HeaderModifier(title: title))
    }
}
