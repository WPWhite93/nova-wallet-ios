import Foundation
import SubstrateSdk
import Starscream

final class ConnectionTransportFactory {
    let tlsSupportProvider: ConnectionTLSSupportProviding

    init(tlsSupportProvider: ConnectionTLSSupportProviding) {
        self.tlsSupportProvider = tlsSupportProvider
    }

    private func createFoundationTranport() -> Transport {
        FoundationTransport()
    }

    private func createTCPTransport() -> Transport {
        TCPTransport()
    }
}

extension ConnectionTransportFactory: WebSocketConnectionFactoryProtocol {
    public func createConnection(
        for url: URL,
        processingQueue: DispatchQueue,
        connectionTimeout: TimeInterval
    ) -> WebSocketConnectionProtocol {
        let request = URLRequest(url: url, timeoutInterval: connectionTimeout)

        let transport = tlsSupportProvider.supportTls12(for: url) ? createFoundationTranport() : createTCPTransport()

        let engine = WSEngine(
            transport: transport,
            certPinner: FoundationSecurity(),
            compressionHandler: nil
        )

        let connection = WebSocket(request: request, engine: engine)
        connection.callbackQueue = processingQueue

        return connection
    }
}
