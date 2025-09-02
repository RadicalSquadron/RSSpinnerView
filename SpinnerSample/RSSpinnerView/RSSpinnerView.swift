//
//  RSSpinnerView.swift
//  RSComponents
//
//  Created by rajesh subramonian on 02/12/22.
//  Copyright © 2020 Hill side developer. All rights reserved.
//

import UIKit

// MARK: - Enum for Spinner Shade Types
public enum SpinnerShade: String {
    case light
    case dark
    case transparentDark
    case transparentNormal
}

// MARK: - Spinner Types
public enum SpinnerType: String {
    case micro
    case small
    case medium
    case large
    case full
}

// MARK: - SpinnerColor Model
public struct SpinnerColor {
    let baseSpinnerColor: UIColor
    let progressSpinnerColor: UIColor
    let shade: SpinnerShade
}

// MARK: - SpinnerModel
public struct SpinnerModel {
    let outerViewFrame: CGRect
    var outerViewBGColor: UIColor = UIColor(red: 0.027, green: 0.035, blue: 0.051, alpha: 1)
    var outerViewCornerRadius: CGFloat = 8.0
    var outerViewAlpha: CGFloat = 0.85
    let spinnerViewFrame: CGRect
    var spinnerLineWidth: CGFloat = 4.0
    let spinnerColors: SpinnerColor
    var titleText: String = ""
    var descriptionText: String = ""
    var spinnerCenter: CGFloat = -17
    let titleCenter: CGFloat = 48
    var descriptionCenter: CGFloat = 61
}

// MARK: - RSSpinnerView
public class RSSpinnerView: UIView {

    // UI Elements
    var outerView: UIView = {
        let baseView = UIView()
        baseView.backgroundColor = .clear
        baseView.translatesAutoresizingMaskIntoConstraints = false
        return baseView
    }()
    
    var spinnerView: UIView = {
        let baseView = UIView()
        baseView.frame = CGRect(x: 0, y: 0, width: 72, height: 72)
        baseView.backgroundColor = .clear
        baseView.translatesAutoresizingMaskIntoConstraints = false
        return baseView
    }()
    
    var circleView: CircularProgressView?
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    
    // Properties
    var spinnerModel: SpinnerModel?
    var parentView: UIView?

    // Default Sizes
    let defaultSpinnerSize = CGRect(x: 0, y: 0, width: 72, height: 72)
    let defaultOuterSize = CGRect(x: 0, y: 0, width: 136, height: 136)
    
    // MARK: - Color Definitions
    var spinnerDefaultColors: (SpinnerShade) -> SpinnerColor = { shade in
        switch shade {
        case .light:
            return SpinnerColor(
                baseSpinnerColor: UIColor(red: 0.82, green: 0.851, blue: 0.898, alpha: 1),
                progressSpinnerColor: UIColor(red: 0, green: 0.314, blue: 0.949, alpha: 1),
                shade: shade
            )
        default:
            return SpinnerColor(
                baseSpinnerColor: UIColor(red: 0.333, green: 0.369, blue: 0.42, alpha: 1),
                progressSpinnerColor: UIColor(red: 0.867, green: 0.89, blue: 0.929, alpha: 1),
                shade: shade
            )
        }
    }
    
    var spinnerOuterBgColor: (SpinnerShade) -> UIColor = { shade in
        switch shade {
        case .light, .transparentDark, .transparentNormal:
            return .clear
        default:
            return UIColor(red: 0.027, green: 0.035, blue: 0.051, alpha: 1)
        }
    }
    
    
    // MARK: - Shared Instance
    static let shared: RSSpinnerView = {
        let instance = RSSpinnerView(frame: UIScreen.main.bounds, type: .small)
        return instance
    }()
    
