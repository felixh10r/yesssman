//
//  yesssman_widget.swift
//  yesssman-widget
//
//  Created by Felix on 28.11.20.
//  Copyright © 2020 scale. All rights reserved.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    let service = YesssService()
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), result: "placeholder", data: nil)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        if context.isPreview {
            completion(SimpleEntry(date: Date(), result: "isPreview", data: QuotaData(free: 14_000, total: 20_000)))
            return
        }
        
        service.getCurrentQuota {
            completion(SimpleEntry(date: Date(), result: "quota", data: $0))
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        let date = Date()
        let nextUpdateDate = Calendar.current.date(byAdding: .hour, value: 1, to: date)!

        service.getCurrentQuota {
            let entry = SimpleEntry(
                date: date,
                result: "timeline",
                data: $0
            )

            let timeline = Timeline(
                entries: [entry],
                policy: .after(nextUpdateDate)
            )

            completion(timeline)
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let result: String
    let data: QuotaData?
}

struct yesssman_widgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        let free = entry.data?.free ?? 50_000
        let total = entry.data?.total ?? 100_000
        let used = total - free
        let ratio = CGFloat(used) / CGFloat(total)
                        
        ZStack {
            GeometryReader { geometry in
                Rectangle()
                    .frame(
                        width: geometry.size.width,
                        height: geometry.size.height
                    )
                    .foregroundColor(
                        Color(UIColor.systemGreen).opacity(0.6)
                    )
                    

                Rectangle()
                    .frame(
                        width: geometry.size.width * ratio,
                        height: geometry.size.height
                    )
                    .foregroundColor(Color(UIColor.systemRed).opacity(0.8))
            }
        }
        .foregroundColor(Color(UIColor.systemFill).opacity(0.1))
        .cornerRadius(20.0)
    }
}

@main
struct yesssman_widget: Widget {
    let kind: String = "yesssman_widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            yesssman_widgetEntryView(entry: entry)
        }
        .supportedFamilies([.systemMedium])
        .configurationDisplayName("yesssman")
        .description("See your current data!")
    }
}

struct yesssman_widget_Previews: PreviewProvider {
    static var previews: some View {
        yesssman_widgetEntryView(entry: SimpleEntry(date: Date(), result: "prev", data: nil))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
