import SwiftUI

struct GalleryItem: Identifiable {
    let id: Int
    var image: String { "scene\(id)" }
    var title: String { "幽影印象 \(id)" }
    static let all = (1...6).map { GalleryItem(id: $0) }
}
struct GalleryView: View {
    @State private var selected: GalleryItem?
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Text("幽影之地・光與灰燼").font(.largeTitle.bold())
                Text("官方宣傳圖集。點選圖片可開啟水平翻頁瀏覽。圖片不與圖鑑地點逐一對應。")
                    .foregroundStyle(.secondary)
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 155), spacing: 14)], spacing: 14) {
                    ForEach(GalleryItem.all) { item in
                        Button { selected = item } label: {
                            VStack(alignment: .leading) {
                                BoundedArtwork(name: item.image, height: 180).saturation(0.8).overlay(alignment: .bottomTrailing) { Image(systemName: "arrow.up.left.and.arrow.down.right").padding(10).foregroundStyle(.white) }.clipShape(RoundedRectangle(cornerRadius: 18))
                                Text(item.title).font(.caption).foregroundStyle(.primary)
                            }
                        }.buttonStyle(.plain).accessibilityLabel("檢視\(item.title)")
                    }
                }
            }.padding().frame(maxWidth: 1100).frame(maxWidth: .infinity)
        }.navigationTitle("幽影畫廊")
            .sheet(item: $selected) { item in GalleryPager(initial: item.id) }
    }
}
struct GalleryPager: View {
    let initial: Int
    @State private var page: Int
    @Environment(\.dismiss) private var dismiss
    init(initial: Int) { self.initial = initial; _page = State(initialValue: initial) }
    var body: some View {
        NavigationStack {
            TabView(selection: $page) {
                ForEach(GalleryItem.all) { item in
                    Image(item.image).resizable().scaledToFit().padding().tag(item.id)
                }
            }.tabViewStyle(.page).background(.black).navigationTitle("\(page) / 6")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar { ToolbarItem(placement: .confirmationAction) { Button("完成") { dismiss() } } }
        }
    }
}
