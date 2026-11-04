//
//  LCAppBannerView.swift
//  LiveContainerSwiftUI
//

import Foundation
import UIKit

final class LCAppBannerRootView: UIView {
    static let bannerHeight: CGFloat = 96

    let runControl = LCAppBannerRunControl()

    private let iconImageView = UIImageView()
    private let nameLabel = UILabel()
    private let badgeStack = UIStackView()
    private let sharedBadge = LCAppBannerBadgeView(symbolName: "arrowshape.turn.up.left.fill")
    private let jitBadge = LCAppBannerBadgeView(symbolName: "bolt.fill")
    private let lockBadge = LCAppBannerBadgeView(symbolName: "lock.fill")
    private let bit32Badge = LCAppBannerBadgeView(text: "32")

    override var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: Self.bannerHeight)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        isOpaque = false
        backgroundColor = .clear

        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.layer.cornerRadius = 14
        iconImageView.layer.cornerCurve = .continuous
        iconImageView.clipsToBounds = true
        iconImageView.isAccessibilityElement = false

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = .systemFont(ofSize: 12, weight: .medium)
        nameLabel.textColor = .white
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 1
        nameLabel.lineBreakMode = .byTruncatingTail
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = 0.75
        nameLabel.isAccessibilityElement = false
        nameLabel.layer.shadowColor = UIColor.black.cgColor
        nameLabel.layer.shadowOpacity = 0.6
        nameLabel.layer.shadowRadius = 2
        nameLabel.layer.shadowOffset = .zero
        nameLabel.layer.masksToBounds = false

        badgeStack.translatesAutoresizingMaskIntoConstraints = false
        badgeStack.axis = .horizontal
        badgeStack.alignment = .center
        badgeStack.spacing = 2
        badgeStack.addArrangedSubview(sharedBadge)
        badgeStack.addArrangedSubview(jitBadge)
        badgeStack.addArrangedSubview(bit32Badge)
        badgeStack.addArrangedSubview(lockBadge)

        runControl.translatesAutoresizingMaskIntoConstraints = false

        addSubview(iconImageView)
        addSubview(nameLabel)
        addSubview(runControl)
        addSubview(badgeStack)

        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 64),
            iconImageView.heightAnchor.constraint(equalToConstant: 64),

            nameLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 6),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2),

            runControl.topAnchor.constraint(equalTo: iconImageView.topAnchor),
            runControl.leadingAnchor.constraint(equalTo: iconImageView.leadingAnchor),
            runControl.trailingAnchor.constraint(equalTo: iconImageView.trailingAnchor),
            runControl.bottomAnchor.constraint(equalTo: iconImageView.bottomAnchor),

            badgeStack.topAnchor.constraint(equalTo: iconImageView.topAnchor, constant: -4),
            badgeStack.trailingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 4)
        ])
    }

    func update(
        model: LCAppModel,
        appInfo: LCAppInfo,
        dynamicColors: Bool,
        darkModeIcon: Bool,
        traitCollection: UITraitCollection
    ) {
        let icon = appInfo.iconIsDarkIcon(darkModeIcon) ?? UIImage()
        iconImageView.image = icon
        iconImageView.alpha = model.isAppRunning ? 0.6 : 1
        nameLabel.text = model.displayName

        sharedBadge.isHidden = !model.uiIsShared
        sharedBadge.backgroundColor = UIColor(named: "BadgeColor") ?? .systemOrange
        jitBadge.isHidden = !model.uiIsJITNeeded || model.uiIs32bit
        jitBadge.backgroundColor = UIColor(named: "JITBadgeColor") ?? .systemPurple
        lockBadge.isHidden = !model.uiIsLocked || model.uiIsHidden
        lockBadge.backgroundColor = UIColor(named: "BadgeColor") ?? .systemOrange
        bit32Badge.isHidden = !model.uiIs32bit
        bit32Badge.backgroundColor = UIColor(named: "32BitBadgeColor") ?? .systemBlue

        runControl.update(
            color: .white,
            isSigning: model.isSigningInProgress,
            progress: model.signProgress,
            isEnabled: !model.isAppRunning
        )
        runControl.accessibilityLabel = model.displayName
    }
}

private final class LCAppBannerBadgeView: UIView {
    private let contentView: UIView

    convenience init(symbolName: String) {
        let imageView = UIImageView(image: UIImage(
            systemName: symbolName,
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 8)
        ))
        imageView.tintColor = .white
        imageView.contentMode = .center
        self.init(contentView: imageView)
    }

    convenience init(text: String) {
        let label = UILabel()
        label.text = text
        label.textColor = .white
        label.font = .systemFont(ofSize: 8)
        label.textAlignment = .center
        self.init(contentView: label)
    }

    private init(contentView: UIView) {
        self.contentView = contentView
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        return nil
    }

    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 8
        clipsToBounds = true
        isAccessibilityElement = false

        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 16),
            heightAnchor.constraint(equalToConstant: 16),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

final class LCAppBannerRunControl: UIControl {
    private let baseLayer = CALayer()
    private let progressCircleLayer = CALayer()
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    private var progress = 0.0

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        clipsToBounds = true
        layer.addSublayer(baseLayer)
        layer.addSublayer(progressCircleLayer)

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .white
        activityIndicator.hidesWhenStopped = true
        activityIndicator.isUserInteractionEnabled = false

        addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        isAccessibilityElement = true
        accessibilityTraits = .button
        accessibilityLabel = "lc.appBanner.run".loc
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 14
        baseLayer.frame = bounds

        let width = bounds.width
        progressCircleLayer.frame = CGRect(
            x: (CGFloat(progress) - 2) * width,
            y: bounds.height / 2 - width,
            width: width * 2,
            height: width * 2
        )
        progressCircleLayer.cornerRadius = width
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        bounds.inset(by: UIEdgeInsets(top: -6, left: -10, bottom: -26, right: -10)).contains(point)
    }

    func update(color: UIColor, isSigning: Bool, progress: Double, isEnabled: Bool) {
        self.progress = min(max(progress, 0), 1)
        self.isEnabled = isEn
