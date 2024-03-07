import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Feature.FavoriteSearchFeature.rawValue,
    targets: [
        .interface(module: .feature(.FavoriteSearchFeature), dependencies: [
            .feature(target: .BaseFeature, type: .interface)
        ]),
        .implements(module: .feature(.FavoriteSearchFeature), product: .staticFramework, resources: .init(.storyboards, .xib), dependencies: [
            .feature(target: .BaseFeature),
            .feature(target: .FavoriteSearchFeature, type: .interface),
            .feature(target: .HomeFeature, type: .interface),
            .domain(target: .SearchDomain, type: .interface),
        ])
    ]
)
