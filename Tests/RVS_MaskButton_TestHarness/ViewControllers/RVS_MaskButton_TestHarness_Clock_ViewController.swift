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
import RVS_MaskButton

/* ###################################################################################################################################### */
// MARK: - The Tab 1 (Clock) View Controller Class -
/* ###################################################################################################################################### */
/**
 This tab presents the control as a digital clock.
 */
class RVS_MaskButton_TestHarness_Clock_ViewController: UIViewController {
    /* ################################################################################################################################## */
    // MARK: The Indexes of the Segmented Switch That Controls Presentation
    /* ################################################################################################################################## */
    /**
     This tab presents the control as a digital clock.
     */
    enum SegmentedSwitchOffsets: Int {
        /// This renders the buttons as normal "Filled Content."
        case normal
        
        /// This renders the buttons as reversed ("Content Cutout From Background")
        case reversed
    }
    
    /* ################################################################## */
    /**
     This segmented switch allows us to switch between normal and reverse cutout mode.
     */
    @IBOutlet weak var normalReverseSegmentedSwitch: UISegmentedControl?

    /* ################################################################## */
    /**
     This switch selects the tint color to use for the gradient start
     */
    @IBOutlet weak var startTintSelectorSegmentedSwitch: UISegmentedControl?

    /* ################################################################## */
    /**
     This switch selects the tint color to use for the gradient end
     */
    @IBOutlet weak var endTintSelectorSegmentedSwitch: UISegmentedControl?

    /* ################################################################## */
    /**
     This is the main digital clock button.
     */
    @IBOutlet weak var digitalClockButton: RVS_MaskButton?
}

/* ###################################################################################################################################### */
// MARK: Instance Methods
/* ###################################################################################################################################### */
extension RVS_MaskButton_TestHarness_Clock_ViewController {
    /* ################################################################## */
    /**
     This checks the `tintSelectorSegmentedSwitch`, and sets the appropriate color for the
     control, based on its value.
     */
    func setSegmentedTintSelect(for inTintSlectorSegmentedSwitch: UISegmentedControl) {
        // Set up the little tint squares for the tint selector control.
        if let image = UIImage(systemName: "square.slash")?.withTintColor(.label) {
            inTintSlectorSegmentedSwitch.setImage(image.withRenderingMode(.alwaysOriginal), forSegmentAt: 0)
            inTintSlectorSegmentedSwitch.setEnabled(endTintSelectorSegmentedSwitch == inTintSlectorSegmentedSwitch, forSegmentAt: 0)
        }
        
        if let color = UIColor(named: "AccentColor"),
           let image = UIImage(systemName: "square.fill")?.withTintColor(color) {
            inTintSlectorSegmentedSwitch.setImage(image.withRenderingMode(.alwaysOriginal), forSegmentAt: 1)
        }
        
        for index in 2..<inTintSlectorSegmentedSwitch.numberOfSegments {
            if let color = UIColor(named: "Tint-\(index)"),
               let image = UIImage(systemName: "square.fill")?.withTintColor(color) {
                inTintSlectorSegmentedSwitch.setImage(image.withRenderingMode(.alwaysOriginal), forSegmentAt: index)
            }
        }
    }
}

/* ###################################################################################################################################### */
// MARK: Base Class Overrides
/* ###################################################################################################################################### */
extension RVS_MaskButton_TestHarness_Clock_ViewController {
    /* ################################################################## */
    /**
     Called when the view loads. Allows us to set up the localization and controls.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        if let count = normalReverseSegmentedSwitch?.numberOfSegments {
            for index in (0..<count) {
                if let title = normalReverseSegmentedSwitch?.titleForSegment(at: index) {
                    normalReverseSegmentedSwitch?.setTitle(title.localizedVariant, forSegmentAt: index)
                }
            }
        }
        
        if let startTintSelectorSegmentedSwitch = startTintSelectorSegmentedSwitch,
           let endTintSelectorSegmentedSwitch = endTintSelectorSegmentedSwitch {
            setSegmentedTintSelect(for: startTintSelectorSegmentedSwitch)
            setSegmentedTintSelect(for: endTintSelectorSegmentedSwitch)
            tintSegmentedSwitchHit(startTintSelectorSegmentedSwitch)
            tintSegmentedSwitchHit(endTintSelectorSegmentedSwitch)
        }
    }
}

/* ###################################################################################################################################### */
// MARK: Callbacks
/* ###################################################################################################################################### */
extension RVS_MaskButton_TestHarness_Clock_ViewController {
    /* ################################################################## */
    /**
     Called when the segmented switch, controlling the cutout method, is hit.
     
     - parameter inSegmentedSwitch: The switch instance.
     */
    @IBAction func normalReverseSegmentedSwitchHit(_ inSegmentedSwitch: UISegmentedControl) {
        digitalClockButton?.reversed = SegmentedSwitchOffsets.reversed.rawValue == inSegmentedSwitch.selectedSegmentIndex
    }
    
    /* ################################################################## */
    /**
     Called when the segmented switch, controlling the start color, is hit.
     
     - parameter inSegmentedSwitch: The switch instance.
     */
    @IBAction func tintSegmentedSwitchHit(_ inSegmentedSwitch: UISegmentedControl) {
        let index = inSegmentedSwitch.selectedSegmentIndex
        if let color = 0 == index ? nil : 1 == index ? UIColor(named: "AccentColor") : UIColor(named: "Tint-\(index)") {
            if startTintSelectorSegmentedSwitch == inSegmentedSwitch {
                digitalClockButton?.gradientStartColor = color
            } else {
                digitalClockButton?.gradientEndColor = color
            }
        }
    }

    /* ################################################################## */
    /**
     Called when the digital clock button is hit.
     
     - parameter inButton: The button instance.
     */
    @IBAction func digitalClockButtonHit(_ inButton: RVS_MaskButton) {
    }
}
