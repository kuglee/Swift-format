import ComposableArchitecture
import SwiftUI

public enum RulesViewAction: Equatable {
  case ruleFilledOut(key: String, value: Bool)
}

public struct RulesViewState {
  public var rules: [String: Bool]

  public init(rules: [String: Bool]) { self.rules = rules }
}

public func rulesViewReducer(
  state: inout RulesViewState,
  action: RulesViewAction
) -> [Effect<RulesViewAction>] {
  switch action {
  case .ruleFilledOut(let key, let value):
    state.rules[key] = value
    return []
  }
}

extension Collection {
  func enumeratedArray() -> Array<(offset: Int, element: Self.Element)> {
    return Array(self.enumerated())
  }
}

public struct RulesView: View {
  @ObservedObject var store: Store<RulesViewState, RulesViewAction>

  public init(store: Store<RulesViewState, RulesViewAction>) {
    self.store = store
  }

  public var body: some View {
    List {
      ForEach(self.store.value.rules.keys.sorted().enumeratedArray(), id: \.offset) { index, key in
        Toggle(
          isOn: Binding(
            get: { self.store.value.rules[key]! },
            set: { self.store.send(.ruleFilledOut(key: key, value: $0)) }
          )
        ) { Text(key) }.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
          .listRowBackground((index  % 2 == 0)
            ? Color(NSColor.alternatingContentBackgroundColors[0])
            : Color(NSColor.alternatingContentBackgroundColors[1]))
      }
    }.border(Color(.placeholderTextColor))
  }
}
