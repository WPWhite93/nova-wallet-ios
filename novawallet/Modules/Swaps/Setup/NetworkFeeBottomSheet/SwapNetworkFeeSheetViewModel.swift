import SoraFoundation

struct SwapNetworkFeeSheetViewModel {
    let title: LocalizableResource<String>
    let message: LocalizableResource<String>
    let sectionTitle: (Int) -> LocalizableResource<String>
    let action: (Int) -> Void
    let selectedIndex: Int
    let count: Int
    let hint: LocalizableResource<String>
}
