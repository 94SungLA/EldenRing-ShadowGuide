import SwiftUI
import Combine

struct GuideSection: Identifiable, Hashable {
    let title: String
    let text: String
    var id: String { title }
}

struct GuideSource: Identifiable, Hashable {
    let id: String
    let title: String
    let url: URL
    let usage: String
    static let all: [GuideSource] = [
        GuideSource(id: "official", title: "Bandai Namco｜進入 DLC 與庇佑系統", url: URL(string: "https://en.bandainamcoent.eu/elden-ring/news/elden-ring-how-enter-the-realm-of-shadow")!, usage: "進入條件、區域往返、庇佑用途"),
        GuideSource(id: "fragments", title: "GameSkinny／John Schutt｜幽影樹碎片位置", url: URL(string: "https://www.gameskinny.com/tips/where-to-find-all-50-scadutree-fragments-in-elden-ring-shadow-of-the-erdtree/")!, usage: "墓地平原前期碎片；僅摘要部分位置"),
        GuideSource(id: "route", title: "PowerPyx｜DLC Walkthrough", url: URL(string: "https://www.powerpyx.com/elden-ring-shadow-of-the-erdtree-dlc-walkthrough/")!, usage: "主線順序與燃燒封印樹前的支線警告"),
        GuideSource(id: "weapons", title: "Gamepressure｜DLC 新武器位置", url: URL(string: "https://www.gamepressure.com/elden-ring/all-weapons-in-dlc/zf11481")!, usage: "仕女劍與大刀的位置"),
        GuideSource(id: "rellana", title: "GamesRadar+／Joel Franey｜雙月騎士攻略", url: URL(string: "https://www.gamesradar.com/games/action/elden-ring-shadow-of-the-erdtree-rellana-twin-moon-knight/")!, usage: "魔力／火焰防禦、雙月衝擊波與攻擊時機"),
        GuideSource(id: "messmer", title: "EIP Gaming｜梅瑟莫頭目攻略", url: URL(string: "https://eip.gg/elden-ring/guides/messmer-the-impaler-boss/")!, usage: "火球落地爆炸、蛇形攻擊與第二階段應對"),
        GuideSource(id: "radahn", title: "GameSpot／Jason Rodriguez｜DLC 最終頭目攻略", url: URL(string: "https://www.gamespot.com/articles/shadow-of-the-erdtree-final-boss-elden-ring-guide/1100-6524348/")!, usage: "最終戰準備、聖屬性追擊與擁抱機制"),
        GuideSource(id: "patch", title: "Bandai Namco｜1.14 更新公告", url: URL(string: "https://en.bandainamcoent.eu/elden-ring/news/elden-ring-patch-notes-version-114")!, usage: "核對最終頭目已調整的開場、傷害與特效；不是宣稱目前最新版"),
    ]
}

