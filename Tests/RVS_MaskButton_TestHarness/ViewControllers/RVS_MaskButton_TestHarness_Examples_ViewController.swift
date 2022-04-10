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

/* ###################################################################################################################################### */
// MARK: - The Tab 0 (Examples) View Controller Class -
/* ###################################################################################################################################### */
/**
 This tab presents the control in a few configurations.
 */
class RVS_MaskButton_TestHarness_Examples_ViewController: RVS_MaskButton_TestHarness_TabBase_ViewController {
    /* ################################################################## */
    /**
     This sets the various controls up to our initial default.
     */
    override func overrideThisAndSetUpTheScreenAccordingToTheSettings() {
        super.overrideThisAndSetUpTheScreenAccordingToTheSettings()
    }
}

/* ###################################################################################################################################### */
// MARK: Base Class Overrides
/* ###################################################################################################################################### */
extension RVS_MaskButton_TestHarness_Examples_ViewController {
    /* ################################################################## */
    /**
     Called when the view hierarchy has been initialized. We use this to set the control states, and apply localization.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /* ################################################################## */
    /**
     Called just before the view appears. We use this to set the display to a standard starting point.
     
     - parameter inIsAnimated: True, if the appearance will be animated.
     */
    override func viewWillAppear(_ inIsAnimated: Bool) {
        super.viewWillAppear(inIsAnimated)
        overrideThisAndSetUpTheScreenAccordingToTheSettings()
    }
}
