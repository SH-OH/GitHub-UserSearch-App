# GitHub-UserSearch-App

## Installation

Tuist 설치. (만약 Tuist가 설치되어 있다면, 넘어가주세요.)

```
make setup
```

OR

```
curl -Ls https://install.tuist.io | bash
```


프로젝트 루트에서 외부 디펜던시 fetch 및 프로젝트 generate. 

```
make generate
```


`remember-pre-project.xcworkspace` 열기 및 **remember-pre-project** scheme에서 실행.

```
open remember-pre-project.xcworkspace
```

## Project Overview

### Technologies Used

#### First-Party Frameworks
* Core Data
* Concurrency
* SPM
    
#### Third-Party Frameworks 
* RxSwift
* ReactorKit
* Kingfisher
* Swinject
* Tuist

#### Data Management and Optimization
* Modular Architecture: `Tuist`를 이용해 확장 가능하고 유지 및 관리가 용이한 모듈화 구조를 채택.
* Data Prefetching: Prefetching 전략을 이용해 사용자 프로필 이미지를 미리 불러와 대량의 리스트 이미지를 가져오는 상황에서 사용자 경험을 개선.
* Memory Caching: Remote에서 가져온 유저 정보에서 즐겨찾기 상태 검색을 최적화하기 위해 메모리 캐싱을 이용. 
* Local Database: 즐겨찾기 정보의 로컬 데이터 저장 및 검색을 위해 `Core Data` 사용.
    * 아래는 즐겨찾기 정보를 저장하는 `FavoriteUser` Entity에 대한 정보 입니다.
```
class FavoriteUser: NSManagedObject {
    @NSManaged public var userId: Int64
    @NSManaged public var isFavorited: Bool
    @NSManaged public var nickname: String?
    @NSManaged public var profileUrl: URL?
}
```
#### Dependency Injection
* Dependency Injection Container (DIC): `Swinject`를 의존성 주입 컨테이너로 활용해 앱 전체의 의존성을 관리하고 Layer 간의 coupling을 낮추며, Testability를 높이기 위해 사용. 

### Architecture

#### Layer

Feature - Domain - Core - UserInterface - Shared 의 5개 Layer로 분리했습니다.

* Feature
	- 사용자의 액션을 처리하거나 데이터를 보여주는, 사용자와 직접 맞닿는 레이어
	- ReactorKit을 이용한 MVI 패턴
	- ex) UserSearchFeature, FavoriteSearchFeature
* Domain
	- 도메인 로직이 진행되는 레이어
	- ex) SearchDomain
* Core
	- 앱의 비즈니스를 포함하지 않고 순수 기능성 모듈이 위치한 레이어
	- ex) NetworkingModule, DatabaseModule
* UserInterface
	- 공용 View, 디자인 시스템, 리소스 등 UI 요소 모듈이 위치한 레이어
	- ex) DesignSystem
* Shared
	- ThirdParty, extension 등 모든 레이어에서 공용으로 재사용될 모듈이 위치한 레이어
	- ex) UtilityModule, GlobalThirdParyLibrary

#### Micro Features

각 모듈은 [Tuist의 Micro Features](https://docs.old.tuist.io/building-at-scale/microfeatures) 구조를 기반으로 설계하였습니다. 이런 구조로 설계함으로써 아래와 같은 장점을 취할 수 있었습니다.

1. **모듈 간의 의존성 분리를 더 강하게 할 수 있음**
2. **모듈 별로 테스트할 수 있음**
- ex) SearchDomain의 경우, 
    1. Test에서 사용될 Test Double을 Testing Target에 구현하고,
    2. SearchDomain의 Tests와 UserSearchFeature의 Demo에서 Domain Testing을 의존하여 사용하고 있습니다.

<img src="https://github.com/SH-OH/Github-SearchUser/assets/50817510/a8fa5ea7-3eac-4896-8140-e429676e4488" width="300">

`microfeature.png` 이미지 입니다.

#### Dependencies Graph

<img src="https://github.com/SH-OH/Github-SearchUser/assets/50817510/af8459ad-297d-49b1-8f7f-0d53c7ad25df" width="600">

`graph.png` 이미지 입니다.
