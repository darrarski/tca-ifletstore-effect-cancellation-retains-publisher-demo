# TCA: `Effect` cancellation retains publisher - demo

Demo project. Reproduces an issue with retained publishes on effect cancellation when using [The Composable Architecture](https://github.com/pointfreeco/swift-composable-architecture).

#### 🚨 [November 1st 2020] This issue seems to be resolved when using Xcode 12.1 (12A7403) with Apple Swift version 5.3 (swiftlang-1200.0.29.2 clang-1200.0.30.1). It looks like the problem was caused by a bug in Combine framework.

## Issue

### Steps to reproduce

1. Clone the repository
2. Open `Demo.xcodeproj` in Xcode 11.5
3. Run the app in iPhone Simulator using `Demo` build scheme
4. Tap Start & Stop buttons several times to start and stop the timer
5. Observe output on the console or use memory debugger

### Expected behavior

6. Whenever the timer is started
    1. A single instance of `CustomTimerPublisher` should be created
    2. A single instance of `CustomTimerSubscription` should be created
7. Whenever the timer is stopped
    1. The subscription should be canceled
    2. Previously created instance of `CustomTimerSubscription` should be disposed
    3. Previously created instance of `CustomTimerPublisher` should be disposed

### Actual behavior

6. Whenever the timer is started
    1. A single instance of `CustomTimerPublisher` is created ✅
    2. A single instance of `CustomTimerSubscription` is created ✅
7. Whenever the timer is stopped
    1. The subscription is canceled ✅
    2. Previously created instance of `CustomTimerSubscription` is disposed ✅
    3. Previously created instance of `CustomTimerPublisher` is retained in the memory ❌

## Details

The problem occurs when returning cancellable `Effect` from a reducer, that was created using `Redcuer.combine` function. It's 100% reproducible. When not using `Reducer.combine`, the subscriptions are correctly canceled and publishers disposed from the memory.

[Separate branch](https://github.com/darrarski/tca-ifletstore-effect-cancellation-retains-publisher-demo/tree/solution-without-combining-reducers) contains the same demo app but do not uses `Reducer.combine` function and it's free from retained publishers issue.

## Links

- [IfLetStore, Effect cancellation retains publisher - Related Projects / Swift Composable Architecture - Swift Forums](https://forums.swift.org/t/ifletstore-and-effect-cancellation-retains-publisher/38306)

## License

Copyright © 2020 [Dariusz Rybicki Darrarski](http://www.darrarski.pl)

License: [GNU GPLv3](LICENSE)
