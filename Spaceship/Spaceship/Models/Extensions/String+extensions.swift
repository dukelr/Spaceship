
import Foundation

extension String {
//    func localized() -> String {
//        NSLocalizedString(self, comment: "")
//    }
//
    static func localized(_ localizationKey: LocalizationKey) -> String {
        NSLocalizedString(localizationKey.rawValue, comment: "")
    }
}
