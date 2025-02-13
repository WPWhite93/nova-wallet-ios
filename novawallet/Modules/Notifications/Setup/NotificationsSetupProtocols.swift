import Foundation

protocol NotificationsSetupViewProtocol: ControllerBackedProtocol {
    func didStartEnabling()
    func didStopEnabling()
}

protocol NotificationsSetupPresenterProtocol: AnyObject {
    func setup()
    func enablePushNotifications()
    func skip()
    func activateTerms()
    func activatePrivacy()
}

protocol NotificationsSetupInteractorInputProtocol: AnyObject {
    func setup()
    func enablePushNotifications()
}

protocol NotificationsSetupInteractorOutputProtocol: AnyObject {
    func didRegister(notificationStatus: PushNotificationsStatus)
    func didReceive(error: Error)
}

protocol NotificationsSetupWireframeProtocol: WebPresentable, AlertPresentable, CommonRetryable, ErrorPresentable {
    func complete(on view: ControllerBackedProtocol?)
    func saved(on view: ControllerBackedProtocol?)
    func show(url: URL, from view: ControllerBackedProtocol?)
    func close(on view: ControllerBackedProtocol?)
}
