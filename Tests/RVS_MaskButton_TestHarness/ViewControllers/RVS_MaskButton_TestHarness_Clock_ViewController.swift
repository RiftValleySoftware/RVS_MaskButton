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
import RVS_BasicGCDTimer

/* ###################################################################################################################################### */
// MARK: - The Tab 0 (Clock) View Controller Class -
/* ###################################################################################################################################### */
/**
 This tab presents the control as a digital clock.
 */
class RVS_MaskButton_TestHarness_Clock_ViewController: RVS_MaskButton_TestHarness_TabBase_ViewController {
    /* ################################################################################################################################## */
    // MARK: The Indexes of the Segmented Switch That Controls Presentation
    /* ################################################################################################################################## */
    /**
     These are the indexes for the font switch
     */
    enum FontSegmentedSwitchOffsets: Int {
        /// This sets the font to "Let's Go Digital."
        case digital
        
        /// This sets the font to the basic system font.
        case system
    }

    /* ################################################################## */
    /**
     This is the font size we'll specify.
     */
    static let fontSize = CGFloat(60)
    
    /* ################################################################## */
    /**
     We just use this, to keep from constantly re-pinging the control.
     */
    var lastTimeString = ""

    /* ################################################################## */
    /**
     This calls the clock, around every second.
     */
    var timerInstance: RVS_BasicGCDTimer?

    /* ################################################################## */
    /**
     This allows us to switch fonts for the clock.
     */
    @IBOutlet weak var fontSelectorSegmentedSwitch: UISegmentedControl!
    
    /* ################################################################## */
    /**
     This is the main digital clock button.
     */
    @IBOutlet weak var digitalClockButton: RVS_MaskButton?
    
    /* ################################################################## */
    /**
     This sets the various controls up to our initial default.
     */
    override func overrideThisAndSetUpTheScreenAccordingToTheSettings() {
        super.overrideThisAndSetUpTheScreenAccordingToTheSettings()
        if let fontSelectorSegmentedSwitch = fontSelectorSegmentedSwitch {
            fontSelectorSegmentedSwitchHit(fontSelectorSegmentedSwitch)
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

        if let count = fontSelectorSegmentedSwitch?.numberOfSegments {
            for index in (0..<count) {
                if let title = fontSelectorSegmentedSwitch?.titleForSegment(at: index) {
                    fontSelectorSegmentedSwitch?.setTitle(title.localizedVariant, forSegmentAt: index)
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
        
        if let fontSelectorSegmentedSwitch = fontSelectorSegmentedSwitch {
            fontSelectorSegmentedSwitch.selectedSegmentIndex = 0
        }
        
        overrideThisAndSetUpTheScreenAccordingToTheSettings()
        
        timerInstance = RVS_BasicGCDTimer(timeIntervalInSeconds: 1.0, delegate: self, leewayInMilliseconds: 100, onlyFireOnce: false, queue: DispatchQueue.main, isWallTime: true)

        timerInstance?.isRunning = true
        
        if let timerInstance = timerInstance {
            basicGCDTimerCallback(timerInstance)
        }
    }
    
    /* ################################################################## */
    /**
     Called just before the view disappears. We use this to kill the timer.
     
     - parameter inIsAnimated: True, if the appearance will be animated.
     */
    override func viewWillDisappear(_ inIsAnimated: Bool) {
        super.viewWillDisappear(inIsAnimated)
        timerInstance = nil
    }
    
    /* ################################################################## */
    /**
     Called when the segmented switch, controlling the cutout method, is hit.
     
     - parameter inSegmentedSwitch: The switch instance.
     */
    override func normalReverseSegmentedSwitchHit(_ inSegmentedSwitch: UISegmentedControl) {
        digitalClockButton?.reversed = ReversedSegmentedSwitchOffsets.reversed.rawValue == inSegmentedSwitch.selectedSegmentIndex
    }

    /* ################################################################## */
    /**
     Called when the segmented switch, controlling the border, is hit.
     
     - parameter inSegmentedSwitch: The switch instance.
     */
    override func borderSelectionSegmentedSwitchHit(_ inSegmentedSwitch: UISegmentedControl) {
        digitalClockButton?.borderWidth = 0 == inSegmentedSwitch.selectedSegmentIndex ? Self.defaultBorderWidthInDisplayUnits : 0
        digitalClockButton?.forceReDraw()
    }

    /* ################################################################## */
    /**
     Called when the segmented switch, controlling the start color, is hit.
     
     - parameter inSegmentedSwitch: The switch instance.
     */
    override func tintSegmentedSwitchHit(_ inSegmentedSwitch: UISegmentedControl) {
        let index = inSegmentedSwitch.selectedSegmentIndex
        if let color = 1 == index ? view?.tintColor : UIColor(named: "Tint-\(index)") {
            if startTintSelectorSegmentedSwitch == inSegmentedSwitch {
                digitalClockButton?.gradientStartColor = color
            } else {
                gradientAngleSlider?.isEnabled = true
                digitalClockButton?.gradientEndColor = color
            }
        } else {
            gradientAngleSlider?.value = 0
            gradientAngleSlider?.isEnabled = false
            digitalClockButton?.gradientAngleInDegrees = 0
            digitalClockButton?.gradientEndColor = nil
        }
    }
    
    /* ################################################################## */
    /**
     The gradient angle slider has changed.
     
     - parameter inSlider: The slider instance. The value will be the angle, in degrees.
     */
    override func gradientAngleSliderChanged(_ inSlider: UISlider) {
        digitalClockButton?.gradientAngleInDegrees = CGFloat(inSlider.value)
    }
}

/* ###################################################################################################################################### */
// MARK: Callbacks
/* ###################################################################################################################################### */
extension RVS_MaskButton_TestHarness_Clock_ViewController {
    /* ################################################################## */
    /**
     This is called when the font switch changes value.
     - parameter inSegmentedSwitch: The switch instance.
     */
    @IBAction func fontSelectorSegmentedSwitchHit(_ inSegmentedSwitch: UISegmentedControl) {
        if FontSegmentedSwitchOffsets.digital.rawValue == inSegmentedSwitch.selectedSegmentIndex,
           let font = UIFont(name: "Let's Go Digital", size: Self.fontSize) {
            digitalClockButton?.buttonFont = font
        } else {
            digitalClockButton?.buttonFont = UIFont.monospacedSystemFont(ofSize: Self.fontSize, weight: .bold)
        }
    }

    /* ################################################################## */
    /**
     Called when the digital clock button is hit.
     
     - parameter inButton: The button instance.
     */
    @IBAction func digitalClockButtonHit(_ inButton: RVS_MaskButton) {
        timerInstance?.isRunning = !(timerInstance?.isRunning ?? true)
    }
}

/* ###################################################################################################################################### */
// MARK: RVS_BasicGCDTimerDelegate Conformance
/* ###################################################################################################################################### */
extension RVS_MaskButton_TestHarness_Clock_ViewController: RVS_BasicGCDTimerDelegate {
    /* ################################################################## */
    /**
     */
    func basicGCDTimerCallback(_ inTimer: RVS_BasicGCDTimer) {
        let timeDisplayFormatter = DateFormatter()
        timeDisplayFormatter.timeStyle = .medium
        let timeString = timeDisplayFormatter.string(from: Date())
        
        if lastTimeString != timeString {
            lastTimeString = timeString
            digitalClockButton?.setTitle(timeString, for: .normal)
        }
    }
}
