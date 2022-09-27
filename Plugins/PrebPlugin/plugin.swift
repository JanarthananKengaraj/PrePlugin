import PackagePlugin
import Foundation

@main
struct AsstsConstants: BuildToolPlugin {
    func createBuildCommands(context: PackagePlugin.PluginContext, target: PackagePlugin.Target) async throws -> [PackagePlugin.Command] {
        
        guard let target = target as? SourceModuleTarget else {
            return []
        }
        
        let resourceDirectoryPath = context.pluginWorkDirectory.appending(subpath: target.name)
            .appending(subpath: "Resources")
        let localizationDirectoryPath = resourceDirectoryPath.appending(subpath: "Base.lproj")
        try FileManager.default.createDirectory(atPath: localizationDirectoryPath.string, withIntermediateDirectories: true)
        let sourceFiles = target.sourceFiles(withSuffix: ".swift")
        let inputFiles = sourceFiles.map(\.path)
        
        return [.prebuildCommand(displayName: "Gererating localized string from soruce files ", executable: .init("/usr/bin/xcrun"), arguments: ["genstrings","-SwiftUI", "-o", localizationDirectoryPath] + inputFiles, outputFilesDirectory: localizationDirectoryPath)]
    }
}
