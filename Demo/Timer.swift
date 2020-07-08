import ComposableArchitecture
import SwiftUI

struct TimerState: Equatable {
    init(count: Int = 0) {
        self.count = count
    }

    var count: Int
}

enum TimerAction: Equatable {
    case start
    case stop
    case tick
}

struct TimerEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

let timerReducer = Reducer<TimerState, TimerAction, TimerEnvironment> { state, action, environment in
    struct TimerEffectId: Hashable {}

    switch action {
    case .start:
        return CustomTimerPublisher(scheduler: environment.mainQueue)
            .map { _ in TimerAction.tick }
            .eraseToEffect()
            .cancellable(id: TimerEffectId(), cancelInFlight: true)

    case .stop:
        return .cancel(id: TimerEffectId())

    case .tick:
        state.count += 1
        return .none
    }
}

struct TimerView: View {
    let store: Store<TimerState, TimerAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                Text("Timer").font(.title).padding()
                Text("\(viewStore.count)")
                HStack {
                    Button(action: { viewStore.send(.start) }) {
                        Text("Start").padding()
                    }
                    Button(action: { viewStore.send(.stop) }) {
                        Text("Stop").padding()
                    }
                }
            }
        }
    }
}

#if DEBUG
struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView(store: .init(
            initialState: .init(),
            reducer: .empty,
            environment: ()
        ))
    }
}
#endif
