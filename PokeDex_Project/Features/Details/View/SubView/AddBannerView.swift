//
//  AddBannerView.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 5/27/24.
//

import Foundation
import GoogleMobileAds
import SwiftUI

/// 구글 AdsMob 뷰
struct AdBannerView: UIViewRepresentable {
    let adUnitID: String

    func makeUIView(context: Context) -> GADBannerView {
        let bannerView = GADBannerView(adSize: GADAdSizeFromCGSize(CGSize(width: UIScreen.main.bounds.width, height: 50)))
        let viewController = UIViewController()
        
        bannerView.rootViewController = viewController
        bannerView.load(GADRequest())
        bannerView.adUnitID = adUnitID
        
        return bannerView
    }
    
    func updateUIView(_ uiView: GADBannerView, context: Context) {}
}

