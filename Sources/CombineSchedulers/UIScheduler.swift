#if canImport(OpenCombine)
  import OpenCombine
  import OpenCombineDispatch
  import Dispatch

  /// A scheduler that executes its work on the main queue as soon as possible.
  ///
  /// This scheduler is inspired by the
  /// [equivalent](https://github.com/ReactiveCocoa/ReactiveSwift/blob/58d92aa01081301549c48a4049e215210f650d07/Sources/Scheduler.swift#L92)
  /// scheduler in the [ReactiveSwift](https://github.com/ReactiveCocoa/ReactiveSwift) project.
  ///
  /// If `UIScheduler.shared.schedule` is invoked from the main thread then the unit of work will be
  /// performed immediately. This is in contrast to `DispatchQueue.main.schedule`, which will incur
  /// a thread hop before executing since it uses `DispatchQueue.main.async` under the hood.
  ///
  /// This scheduler can be useful for situations where you need work executed as quickly as
  /// possible on the main thread, and for which a thread hop would be problematic, such as when
  /// performing animations.
  public struct UIScheduler: OpenCombine.Scheduler, Sendable {
    public typealias SchedulerOptions = Never
    public typealias SchedulerTimeType = DispatchQueue.OCombine.SchedulerTimeType

    /// The shared instance of the UI scheduler.
    ///
    /// You cannot create instances of the UI scheduler yourself. Use only the shared instance.
    public static let shared = Self()

    public var now: SchedulerTimeType { DispatchQueue.OCombine(.main).now }
    public var minimumTolerance: SchedulerTimeType.Stride { DispatchQueue.OCombine(.main).minimumTolerance }

    public func schedule(options: SchedulerOptions? = nil, _ action: @escaping () -> Void) {
      if DispatchQueue.getSpecific(key: key) == value {
        action()
      } else {
        DispatchQueue.OCombine(.main).schedule(action)
      }
    }

    public func schedule(
      after date: SchedulerTimeType,
      tolerance: SchedulerTimeType.Stride,
      options: SchedulerOptions? = nil,
      _ action: @escaping () -> Void
    ) {
      DispatchQueue.OCombine(.main).schedule(after: date, tolerance: tolerance, options: nil, action)
    }

    public func schedule(
      after date: SchedulerTimeType,
      interval: SchedulerTimeType.Stride,
      tolerance: SchedulerTimeType.Stride,
      options: SchedulerOptions? = nil,
      _ action: @escaping () -> Void
    ) -> Cancellable {
      DispatchQueue.OCombine(.main).schedule(
        after: date, interval: interval, tolerance: tolerance, options: nil, action
      )
    }

    private init() {
      DispatchQueue.main.setSpecific(key: key, value: value)
    }
  }

  private let key = DispatchSpecificKey<UInt8>()
  private let value: UInt8 = 0
#endif
