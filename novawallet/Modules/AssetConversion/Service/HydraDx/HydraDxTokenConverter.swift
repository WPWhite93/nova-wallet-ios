import Foundation
import SubstrateSdk

extension HydraDx {
    struct LocalRemoteAssetId: Equatable, Hashable {
        let localAssetId: ChainAssetId
        let remoteAssetId: HydraDx.AssetId
    }

    struct SwapPair: Equatable, Hashable {
        let assetIn: LocalRemoteAssetId
        let assetOut: LocalRemoteAssetId
    }

    struct LocalSwapPair: Equatable, Hashable {
        let assetIn: ChainAssetId
        let assetOut: ChainAssetId
    }

    struct RemoteSwapPair: Equatable, Hashable {
        let assetIn: HydraDx.AssetId
        let assetOut: HydraDx.AssetId
    }
}

enum HydraDxTokenConverterError: Error {
    case unexpectedAsset(ChainAsset)
}

enum HydraDxTokenConverter {
    static let nativeRemoteAssetId = HydraDx.AssetId(0)

    static func convertToRemote(
        chainAsset: ChainAsset,
        codingFactory: RuntimeCoderFactoryProtocol
    ) throws -> HydraDx.LocalRemoteAssetId {
        let storageInfo = try AssetStorageInfo.extract(
            from: chainAsset.asset,
            codingFactory: codingFactory
        )

        switch storageInfo {
        case .native:
            return .init(localAssetId: chainAsset.chainAssetId, remoteAssetId: nativeRemoteAssetId)
        case let .orml(info):
            let context = codingFactory.createRuntimeJsonContext()
            let remoteId = try info.currencyId.map(
                to: StringScaleMapper<HydraDx.AssetId>.self,
                with: context.toRawContext()
            ).value

            return .init(localAssetId: chainAsset.chainAssetId, remoteAssetId: remoteId)
        default:
            throw HydraDxTokenConverterError.unexpectedAsset(chainAsset)
        }
    }
}
