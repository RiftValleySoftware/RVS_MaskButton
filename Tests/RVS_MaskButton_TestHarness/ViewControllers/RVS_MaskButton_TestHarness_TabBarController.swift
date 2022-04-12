/**
 © Copyright 2022, The Great Rift Valley Software Company

 LICENSE:

 MIT License

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy,
 modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
 CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

 The Great Rift Valley Software Company: https://riftvalleysoftware.com
*/

import UIKit
import RVS_Generic_Swift_Toolbox

/* ###################################################################################################################################### */
// MARK: - Main Tab Bar Controller Class -
/* ###################################################################################################################################### */
/**
 We subclass the tab bar controller, in order to do a small amount of customization and localization.
 */
class RVS_MaskButton_TestHarness_TabBarController: UITabBarController {
    /* ################################################################## */
    /**
     We overload the `viewDidLoad()` method, in order to localize the tab names, and set the colors for the tab bar.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        let normalColor: UIColor = UIColor(named: "AccentColor") ?? .white
        let selectedColor: UIColor = .label

        let normalTextAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: normalColor]
        let selectedTextAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: selectedColor]

        // This is a personal preference. I like selected tabs to be in label color, and unselected ones, in action color.
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