struct Entry: Identifiable, Hashable {
    let id: String
    let title: String
    let subtitle: String
    let category: String
    let image: String
    let symbol: String
    let paragraphs: [String]
    let guide: [GuideSection]
    let sourceIDs: [String]
    var spoiler = false
    var sources: [GuideSource] { sourceIDs.compactMap { id in GuideSource.all.first { $0.id == id } } }
    static let categories = ["行前準備", "幽影之地", "戰鬥筆記", "故事線索"]
    static let all: [Entry] = [
        Entry(id: "begin", title: "進入 DLC：先確認這兩場戰鬥", subtitle: "拉塔恩、蒙格，以及繭裡伸出的手", category: "行前準備", image: "cover", symbol: "sparkles", paragraphs: ["入口在蒙格溫王朝，不在黃金樹附近。先確認目前這一輪已擊敗「碎星」拉塔恩與「鮮血君王」蒙格，再到蒙格戰場與繭中伸出的手互動。", "進入後先坐第一個賜福。啟用幽影之地的賜福後，就能從地圖往返本篇區域，不用每次都重走蒙格的入口。"], guide: [
            GuideSection(title: "找不到蒙格溫王朝？", text: "白面具梵雷的任務會給純血騎士勳章，可直接前往王朝；另一條路是化聖雪原的傳送門。抵達後仍須走完王朝區域並擊敗蒙格。"),
            GuideSection(title: "打完蒙格還不能進去？", text: "檢查拉塔恩是否已在「這一輪」被擊敗。若已進入新一輪，上一輪的擊殺不算這輪的進度。先完成必要戰鬥，再回來與手臂互動。"),
        ], sourceIDs: ["official"], spoiler: false),
        Entry(id: "blessing", title: "打不動敵人？先檢查庇佑", subtitle: "碎片撿到了，還得回賜福升級", category: "行前準備", image: "scene1", symbol: "leaf.fill", paragraphs: ["幽影樹碎片要在賜福的「幽影之地庇佑」選單使用，才會提升幽影樹庇佑。它同時提高角色攻擊與減傷，效果只在幽影之地生效。", "靈灰庇佑用另一種資源強化召喚協助，可與幽影樹庇佑同時生效。回本篇後不會享有這兩種區域加成。"], guide: [
            GuideSection(title: "卡關時的檢查順序", text: "先回賜福看是否有尚未使用的碎片，再檢查武器強化與裝備重量。若是連續被兩下打倒，先改善生存條件；如果總在同一招死亡，再針對該招練習，不必每次都急著打完整場。"),
        ], sourceIDs: ["official"], spoiler: false),
        Entry(id: "plain", title: "墓地平原：先拿這幾處碎片", subtitle: "三叉口 → 正門前 → 慰藉教堂", category: "幽影之地", image: "scene2", symbol: "mountain.2.fill", paragraphs: ["開局不必先挑戰路上的大型敵人。這一頁整理三處容易辨認的碎片地標，先提升庇佑，再決定要往城鎮或城砦走。"], guide: [
            GuideSection(title: "1｜三叉口的十字記號", text: "從墓地平原向北找米凱拉的十字記號。附近可遇到弗蕾亞與角人；碎片就在十字記號旁。先開賜福，順便與 NPC 說話。"),
            GuideSection(title: "2｜正門前的十字記號", text: "由三叉口往西穿過大型門洞，抵達正門前的十字記號。安帕赫與穆爾在這附近，十字記號旁也有一片碎片。"),
            GuideSection(title: "3｜慰藉教堂", text: "回到平原東南側找慰藉教堂，教堂內的瑪莉卡雕像前可一次取得兩片。附近有黑騎士，不必先擊敗它才能拾取；拿到資源後可先離開。"),
            GuideSection(title: "再補一處：火吻廢墟東側", text: "從火吻廢墟北側的賜福向東，到懸崖附近的墓地找頭頂發光壺的影子敵人。擊敗它可取得碎片。不要只沿大道跑，這種持壺敵人也可能帶著重要資源。"),
        ], sourceIDs: ["fragments"], spoiler: false),
        Entry(id: "castle", title: "主線先看方向，再決定去哪裡", subtitle: "城砦、幽影城與勞弗古遺跡", category: "幽影之地", image: "scene3", symbol: "building.columns.fill", paragraphs: ["想知道下一步去哪裡，可以把主線拆成「前期探索」「幽影城」「勞弗古遺跡」「最後區域」四段。完整路線會提到後期頭目與區域入口，預設收起。"], guide: [
            GuideSection(title: "路線骨架", text: "一條常見推進路線是墓地平原 → 恩希斯城砦 → 幽影亞壇 → 幽影城。進入幽影城後，以物種保藏庫作為往上探索的中心，目標是梅瑟莫的暗室。這是參考路線，不是全支線清單。"),
            GuideSection(title: "取得火種之後", text: "擊敗梅瑟莫取得火種，再由幽影城西側前往勞弗古遺跡，推進到花蕾教堂。擊敗蘿蜜娜後，可使用火種燃燒教堂後方的封印樹，開啟通往艾尼爾・伊利姆的後期流程。"),
            GuideSection(title: "先別急著燒樹", text: "燃燒封印樹會截斷多條 NPC 支線。即使還能回頭逛地圖，也不代表任務仍能繼續。若還沒檢查安帕赫、弗蕾亞與休里耶的進度，先停在這裡。"),
        ], sourceIDs: ["route"], spoiler: false),
        Entry(id: "weapons", title: "前期新武器：仕女劍與大刀", subtitle: "先拿到、試招，再投入鍛造石", category: "戰鬥筆記", image: "scene5", symbol: "shield.lefthalf.filled", paragraphs: ["想試 DLC 的新武器類型，前期就有仕女劍與大刀可拿。本頁只列兩把的取得方向，避免把整篇變成看不完的武器排名。"], guide: [
            GuideSection(title: "仕女劍 Milady｜恩希斯城砦", text: "從城砦入口往內探索，找可爬梯上去的小塔；塔頂寶箱就是仕女劍。它屬於輕大劍，適合想保留劍身長度、又想試較流暢連段的人。"),
            GuideSection(title: "大刀 Great Katana｜墓地平原湖區", text: "到平原北側、幽火龍棲息的湖區，找龍旁的屍體拾取。武器本身是地面拾取物，不必先擊敗龍。靠近時先規劃離開方向，別拿到武器後停在原地看數值。"),
            GuideSection(title: "拿到後先做什麼", text: "先在安全處確認能力需求、普通攻擊與重攻擊。這裡不把「排行很高」當成推薦理由；如果動作不合手，先保留強化素材，比硬換整套配點省事。"),
        ], sourceIDs: ["weapons"], spoiler: false),
        Entry(id: "rellana", title: "「雙月騎士」蕾菈娜", subtitle: "兩顆月亮落地後，還有第三次衝擊", category: "戰鬥筆記", image: "scene3", symbol: "moon.stars.fill", paragraphs: ["蕾菈娜在恩希斯城砦尾端，使用雙劍與魔法。這場最容易出問題的是把短暫停頓誤認成連段結束，或只閃過前兩次月亮衝擊。"], guide: [
            GuideSection(title: "進霧門前", text: "準備魔力與火焰減傷。若本來就有強化過的雷屬性手段，可以帶入測試；不必為了一場戰鬥臨時把陌生武器升滿。"),
            GuideSection(title: "一階段：先確定收招", text: "近身繞到側後方找空檔，整段揮砍結束後才回擊。若自己的攻擊出手較慢，先打一擊就停，避免用第二擊交換她下一段連招。"),
            GuideSection(title: "二階段：雙月不是兩次就結束", text: "雙月落地會先後產生衝擊波，接著還有她本人落地的第三次。看到升空先拉開一點距離，依三次落地節奏逐次跳起；別看到第二顆月亮炸完就衝上去喝水或追擊。"),
            GuideSection(title: "火焰與魔力長劍", text: "進二階段後保留中距離觀察。火焰旋轉與魔力長劍尚未結束時不搶傷害，等整招收完再接近。"),
        ], sourceIDs: ["rellana"], spoiler: false),
        Entry(id: "messmer", title: "「穿刺者」梅瑟莫", subtitle: "把落地與爆炸分成兩次閃避", category: "戰鬥筆記", image: "scene4", symbol: "flame.fill", paragraphs: ["這場在幽影城深處。長槍、延遲攻擊與火焰效果會讓人提早翻滾；完整攻略包含二階段蛇形態，解鎖後再閱讀。"], guide: [
            GuideSection(title: "開場火球：別只滾一次", text: "升空火球的落地衝撞與後續爆炸是兩個時機。先閃落地，再閃延遲爆炸；確認爆炸結束後，才把這段硬直拿來補血或回擊。"),
            GuideSection(title: "長槍連段：看武器，不看火光", text: "被第一下打中後先保留精力處理後續，不急著補血。短暫停頓可能接下一次刺擊；等連段完全收招再用短攻擊反擊。"),
            GuideSection(title: "半血後：蛇頭才是判斷點", text: "二階段會加入大蛇突進與多蛇連咬。對準蛇頭接近的時機向側面閃，不要只盯人形本體；多蛇攻擊還沒結束就追擊，很容易被後續長槍與地面噴發接住。"),
            GuideSection(title: "腳下出現黑色區域", text: "先移開腳下的黑色區域，避免從地面竄出的蛇。遠距離施法也不能當成安全區；如果召喚物倒下，先改用收招較快的攻擊，別硬放長時間法術。"),
        ], sourceIDs: ["messmer"], spoiler: false),
        Entry(id: "miquella", title: "NPC 支線：燒樹前先停一下", subtitle: "最晚確認點，比逐個猜結局更實用", category: "故事線索", image: "scene6", symbol: "person.2.fill", paragraphs: ["如果想看 NPC 的後續，主線跑得快不一定省時間。這頁保留一個明確檢查點：當你已能燃燒花蕾教堂後方的封印樹，先不要立刻互動。"], guide: [
            GuideSection(title: "檢查三條線", text: "先確認安帕赫、弗蕾亞與休里耶的對話、交付與後續事件是否完成。各人的觸發步驟不同；本頁只提醒確認時機，完整交付順序請開啟下方原攻略的支線連結核對。"),
            GuideSection(title: "已經燒了，還能補嗎？", text: "多條支線會在此推進或中斷，不能靠傳送回原地保證補回。若重要 NPC 已離開，不要把地圖仍可探索誤當成任務仍可補做。下方來源含任務與結局劇透。"),
        ], sourceIDs: ["route"], spoiler: false),
        Entry(id: "story", title: "封印樹之後的流程", subtitle: "艾尼爾・伊利姆與終點前的準備", category: "故事線索", image: "cover", symbol: "door.left.hand.open", paragraphs: ["本章整理燃燒封印樹之後的進度，包含後期區域與戰鬥資訊。"], guide: [
            GuideSection(title: "前往艾尼爾・伊利姆", text: "燃燒封印樹後，沿最後區域繼續前進。這不是只打一場頭目的短走廊；先開賜福、整理補給，再處理後續 NPC 戰鬥。"),
            GuideSection(title: "進最後戰場前", text: "先回頭補庇佑、檢查減傷與快捷道具。已完成相關支線時，最終戰可出現安帕赫與休里耶的召喚選項；若沒有符號，先核對任務條件，不要假設所有存檔都會出現。"),
        ], sourceIDs: ["route", "radahn"], spoiler: true),
        Entry(id: "radahn", title: "「約定之王」拉塔恩", subtitle: "二階段要一起處理刀與聖光", category: "戰鬥筆記", image: "cover", symbol: "sun.max.trianglebadge.exclamationmark", paragraphs: ["這是 DLC 最終頭目，地點在艾尼爾・伊利姆。二階段米凱拉會加入戰鬥，原本的近戰攻擊會帶上聖屬性追擊。"], guide: [
            GuideSection(title: "裝備先處理物理與聖減傷", text: "準備物理與聖屬性防禦；若已取得黃金編髮，可作為聖減傷選項。庇佑不足時先回去補碎片，不必把攻略作者通關時的等級當成硬門檻。"),
            GuideSection(title: "近戰：翻過第一刀還不算安全", text: "以整段連擊為單位判斷。可嘗試向頭目方向翻過揮砍，避免一味向後滾被後續追上；二階段同時留意刀後的光柱，不能沿用「刀沒打中就立刻喝水」的習慣。"),
            GuideSection(title: "擁抱：第二次會直接失敗", text: "被米凱拉的擁抱抓到一次後，即使沒有立刻扣血，也不是沒事。再次被抓會因心被偷走而落敗；看到抓取起手優先閃避，不用格擋硬接。"),
            GuideSection(title: "閱讀舊攻略時留意版本", text: "1.14 已調整最終頭目的開場行為、部分招式、傷害與特效。GameSpot 原文寫於 2024 年 6 月，本頁沒有沿用「開場一定出某招」的說法。實際節奏以目前安裝版本為準。"),
        ], sourceIDs: ["radahn", "patch"], spoiler: true),
    ]
}

final class ReadingStore: ObservableObject {
    @Published var bookmarks: Set<String> {
        didSet { UserDefaults.standard.set(Array(bookmarks), forKey: "bookmarks") }
    }
    init() { bookmarks = Set(UserDefaults.standard.stringArray(forKey: "bookmarks") ?? []) }
    func toggle(_ entry: Entry) {
        if bookmarks.contains(entry.id) { bookmarks.remove(entry.id) } else { bookmarks.insert(entry.id) }
    }
}
