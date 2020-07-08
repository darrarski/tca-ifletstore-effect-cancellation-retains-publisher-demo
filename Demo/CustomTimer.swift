import Combine
import ComposableArchitecture
import CoreData

private var CustomTimerPublisher_instanceCounter = 0
private var CustomTimerSubscription_instanceCounter = 0

final class CustomTimerPublisher<SchedulerType>: Publisher
    where SchedulerType: Scheduler
{
    init(scheduler: SchedulerType) {
        self.scheduler = scheduler
        CustomTimerPublisher_instanceCounter += 1
        Swift.print("^^^ CustomTimerPublisher.init (\(CustomTimerPublisher_instanceCounter))")
    }

    deinit {
        CustomTimerPublisher_instanceCounter -= 1
        Swift.print("^^^ CustomTimerPublisher.deinit (\(CustomTimerPublisher_instanceCounter))")
    }

    private let scheduler: SchedulerType

    // MARK: - Publisher

    typealias Output = Void
    typealias Failure = Never

    func receive<S>(subscriber: S) where S: Subscriber, S.Failure == Failure, S.Input == Output {
        subscriber.receive(subscription: CustomTimerSubscription(
            subscriber: subscriber,
            scheduler: scheduler
        ))
    }

}

final class CustomTimerSubscription<SubscriberType, SchedulerType>: Subscription
    where SubscriberType: Subscriber,
    SubscriberType.Input == Void,
    SubscriberType.Failure == Never,
    SchedulerType: Scheduler
{
    init(subscriber: SubscriberType, scheduler: SchedulerType) {
        self.subscriber = subscriber
        self.scheduler = scheduler
        CustomTimerSubscription_instanceCounter += 1
        Swift.print("^^^ CustomTimerSubscription.init (\(CustomTimerSubscription_instanceCounter))")
    }

    deinit {
        CustomTimerSubscription_instanceCounter -= 1
        Swift.print("^^^ CustomTimerSubscription.deinit (\(CustomTimerSubscription_instanceCounter))")
    }

    private let subscriber: SubscriberType
    private let scheduler: SchedulerType
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Subscription

    func request(_ demand: Subscribers.Demand) {
        guard demand > 0, cancellables.isEmpty else { return }

        Effect.timer(id: "", every: 1, tolerance: 0, on: scheduler)
            .sink(receiveValue: { [weak self] _ in
                _ = self?.subscriber.receive(())
            })
            .store(in: &cancellables)
    }

    // MARK: - Cancellable

    func cancel() {
        Swift.print("^^^ CustomTimerSubscription.cancel")
        cancellables.removeAll()
    }

}
