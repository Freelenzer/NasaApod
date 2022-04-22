import SwiftUI

struct APODListView: View {
    @ObservedObject var dataSource: ContentDataSource
    @State var hero = false

    var body: some View {
        ScrollView(showsIndicators: false) {
            ForEach(0 ..< self.dataSource.items.count, id: \.self) { i in
                GeometryReader { geometry in
                    CardView(apod: self.$dataSource.items[i], hero: self.$hero).onAppear {
                        self.dataSource.loadMoreContentIfNeeded(currentItem: self.dataSource.items[i])
                    }
                    .offset(y: self.dataSource.items[i].expand ? -geometry.frame(in: .global).minY : 0)
                    .opacity(self.hero ? (self.dataSource.items[i].expand ? 1 : 0) : 1)
                    .frame(maxWidth: self.dataSource.items[i].expand ? UIScreen.main.bounds.width : 500, alignment: .center)
                    .onTapGesture {
                        withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.8, blendDuration: 0)) {
                            if !self.dataSource.items[i].expand {
                                self.hero.toggle()
                                self.dataSource.items[i].expand.toggle()
                            }
                        }
                    }
                }.frame(height: self.dataSource.items[i].expand ? UIScreen.main.bounds.height : 350)
            }
            if dataSource.isLoadingPage {
                ProgressView()
            }
        }
    }
}

struct APODListView_Previews: PreviewProvider {
    static var previews: some View {
        APODListView(dataSource: ContentDataSource())
    }
}
