import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Feature.UserSearchFeature.rawValue,
    targets: [
        .interface(module: .feature(.UserSearchFeature), dependencies: [
            .feature(target: .BaseFeature, type: .interface),
        ]),
        .implements(module: .feature(.UserSearchFeature), product: .staticFramework, resources: .init(.storyboards, .xib), dependencies: [
            .feature(target: .BaseFeature),
            .feature(target: .UserSearchFeature, type: .interface),
            .feature(target: .HomeFeature, type: .interface),
            .domain(target: .SearchDomain, type: .interface),
        ]),
        .demo(module: .feature(.UserSearchFeature), dependencies: [
            .feature(target: .UserSearchFeature),
            .domain(target: .SearchDomain, type: .testing)
        ])
    ]
)
