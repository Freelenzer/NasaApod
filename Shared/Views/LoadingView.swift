import SwiftUI

struct LoadingView: View {
    @StateObject var dataSource = ContentDataSource()

    var body: some View {
        ZStack(alignment: .center) {
            Color(UIColor.systemBackground)
            if self.dataSource.items.count > 0 {
                APODListView(dataSource: dataSource)
            } else if self.dataSource.hasErrors && !self.dataSource.isLoadingPage {
                VStack {
                    Text("Loading error")
                    Button("Try Again") {
                        self.dataSource.loadMoreContent()
                    }
                }
            } else {
                ProgressView()
            }
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
