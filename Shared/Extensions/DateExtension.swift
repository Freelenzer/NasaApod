import Foundation

extension Date {
    func changeDays(by days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: self)!
    }

    func formatDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        return dateFormatter.string(from: self)
    }
}
