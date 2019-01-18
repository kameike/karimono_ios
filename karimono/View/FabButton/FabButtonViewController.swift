//
//  FabButtonViewController.swift
//  karimono
//
//  Created by Kei Kameda on 2019/01/09.
//  Copyright © 2019 Kei Kameda. All rights reserved.
//

import UIKit
import RxSwift

protocol FabControllable {
    func show() -> CGFloat
    func hide()
    func updateContext(for team: FabButtonContext)
}

struct FabButtonContext {
    let team: Team?
}


@IBDesignable
class FabButton: UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    var labelConstarint: NSLayoutConstraint?
    var label: UILabel?

    init(icon: UIImage) {
        super.init(frame: .zero)
        commonInit()
    }

    init(label: String, icon: UIImage) {
        super.init(frame: .zero)
        setImage(icon, for: .normal)

        let lab = UILabel()
        lab.text = label
        addSubview(lab)
        lab.translatesAutoresizingMaskIntoConstraints = false

        let labelConstarint = lab.leftAnchor.constraint(equalTo: rightAnchor, constant: 15)

        NSLayoutConstraint.activate([
            lab.centerYAnchor.constraint(equalTo: centerYAnchor),
            labelConstarint,
            ])

        self.labelConstarint = labelConstarint

        self.label = lab

        commonInit()
    }

    override func prepareForInterfaceBuilder() {
        commonInit()
    }

    var size: CGFloat {
        return 80
    }

    private let rotation: CGFloat = 0

    func hide(withAnimation useAnimation: Bool) {
        self.labelConstarint?.constant = -(label?.frame.width ?? 0)
        UIView.animate(withDuration: useAnimation ? 0.2: 0, animations: {
            self.transform = self.transform.rotated(by: -self.rotation)
            self.layoutIfNeeded()
            self.label?.alpha = 0
        })
    }

    func show(withAnimation useAnimation: Bool) {

        UIView.animate(withDuration: useAnimation ? 0.2: 0, animations: {
            self.transform = self.transform.rotated(by: self.rotation)
            self.label?.alpha = 1

        }, completion: { _ in
            self.labelConstarint?.constant = 15
            UIView.animate(withDuration: 0.1, animations: {
                self.layoutIfNeeded()
            })
        })
    }

    private func commonInit() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.Karimono.main
        setTitleColor(.white, for: .normal)

        setTitle("2", for: .normal)

        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowColor = UIColor(hex: "000000").cgColor
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 5

        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: size),
            heightAnchor.constraint(equalToConstant: size),
            ])

        layer.cornerRadius = size / 2

        label?.textColor = UIColor.Karimono.textPrimary
    }
}


@IBDesignable
class SmallFabButton: FabButton {
    override var size: CGFloat {
        return 60
    }
}

class FabButtonViewModel: BaseViewModel & RepositoryInjectable {
    var repository: Repositable!
}

class FabButtonUIViewController: UIViewController, InitBaseViewController, ViewModelInjectable {
    typealias ViewModel = FabButtonViewModel
    var viewModel: FabButtonUIViewController.ViewModel!

    private enum State {
        case animating
        case show
        case hide
    }

    private var state: State = .hide
    private let mainButton = FabButton(icon: UIImage())
    private let cameraButton = FabElementButton.loadFromNib()
    private let newButton =  FabElementButton.loadFromNib()
    private let bag = DisposeBag()
    private var newButtonTop: NSLayoutConstraint!
    private var cameraButtonTop: NSLayoutConstraint!
    private var context = FabButtonContext(team: nil)

    private var currentSize: CGFloat {
        return 10
    }

    private let duration: TimeInterval = 0.2



    override func viewDidLoad() {
        super.viewDidLoad()

        view.isUserInteractionEnabled = true

        view.addSubview(mainButton)
        NSLayoutConstraint.activate([
            mainButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mainButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            ])


        view.insertSubview(newButton, at: 0)
        newButtonTop = newButton.centerYAnchor.constraint(equalTo: mainButton.centerYAnchor)

        NSLayoutConstraint.activate([
            newButtonTop,
            newButton.centerXAnchor.constraint(equalTo: mainButton.centerXAnchor),
            ])

        newButtonTop.constant = 0


        newButton.hide(withAnimation: false)
        newButton.setup(label: "直接入力する", icon: UIImage())

        view.insertSubview(cameraButton, at: 0)
        cameraButtonTop = cameraButton.centerYAnchor.constraint(equalTo: mainButton.centerYAnchor)

        NSLayoutConstraint.activate([
            cameraButtonTop,
            cameraButton.centerXAnchor.constraint(equalTo: mainButton.centerXAnchor),
            ])

        cameraButton.setup(label: "QRコードから読み込む", icon: UIImage())

        NSLayoutConstraint.activate([
            cameraButton.topAnchor.constraint(equalTo: view.topAnchor),
            mainButton.rightAnchor.constraint(equalTo: view.rightAnchor),
            ])

        // newButton.addTarget(self, action: #selector(createTapped), for: .touchUpInside)
        // cameraButton.addTarget(self, action: #selector(cameraTapped), for: .touchUpInside)

        mainButton.addTarget(self, action: #selector(handleMainButtonTap), for: .touchUpInside)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if state == .show {
            hide()
        }
    }

    @objc func handleMainButtonTap() {
        switch state {
        case .animating:
            return
        case .hide:
            _ = show()
        case .show:
            hide()
        }
    }

    @objc func createTapped() {
        let vm = NewBorrwoingViewModel(itemName: "", teamName: context.team?.name, memo: nil)
        let vc = NewBorrwoingViewController.viewController(viewModel: vm, repository: viewModel.repository)
        present(vc, animated: true, completion: nil)
    }

    @objc func cameraTapped() {
        let vm = QrCodeReaderViewModel()
        let vc = QrCodeReaderViewController.viewController(viewModel: vm, repository: viewModel.repository)
        present(vc, animated: true, completion: nil)
    }
}

extension FabButtonUIViewController: FabControllable {
    func show() -> CGFloat {
        self.state = .animating
        view.superview?.superview?.layoutIfNeeded()
        newButtonTop.constant = -80 - 10
        cameraButtonTop.constant = -160 - 10

        self.newButton.show(withAnimation: true)
        self.cameraButton.show(withAnimation: true)

        UIView.animate(withDuration: duration, animations: {
            self.view.superview?.superview?.layoutIfNeeded()
        }, completion: { _ in
            self.state = .show
        })
        return currentSize
    }

    func hide() {
        self.state = .animating
        view.superview?.superview?.layoutIfNeeded()
        newButtonTop.constant = 0
        cameraButtonTop.constant = 0

        self.newButton.hide(withAnimation: true)
        self.cameraButton.hide(withAnimation: true)

        UIView.animate(withDuration: duration, animations: {
            self.view.superview?.superview?.layoutIfNeeded()
        }, completion: { _ in
            self.state = .hide
        })
    }

    func updateContext(for team: FabButtonContext) {

    }
}
