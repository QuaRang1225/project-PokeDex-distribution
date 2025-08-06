//
//  config.swift
//  PokeDex_Project
//
//  Created by Quarang on 7/16/25.
//

import Foundation

/// xcconfig 파일에 있는 내용 변수로 설정
struct Config {
    static let awsURL = "http://\(Bundle.main.infoDictionary!["AWS_URL"] as! String)"
    static let localURL = "http://\(Bundle.main.infoDictionary!["LOCAL_URL"] as! String)"
    static let sdkId = Bundle.main.infoDictionary!["SDK_ID"] as! String
    static let adsmobId = Bundle.main.infoDictionary!["ADSMOB_ID"] as! String
}
