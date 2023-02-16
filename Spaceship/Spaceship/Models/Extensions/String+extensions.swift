
import Foundation

extension String {
    func localized() -> String {
        NSLocalizedString(self, comment: "")
    }
}
