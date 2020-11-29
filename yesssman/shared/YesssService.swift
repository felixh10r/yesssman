//
//  YesssService.swift
//  yesssman
//
//  Created by Felix on 21.12.19.
//  Copyright © 2019 scale. All rights reserved.
//

import Foundation
import SwiftSoup

struct QuotaData {
    var free: Int
    var total: Int
}

private func getHtml(completionHandler: @escaping (String?) -> Void) {
//    let credentials = NSDictionary(contentsOfFile: Bundle.main.path(forResource: "Credentials", ofType: "plist")!)!
    
//    let username = credentials["login_rufnummer"]!
//    let password = credentials["login_passwort"]!
    let Url = String(format: "https://www.yesss.at/kontomanager.at/index.php")

    guard
        let serviceUrl = URL(string: Url),
        let username = UserDefaults(suiteName: "group.at.scale.yesssman")?.string(forKey: "phoneNumber"),
        let password = UserDefaults(suiteName: "group.at.scale.yesssman")?.string(forKey: "password")
    else {
        completionHandler(nil)
        return
    }
    
    var request = URLRequest(url: serviceUrl)
    request.httpMethod = "POST"
    request.httpBody = "login_rufnummer=\(username)&login_passwort=\(password)".data(using: String.Encoding.utf8)!

    let session = URLSession.shared
    
    session.dataTask(with: request) { data, _, _ in
        if let data = data {
            completionHandler(String(data: data, encoding: .utf8)!)
        } else {
            completionHandler(nil)
        }
    }.resume()
}

class YesssService {
    func getCurrentQuota(completionHandler: @escaping ((QuotaData?) -> Void)) {
        getHtml {
            guard let str = $0 else {
                completionHandler(nil)
                return
            }
            
            do {
                let doc = try SwiftSoup.parse(str)

                guard
                    let row = try doc
                    .select(".progress-list")
                    .first()?
                    .select(".progress-item")
                    .eq(1),
                    let free = try row
                    .select(".bar-label-right")
                    .first()?
                    .text()
                    .replacingOccurrences(of: "Verbleibend: ", with: ""),
                    let total = try row
                    .select(".progress-heading.right")
                    .first()?
                    .text()
                    .replacingOccurrences(of: " MB", with: ""),
                    let freeInt = Int(free),
                    let totalInt = Int(total)
                else {
                    completionHandler(nil)
                    return
                }

                completionHandler(QuotaData(free: freeInt, total: totalInt))
            } catch {
                completionHandler(nil)
                print(error)
            }
        }
    }
}
