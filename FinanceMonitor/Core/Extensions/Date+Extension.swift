import Foundation

extension Date {

    enum DateFormat: String {
        case full = "EEEE, MMMM d, yyyy"
        case short = "MMM d, yyyy"
        case time = "h:mm a"
        case fancy = "EEEE, MMMM d 'at' h:mm a"
    }

    func date(with format: DateFormat) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        return formatter.string(from: self)
    }
}
