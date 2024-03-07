import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Shared.FoundationUtility.rawValue,
    targets: [
        .implements(module: .shared(.FoundationUtility))
    ]
)
