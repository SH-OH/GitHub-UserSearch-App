//
//  HomeViewReactor.swift
//  HomeFeatureInterface
//
//  Created by Oh Sangho on 2/23/24.
//  Copyright © 2024 com.shoh.app. All rights reserved.
//

import ReactorKit
import RxSwift
import RxRelay

final class HomeViewReactor: Reactor {
	
	enum Action {
		
	}
	
	enum Mutation {
		
		case setIsLoading(Bool)
		case setErrorMessage(String)
	}
	
	struct State {
		
		var isLoading: Bool = false
		@Pulse var errorMessage: String?
	}
	
	let initialState: State
	
	init() {
		initialState = .init()
	}
	
	func mutate(action: Action) -> Observable<Mutation> {
		switch action {
			
		}
	}
	
	func reduce(state: State, mutation: Mutation) -> State {
		var newState: State = state
		
		switch mutation {
		case .setIsLoading(let newValue):
			newState.isLoading = newValue
            
        case .setErrorMessage(let newValue):
            newState.errorMessage = newValue
		}
		
		return newState
	}
}
