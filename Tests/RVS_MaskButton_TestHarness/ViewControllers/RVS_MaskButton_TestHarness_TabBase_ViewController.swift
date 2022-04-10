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
// MARK: - UIView Extension -
/* ###################################################################################################################################### */
/**
 We add a couple of ways to deal with IB properties (shortcuts to layer properties).
 */
extension UIView {
    /* ################################################################## */
    /**
     This gives us access to the corner radius, so we can give the view rounded corners.
     
     > **NOTE:** This requires that `clipsToBounds` be set.
     */
    @IBInspectable var cornerRadius: CGFloat {
        get { layer.cornerRadius }
        set {
            layer.cornerRadius = newValue
            setNeedsDisplay()
        }
    }
    
    /* ################################################################## */
    /**
     Inspired by [this SO answer](https://stackoverflow.com/a/45089222/879365)
     This allows us to specify a border for the view. It is width, in display units.
     */
    @IBInspectable var borderWidth: CGFloat {
        get { layer.borderWidth }
        set {
            layer.borderWidth = newValue
            setNeedsDisplay()
        }
    }
}

/* ###################################################################################################################################### */
// MARK: - The Base (Both Tabs) Base View Controller Class -
/* ###################################################################################################################################### */
/**
 */
class RVS_MaskButton_TestHarness_TabBase_ViewController: UIViewController {
    /* ################################################################################################################################## */
    // MARK: The Indexes of the Segmented Switch That Controls Presentation
    /* ################################################################################################################################## */
    /**
     These are the indexes for the reverse switch.
     */
    enum ReversedSegmentedSwitchOffsets: Int {
        /// This renders the buttons as normal "Filled Content."
        case normal
        
        /// This renders the buttons as reversed ("Content Cutout From Background")
        case reversed
    }
    
    /* ################################################################## */
    /**
     This is the border width we want to set, when it is on.
     */
    static let defaultBorderWidthInDisplayUnits = CGFloat(8)

    /* ################################################################## */
    /**
     This segmented switch allows us to switch between normal and reverse cutout mode.
     */
    @IBOutlet weak var normalReverseSegmentedSwitch: UISegmentedControl?

    /* ################################################################## */
    /**
     This segmented switch allows us to switch between bordered and unbordered.
     */
    @IBOutlet weak var borderSelectionSegmentedSwitch: UISegmentedControl!

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
     This slider controls the angle of the gradient.
     */
    @IBOutlet weak var gradientAngleSlider: UISlider!
    
    /* ################################################################## */
    /**
     This should be overridden, and used to set up the screen to match the settings.
     */
    func overrideThisAndSetUpTheScreenAccordingToTheSettings() {
        if let normalReverseSegmentedSwitch = normalReverseSegmentedSwitch {
            normalReverseSegmentedSwitchHit(normalReverseSegmentedSwitch)
        }
        
        if let borderSelectionSegmentedSwitch = borderSelectionSegmentedSwitch {
            borderSelectionSegmentedSwitchHit(borderSelectionSegmentedSwitch)
        }

        if let startTintSelectorSegmentedSwitch = startTintSelectorSegmentedSwitch,
           let endTintSelectorSegmentedSwitch = endTintSelectorSegmentedSwitch {
            setSegmentedTintSelect(for: endTintSelectorSegmentedSwitch)
            tintSegmentedSwitchHit(startTintSelectorSegmentedSwitch)
            tintSegmentedSwitchHit(endTintSelectorSegmentedSwitch)
        }
        
        if let gradientAngleSlider = gradientAngleSlider {
            gradientAngleSliderChanged(gradientAngleSlider)
        }
    }
}

/* ###################################################################################################################################### */
// MARK: Instance Methods
/* ###################################################################################################################################### */
extension RVS_MaskButton_TestHarness_TabBase_ViewController {
    /* ################################################################## */
    /**
     This sets the colored squares for the given switch.
     */
    func setSegmentedTintSelect(for inTintSlectorSegmentedSwitch: UISegmentedControl) {
        // Set up the little tint squares for the tint selector control.
        if let image = UIImage(systemName: "square.slash")?.withRenderingMode(.alwaysTemplate) {
            let displayImage = image.withTintColor(endTintSelectorSegmentedSwitch == inTintSlectorSegmentedSwitch ? .label : .label.withAlphaComponent(0.5))
            inTintSlectorSegmentedSwitch.setImage(displayImage, forSegmentAt: 0)
            // We don't allow nil to be enabled for the start color (causes an assertion).
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
extension RVS_MaskButton_TestHarness_TabBase_ViewController {
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
        
        if let count = borderSelectionSegmentedSwitch?.numberOfSegments {
            for index in (0..<count) {
                if let title = borderSelectionSegmentedSwitch?.titleForSegment(at: index) {
                    borderSelectionSegmentedSwitch?.setTitle(title.localizedVariant, forSegmentAt: index)
                }
            }
        }
    }
    
    /* ################################################################## */
    /**
     Called just before the view appears. We use this to set the display to a standard starting point.
     
     - parameter inIsAnimated: True, if the appearance will be animated.
     */
    override func viewWillAppear(_ inIsAnimated: Bool) {
        super.viewWillAppear(inIsAnimated)

        if let normalReverseSegmentedSwitch = normalReverseSegmentedSwitch {
            normalReverseSegmentedSwitch.selectedSegmentIndex = 0
        }
        
        if let borderSelectionSegmentedSwitch = borderSelectionSegmentedSwitch {
            borderSelectionSegmentedSwitch.selectedSegmentIndex = 0
        }

        if let startTintSelectorSegmentedSwitch = startTintSelectorSegmentedSwitch,
           let endTintSelectorSegmentedSwitch = endTintSelectorSegmentedSwitch {
            startTintSelectorSegmentedSwitch.selectedSegmentIndex = 2
            endTintSelectorSegmentedSwitch.selectedSegmentIndex = 1
        }
        
        if let gradientAngleSlider = gradientAngleSlider {
            gradientAngleSlider.value = 0
        }
    }
}

/* ###################################################################################################################################### */
// MARK: Callbacks
/* ###################################################################################################################################### */
extension RVS_MaskButton_TestHarness_TabBase_ViewController {
    /* ################################################################## */
    /**
     Called when the segmented switch, controlling the cutout method, is hit.
     
     - parameter inSegmentedSwitch: The switch instance.
     */
    @IBAction func normalReverseSegmentedSwitchHit(_ inSegmentedSwitch: UISegmentedControl) { }

    /* ################################################################## */
    /**
     Called when the segmented switch, controlling the border, is hit.
     
     - parameter inSegmentedSwitch: The switch instance.
     */
    @IBAction func borderSelectionSegmentedSwitchHit(_ inSegmentedSwitch: UISegmentedControl) { }

    /* ################################################################## */
    /**
     Called when the segmented switch, controlling the start color, is hit.
     
     - parameter inSegmentedSwitch: The switch instance.
     */
    @IBAction func tintSegmentedSwitchHit(_ inSegmentedSwitch: UISegmentedControl) { }
    
    /* ################################################################## */
    /**
     The gradient angle slider has changed.
     
     - parameter inSlider: The slider instance. The value will be the angle, in degrees.
     */
    @IBAction func gradientAngleSliderChanged(_ inSlider: UISlider) { }
}
