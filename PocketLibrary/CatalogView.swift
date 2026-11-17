import SwiftUI

struct CatalogView: View {
    var bookmarksOnly = false
    @EnvironmentObject private var store: ReadingStore
    @AppStorage("spoilers") private var spoilers = false
    @State private var search = ""
    private var entries: [Entry] {
        Entry.all.filter { (spoilers || !$0.spoiler) && (!bookmarksOnly || store.bookmarks.contains($0.id)) && (search.isEmpty || ($0.title + $0.subtitle + $0.category).localizedCaseInsensitiveContains(search)) }
    }
    var body: some View {
        List {
            if !bookmarksOnly {
                Section {
                    SpoilerAccessControl()
                    Text(spoilers ? "完整攻略已開啟；後期頭目、主線與支線結果會直接顯示。" : "目前顯示入門介紹。開啟後可閱讀具體路線、招式應對與後期攻略。")
                        .font(.caption).foregroundStyle(.secondary)
                }
            }
            ForEach(Entry.categories, id: \.self) { category in
                let rows = entries.filter { $0.category == category }
                if !rows.isEmpty {
                    Section(category) {
                        ForEach(rows) { entry in
                            NavigationLink(value: entry) {
                                HStack(spacing: 14) {
                                    Image(entry.image).resizable().scaledToFill().frame(width: 64, height: 74).clipShape(RoundedRectangle(cornerRadius: 10))
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text(entry.title).font(.headline)
                                        Text(entry.subtitle).font(.caption).foregroundStyle(.secondary)
                                        if entry.spoiler { Label("重大劇透", systemImage: "eye.slash").font(.caption2).foregroundStyle(.orange) }
                                    }
                                    Spacer()
                                    if store.bookmarks.contains(entry.id) { Image(systemName: "bookmark.fill").foregroundStyle(.tint).accessibilityLabel("已收藏") }
                                }.padding(.vertical, 4)
                            }
                        }
                    }
                }
            }
        }.navigationTitle(bookmarksOnly ? "我的收藏" : "探索圖鑑")
            .searchable(text: $search, prompt: "搜尋章節、地區或人物")
            .overlay { if entries.isEmpty { ContentUnavailableView(bookmarksOnly ? "還沒有收藏章節" : "找不到章節", systemImage: bookmarksOnly ? "bookmark" : "magnifyingglass", description: Text(bookmarksOnly ? "閱讀章節時點選書籤，即可稍後重讀。" : "試試其他關鍵字。")) } }
            .navigationDestination(for: Entry.self) { DetailView(entry: $0) }
    }
}

struct DetailView: View {
    let entry: Entry
    @EnvironmentObject private var store: ReadingStore
    @AppStorage("readingSize") private var readingSize = 18.0
    @AppStorage("spoilers") private var spoilers = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var showNote = false
    var body: some View {
        Group {
            if entry.spoiler && !spoilers {
                ContentUnavailableView("劇情筆記已隱藏", systemImage: "eye.slash", description: Text("可於圖鑑或「關於」頁面開啟完整攻略。"))
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        BoundedArtwork(name: entry.image, height: 290).clipShape(RoundedRectangle(cornerRadius: 22))
                        Label(entry.category, systemImage: entry.symbol).font(.caption).foregroundStyle(.tint)
                        Text(entry.title).font(.largeTitle.bold())
                        Text(entry.subtitle).font(.title3).foregroundStyle(.secondary)
                        ForEach(Array(entry.paragraphs.enumerated()), id: \.offset) { _, paragraph in
                            Text(paragraph).font(.system(size: readingSize)).lineSpacing(9).textSelection(.enabled)
                        }
                        if spoilers {
                            Button { withAnimation(reduceMotion ? nil : .spring(duration: 0.4)) { showNote.toggle() } } label: {
                                Label(showNote ? "收起攻略步驟" : "展開攻略步驟", systemImage: "list.bullet.clipboard")
                            }.buttonStyle(.borderedProminent)
                            if showNote {
                                VStack(alignment: .leading, spacing: 24) {
                                    ForEach(entry.guide) { section in
                                        VStack(alignment: .leading, spacing: 10) {
                                            Text(section.title).font(.title3.bold())
                                            Text(section.text).font(.system(size: readingSize)).lineSpacing(8).textSelection(.enabled)
                                        }
                                    }
                                }.padding(18)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(.tint.opacity(0.08), in: RoundedRectangle(cornerRadius: 16))
                                    .transition(.move(edge: .top).combined(with: .opacity))
                            }
                        } else {
                            VStack(alignment: .leading, spacing: 12) {
                                Label("詳細攻略尚未開啟", systemImage: "eye.slash") .font(.headline)
                                Text("包含具體取得位置、戰鬥階段與後期進度。確認接受完整劇透後，可直接展開本章攻略。")
                                    .font(.callout).foregroundStyle(.secondary)
                                SpoilerAccessControl { showNote = true }
                            }.padding().background(.tint.opacity(0.08), in: RoundedRectangle(cornerRadius: 16))
                        }
                        // 來源標題本身可能透露最終頭目，因此跟隨完整攻略開關。
                        if spoilers {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("本章參考來源").font(.headline)
                                Text("依下列攻略重新整理，非全文轉載。原文可能包含更多劇透；查閱日期 2026-11-17。")
                                    .font(.caption).foregroundStyle(.secondary)
                                ForEach(entry.sources) { source in
                                    Link(destination: source.url) {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Label(source.title, systemImage: "arrow.up.right.square")
                                            Text(source.usage).font(.caption).foregroundStyle(.secondary)
                                        }.frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }
                            }
                        }
                        HStack {
                            Text("閱讀字級").font(.caption)
                            Slider(value: $readingSize, in: 16...28, step: 1).accessibilityLabel("閱讀字級")
                            Text("Aa").font(.system(size: readingSize))
                        }
                    }.padding(22).frame(maxWidth: 780).frame(maxWidth: .infinity)
                }
            }
        }.navigationTitle(entry.spoiler && !spoilers ? "完整攻略已隱藏" : entry.title).navigationBarTitleDisplayMode(.inline)
            .onAppear { showNote = spoilers }
            .onChange(of: spoilers) { _, enabled in showNote = enabled }
            .toolbar {
                if !entry.spoiler || spoilers {
                    Button { store.toggle(entry) } label: { Image(systemName: store.bookmarks.contains(entry.id) ? "bookmark.fill" : "bookmark") }
                        .accessibilityLabel(store.bookmarks.contains(entry.id) ? "移除收藏" : "收藏章節")
                }
            }
    }
}
