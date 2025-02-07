import Foundation
import RobinHood

final class ParallelContributionSource: ExternalContributionSourceProtocol {
    var sourceName: String { "Parallel" }

    func getContributions(
        accountId _: AccountId,
        chain _: ChainModel
    ) -> CompoundOperationWrapper<[ExternalContribution]> {
        CompoundOperationWrapper.createWithResult([])
    }
}
