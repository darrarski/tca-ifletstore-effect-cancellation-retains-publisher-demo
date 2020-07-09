import ComposableArchitecture
import SwiftUI

struct AppState: Equatable {
    init(timer: TimerState = .init()) {
        self.timer = timer
    }

    var timer: TimerState
}

enum AppAction: Equatable {
    case timer(TimerAction)
}

struct AppEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

extension AppEnvironment {
    var timerEnvironment: TimerEnvironment {
        .init(mainQueue: mainQueue)
    }
}

let appReducer: Reducer<AppState, AppAction, AppEnvironment> = .combine(
    timerReducer.pullback(
        state: \.timer,
        action: /AppAction.timer,
        environment: \.timerEnvironment
    )
)

struct AppView: View {
    let store: Store<AppState, AppAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            TimerView(store: self.store.scope(
                state: \.timer,
                action: AppAction.timer
            ))
        }
    }
}

#if DEBUG
struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView(store: .init(
            initialState: .init(),
            reducer: .empty,
            environment: ()
        ))
    }
}
#endif
