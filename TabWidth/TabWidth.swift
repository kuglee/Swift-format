import ComposableArchitecture
import StyleGuide
import SwiftUI
import Utility

public enum TabWidthViewAction: Equatable {
  case tabWidthFilledOut(Int)
  case tabWidthIncremented
  case tabWidthDecremented
}

public struct TabWidthViewState {
  public var tabWidth: Int

  public init(tabWidth: Int) { self.tabWidth = tabWidth }
}

public func tabWidthViewReducer(
  state: inout TabWidthViewState,
  action: TabWidthViewAction
) -> [Effect<TabWidthViewAction>] {
  switch action {
  case .tabWidthFilledOut(let value): state.tabWidth = value
  case .tabWidthIncremented: state.tabWidth += 1
  case .tabWidthDecremented: state.tabWidth -= 1
  }

  return []
}

public struct TabWidthView: View {
  internal enum InternalConstants {
    private class EmptyClass {}
    static let bundle = Bundle(for: InternalConstants.EmptyClass.self)
  }

  @ObservedObject var store: Store<TabWidthViewState, TabWidthViewAction>

  public init(store: Store<TabWidthViewState, TabWidthViewAction>) {
    self.store = store
  }

  public var body: some View {
    HStack {
      Text("tabWidth:", bundle: InternalConstants.bundle)
        .modifier(TrailingAlignmentStyle())
      Stepper(
        onIncrement: { self.store.send(.tabWidthIncremented) },
        onDecrement: { self.store.send(.tabWidthDecremented) },
        label: {
          TextField(
            "",
            value: Binding(
              get: { self.store.value.tabWidth },
              set: { self.store.send(.tabWidthFilledOut($0)) }
            ),
            formatter: UIntNumberFormatter()
          )
          .modifier(PrimaryTextFieldStyle())
        }
      )
      .toolTip("TAB_WIDTH_TOOLTIP", bundle: InternalConstants.bundle)
      Text("spaces", bundle: InternalConstants.bundle)
    }
  }
}
