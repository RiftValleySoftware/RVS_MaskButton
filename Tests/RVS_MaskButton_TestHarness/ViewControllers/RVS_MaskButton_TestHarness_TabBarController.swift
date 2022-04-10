//
//  RVS_MaskButton_TestHarness_TabController.swift
//  RVS_MaskButton_TestHarness
//
//  Created by Chris Marshall on 4/10/22.
//

import UIKit
import RVS_Generic_Swift_Toolbox

class RVS_MaskButton_TestHarness_TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let normalColor: UIColor = UIColor(named: "AccentColor") ?? .white
        let selectedColor: UIColor = .label

        let normalTextAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: normalColor]
        let selectedTextAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: selectedColor]

        let appearance = UITabBarAppearance()
        appearance.stackedLayoutAppearance.normal.iconColor = normalColor
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = normalTextAttributes
        appearance.stackedLayoutAppearance.selected.iconColor = selectedColor
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = selectedTextAttributes
        appearance.inlineLayoutAppearance.normal.iconColor = normalColor
        appearance.inlineLayoutAppearance.normal.titleTextAttributes = normalTextAttributes
        appearance.inlineLayoutAppearance.selected.iconColor = selectedColor
        appearance.inlineLayoutAppearance.selected.titleTextAttributes = selectedTextAttributes
        appearance.compactInlineLayoutAppearance.normal.iconColor = normalColor
        appearance.compactInlineLayoutAppearance.normal.titleTextAttributes = normalTextAttributes
        appearance.compactInlineLayoutAppearance.selected.iconColor = selectedColor
        appearance.compactInlineLayoutAppearance.selected.titleTextAttributes = selectedTextAttributes

        tabBar.standardAppearance = appearance
        tabBar.itemPositioning = .centered
        tabBar.items?.forEach { $0.title = $0.title?.localizedVariant }
    }
}
