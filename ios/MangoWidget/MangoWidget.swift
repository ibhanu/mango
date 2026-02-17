import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), affirmation: "Deep breaths. You've got this.", category: "Mango", streak: 1, mascotName: "Seedling", mascotAsset: "", consistency: 0.5, activity: "1011101")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), affirmation: "Deep breaths. You've got this.", category: "Mango", streak: 1, mascotName: "Seedling", mascotAsset: "", consistency: 0.5, activity: "1011101")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let userDefaults = UserDefaults(suiteName: "group.com.affirmation.mango.18A6A43D")
        let category = userDefaults?.string(forKey: "category_text") ?? "Mango"
        let streak = userDefaults?.integer(forKey: "daily_streak") ?? 1
        let mascotName = userDefaults?.string(forKey: "evolution_name") ?? "Seedling"
        let mascotAsset = userDefaults?.string(forKey: "mascot_asset") ?? ""
        let consistency = userDefaults?.double(forKey: "monthly_consistency") ?? 0.0
        let activity = userDefaults?.string(forKey: "activity_7days") ?? "0000000"
        
        // Get the list of affirmations for cycling
        let affirmationsString = userDefaults?.string(forKey: "affirmations_list") ?? ""
        let affirmations = affirmationsString.isEmpty 
            ? ["Deep breaths. You've got this."] 
            : affirmationsString.components(separatedBy: "|||")
        
        var entries: [SimpleEntry] = []
        let currentDate = Date()
        
        // Generate entries for the next 12 hours (one per hour)
        for hourOffset in 0..<min(12, affirmations.count) {
            guard let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate) else { continue }
            let affirmationIndex = hourOffset % affirmations.count
            let entry = SimpleEntry(
                date: entryDate,
                affirmation: affirmations[affirmationIndex],
                category: category,
                streak: streak,
                mascotName: mascotName,
                mascotAsset: mascotAsset,
                consistency: consistency,
                activity: activity
            )
            entries.append(entry)
        }
        
        // If no entries were created, add a fallback
        if entries.isEmpty {
            let fallback = userDefaults?.string(forKey: "affirmation_text") ?? "Deep breaths. You've got this."
            entries.append(SimpleEntry(date: currentDate, affirmation: fallback, category: category, streak: streak, mascotName: mascotName, mascotAsset: mascotAsset, consistency: consistency, activity: activity))
        }
        
        // Request refresh after 12 hours
        let nextUpdate = Calendar.current.date(byAdding: .hour, value: 12, to: currentDate) ?? currentDate.addingTimeInterval(43200)
        let timeline = Timeline(entries: entries, policy: .after(nextUpdate))
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let affirmation: String
    let category: String
    let streak: Int
    let mascotName: String
    let mascotAsset: String
    let consistency: Double
    let activity: String
}

struct MangoWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        ZStack {
            // Background logic: Only show LuxuryBackground for Home Screen widgets
            if !isAccessoryFamily {
                LuxuryBackground()
            }
            
            VStack {
                switch family {
                case .accessoryCircular:
                    AccessoryCircularView(entry: entry)
                case .accessoryRectangular:
                    AccessoryRectangularView(entry: entry)
                case .accessoryInline:
                    AccessoryInlineView(entry: entry)
                default:
                    MainWidgetContent(entry: entry, isSmall: family == .systemSmall, theme: .mango)
                }
            }
        }
    }
    
    private var isAccessoryFamily: Bool {
        family == .accessoryCircular || family == .accessoryRectangular || family == .accessoryInline
    }
}

struct LuxuryBackground: View {
    var body: some View {
        ZStack {
            // Base luxury gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.16, green: 0.12, blue: 0.11), 
                    Color(red: 0.08, green: 0.06, blue: 0.05)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            // Soft glowing "Halo" to light up the day
            RadialGradient(
                gradient: Gradient(colors: [
                    Color(red: 1.0, green: 0.7, blue: 0.4).opacity(0.15),
                    Color.clear
                ]),
                center: .topTrailing,
                startRadius: 0,
                endRadius: 200
            )
            
            // Subtle ambient light
            RadialGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.4, green: 0.5, blue: 1.0).opacity(0.1),
                    Color.clear
                ]),
                center: .bottomLeading,
                startRadius: 0,
                endRadius: 150
            )
        }
    }
}

// MARK: - Theme Enum for MainWidgetContent
enum WidgetTheme {
    case mango, ocean, forest
    
    var accentColor: Color {
        switch self {
        case .mango: return Color(red: 1.0, green: 0.7, blue: 0.4)
        case .ocean: return Color(red: 0.4, green: 0.7, blue: 1.0)
        case .forest: return Color(red: 0.5, green: 0.8, blue: 0.5)
        }
    }
}

struct MainWidgetContent: View {
    var entry: SimpleEntry
    var isSmall: Bool
    var theme: WidgetTheme = .mango
    
