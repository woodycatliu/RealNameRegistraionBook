//
//  RealNameRegistraionBookWidget.swift
//  RealNameRegistraionBookWidget
//
//  Created by Woody Liu on 2021/10/29.
//

import WidgetKit
import SwiftUI
import Intents


struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct RealNameRegistraionBookWidgetEntryView : View {
    @Environment(\.widgetFamily)
    var family: WidgetFamily
    
    var entry: Provider.Entry

    var body: some View {
        switch family {
        case .systemSmall:
            SmallWidget(entry: entry)
        case .systemMedium:
            MediumWidget()
        default:
            Text(entry.date, style: .time)
        }
    }
    
}

@main
struct RealNameRegistraionBookWidget: Widget {
    let kind: String = "RealNameRegistraionBookWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            RealNameRegistraionBookWidgetEntryView(entry: entry)
        }
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct RealNameRegistraionBookWidget_Previews: PreviewProvider {
    static var previews: some View {
        RealNameRegistraionBookWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}



extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}


struct SmallWidget: View {
    
    static let formatter: DateFormatter = {
       let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "Asia/Taipei")
        formatter.dateFormat = "yyyy-MM-dd(EEE)"
        return formatter
    }()
    
    var entry: Provider.Entry
    
    var body: some View {
        Color.yellow
            .overlay(
                VStack {
                    Text(entry.date, formatter: SmallWidget.formatter)
                        .foregroundColor(.white)
                        .font(.subheadline)
                    Image(systemName: "qrcode.viewfinder")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(Color.init(hex: "EEEEEE"))
                        .scaledToFit()
                    Spacer()
                }
                    .padding(20)
            )
            .widgetURL(URL(string: "game://qrcode"))
    }
}

struct MediumWidget: View {
    
    // Color.init(hex: "373A40")
    // Color.init(hex: "686D76")
    
    var body: some View {
        HStack {
            Spacer()
            linkCreater(.main)
            Spacer()
            linkCreater(.qrcode)
            Spacer()
        }
        .padding()
        .background(Color.init(hex: "373A40"))
    }
    fileprivate func linkCreater(_ style: MediumWidget.Style) -> AnyView {
        return AnyView(Link(destination: style.url, label: {
            Circle()
                .fill(style.fillColor)
                .overlay(Circle()
                            .strokeBorder(style.borderColor))
                .padding(30)
                .overlay(Image(systemName: style.image)
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(Color.init(hex: "EEEEEE"))
                            .scaledToFit()
                            .padding(50))
        }))
    }
}

extension MediumWidget {
    enum Style {
        case qrcode
        case main
        
        var url: URL {
            switch self {
            case .qrcode:
                return URL(string: "game://qrcode")!
            case .main:
                return URL(string: "game://main")!
            }
        }
        
        var image: String {
            switch self {
            case .qrcode:
                return "qrcode"
            case .main:
                return "list.bullet.rectangle.portrait.fill"
            }
            
        }
        
        var fillColor: Color {
            switch self {
            case .qrcode:
                return Color.init(hex: "686D76")
            case .main:
                return Color.init(hex: "000000")
            }
        }
        
        var borderColor: Color {
            switch self {
            case .qrcode:
                return Color.init(hex: "000000")
            case .main:
                return Color.init(hex: "686D76")
            }
        }
    }
}
