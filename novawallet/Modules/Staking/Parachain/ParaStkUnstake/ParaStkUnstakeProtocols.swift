import BigInt

protocol ParaStkUnstakeViewProtocol: ControllerBackedProtocol {
    func didReceiveCollator(viewModel: AccountDetailsSelectionViewModel?)
    func didReceiveAssetBalance(viewModel: AssetBalanceViewModelProtocol)
    func didReceiveFee(viewModel: BalanceViewModelProtocol?)
    func didReceiveAmount(inputViewModel: AmountInputViewModelProtocol)
    func didReceiveMinStake(viewModel: BalanceViewModelProtocol?)
    func didReceiveTransferable(viewModel: BalanceViewModelProtocol?)
    func didReceiveHints(viewModel: [String])
}

protocol ParaStkUnstakePresenterProtocol: AnyObject {
    func setup()
    func selectCollator()
    func updateAmount(_ newValue: Decimal?)
    func selectAmountPercentage(_ percentage: Float)
    func proceed()
}

protocol ParaStkBaseUnstakeInteractorInputProtocol: AnyObject {
    func setup()
    func estimateFee(for callWrapper: UnstakeCallWrapper)
}

protocol ParaStkUnstakeInteractorInputProtocol: ParaStkBaseUnstakeInteractorInputProtocol {
    func applyCollator(with accountId: AccountId)
    func fetchIdentities(for collatorIds: [AccountId])
}

protocol ParaStkBaseUnstakeInteractorOutputProtocol: AnyObject {
    func didReceiveAssetBalance(_ balance: AssetBalance?)
    func didReceivePrice(_ priceData: PriceData?)
    func didReceiveFee(_ result: Result<ExtrinsicFeeProtocol, Error>)
    func didReceiveDelegator(_ delegator: ParachainStaking.Delegator?)
    func didReceiveScheduledRequests(_ scheduledRequests: [ParachainStaking.DelegatorScheduledRequest]?)
    func didReceiveStakingDuration(_ stakingDuration: ParachainStakingDuration)
    func didReceiveError(_ error: Error)
}

protocol ParaStkUnstakeInteractorOutputProtocol: ParaStkBaseUnstakeInteractorOutputProtocol {
    func didReceiveCollator(metadata: ParachainStaking.CandidateMetadata?)
    func didReceiveDelegationIdentities(_ identities: [AccountId: AccountIdentity]?)
    func didReceiveMinTechStake(_ minStake: BigUInt)
    func didReceiveMinDelegationAmount(_ amount: BigUInt)
}

protocol ParaStkUnstakeWireframeProtocol: AlertPresentable, ErrorPresentable, ParachainStakingErrorPresentable,
    FeeRetryable {
    func showUnstakingCollatorSelection(
        from view: ParaStkUnstakeViewProtocol?,
        viewModels: [AccountDetailsPickerViewModel],
        selectedIndex: Int,
        delegate: ModalPickerViewControllerDelegate,
        context: AnyObject?
    )

    func showUnstakingConfirm(
        from view: ParaStkUnstakeViewProtocol?,
        collator: DisplayAddress,
        callWrapper: UnstakeCallWrapper
    )
}
