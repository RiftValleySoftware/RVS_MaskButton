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
class RVS_MaskButton_TestHarness_Cards_ViewController: RVS_MaskButton_TestHarness_TabBase_ViewController {
    /* ################################################################## */
    /**
     */
    typealias ImageReference = (imageName: String, sfSymbol: String)
    
    /* ################################################################## */
    /**
     */
    static let horizontalImageNames: [ImageReference] = [(imageName: "1", sfSymbol: "a.circle.fill"),
                                                         (imageName: "2", sfSymbol: "2.circle.fill"),
                                                         (imageName: "3", sfSymbol: "3.circle.fill"),
                                                         (imageName: "4", sfSymbol: "4.circle.fill"),
                                                         (imageName: "5", sfSymbol: "5.circle.fill"),
                                                         (imageName: "6", sfSymbol: "6.circle.fill"),
                                                         (imageName: "7", sfSymbol: "7.circle.fill"),
                                                         (imageName: "8", sfSymbol: "8.circle.fill"),
                                                         (imageName: "9", sfSymbol: "9.circle.fill"),
                                                         (imageName: "10", sfSymbol: "10.circle.fill"),
                                                         (imageName: "11", sfSymbol: "j.circle.fill"),
                                                         (imageName: "12", sfSymbol: "q.circle.fill"),
                                                         (imageName: "13", sfSymbol: "k.circle.fill")
    ]
    
    /* ################################################################## */
    /**
     */
    static let verticalImageNames: [ImageReference] = [(imageName: "S", sfSymbol: "suit.spade.fill"),
                                                       (imageName: "H", sfSymbol: "suit.heart.fill"),
                                                       (imageName: "C", sfSymbol: "suit.club.fill"),
                                                       (imageName: "D", sfSymbol: "suit.diamond.fill")
    ]
    
    /* ################################################################## */
    /**
     */
    var currentHorizontalIndex: Int = 0
    
    /* ################################################################## */
    /**
     */
    var currentVerticalIndex: Int = 0
    
    /* ################################################################## */
    /**
     */
    @IBOutlet weak var cardImageView: UIImageView!

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
     */
    @IBOutlet weak var upMaskButton: RVS_MaskButton?
    
    /* ################################################################## */
    /**
     */
    @IBOutlet weak var downMaskButton: RVS_MaskButton?
    
    /* ################################################################## */
    /**
     This sets the various controls up to our initial default.
     */
    override func overrideThisAndSetUpTheScreenAccordingToTheSettings() {
        super.overrideThisAndSetUpTheScreenAccordingToTheSettings()
        setUpButtons()
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
// MARK: Computed Properties
/* ###################################################################################################################################### */
extension RVS_MaskButton_TestHarness_Cards_ViewController {
    /* ################################################################## */
    /**
     */
    var currentMainImage: String { "\(Self.verticalImageNames[currentVerticalIndex].imageName)-\(Self.horizontalImageNames[currentHorizontalIndex].imageName)" }
    
    /* ################################################################## */
    /**
     */
    var currentLeftImage: String { Self.horizontalImageNames[previousHorizontalIndex].sfSymbol }
    
    /* ################################################################## */
    /**
     */
    var currentRightImage: String { Self.horizontalImageNames[nextHorizontalIndex].sfSymbol }

    /* ################################################################## */
    /**
     */
    var previousHorizontalIndex: Int { (1 > currentHorizontalIndex ? Self.horizontalImageNames.count : currentHorizontalIndex) - 1 }
    
    /* ################################################################## */
    /**
     */
    var nextHorizontalIndex: Int {
        let nextIndex = currentHorizontalIndex + 1
        
        guard Self.horizontalImageNames.count > nextIndex else { return 0 }
        
        return nextIndex
    }
    
    /* ################################################################## */
    /**
     */
    var currentUpImage: String { Self.verticalImageNames[nextVerticalIndex].sfSymbol }
    
    /* ################################################################## */
    /**
     */
    var currentDownImage: String { Self.verticalImageNames[previousVerticalIndex].sfSymbol }

    /* ################################################################## */
    /**
     */
    var previousVerticalIndex: Int { (1 > currentVerticalIndex ? Self.verticalImageNames.count : currentVerticalIndex) - 1 }
    
    /* ################################################################## */
    /**
     */
    var nextVerticalIndex: Int {
        let nextIndex = currentVerticalIndex + 1
        
        guard Self.verticalImageNames.count > nextIndex else { return 0 }
        
        return nextIndex
    }
}

/* ###################################################################################################################################### */
// MARK: Instance Methods
/* ###################################################################################################################################### */
extension RVS_MaskButton_TestHarness_Cards_ViewController {
    /* ################################################################## */
    /**
     */
    func setUpButtons() {
        if let cardImage = UIImage(named: currentMainImage) {
            cardImageView?.image = cardImage
        }
        
        if let leftImage = UIImage(systemName: currentLeftImage)?.applyingSymbolConfiguration(UIImage.SymbolConfiguration(scale: .large)) {
            leftMaskButton?.setImage(leftImage, for: .normal)
        }
        
        if let rightImage = UIImage(systemName: currentRightImage)?.applyingSymbolConfiguration(UIImage.SymbolConfiguration(scale: .large)) {
            rightMaskButton?.setImage(rightImage, for: .normal)
        }
        
        if let upImage = UIImage(systemName: currentUpImage)?.applyingSymbolConfiguration(UIImage.SymbolConfiguration(scale: .large)) {
            upMaskButton?.setImage(upImage, for: .normal)
        }
        
        let downName = currentDownImage
        if let downImage = UIImage(systemName: downName)?.applyingSymbolConfiguration(UIImage.SymbolConfiguration(scale: .large)) {
            downMaskButton?.setImage(downImage, for: .normal)
        }
        
        if let upMaskButton = upMaskButton {
            upMaskButton.cornerRadius = upMaskButton.bounds.size.height / 2
        }
        
        if let downMaskButton = downMaskButton {
            downMaskButton.cornerRadius = downMaskButton.bounds.size.height / 2
        }
    }
}

/* ###################################################################################################################################### */
// MARK: Base Class Overrides
/* ###################################################################################################################################### */
extension RVS_MaskButton_TestHarness_Cards_ViewController {
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
        currentVerticalIndex = 1
        currentHorizontalIndex = 11
        overrideThisAndSetUpTheScreenAccordingToTheSettings()
    }
    
    /* ################################################################## */
    /**
     Called when the layout changes. We make sure to completely redraw the buttons.
     */
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        leftMaskButton?.forceRedraw()
        rightMaskButton?.forceRedraw()
        upMaskButton?.forceRedraw()
        downMaskButton?.forceRedraw()
    }
    
