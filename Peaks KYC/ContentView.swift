//
//  ContentView.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 18/07/25.
//

import SwiftUI
import Yams

enum ButtonVariant {
    case normal, accent
    
    var background: Color {
        switch self {
        case .normal: return .black
        case .accent: return .brand
        }
    }
    
    var foreground: Color {
        switch self {
        case .normal: return .white
        case .accent: return .black
        }
    }
}

struct BlueButton: ButtonStyle {
    private let variant: ButtonVariant
    @Environment(\.isEnabled) private var isEnabled
    
    init(_ variant: ButtonVariant = .normal) {
        self.variant = variant
    }
    
    func makeBody(configuration: Configuration) -> some View {
        let bg = isEnabled ? variant.background : .gray.mix(with: .white, by: 0.9)
        let fg = isEnabled ? variant.foreground : .gray.mix(with: .white, by: 0.4)
        
        return configuration.label
            .frame(maxWidth: .infinity)
            .font(.body)
            .fontWeight(.semibold)
            .padding(20)
            .background(bg)
            .foregroundColor(fg)
            .clipShape(.capsule)
            .scaleEffect(configuration.isPressed && isEnabled ? 0.95 : 1)
            .animation(.spring(), value: configuration.isPressed)
    }
}

// Structure creating a custom textFieldStyle
struct WhiteBorder: TextFieldStyle {
    @FocusState private var isFocused: Bool
    @Binding var text: String
    var isValid: Bool
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        let empty = text.isEmpty
        let fg: Color = {
            if !isValid {
                return .red
            } else {
                return isFocused || !empty ? .black : .secondary
            }
        }()
        
        let strokeSize: Double = {
            if !isValid || isFocused {
                return 2.0
            } else {
                return 0.5
            }
        }()
        
        configuration
            .overlay(alignment: .trailing) {
                if !empty && isFocused {
                    Button { text = "" } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(.black)
                            .fontWeight(.medium)
                    }
                }
            }
            .padding()
            .focused($isFocused)
            .overlay(
                Capsule()
                    .stroke(fg, lineWidth: strokeSize)
            )
            .animation(.spring(duration: 0.4), value: isFocused)
            .animation(.spring(duration: 0.4), value: isValid)
    }
}


struct ContentView: View {
    @State private var isDisabled: Bool = true
    @State private var isValid: Bool = false
    @State private var textFieldText: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            


            
            let prompt: String = "Surname"
            let isOptional: Bool = true
            
            VStack(alignment: .leading) {
                Text("\(prompt)\(isOptional ? " (optional)" : "")")
                    .font(.headline)
                
                TextField(
                    "Title Ket",
                    text: $textFieldText,
                    prompt: Text("Enter \(prompt.lowercased())")
                )
                .keyboardType(.default)
                .textFieldStyle(WhiteBorder(text: $textFieldText, isValid: isValid))
                
                Label("Please enter a valid", systemImage: "exclamationmark.circle.fill")
                    .foregroundStyle(.red)
                    .imageScale(.small)
                    .opacity(isValid ? 0 : 1)
                    .animation(.spring(duration: 0.2), value: isValid)
                
            }
            
            Toggle(isOn: $isDisabled){
                Text("Button disabled")
            }.task {
                await loadNLProfile()
            }
            
            Toggle(isOn: $isValid){
                Text("Is valid TF")
            }
            
            let isComplete: Bool = true
            HStack {
                if isComplete {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                }
                
                Text("Registration complete")
                    .foregroundStyle(isComplete ? .black : .secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(20)
            .overlay(
                RoundedRectangle(cornerRadius: 23)
                    .stroke(.gray, lineWidth: 0.5)
            )
            
            Button("Normal Button") { }
                .buttonStyle(BlueButton())
            
            Button("Normal Button Disabled") { }
                .buttonStyle(BlueButton())
                .disabled(isDisabled)
            
            Button("Accent Button") { }
                .buttonStyle(BlueButton(.accent))
            
            Button("Accent Button Disabled") {
                do {
                    let config = try loadKYCConfig()
                    print(dump(config))
                } catch {
                    print("Failed to load KYC config:", error)
                }
            }
            .buttonStyle(BlueButton(.accent))
            .disabled(isDisabled)
        }
        .padding(.horizontal)
    }
    
