import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Feature.HomeFeature.rawValue,
    targets: [
        .interface(module: .feature(.HomeFeature), dependencies: [
            .feature(target: .BaseFeature, type: .interface)
        ]),
        .implements(module: .feature(.HomeFeature), product: .staticFramework, resources: .init(.storyboards), dependencies: [
            .feature(target: .BaseFeature),
            .feature(target: .HomeFeature, type: .interface),
            .domain(target: .SearchDomain, type: .interface),
        ])
    ]
)
