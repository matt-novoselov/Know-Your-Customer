import Foundation

// Creates a temporary bundle containing given YAML strings.
func makeTemporaryBundle(yamlFiles: [String: String]) throws -> Bundle {
    let dir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
    try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
    let plist = dir.appendingPathComponent("Info.plist")
    try Data("<?xml version=\"1.0\" encoding=\"UTF-8\"?><plist version=\"1.0\"><dict></dict></plist>".utf8).write(to: plist)
    for (name, contents) in yamlFiles {
        try Data(contents.utf8).write(to: dir.appendingPathComponent(name))
    }
    return Bundle(url: dir)!
}