    func loadKYCConfig() throws -> KYCConfig {
        guard let url = Bundle.main.url(forResource: "NL", withExtension: "yaml") else {
            throw NSError(domain: "YAML", code: 1, userInfo: [NSLocalizedDescriptionKey: "NL.yaml not found"])
        }
        let yamlString = try String(contentsOf: url, encoding: .utf8)
        let decoder = YAMLDecoder()
        return try decoder.decode(KYCConfig.self, from: yamlString)
    }
    
}


#Preview {
    ContentView()
}


struct KYCConfig: Decodable {
    let country: String
    let fields: [FieldConfig]
}

struct FieldConfig: Decodable {
    let id: String
    let label: String
    let required: Bool
    let type: FieldType
    let validation: ValidationConfig?
}

enum FieldType: String, Decodable {
    case text, number, date
}

struct ValidationConfig: Decodable {
    let regex: String?
    let message: String?
    let minLength, maxLength: Int?
    let minValue, maxValue: Double?
}


protocol FieldView: View {
    var fieldConfig: FieldConfig { get set }
    func onSubmit()
}

//////////////////
import SwiftUI

struct CountryData {
    let name: String
    let flag: Image
    let yamlFileName: String
}

enum Country {
    case netherlands
    case germany
    case usa
    
    var data: CountryData {
        switch self {
        case .netherlands:
            return CountryData(
                name: "The Netherlands",
                flag: Image(.netherlandsFlag),
                yamlFileName: "NL.yaml"
            )
        case .germany:
            return CountryData(
                name: "Germany",
                flag: Image(.germanyFlag),
                yamlFileName: "DE.yaml"
            )
        case .usa:
            return CountryData(
                name: "United States of America",
                flag: Image(.usaFlag),
                yamlFileName: "US.yaml"
            )
        }
    }
}

extension UIApplication {
    // Fetch the App Icon from the asset catalog
    var appIcon: UIImage? {
        guard let icons = Bundle.main.infoDictionary?["CFBundleIcons"] as? [String: Any],
              let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any],
              let iconFiles = primaryIcon["CFBundleIconFiles"] as? [String],
              let iconName = iconFiles.first else {
                  return nil
              }
        return UIImage(named: iconName)
    }
}

struct AppIconView: View {
    @State private var size: CGSize = .zero
    
    var body: some View {
        if let appIcon = UIApplication.shared.appIcon {
            Image(uiImage: appIcon)
                .resizable()
                .scaledToFit()
                .clipShape(.rect(cornerRadius: size.width / 9 * 2))
                .onGeometryChange(for: CGSize.self) { geometry in
                                return geometry.size
                            } action: { newValue in
                                size = newValue
                            }

        } else {
            ProgressView()
        }
    }
}

struct HomeView: View {
    var body: some View {
        VStack(spacing: 10) {
            Spacer().frame(height: 50)
            
            VStack {
                HStack {
                    AppIconView()
                        .frame(height: 44)
                    
                    Text("KYCa")
                        .font(.dazzed(size: 24, weight: .bold, width: 0))
                        .fontWeight(.black)
                }
                
                Text("Simple investing for everyone")
                    .font(.dazzed(size: 20, weight: .semibold, width: 0))
                    .fontWeight(.bold)
            }
            
            Spacer()
            
            Button("I am new to KYC") { }
                .buttonStyle(BlueButton(.accent))
            
            Button("I already have an account") { }
                .buttonStyle(BlueButton())
                .disabled(true)
        }
        .padding()
        .background(){
            AnimatedColorsMeshGradientView()
                .opacity(0.5)
        }
    }
}

struct AnimatedColorsMeshGradientView: View {
  private let colors: [Color] = [
    .brand, .white, .brand,
    .white, .brand, .white,
    .white, .white, .white,
  ]

