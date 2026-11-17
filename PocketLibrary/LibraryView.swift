import SwiftUI

struct LibraryView: View {
    @StateObject private var store = ReadingStore()
    @AppStorage("spoilers") private var spoilers = false
    @AppStorage("appearance") private var appearance = "system"
    var body: some View {
        TabView {
            Tab("啟程", systemImage: "sparkles") { NavigationStack { HomeView() } }
            Tab("圖鑑", systemImage: "books.vertical") { NavigationStack { CatalogView() } }
            Tab("畫廊", systemImage: "square.grid.2x2") { NavigationStack { GalleryView() } }
            Tab("收藏", systemImage: "bookmark") { NavigationStack { CatalogView(bookmarksOnly: true) } }
            Tab("關於", systemImage: "info.circle") { NavigationStack { AboutView() } }
        }
        .tabViewStyle(.sidebarAdaptable)
        .tint(.accentColor)
        .environmentObject(store)
        .preferredColorScheme(appearance == "dark" ? .dark : appearance == "light" ? .light : nil)
    }
}

struct HomeView: View {
    @AppStorage("spoilers") private var spoilers = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var glow = false
    private var entries: [Entry] { Entry.all.filter { spoilers || !$0.spoiler } }
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 28, pinnedViews: [.sectionHeaders]) {
                ZStack(alignment: .bottomLeading) {
                    BoundedArtwork(name: "cover", height: 430)
                        .overlay(LinearGradient(colors: [.clear, .black.opacity(0.95)], startPoint: .top, endPoint: .bottom))
                    VStack(alignment: .leading, spacing: 12) {
                        Text("SHADOW OF THE ERDTREE").font(.caption).tracking(3)
                        Text("幽影手札").font(.system(size: 44, weight: .bold, design: .serif))
                        Text("入門準備、碎片位置與頭目打法。")
                        NavigationLink(value: Entry.all[0]) { Label("翻開第一章", systemImage: "book.pages") }
                            .buttonStyle(.borderedProminent).tint(Color(red: 0.66, green: 0.49, blue: 0.23))
                    }.foregroundStyle(.white).padding(28)
                }.clipShape(RoundedRectangle(cornerRadius: 24))
                HStack(spacing: 14) {
                    Image(systemName: "sparkles").font(.title).foregroundStyle(.tint)
                        .symbolEffect(.pulse, options: .repeating, isActive: !reduceMotion)
                        .rotationEffect(.degrees(glow ? 8 : -8))
                        .animation(reduceMotion ? nil : .easeInOut(duration: 3).repeatForever(autoreverses: true), value: glow)
                    VStack(alignment: .leading) {
                        (Text("給初次踏入 ").foregroundStyle(.primary) + Text("幽影之地").foregroundStyle(Color.accentColor).bold() + Text(" 的你").foregroundStyle(.primary)).font(.headline)
                        Text("入門介紹預設開啟 · 完整攻略自行解鎖").font(.caption).foregroundStyle(.secondary)
                    }
                }.onAppear { glow = true }
                SpoilerAccessControl()
                Section {
                    TabView {
                        ForEach(entries.prefix(4)) { entry in
                            NavigationLink(value: entry) { EntryCard(entry: entry) }.buttonStyle(.plain).padding(.horizontal, 3)
                        }
                    }.tabViewStyle(.page).frame(height: 270)
                } header: { Text("旅程精選").font(.title2.bold()).frame(maxWidth: .infinity, alignment: .leading).padding(.vertical, 10).background(.background) }
                Section {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 16) {
                            ForEach(entries.filter { $0.category == "戰鬥筆記" || $0.category == "故事線索" }) { entry in
                                NavigationLink(value: entry) { EntryCard(entry: entry).frame(width: 265) }.buttonStyle(.plain)
                            }
                        }
                    }
                } header: { Text("人物與戰鬥").font(.title2.bold()).frame(maxWidth: .infinity, alignment: .leading).padding(.vertical, 10).background(.background) }
                Text("非官方遊戲介紹 · 圖片為官方宣傳素材").font(.caption).foregroundStyle(.secondary)
            }.padding().frame(maxWidth: 1000).frame(maxWidth: .infinity)
        }.background(Color(.systemGroupedBackground)).navigationTitle("幽影手札")
            .navigationDestination(for: Entry.self) { DetailView(entry: $0) }
    }
}

struct EntryCard: View {
    let entry: Entry
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            BoundedArtwork(name: entry.image, height: 240)
                .overlay(LinearGradient(colors: [.clear, .black.opacity(0.9)], startPoint: .top, endPoint: .bottom))
            VStack(alignment: .leading, spacing: 6) {
                Label(entry.category, systemImage: entry.symbol).font(.caption).foregroundStyle(Color(red: 0.9, green: 0.77, blue: 0.5))
                Text(entry.title).font(.title2.bold())
                Text(entry.subtitle).font(.caption)
            }.foregroundStyle(.white).padding(20)
        }.modifier(ShadowCardStyle())
    }
}

#Preview { LibraryView() }

/// 統一圖鑑卡片的圓角與描邊，讓樣式集中維護。
struct ShadowCardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(RoundedRectangle(cornerRadius: 20).strokeBorder(.white.opacity(0.12), lineWidth: 1))
    }
}

/// 圖片放在不參與父層寬度計算的 overlay，避免原始寬高比撐大直式頁面。
struct BoundedArtwork: View {
    let name: String
    let height: CGFloat

    var body: some View {
        Color.clear
            .frame(height: height)
            .overlay {
                GeometryReader { geometry in
                    Image(name)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                }
            }
            .clipped()
            .accessibilityHidden(true)
    }
}

/// 使用共同開關，解鎖前先說明整個 App 的劇透範圍。
struct SpoilerAccessControl: View {
    @AppStorage("spoilers") private var spoilers = false
    @State private var confirm = false
    var onUnlock: () -> Void = {}

    var body: some View {
        Button {
            if spoilers { spoilers = false }
            else { confirm = true }
        } label: {
            Label(spoilers ? "關閉完整攻略" : "開啟完整攻略（含重大劇透）", systemImage: spoilers ? "eye.slash" : "lock.open")
                .multilineTextAlignment(.leading)
        }
        .confirmationDialog("開啟整個 App 的完整攻略？", isPresented: $confirm, titleVisibility: .visible) {
            Button("接受劇透，開啟完整攻略") {
                spoilers = true
                onUnlock()
            }
            Button("繼續看入門介紹", role: .cancel) {}
        } message: {
            Text("將顯示後期區域、頭目二階段、NPC 支線轉折、最終頭目身分與相關來源標題。可隨時關閉；收藏與搜尋也會同步隱藏重大劇透章節。")
        }
    }
}
