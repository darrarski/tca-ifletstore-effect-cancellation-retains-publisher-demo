# TCA: `IfLetStore`, `Effect` cancellation retains publisher - demo

Demo project. Reproduces an issue with retained publishes on effect cancellation when using `IfLetStore` from [The Composable Architecture](https://github.com/pointfreeco/swift-composable-architecture).

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

The problem occurs when using `IfLetStore` and cancellable `Effect`. It's 100% reproducible. When not using `IfLetStore`, the subscriptions are correctly canceled and publishers disposed from the memory.

## Links

- [IfLetStore, Effect cancellation retains publisher - Related Projects / Swift Composable Architecture - Swift Forums](https://forums.swift.org/t/ifletstore-and-effect-cancellation-retains-publisher/38306)

## License

Copyright © 2020 [Dariusz Rybicki Darrarski](http://www.darrarski.pl)

License: [GNU GPLv3](LICENSE)
