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
 This tab presents a simple "card cycle" UI.
 
 It presents a window, with two buttons on the bottom, and two in the right margin, of a window that has a playing card displayed.
 
 Selecting the lower buttons, moves the card value (Ace -> King).
 
 Selecting the margin buttons, selects the suite (Spades, Hearts, Clubs, and Diamonds).
 
 These buttons all use images (SF Symbols).
 */
class RVS_MaskButton_TestHarness_Cards_ViewController: RVS_MaskButton_TestHarness_TabBase_ViewController {
    /* ################################################################## */
    /**
     */
    typealias ImageReference = (imageName: String, sfSymbol: String)
    
    /* ################################################################## */
    /**
     Each suit is represented by its various members. A...K (Ace, 2-10, Jack, Queen, King).
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
     Spades, Hearts, Clubs, and Diamonds.
     */
    static let verticalImageNames: [ImageReference] = [(imageName: "S", sfSymbol: "suit.spade.fill"),
                                                       (imageName: "H", sfSymbol: "suit.heart.fill"),
                                                       (imageName: "C", sfSymbol: "suit.club.fill"),
                                                       (imageName: "D", sfSymbol: "suit.diamond.fill")
    ]
    
    /* ################################################################## */
    /**
     The zero-based current horizontal index of the displayed card (which suit member).
     */
    var currentHorizontalIndex: Int = 0
    
    /* ################################################################## */
    /**
     The zero-based current vertiical index of the displayed card (which suit).
     */
    var currentVerticalIndex: Int = 0
    
    /* ################################################################## */
    /**
     The container, for all the various parts of the "card sorter."
     */
    @IBOutlet weak var imageContainerView: UIView?

    /* ################################################################## */
    /**
     This is the displayed card.
     */
    @IBOutlet weak var cardImageView: UIImageView?

    /* ################################################################## */
    /**
     The bottom button on the left; used to select suit members.
     */
    @IBOutlet weak var leftMaskButton: RVS_MaskButton?

    /* ################################################################## */
    /**
     The bottom button on the right; used to select suit members.
     */
    @IBOutlet weak var rightMaskButton: RVS_MaskButton?

    /* ################################################################## */
    /**
     The upper side button on the right border; used to select suits.
     */
    @IBOutlet weak var upMaskButton: RVS_MaskButton?
    
    /* ################################################################## */
    /**
     The lower side button on the right border; used to select suits.
     */
    @IBOutlet weak var downMaskButton: RVS_MaskButton?
    
    /* ################################################################## */
    /**
     This sets the various controls up to our initial default.
     This override needs to be in the main declaration (not an extension).
     */
    override func overrideThisAndSetUpTheScreenAccordingToTheSettings() {
        super.overrideThisAndSetUpTheScreenAccordingToTheSettings()
        setUpButtons()
    }
    
    /* ################################################################## */
    /**
     This sets the colored squares for the given switch.
     This override needs to be in the main declaration (not an extension).
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
     This returns the name of the image to use for the card.
     */
    var currentMainImage: String { "\(Self.verticalImageNames[currentVerticalIndex].imageName)-\(Self.horizontalImageNames[currentHorizontalIndex].imageName)" }
    
    /* ################################################################## */
    /**
     This returns the name of the image to use for the left button.
     */
    var currentLeftImage: String { Self.horizontalImageNames[previousHorizontalIndex].sfSymbol }
    
    /* ################################################################## */
    /**
     This returns the name of the image to use for the right button.
     */
    var currentRightImage: String { Self.horizontalImageNames[nextHorizontalIndex].sfSymbol }

    /* ################################################################## */
    /**
     This is the index (0-based) to use for the left button. It cycles around, if at the bottom.
     */
    var previousHorizontalIndex: Int { (1 > currentHorizontalIndex ? Self.horizontalImageNames.count : currentHorizontalIndex) - 1 }
    
    /* ################################################################## */
    /**
     This is the index (0-based) to use for the right button. It cycles around, if at the end.
     */
    var nextHorizontalIndex: Int {
        let nextIndex = currentHorizontalIndex + 1
        
        guard Self.horizontalImageNames.count > nextIndex else { return 0 }
        
        return nextIndex
    }
    
