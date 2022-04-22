import Foundation

struct APOD: Codable, Identifiable {
    let id = UUID()
    var title: String
    var explanation: String
    var date: String
    var url: String
    var copyright: String?
    var thumbnail_url: String?

    var expand: Bool = false

    private enum CodingKeys: String, CodingKey {
        case title, explanation, url, copyright, date, thumbnail_url
    }

    func getParsedDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        return dateFormatter.date(from: date)
    }

    func getPrettyDate() -> String {
        if let parsedDate = getParsedDate() {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_us")
            dateFormatter.dateFormat = "EEE, dd.MM.YYYY"

            return dateFormatter.string(from: parsedDate)
        }
        return date
    }
}
