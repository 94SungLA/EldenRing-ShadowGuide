import SwiftUI
import WebKit
import AVKit

struct AboutView: View {
    @AppStorage("spoilers") private var spoilers = false
    @AppStorage("appearance") private var appearance = "system"
    var body: some View {
        List {
            Section {
                HStack(spacing: 16) {
                    Image(systemName: "book.closed.fill").font(.largeTitle).foregroundStyle(.tint)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("幽影手札").font(.title.bold())
                        Text("ELDEN RING · SHADOW OF THE ERDTREE").font(.caption2).foregroundStyle(.secondary)
                    }
                }.padding(.vertical)
                Text("以圖鑑的方式，閱讀幽影之地。這是一份使用 SwiftUI 製作的非官方課堂作品。")
            }
            Section("閱讀偏好") {
                SpoilerAccessControl()
                Text("預設顯示入門介紹。完整攻略含路線、頭目階段、NPC 進度與結局資訊；關閉後，收藏與搜尋也會隱藏重大劇透章節。").font(.caption).foregroundStyle(.secondary)
                Picker("外觀", selection: $appearance) {
                    Text("跟隨系統").tag("system")
                    Text("淺色").tag("light")
                    Text("深色").tag("dark")
                }
            }
            Section("影音與延伸閱讀") {
                NavigationLink { TrailerView() } label: { Label("官方發售宣傳影片", systemImage: "play.rectangle") }
                NavigationLink { OfficialWebView().navigationTitle("官方網站").navigationBarTitleDisplayMode(.inline) } label: { Label("在 App 內閱讀官方網站", systemImage: "globe") }
                NavigationLink { OnlineArtworkView() } label: { Label("網路圖片示範", systemImage: "network") }
            }
            Section("資料與素材") {
                Text("攻略依 Bandai Namco、GameSkinny、PowerPyx、Gamepressure、GamesRadar+、EIP Gaming 與 GameSpot 重新整理，各章節附對應連結。圖片為官方宣傳圖，不是攻略路線或頭目對照圖。")
                NavigationLink { GuideSourcesView() } label: { Label("攻略引用與版本說明", systemImage: "text.book.closed") }
                Text("©Bandai Namco Entertainment Inc. / ©FromSoftware, Inc. 本作品與官方無隸屬關係。")
                    .font(.caption).foregroundStyle(.secondary)
                Link("Bandai Namco 官方介紹", destination: Media.official)
                Link("Steam 官方商店", destination: URL(string: "https://store.steampowered.com/app/2778580/")!)
            }
        }.navigationTitle("關於手札")
    }
}

enum Media {
    static let official = URL(string: "https://en.bandainamcoent.eu/elden-ring/elden-ring/shadow-of-the-erdtree")!
    static let artwork = URL(string: "https://static.bandainamcoent.eu/high/elden-ring/elden-ring/08-shadow-of-the-erdtree/elden-ring-expansion-SOTE/00-page-content/ERSOTE-header-mobile.jpg")!
    static let trailer = URL(string: "https://video.akamai.steamstatic.com/store_trailers/2778580/716616/658de74e240706b1cd8410e4598c1ad4805732a8/1750819857/hls_264_master.m3u8?t=1719350815")!
}

struct TrailerView: View {
    @State private var player = AVPlayer(url: Media.trailer)
    @State private var failed = false
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                VideoPlayer(player: player).frame(height: 260).clipShape(RoundedRectangle(cornerRadius: 16))
                Text("官方發售宣傳影片").font(.title2.bold())
                Text("影片包含官方公開的場景與頭目畫面，屬輕度劇透。點擊播放鍵開始；影片以官方商店串流載入，需要網路。")
                if failed { Label("影片暫時無法載入，請確認網路或開啟官方網站觀看。", systemImage: "wifi.exclamationmark").foregroundStyle(.secondary) }
                Link("前往官方影片頁面", destination: Media.official)
            }.padding().frame(maxWidth: 850).frame(maxWidth: .infinity)
        }.navigationTitle("幽影映像")
            .onDisappear { player.pause() }
            .onReceive(player.publisher(for: \.currentItem?.status)) { if $0 == .failed { failed = true } }
    }
}

struct OfficialWebView: View {
    @State private var failed = false
    var body: some View {
        VStack(spacing: 0) {
            Text("Bandai Namco 官方網站 · 需連線").font(.caption).padding(8)
            if failed { ContentUnavailableView("網站無法載入", systemImage: "wifi.exclamationmark", description: Text("請確認網路，再回到此頁重試。")); Link("在瀏覽器開啟", destination: Media.official).padding() }
            else { WebView(url: Media.official, failed: $failed) }
        }
    }
}
struct WebView: UIViewRepresentable {
    let url: URL
    @Binding var failed: Bool
    func makeCoordinator() -> Coordinator { Coordinator(failed: $failed) }
    func makeUIView(context: Context) -> WKWebView {
        let view = WKWebView(); view.navigationDelegate = context.coordinator
        view.load(URLRequest(url: url)); return view
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {}
    final class Coordinator: NSObject, WKNavigationDelegate {
        @Binding var failed: Bool
        init(failed: Binding<Bool>) { _failed = failed }
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) { failed = true }
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) { failed = true }
    }
}
struct OnlineArtworkView: View {
    var body: some View {
        ScrollView {
            AsyncImage(url: Media.artwork) { phase in
                switch phase {
                case .empty: ProgressView("正在讀取官方圖片").frame(height: 300)
                case .success(let image): image.resizable().scaledToFit().clipShape(RoundedRectangle(cornerRadius: 24))
                case .failure: ContentUnavailableView("無法載入圖片", systemImage: "wifi.exclamationmark", description: Text("主圖鑑仍可離線瀏覽。"))
                @unknown default: EmptyView()
                }
            }.padding()
            Text("官方主視覺 · AsyncImage 網路載入").font(.caption).foregroundStyle(.secondary)
        }.navigationTitle("來自幽影之地")
    }
}

struct GuideSourcesView: View {
    @AppStorage("spoilers") private var spoilers = false
    private var sources: [GuideSource] {
        GuideSource.all.filter { spoilers || !["radahn", "patch", "route"].contains($0.id) }
    }
    var body: some View {
        List {
            Section("引用方式") {
                Text("內容為攻略摘要與重新編排，沒有轉載完整文章或攻略站截圖。各篇作者與站方保有原文權利。查閱日期：2026-11-17。")
                Text("戰術是參考方案，並非實測保證；更新可能改變招式與數值。2024 年初版攻略的部分開場描述已不適用，最終戰章節另附官方更新說明。")
            }
            Section("攻略與介紹文章") {
                ForEach(sources) { source in
                    Link(destination: source.url) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(source.title)
                            Text(source.usage).font(.caption).foregroundStyle(.secondary)
                        }.padding(.vertical, 4)
                    }
                }
            }
            if !spoilers {
                Section {
                    Text("另有主線與最終戰來源；標題可能劇透，開啟完整攻略後才列出。")
                    SpoilerAccessControl()
                }
            }
        }.navigationTitle("攻略引用").navigationBarTitleDisplayMode(.inline)
    }
}