    /* ################################################################## */
    /**
     Called when the segmented switch, controlling the cutout method, is hit.
     
     - parameter inSegmentedSwitch: The switch instance.
     */
    override func normalReverseSegmentedSwitchHit(_ inSegmentedSwitch: UISegmentedControl) {
        leftMaskButton?.reversed = ReversedSegmentedSwitchOffsets.reversed.rawValue == inSegmentedSwitch.selectedSegmentIndex
        rightMaskButton?.reversed = ReversedSegmentedSwitchOffsets.reversed.rawValue == inSegmentedSwitch.selectedSegmentIndex
        upMaskButton?.reversed = ReversedSegmentedSwitchOffsets.reversed.rawValue == inSegmentedSwitch.selectedSegmentIndex
        downMaskButton?.reversed = ReversedSegmentedSwitchOffsets.reversed.rawValue == inSegmentedSwitch.selectedSegmentIndex
    }

    /* ################################################################## */
    /**
     Called when the segmented switch, controlling the border, is hit.
     
     - parameter inSegmentedSwitch: The switch instance.
     */
    override func borderSelectionSegmentedSwitchHit(_ inSegmentedSwitch: UISegmentedControl) {
        leftMaskButton?.borderWidth = 0 == inSegmentedSwitch.selectedSegmentIndex ? Self.defaultBorderWidthInDisplayUnits : 0
        leftMaskButton?.forceRedraw()
        rightMaskButton?.borderWidth = 0 == inSegmentedSwitch.selectedSegmentIndex ? Self.defaultBorderWidthInDisplayUnits : 0
        rightMaskButton?.forceRedraw()
        upMaskButton?.borderWidth = 0 == inSegmentedSwitch.selectedSegmentIndex ? Self.defaultBorderWidthInDisplayUnits : 0
        upMaskButton?.forceRedraw()
        downMaskButton?.borderWidth = 0 == inSegmentedSwitch.selectedSegmentIndex ? Self.defaultBorderWidthInDisplayUnits : 0
        downMaskButton?.forceRedraw()
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
                upMaskButton?.gradientStartColor = color
                downMaskButton?.gradientStartColor = color
            } else {
                gradientAngleSlider?.isEnabled = true
                leftMaskButton?.gradientEndColor = color
                rightMaskButton?.gradientEndColor = color
                upMaskButton?.gradientEndColor = color
                downMaskButton?.gradientEndColor = color
            }
        } else if startTintSelectorSegmentedSwitch != inSegmentedSwitch {
            gradientAngleSlider?.value = 0
            gradientAngleSlider?.isEnabled = false
            leftMaskButton?.gradientAngleInDegrees = 0
            leftMaskButton?.gradientEndColor = nil
            rightMaskButton?.gradientAngleInDegrees = 0
            rightMaskButton?.gradientEndColor = nil
            upMaskButton?.gradientAngleInDegrees = 0
            upMaskButton?.gradientEndColor = nil
            downMaskButton?.gradientAngleInDegrees = 0
            downMaskButton?.gradientEndColor = nil
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
        upMaskButton?.gradientAngleInDegrees = CGFloat(inSlider.value)
        downMaskButton?.gradientAngleInDegrees = CGFloat(inSlider.value)
    }
}

/* ###################################################################################################################################### */
// MARK: Callbacks
/* ###################################################################################################################################### */
extension RVS_MaskButton_TestHarness_Cards_ViewController {
    /* ################################################################## */
    /**
     */
    @IBAction func leftMaskButtonHit(_ sender: RVS_MaskButton) {
        currentHorizontalIndex = previousHorizontalIndex
        setUpButtons()
    }

    /* ################################################################## */
    /**
     */
    @IBAction func rightMaskButtonHit(_ sender: RVS_MaskButton) {
        currentHorizontalIndex = nextHorizontalIndex
        setUpButtons()
    }
    
    /* ################################################################## */
    /**
     */
    @IBAction func upMaskButtonHit(_ sender: RVS_MaskButton) {
        currentVerticalIndex = nextVerticalIndex
        setUpButtons()
    }

    /* ################################################################## */
    /**
     */
    @IBAction func downMaskButtonHit(_ sender: RVS_MaskButton) {
        currentVerticalIndex = previousVerticalIndex
        setUpButtons()
    }
}
