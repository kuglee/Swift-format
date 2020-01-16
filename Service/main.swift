import Foundation

class ServiceDelegate: NSObject, NSXPCListenerDelegate {
  func listener(
    _ listener: NSXPCListener,
    shouldAcceptNewConnection newConnection: NSXPCConnection
  ) -> Bool {
    newConnection.exportedInterface = NSXPCInterface(
      with: SwiftFormatServiceProtocol.self
    )
    newConnection.exportedObject = SwiftFormatService()
    newConnection.resume()

    return true
  }
}

let delegate = ServiceDelegate()

let listener = NSXPCListener.service()
listener.delegate = delegate
listener.resume()
