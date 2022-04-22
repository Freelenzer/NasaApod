import Combine
import Foundation

class ContentDataSource: ObservableObject {
    @Published var items = [APOD]()
    @Published var isLoadingPage = false
    @Published var hasErrors = false
    private var currentPage = 1
    private var canLoadMorePages = true
    private var startDate = Date().changeDays(by: -9)
    private var endDate = Date()

    private static let MAX_PAGE_NUMBER = 5

    init() {
        loadMoreContent()
    }

    func loadMoreContentIfNeeded(currentItem item: APOD) {
        if let itemDate = item.getParsedDate(),
           itemDate < startDate
        {
            startDate = startDate.changeDays(by: -10)
            endDate = endDate.changeDays(by: -10)
            loadMoreContent()
        }
    }

    func loadMoreContent() {
        guard !isLoadingPage, canLoadMorePages else {
            return
        }

        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.nasa.gov"
        components.path = "/planetary/apod"
        components.queryItems = [
            URLQueryItem(name: "api_key", value: "DEMO_KEY"),
            URLQueryItem(name: "start_date", value: startDate.formatDate()),
            URLQueryItem(name: "end_date", value: endDate.formatDate()),
            URLQueryItem(name: "thumbs", value: "true")
        ]

        if let url = components.url {
            isLoadingPage = true

            URLSession.shared.dataTaskPublisher(for: url)
                .map(\.data)
                .decode(type: [APOD].self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .handleEvents(receiveOutput: { _ in
                    self.canLoadMorePages = self.currentPage <= 5
                    self.isLoadingPage = false
                    self.currentPage += 1
                })
                .map { response in
                    self.hasErrors = false
                    // tl: sorting the items by date.
                    // As the date is in ISO 8601 format we can use string comparison
                    return self.items + response
                        .sorted(by: { $0.date.compare($1.date) == .orderedDescending })
                }
                .catch { _ -> Just in
                    self.isLoadingPage = false
                    self.hasErrors = true
                    return Just(self.items)
                }
                .assign(to: &$items)
        }
    }
}
