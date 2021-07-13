//
//  BaseViewModel.swift
//  MyHotels
//
//  Created by Banisetty Avinash on 7/11/21.
//

import Foundation

class BaseViewModel<State> {

    private var views = Set<AnyStatefulView<State>>()
    
    var state: State {
        didSet {
            views.forEach { view in
                stateDidChange(from: oldValue, to: state, for: view)
            }
        }
    }
    
    init(initialState state: State) {
        self.state = state
    }
    
    func subscribe<V: StatefulView>(view: V) where V.State == State {
        let statefulView = AnyStatefulView(withStatefulView: view)
        views.insert(statefulView)
    }
    
    func unsubscribe<V: StatefulView>(view: V) where V.State == State {
        let statefulView = AnyStatefulView(withStatefulView: view)
        if views.contains(statefulView) {
            views.remove(statefulView)
        }
    }
    
    func stateDidChange(from oldState: State, to newState: State, for view: AnyStatefulView<State>) {
        view.render(state: newState)
    }
}
