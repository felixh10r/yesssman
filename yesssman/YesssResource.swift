//
//  YesssResource.swift
//  yesssman
//
//  Created by Felix on 21.12.19.
//  Copyright © 2019 scale. All rights reserved.
//

import SwiftUI
import UIKit

final class YesssResource: ObservableObject {
    @Published var data: QuotaData? = nil

    init() {
        YesssService().getCurrentQuota { data in
            DispatchQueue.main.async {
                self.data = data
            }
        }
    }
}