    /* ################################################################## */
    /**
     The name of the image to use for the up button.
     */
    var currentUpImage: String { Self.verticalImageNames[nextVerticalIndex].sfSymbol }
    
    /* ################################################################## */
    /**
     The name of the image to use for the down button.
     */
    var currentDownImage: String { Self.verticalImageNames[previousVerticalIndex].sfSymbol }

    /* ################################################################## */
    /**
     This is the index (0-based) to use for the down button. It cycles around, if at the bottom.
     */
    var previousVerticalIndex: Int { (1 > currentVerticalIndex ? Self.verticalImageNames.count : currentVerticalIndex) - 1 }
    
    /* ################################################################## */
    /**
     This is the index (0-based) to use for the up button. It cycles around, if at the end.
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
     This sets up the images for all the buttons; reflecting the current indexes.
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
        
        // This sets the corners of the viewer.
        if let imageContainerView = imageContainerView {
            imageContainerView.layer.cornerRadius = 30
        }

        // This makes the buttons in the margin round.
        if let upMaskButton = upMaskButton {
            upMaskButton.layer.cornerRadius = upMaskButton.bounds.size.height / 2
        }
        
        if let downMaskButton = downMaskButton {
            downMaskButton.layer.cornerRadius = downMaskButton.bounds.size.height / 2
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
        // We use white for the top, and nil for the bottom (so it is a solid color).
        startTintSelectorSegmentedSwitch?.selectedSegmentIndex = 1
        endTintSelectorSegmentedSwitch?.selectedSegmentIndex = 0
        // Start with the Ace of Spades.
        currentVerticalIndex = 0
        currentHorizontalIndex = 0

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
     
     We determine the thickness of the border, quite simply, by casting the segment index to a CGFloat.
     
     - parameter inSegmentedSwitch: The switch instance.
     */
    override func borderSelectionSegmentedSwitchHit(_ inSegmentedSwitch: UISegmentedControl) {
        leftMaskButton?.borderWidthInDisplayUnits = CGFloat(inSegmentedSwitch.selectedSegmentIndex)
        leftMaskButton?.forceRedraw()
        rightMaskButton?.borderWidthInDisplayUnits = CGFloat(inSegmentedSwitch.selectedSegmentIndex)
        rightMaskButton?.forceRedraw()
        upMaskButton?.borderWidthInDisplayUnits = CGFloat(inSegmentedSwitch.selectedSegmentIndex)
        upMaskButton?.forceRedraw()
        downMaskButton?.borderWidthInDisplayUnits = CGFloat(inSegmentedSwitch.selectedSegmentIndex)
        downMaskButton?.forceRedraw()
    }

    /* ################################################################## */
    /**
     Called when the segmented switch, controlling the start color, is hit.
     
     - parameter inSegmentedSwitch: The switch instance.
     */
    override func tintSegmentedSwitchHit(_ inSegmentedSwitch: UISegmentedControl) {
        let index = inSegmentedSwitch.selectedSegmentIndex
        // We use white (instead of the accent color), for this view.
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
     Called when the "previous suite member" button (left bottom) is hit.
      - parameter: Ignored.
     */
    @IBAction func leftMaskButtonHit(_: RVS_MaskButton) {
        currentHorizontalIndex = previousHorizontalIndex
        setUpButtons()
    }

    /* ################################################################## */
    /**
     Called when the "next suite member" button (right bottom) is hit.
      - parameter: Ignored.
     */
    @IBAction func rightMaskButtonHit(_: RVS_MaskButton) {
        currentHorizontalIndex = nextHorizontalIndex
        setUpButtons()
    }
    
    /* ################################################################## */
    /**
     Called when the "next suite" button (upper right) is hit.
      - parameter: Ignored.
     */
    @IBAction func upMaskButtonHit(_: RVS_MaskButton) {
        currentVerticalIndex = nextVerticalIndex
        setUpButtons()
    }

    /* ################################################################## */
    /**
     Called when the "previous suite" button (lower right) is hit.
      - parameter: Ignored.
     */
    @IBAction func downMaskButtonHit(_: RVS_MaskButton) {
        currentVerticalIndex = previousVerticalIndex
        setUpButtons()
    }
}
