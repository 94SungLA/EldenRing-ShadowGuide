# 幽影手札｜專案與作業對照

專案：`/Users/sungla/Developer/PocketLibrary/PocketLibrary.xcodeproj`

環境：Xcode 27.0，最低 iOS／iPadOS 18，原生 SwiftUI，無第三方套件。

## 在 Xcode 確認

1. Finder 按 `Shift + Command + G`，貼上 `/Users/sungla/Developer/PocketLibrary`，開啟 `PocketLibrary.xcodeproj`。也可在終端機輸入 `open -a /Applications/Xcode.app /Users/sungla/Developer/PocketLibrary/PocketLibrary.xcodeproj`。
2. 上方 Scheme 選 `PocketLibrary`，裝置選已安裝 iOS 18 以上的 iPhone 模擬器，按 `Command + R`。
3. 若裝置只有 `Any iOS Device`，到 Xcode Settings → Components 安裝 iOS Simulator runtime，再選模擬器。
4. 模擬器不需開發者 Team；如使用實體 iPhone，需在 Signing & Capabilities 選自己的 Team。
5. 切換至 iPad 模擬器並以橫向執行，檢查上方 tab bar 與側邊欄切換按鈕。

## 必做項目

| 作業要求 | 實作位置／操作 |
|---|---|
| 多頁面、不同 Swift 檔案 | LibraryView、CatalogView、GalleryView、AboutView |
| NavigationStack／NavigationLink 傳值與標題 | HomeView／CatalogView 傳 Entry，DetailView 顯示標題 |
| struct／Identifiable／array | Entry.swift 的 Entry 與 Entry.all |
| List 與 Identifiable | CatalogView 的 ForEach(entries) 與分類 Section |
| TabView 與 Tab、iPhone／iPad | LibraryView，sidebarAdaptable；實際裝置截圖待補 |
| 水平分頁 | 首頁精選 TabView.page、GalleryPager |
| animation | 首頁圖示旋轉，減少動態效果時停用 |
| transition | 閱讀頁「攻略步驟」展開與收合 |
| SF Symbol 動畫 | 首頁 sparkles 的 symbolEffect(.pulse) |
| WebView | 關於 → 在 App 內閱讀官方網站；WKWebView 包裝 |
| light／dark mode | 關於 → 外觀；語意色與背景 |
| SF Symbol | 分頁、分類、收藏與操作按鈕 |
| 格子照片牆 | 畫廊 LazyVGrid，點選可展開 |
| 上下捲動內含水平捲動 | 首頁 ScrollView 內的水平 ScrollView／LazyHStack |
| VideoPlayer | 關於 → 官方發售宣傳影片；AVPlayer HLS |
| App Icon／名稱 | AppIcon.appiconset；顯示名稱「幽影手札」 |
| Info.plist 啟動畫面 | UILaunchScreen／LaunchBackground |

## 已加入的加分項目

| 項目 | 位置 |
|---|---|
| pinned header | HomeView 的 LazyVStack Section header |
| 圖片效果 modifier | 畫廊 saturation，卡片 overlay／clipShape |
| 多種文字樣式組合 | 首頁歡迎文字不同顏色與字重的 Text 組合 |
| 自訂 ViewModifier | ShadowCardStyle |
| AsyncImage | 關於 → 網路圖片示範，含讀取中與錯誤狀態 |

另有搜尋、收藏持久化、閱讀字級、劇透開關。未製作額外 landing page 網站。

## 繳交前實機／模擬器檢查

- iPhone：首頁 tab bar 在下方、精選卡片左右滑、點卡片開啟對應內容。
- 圖鑑：搜尋「幽影」，確認分類與結果；進入章節，標題需正確。
- 閱讀：解鎖、展開與收起攻略、調整字級、收藏；重開 App 確認收藏與設定仍在。
- 畫廊：確認網格、點圖展開、左右翻頁、按完成返回。
- 關於：切換深／淺色、開啟完整攻略並確認劇透提示；再關閉，確認圖鑑、搜尋與收藏都會隱藏重大劇透章節。
- 開啟官方網站與影片並實際播放，確認離開影片頁停止播放；斷網時主要圖文仍可讀。
- iPad：橫向／直向、上方 tab bar、展開側邊欄、畫廊欄數與閱讀頁寬度。
- 到系統設定開啟「減少動態效果」，確認首頁持續動畫停用。
- 錄製一段操作影片，補上 iPhone／iPad 截圖後更新 Medium 草稿。

## 文章與交付狀態

Medium 草稿已準備。署名／學號尚未指定，沒有代填；GitHub URL、操作影片與裝置截圖保留空位。尚未建立遠端 repository，也沒有發布 Medium 文章。

遊戲素材與資訊來源見專案 `SOURCES.md`。官方宣傳圖片僅作氛圍展示，不是各章節地點的精確對照圖。


## 攻略內容更新

現有 10 篇章節、29 段具體攻略。完整攻略解鎖後直接展開；各章節有對應原文，總表見「攻略引用與編寫範圍.md」。解鎖涵蓋全 App，關閉後會重新遮蔽內容與敏感來源標題。
