import Foundation
import ProjectDescription

public struct ProjectEnvironment {
    public let name: String
    public let organizationName: String
    public let destinations: Destinations
    public let deploymentTargets: DeploymentTargets
    public let baseSetting: SettingsDictionary
}

public let env = ProjectEnvironment(
    name: "GitHub-UserSearch-App",
    organizationName: "com.shoh.app",
    destinations: [.iPhone],
    deploymentTargets: .iOS("14.0"),
    baseSetting: [:]
)