  private let points: [SIMD2<Float>] = [
    SIMD2<Float>(0.0, 0.0), SIMD2<Float>(0.5, 0.0), SIMD2<Float>(1.0, 0.0),
    SIMD2<Float>(0.0, 0.5), SIMD2<Float>(0.5, 0.5), SIMD2<Float>(1.0, 0.5),
    SIMD2<Float>(0.0, 1.0), SIMD2<Float>(0.5, 1.0), SIMD2<Float>(1.0, 1.0)
  ]
}

extension AnimatedColorsMeshGradientView {
  var body: some View {
    TimelineView(.animation) { timeline in
      MeshGradient(
        width: 3,
        height: 3,
        locations: .points(points),
        colors: .colors(animatedColors(for: timeline.date)),
        background: .black,
        smoothsColors: true
      )
    }
    .ignoresSafeArea()
  }
}

extension AnimatedColorsMeshGradientView {
  private func animatedColors(for date: Date) -> [Color] {
    let phase = CGFloat(date.timeIntervalSince1970)

    return colors.enumerated().map { index, color in
      let hueShift = cos(phase + Double(index) * 0.3) * 0.1
      return shiftHue(of: color, by: hueShift)
    }
  }

  private func shiftHue(of color: Color, by amount: Double) -> Color {
    var hue: CGFloat = 0
    var saturation: CGFloat = 0
    var brightness: CGFloat = 0
    var alpha: CGFloat = 0

    UIColor(color).getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)

    hue += CGFloat(amount)
    hue = hue.truncatingRemainder(dividingBy: 1.0)

    if hue < 0 {
      hue += 1
    }

    return Color(hue: Double(hue), saturation: Double(saturation), brightness: Double(brightness), opacity: Double(alpha))
  }
}

#Preview {
    HomeView()
}

import SwiftUI

extension Font {
    /// Custom “Dazzed” font from bundle
    /// - Parameters:
    ///   - size: point size
    ///   - weight: font weight (uses UIFont.Weight)
    ///   - width: font width trait (0 = normal, negative = condensed, positive = expanded)
    static func dazzed(
        size: CGFloat,
        weight: UIFont.Weight = .regular,
        width: CGFloat = 0
    ) -> Font {
        let traits: [UIFontDescriptor.TraitKey: Any] = [
            .weight: weight,
            .width: width
        ]
        let descriptor = UIFontDescriptor(fontAttributes: [
            .family: "Dazzed-TRIAL", // your font’s family name
            .traits: traits
        ])
        let uiFont = UIFont(descriptor: descriptor, size: size)
        return Font(uiFont)
    }
}



// MARK: - Model

/// Represents the user profile data we fetch for NL clients.
struct MockAPIUserProfile: Codable {
    let firstName: String
    let lastName: String
    let birthDate: Date
}

// MARK: - API Protocol

/// Protocol defining real vs. mock API implementations.
protocol APIService {
    /// Fetches the NL user profile.
    /// - Returns: NLUserProfile parsed from JSON.
    func fetchNLUserProfile() async throws -> MockAPIUserProfile
}

// MARK: - Mock Implementation

/// A mock API client that simulates network latency and returns hardcoded data.
final class MockAPI: APIService {
    static let shared = MockAPI()
    private init() {}

    /// Simulates a network call to `/api/nl-user-profile` with a 1-second delay.
    func fetchNLUserProfile() async throws -> MockAPIUserProfile {
        // 1. Simulate 0.5 second of network latency
        try await Task.sleep(nanoseconds: 500_000_000)

        // 2. Hard-coded JSON response
        let json = """
        {
            "firstName": "Jan",
            "lastName": "Jansen",
            "birthDate": "1985-04-15T00:00:00Z"
        }
        """.data(using: .utf8)!

        // 3. Decode into our model
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(MockAPIUserProfile.self, from: json)
    }
}

// MARK: - Usage Example

@MainActor
func loadNLProfile() async {
    do {
        let profile = try await MockAPI.shared.fetchNLUserProfile()
        print("First Name: \(profile.firstName)")
        print("Last Name:  \(profile.lastName)")
        print("Birth Date: \(profile.birthDate)")
        // Bind these to your read-only fields in the NL form
    } catch {
        print("Failed to fetch NL profile:", error)
    }
}