    var body: some View {
        VStack(spacing: isSmall ? 10 : 14) {
            // Glass Container for Text
            VStack(spacing: 8) {
                Text(entry.affirmation)
                    .font(.system(size: isSmall ? 17 : 24, weight: .medium, design: .serif))
                    .italic()
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .lineLimit(isSmall ? 4 : 3)
                    .minimumScaleFactor(0.7)
                    .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
                
                HStack(spacing: 6) {
                    Rectangle()
                        .frame(width: 8, height: 1)
                        .foregroundColor(.white.opacity(0.3))
                    
                    Text(entry.category.uppercased())
                        .font(.system(size: isSmall ? 8 : 10, weight: .bold))
                        .tracking(3)
                        .foregroundColor(Color.white.opacity(0.5))
                    
                    Rectangle()
                        .frame(width: 8, height: 1)
                        .foregroundColor(.white.opacity(0.3))
                }
                
                // Mascot Evolution Name
                Text(entry.mascotName)
                    .font(.system(size: 10, weight: .semibold, design: .rounded))
                    .foregroundColor(Color(red: 1.0, green: 0.7, blue: 0.4).opacity(0.8))
                    .padding(.top, 4)
            }
            .padding(isSmall ? 16 : 24)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.white.opacity(0.06))
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
                    )
            )
            .padding(isSmall ? 10 : 16)
        }
    }
}

struct AccessoryCircularView: View {
    var entry: SimpleEntry
    var body: some View {
        ZStack {
            AccessoryWidgetBackground()
            VStack(spacing: -2) {
                Text("🥭")
                    .font(.system(size: 20))
                Text("\(entry.streak)")
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                Text(entry.mascotName)
                    .font(.system(size: 8, weight: .medium))
                    .opacity(0.8)
            }
        }
    }
}

struct AccessoryRectangularView: View {
    var entry: SimpleEntry
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            VStack {
                Text("🥭")
                    .font(.system(size: 14))
                    .padding(.top, 2)
            }
            
            VStack(alignment: .leading, spacing: 0) {
                Text(entry.affirmation)
                    .font(.system(size: 15, weight: .medium, design: .serif))
                    .italic()
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
                
                Text(entry.category.uppercased())
                    .font(.system(size: 8, weight: .heavy))
                    .tracking(2)
                    .foregroundColor(.secondary)
                    .padding(.top, 2)
            }
        }
    }
}

struct AccessoryInlineView: View {
    var entry: SimpleEntry
    var body: some View {
        ViewThatFits {
            Text("🥭 \(entry.affirmation)")
            Text(entry.affirmation)
        }
    }
}

struct MangoWidget: Widget {
    let kind: String = "MangoWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            MangoWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .contentMarginsDisabled()
        .configurationDisplayName("Mango Classic")
        .description("Warm luxury affirmations with mango theme.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge, .accessoryCircular, .accessoryRectangular, .accessoryInline])
    }
}

// MARK: - Ocean Theme Widget
struct OceanWidgetEntryView: View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        ZStack {
            if !isAccessoryFamily {
                OceanBackground()
            }
            MainWidgetContent(entry: entry, isSmall: family == .systemSmall, theme: .ocean)
        }
    }
    
    private var isAccessoryFamily: Bool {
        family == .accessoryCircular || family == .accessoryRectangular || family == .accessoryInline
    }
}

