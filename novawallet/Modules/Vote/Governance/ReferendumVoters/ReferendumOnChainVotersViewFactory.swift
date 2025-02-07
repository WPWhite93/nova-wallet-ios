import Foundation
import SubstrateSdk
import RobinHood
import SoraFoundation

struct ReferendumOnChainVotersViewFactory {
    static func createView(
        state: GovernanceSharedState,
        referendum: ReferendumLocal,
        type: ReferendumVotersType
    ) -> VotesViewProtocol? {
        guard
            let interactor = createInteractor(for: state, referendum: referendum),
            let chain = state.settings.value?.chain
        else {
            return nil
        }

        let wireframe = ReferendumVotersWireframe()

        let localizationManager = LocalizationManager.shared

        let stringViewModelFactory = ReferendumDisplayStringFactory(
            formatterFactory: AssetBalanceFormatterFactory()
        )

        let presenter = ReferendumVotersPresenter(
            interactor: interactor,
            wireframe: wireframe,
            type: type,
            referendum: referendum,
            chain: chain,
            stringFactory: stringViewModelFactory,
            localizationManager: localizationManager,
            logger: Logger.shared
        )

        let view = VotesViewController(
            presenter: presenter,
            quantityFormatter: NumberFormatter.quantity.localizableResource(),
            localizationManager: localizationManager
        )

        presenter.view = view
        interactor.presenter = presenter

        return view
    }

    private static func createInteractor(
        for state: GovernanceSharedState,
        referendum: ReferendumLocal
    ) -> ReferendumVotersInteractor? {
        guard let chain = state.settings.value?.chain else {
            return nil
        }

        let chainRegistry = ChainRegistryFacade.sharedRegistry

        guard
            let connection = chainRegistry.getConnection(for: chain.chainId),
            let runtimeProvider = chainRegistry.getRuntimeProvider(for: chain.chainId),
            let referendumsOperationFactory = state.referendumsOperationFactory else {
            return nil
        }

        let operationQueue = OperationQueue()

        let requestFactory = StorageRequestFactory(
            remoteFactory: StorageKeyFactory(),
            operationManager: OperationManager(operationQueue: operationQueue)
        )

        let identityOperationFactory = IdentityOperationFactory(
            requestFactory: requestFactory,
            emptyIdentitiesWhenNoStorage: true
        )

        let identityProxyFactory = IdentityProxyFactory(
            originChain: chain,
            chainRegistry: chainRegistry,
            identityOperationFactory: identityOperationFactory
        )

        return ReferendumVotersInteractor(
            referendumIndex: referendum.index,
            chain: chain,
            referendumsOperationFactory: referendumsOperationFactory,
            identityProxyFactory: identityProxyFactory,
            connection: connection,
            runtimeProvider: runtimeProvider,
            operationQueue: operationQueue
        )
    }
}
