//
//  StatefulView.swift
//  MyHotels
//
//  Created by Banisetty Avinash on 7/11/21.
//

import Foundation

public protocol StatefulView {
    associatedtype State
    func render(state: State)
}

class AnyStatefulView<State>:StatefulView {
    
    let identifier: String
    
    private let renderBlock: (State) -> Void
    
    init<V: StatefulView>(withStatefulView view:V) where V.State == State {
        identifier = String(describing: view)
        renderBlock = { viewState in
            view.render(state: viewState)
        }
    }
    
    // Argument in this function decides type of State
    func render(state: State) {
        renderBlock(state)
    }
}

extension AnyStatefulView: Hashable {
    static func == (lhs: AnyStatefulView<State>, rhs: AnyStatefulView<State>) -> Bool {
        lhs.identifier == rhs.identifier
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier.hashValue)
    }
}
