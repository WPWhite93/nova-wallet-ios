import Foundation
@testable import novawallet
import RobinHood
import SubstrateSdk

final class SlashesOperationFactoryStub: SlashesOperationFactoryProtocol {
    let slashingSpans: SlashingSpans?

    init(slashingSpans: SlashingSpans?) {
        self.slashingSpans = slashingSpans
    }

    func createSlashingSpansOperationForStash(
        _ stashAccount: @escaping () throws -> AccountId,
        engine: JSONRPCEngine,
        runtimeService: RuntimeCodingServiceProtocol) -> CompoundOperationWrapper<SlashingSpans?> {
        return CompoundOperationWrapper.createWithResult(slashingSpans)
    }
}