    // MARK: - Initializers
    private init(frame: CGRect, type: SpinnerType) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }

    public convenience init(spinnerType: SpinnerType, spinnerColor: SpinnerShade = .dark, onView: UIView, description: String = "Loading...", title: String = "Please Wait") {
        self.init(frame: UIScreen.main.bounds, type: .small)
        self.parentView = onView
        self.spinnerModel = constructDataModel(with: spinnerType, spinnerColor: spinnerColor, inView: onView, description: description, title: title)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Functions

    func setupResources(forLabels: [UILabel], withText: [String?], inView: UIView) {
        for (index, singleLabel) in forLabels.enumerated() {
            singleLabel.text = withText[safe: index] ?? ""
            singleLabel.font = .systemFont(ofSize: 14)
            singleLabel.backgroundColor = .clear
            singleLabel.textAlignment = .center
            singleLabel.numberOfLines = 0
            singleLabel.translatesAutoresizingMaskIntoConstraints = false
            singleLabel.frame = CGRect(x: 0, y: 0, width: inView.frame.width - 64, height: 20)
            singleLabel.textColor = (singleLabel == titleLabel) ? .white : UIColor(red: 0.82, green: 0.851, blue: 0.898, alpha: 1)
            outerView.addSubview(singleLabel)
        }
    }

    func setupSpinnerView(inView: UIView, spinnerColor: SpinnerColor, linewidth: CGFloat) {
        circleView?.removeFromSuperview()
        circleView = CircularProgressView(progress: 1, baseColor: spinnerColor.baseSpinnerColor, progressColor: spinnerColor.progressSpinnerColor, width: linewidth)
        guard let circleView = circleView else { return }
        inView.addSubview(circleView)
        circleView.bounds = inView.bounds
        circleView.center = CGPoint(x: inView.frame.height / 2, y: inView.frame.width / 2)
    }

    func setupEntireView(onModel: SpinnerModel, onView: UIView) {
        spinnerModel = onModel
        outerView.frame = onModel.outerViewFrame
        outerView.layer.cornerRadius = onModel.outerViewCornerRadius
        outerView.alpha = onModel.outerViewAlpha
        spinnerView.frame = onModel.spinnerViewFrame
        setupSpinnerView(inView: spinnerView, spinnerColor: onModel.spinnerColors, linewidth: onModel.spinnerLineWidth)
        outerView.addSubview(spinnerView)
        self.addSubview(outerView)
        setupBaseConstraints()
        setupConstraints(forView: spinnerView, constantValue: onModel.spinnerCenter)

        outerView.backgroundColor = spinnerOuterBgColor(onModel.spinnerColors.shade)

        if !onModel.titleText.isEmpty {
            setupResources(forLabels: [titleLabel], withText: [onModel.titleText], inView: outerView)
            setupConstraints(forView: titleLabel, constantValue: onModel.titleCenter)
        }

        if !onModel.descriptionText.isEmpty {
            setupResources(forLabels: [descriptionLabel], withText: [onModel.descriptionText], inView: outerView)
            setupConstraints(forView: descriptionLabel, constantValue: onModel.descriptionCenter)
        }
    }

    func constructDataModel(with spinnerType: SpinnerType, spinnerColor: SpinnerShade = .dark, inView: UIView, description: String = "Loading...", title: String = "Please Wait") -> SpinnerModel {
        switch spinnerType {
        case .micro:
            let width: CGFloat = (spinnerColor == .transparentDark) ? 1.0 : 2.0
            return SpinnerModel(
                outerViewFrame: getFrame([inView.frame.width, inView.frame.height]),
                outerViewCornerRadius: 0.0,
                outerViewAlpha: 1,
                spinnerViewFrame: inView.frame,
                spinnerLineWidth: width,
                spinnerColors: spinnerDefaultColors(spinnerColor),
                spinnerCenter: 0
            )
        case .medium:
            return SpinnerModel(
                outerViewFrame: getFrame([204, 170]),
                spinnerViewFrame: defaultSpinnerSize,
                spinnerColors: spinnerDefaultColors(spinnerColor),
                descriptionText: description,
                descriptionCenter: 48
            )
        case .large:
            return SpinnerModel(
                outerViewFrame: getFrame([427, 196]),
                spinnerViewFrame: defaultSpinnerSize,
                spinnerColors: spinnerDefaultColors(spinnerColor),
                titleText: title,
                descriptionText: description
            )
        case .full:
            return SpinnerModel(
                outerViewFrame: getFrame([self.frame.width, self.frame.height]),
                outerViewCornerRadius: 0.0,
                outerViewAlpha: 1,
                spinnerViewFrame: defaultSpinnerSize,
                spinnerColors: spinnerDefaultColors(spinnerColor),
                spinnerCenter: 0
            )
        default:
            return SpinnerModel(
                outerViewFrame: defaultOuterSize,
                spinnerViewFrame: defaultSpinnerSize,
                spinnerColors: spinnerDefaultColors(spinnerColor),
                spinnerCenter: 0
            )
        }
    }

    func getFrame(_ sizeVal: [CGFloat]) -> CGRect {
        return CGRect(x: 0, y: 0, width: sizeVal[0], height: sizeVal[1])
    }

    func setupConstraints(forView: AnyObject, constantValue: CGFloat) {
        forView.removeConstraints(forView.constraints)
        forView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        forView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: constantValue).isActive = true
        forView.widthAnchor.constraint(equalToConstant: forView.frame.width).isActive = true
        forView.heightAnchor.constraint(equalToConstant: forView.frame.height).isActive = true
    }

    func setupBaseConstraints() {
        self.translatesAutoresizingMaskIntoConstraints = false
        let attributes: [NSLayoutConstraint.Attribute] = [.top, .bottom, .right, .left]
        NSLayoutConstraint.activate(attributes.map {
            NSLayoutConstraint(item: self, attribute: $0, relatedBy: .equal, toItem: self.superview, attribute: $0, multiplier: 1, constant: 0)
        })
        setupConstraints(forView: outerView, constantValue: 0)
    }
}

// MARK: - Public API
extension RSSpinnerView {
    public func addSpinner() {
        if let model = self.spinnerModel, let view = self.parentView {
            view.addSubview(self)
            self.setupEntireView(onModel: model, onView: view)
            circleView?.animateCircle(duration: 0.5, delay: 0.5)
        }
    }

    public func removeSpinner() {
        self.stopLoadingIndicator()
        self.removeFromSuperview()
    }

    public class func showSpinner(ofSize spinnerType: SpinnerType = .small, spinnerColor: SpinnerShade = .dark, onView: UIView, description: String = "Loading...", title: String = "Please Wait") {
        let loader = RSSpinnerView.shared
        clearViews([loader, loader.outerView, loader.spinnerView])
        onView.addSubview(loader)
        let model = loader.constructDataModel(with: spinnerType, spinnerColor: spinnerColor, inView: onView, description: description, title: title)
        loader.setupEntireView(onModel: model, onView: onView)
        loader.circleView?.animateCircle(duration: 0.5, delay: 0.5)
    }

    public class func hideSpinner() {
        let loader = RSSpinnerView.shared
        loader.stopLoadingIndicator()
        loader.removeFromSuperview()
    }

    public func stopLoadingIndicator() {
        circleView?.stopAnimation()
    }

    class func clearViews(_ views: [UIView]) {
        views.forEach { view in
            view.subviews.forEach { $0.removeFromSuperview() }
        }
    }
}

// MARK: - Safe Array Access
extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