struct OceanBackground: View {
    var body: some View {
        LinearGradient(
            colors: [Color(red: 0.1, green: 0.2, blue: 0.35), Color(red: 0.05, green: 0.1, blue: 0.2)],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

struct OceanWidget: Widget {
    let kind: String = "OceanWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            OceanWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .contentMarginsDisabled()
        .configurationDisplayName("Mango Ocean")
        .description("Calm ocean-themed affirmations.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

// MARK: - Forest Theme Widget
struct ForestWidgetEntryView: View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        ZStack {
            if !isAccessoryFamily {
                ForestBackground()
            }
            MainWidgetContent(entry: entry, isSmall: family == .systemSmall, theme: .forest)
        }
    }
    
    private var isAccessoryFamily: Bool {
        family == .accessoryCircular || family == .accessoryRectangular || family == .accessoryInline
    }
}

struct ForestBackground: View {
    var body: some View {
        LinearGradient(
            colors: [Color(red: 0.15, green: 0.25, blue: 0.15), Color(red: 0.05, green: 0.1, blue: 0.05)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

struct ForestWidget: Widget {
    let kind: String = "ForestWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            ForestWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .contentMarginsDisabled()
        .configurationDisplayName("Mango Forest")
        .description("Grounded forest-themed affirmations.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

// MARK: - Minimal Theme Widget  
struct MinimalWidgetEntryView: View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        ZStack {
            if !isAccessoryFamily {
                Color.black
            }
            MinimalContent(entry: entry, isSmall: family == .systemSmall)
        }
    }
    
    private var isAccessoryFamily: Bool {
        family == .accessoryCircular || family == .accessoryRectangular || family == .accessoryInline
    }
}

struct MinimalContent: View {
    var entry: SimpleEntry
    var isSmall: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(entry.affirmation)
                .font(.system(size: isSmall ? 16 : 22, weight: .light, design: .default))
                .foregroundColor(.white)
                .lineLimit(isSmall ? 4 : 3)
                .minimumScaleFactor(0.7)
            
            Spacer()
            
            HStack {
                Text("🥭")
                    .font(.system(size: 12))
                Text(entry.category.uppercased())
                    .font(.system(size: 9, weight: .medium))
                    .tracking(2)
                    .foregroundColor(.white.opacity(0.5))
            }
        }
        .padding(isSmall ? 16 : 20)
    }
}

struct MinimalWidget: Widget {
    let kind: String = "MinimalWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            MinimalWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .contentMarginsDisabled()
        .configurationDisplayName("Mango Minimal")
        .description("Clean, minimal left-aligned affirmations.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

// MARK: - Widget Bundle
@main
struct MangoWidgetBundle: WidgetBundle {
    var body: some Widget {
        MangoWidget()
        OceanWidget()
        ForestWidget()
        MinimalWidget()
        StreakWidget()
    }
}

// MARK: - Dedicated Streak Widget
struct StreakWidget: Widget {
    let kind: String = "StreakWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            StreakWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .contentMarginsDisabled()
        .configurationDisplayName("Mango Streak")
        .description("Track your mindfulness streak and consistency.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct StreakWidgetEntryView: View {
    var entry: SimpleEntry
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        ZStack {
            LuxuryBackground()
            
            if family == .systemSmall {
                SmallStreakView(entry: entry)
            } else {
                MediumStreakView(entry: entry)
            }
        }
    }
}

struct SmallStreakView: View {
    var entry: SimpleEntry
    
    var body: some View {
        VStack(spacing: 8) {
            Text("🔥")
                .font(.system(size: 32))
                .shadow(radius: 4)
            
            Text("\(entry.streak)")
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            
            Text("DAY STREAK")
                .font(.system(size: 10, weight: .heavy))
                .tracking(2)
                .foregroundColor(Color(red: 1.0, green: 0.7, blue: 0.4))
            
            // Progress Bar
            ProgressView(value: entry.consistency)
                .progressViewStyle(LinearProgressViewStyle(tint: Color(red: 1.0, green: 0.7, blue: 0.4)))
                .scaleEffect(x: 1, y: 0.5, anchor: .center)
                .padding(.horizontal, 20)
                .padding(.top, 4)
        }
    }
}

struct MediumStreakView: View {
    var entry: SimpleEntry
    
    var body: some View {
        HStack(spacing: 20) {
            // Left: Big Streak
            VStack(spacing: 4) {
                Text("🔥")
                    .font(.system(size: 40))
                Text("\(entry.streak)")
                    .font(.system(size: 44, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                Text("DAYS")
                    .font(.system(size: 12, weight: .heavy))
                    .tracking(2)
                    .foregroundColor(Color(red: 1.0, green: 0.7, blue: 0.4))
            }
            .frame(width: 100)
            
            // Right: Activity Chart
            VStack(alignment: .leading, spacing: 12) {
                Text("LAST 7 DAYS")
                    .font(.system(size: 10, weight: .bold))
                    .tracking(1)
                    .foregroundColor(.white.opacity(0.6))
                
                HStack(spacing: 8) {
                    let chars = Array(entry.activity)
                    ForEach(0..<chars.count, id: \.self) { i in
                        VStack(spacing: 4) {
                            Circle()
                                .fill(chars[i] == "1" ? Color(red: 1.0, green: 0.7, blue: 0.4) : Color.white.opacity(0.1))
                                .frame(width: 12, height: 12)
                            
                            Text(dayName(for: i))
                                .font(.system(size: 8, weight: .medium))
                                .foregroundColor(.white.opacity(0.4))
                        }
                    }
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("MONTHLY CONSISTENCY")
                        .font(.system(size: 8, weight: .bold))
                        .foregroundColor(.white.opacity(0.5))
                    
                    HStack {
                        ProgressView(value: entry.consistency)
                            .progressViewStyle(LinearProgressViewStyle(tint: Color(red: 1.0, green: 0.7, blue: 0.4)))
                        
                        Text("\(Int(entry.consistency * 100))%")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(.vertical, 16)
        }
        .padding(.horizontal, 16)
    }
    
    func dayName(for index: Int) -> String {
        let days = ["M", "T", "W", "T", "F", "S", "S"]
        // This is a simplification, but good for visualization
        return days[index % 7]
    }
}
