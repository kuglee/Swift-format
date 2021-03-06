import ComposableArchitecture
import StyleGuide
import SwiftUI
import Utility

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

public struct RulesView: View {
  internal struct InternalConstants {
    private class EmptyClass {}
    static let bundle = Bundle(for: InternalConstants.EmptyClass.self)
  }

  @ObservedObject var store: Store<RulesViewState, RulesViewAction>

  public init(store: Store<RulesViewState, RulesViewAction>) {
    self.store = store
  }

  public var body: some View {
    VStack(alignment: .leading, spacing: .grid(2)) {
      Text("Formatting and linting rules:", bundle: InternalConstants.bundle)
      List {
        ForEach(
          self.store.value.rules.keys.sorted().enumeratedArray(),
          id: \.offset
        ) { index, key in
          Toggle(
            isOn: Binding(
              get: { self.store.value.rules[key]! },
              set: { self.store.send(.ruleFilledOut(key: key, value: $0)) }
            )
          ) { Text(LocalizedStringKey(key), bundle: InternalConstants.bundle) }
          .modifier(PrimaryToggleStyle())
          .modifier(
            AlternatingListBackgroundStyle(
              background: index % 2 == 0 ? .dark : .light
            )
          )
        }
      }
      .modifier(PrimaryListBorderStyle())
    }
  }
}
