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
// MARK: - The Tab 1 (Examples) View Controller Class -
/* ###################################################################################################################################### */
/**
 This tab presents the control in a few configurations.
 */
class RVS_MaskButton_TestHarness_Examples_ViewController: RVS_MaskButton_TestHarness_TabBase_ViewController {
    /* ################################################################## */
    /**
     */
    @IBOutlet weak var leftMaskButton: RVS_MaskButton?
    
    /* ################################################################## */
    /**
     */
    @IBOutlet weak var rightMaskButton: RVS_MaskButton?
    
    /* ################################################################## */
    /**
     This sets the various controls up to our initial default.
     */
    override func overrideThisAndSetUpTheScreenAccordingToTheSettings() {
        super.overrideThisAndSetUpTheScreenAccordingToTheSettings()
    }
    
    /* ################################################################## */
    /**
     This sets the colored squares for the given switch.
     */
    override func setSegmentedTintSelect(for inTintSlectorSegmentedSwitch: UISegmentedControl) {
        // Set up the little tint squares for the tint selector control.
        if let image = UIImage(systemName: "square.slash")?.withRenderingMode(.alwaysTemplate) {
            let displayImage = image.withTintColor(endTintSelectorSegmentedSwitch == inTintSlectorSegmentedSwitch ? .label : .label.withAlphaComponent(0.5))
            inTintSlectorSegmentedSwitch.setImage(displayImage, forSegmentAt: 0)
            // We don't allow nil to be enabled for the start color (causes an assertion).
            inTintSlectorSegmentedSwitch.setEnabled(endTintSelectorSegmentedSwitch == inTintSlectorSegmentedSwitch, forSegmentAt: 0)
        }
        
        if let image = UIImage(systemName: "square.fill")?.withTintColor(.white) {
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
extension RVS_MaskButton_TestHarness_Examples_ViewController {
    /* ################################################################## */
    /**
     Called when the view hierarchy has been initialized. We use this to set the control states, and apply localization.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        leftMaskButton?.setTitle((leftMaskButton?.title(for: .normal) ?? "ERROR").localizedVariant, for: .normal)
    }
    
    /* ################################################################## */
    /**
     Called just before the view appears. We use this to set the display to a standard starting point.
     
     - parameter inIsAnimated: True, if the appearance will be animated.
     */
    override func viewWillAppear(_ inIsAnimated: Bool) {
        super.viewWillAppear(inIsAnimated)
        normalReverseSegmentedSwitch?.selectedSegmentIndex = 1
        startTintSelectorSegmentedSwitch?.selectedSegmentIndex = 1
        endTintSelectorSegmentedSwitch?.selectedSegmentIndex = 0
        overrideThisAndSetUpTheScreenAccordingToTheSettings()
    }
    
    /* ################################################################## */
    /**
     Called when the segmented switch, controlling the cutout method, is hit.
     
     - parameter inSegmentedSwitch: The switch instance.
     */
    override func normalReverseSegmentedSwitchHit(_ inSegmentedSwitch: UISegmentedControl) {
        leftMaskButton?.reversed = ReversedSegmentedSwitchOffsets.reversed.rawValue == inSegmentedSwitch.selectedSegmentIndex
        rightMaskButton?.reversed = ReversedSegmentedSwitchOffsets.reversed.rawValue == inSegmentedSwitch.selectedSegmentIndex
    }

    /* ################################################################## */
    /**
     Called when the segmented switch, controlling the border, is hit.
     
     - parameter inSegmentedSwitch: The switch instance.
     */
    override func borderSelectionSegmentedSwitchHit(_ inSegmentedSwitch: UISegmentedControl) {
        leftMaskButton?.borderWidth = 0 == inSegmentedSwitch.selectedSegmentIndex ? Self.defaultBorderWidthInDisplayUnits : 0
        leftMaskButton?.forceReDraw()
        rightMaskButton?.borderWidth = 0 == inSegmentedSwitch.selectedSegmentIndex ? Self.defaultBorderWidthInDisplayUnits : 0
        rightMaskButton?.forceReDraw()
    }

    /* ################################################################## */
    /**
     Called when the segmented switch, controlling the start color, is hit.
     
     - parameter inSegmentedSwitch: The switch instance.
     */
    override func tintSegmentedSwitchHit(_ inSegmentedSwitch: UISegmentedControl) {
        let index = inSegmentedSwitch.selectedSegmentIndex
        if 0 < index,
           let color = (1 == index ? .white : UIColor(named: "Tint-\(index)")) {
            if startTintSelectorSegmentedSwitch == inSegmentedSwitch {
                leftMaskButton?.gradientStartColor = color
                rightMaskButton?.gradientStartColor = color
            } else {
                gradientAngleSlider?.isEnabled = true
                leftMaskButton?.gradientEndColor = color
                rightMaskButton?.gradientEndColor = color
            }
        } else if startTintSelectorSegmentedSwitch != inSegmentedSwitch {
            gradientAngleSlider?.value = 0
            gradientAngleSlider?.isEnabled = false
            leftMaskButton?.gradientAngleInDegrees = 0
            leftMaskButton?.gradientEndColor = nil
            rightMaskButton?.gradientAngleInDegrees = 0
            rightMaskButton?.gradientEndColor = nil
        }
    }
    
    /* ################################################################## */
    /**
     The gradient angle slider has changed.
     
     - parameter inSlider: The slider instance. The value will be the angle, in degrees.
     */
    override func gradientAngleSliderChanged(_ inSlider: UISlider) {
        leftMaskButton?.gradientAngleInDegrees = CGFloat(inSlider.value)
        rightMaskButton?.gradientAngleInDegrees = CGFloat(inSlider.value)
    }
}

/* ###################################################################################################################################### */
// MARK: Callbacks
/* ###################################################################################################################################### */
extension RVS_MaskButton_TestHarness_Examples_ViewController {
    /* ################################################################## */
    /**
     */
    @IBAction func leftMaskButtonHit(_ sender: RVS_MaskButton) {
        
    }

    /* ################################################################## */
    /**
     */
    @IBAction func rightMaskButtonHit(_ sender: RVS_MaskButton) {
    }
}
