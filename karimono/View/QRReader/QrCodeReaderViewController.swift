//
//  QRCodeReaderViewController.swift
//  karimono
//
//  Created by Kei Kameda on 2019/01/08.
//  Copyright © 2019 Kei Kameda. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit
import RxSwift

class QrCodeReaderViewModel: BaseViewModel, RepositoryInjectable {
    var repository: Repositable!
}

class QrCodeReaderViewController: UIViewController, ViewModelInjectable , StoryBoardBasedViewController, AVCaptureMetadataOutputObjectsDelegate {
    typealias ViewModel = QrCodeReaderViewModel
    var viewModel: QrCodeReaderViewModel!

    let captureSession = AVCaptureSession()
    var videoLayer: AVCaptureVideoPreviewLayer!
    @IBOutlet weak var cameraView: UIView!

    @IBOutlet weak var closeButton: UIButton!
    private let bag = DisposeBag()


    override func viewDidLoad() {
        super.viewDidLoad()
        guard let videoDevice = AVCaptureDevice.default(for: .video) else {
            fatalError()
        }
        let videoInput = try! AVCaptureDeviceInput.init(device: videoDevice)
        captureSession.addInput(videoInput)

        let metadataOutput = AVCaptureMetadataOutput()
        captureSession.addOutput(metadataOutput)

        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        metadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]

        videoLayer = AVCaptureVideoPreviewLayer.init(session: captureSession)
        videoLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoLayer.frame = cameraView.bounds
        cameraView.layer.addSublayer(videoLayer)

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession.startRunning()
        }

        closeButton.rx.tap.asObservable()
            .bind(onNext: {[weak self] _ in self?.dismiss(animated: true, completion: nil) })
            .disposed(by: bag)
    }


    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {

        for metadata in metadataObjects as! [AVMetadataMachineReadableCodeObject] {
            if metadata.type == AVMetadataObject.ObjectType.qr {
                if let message = metadata.stringValue, let data = message.data(using: .utf8) {
                    guard let borrowing = try? JSONDecoder().decode(BorrowingRequestData.self, from: data) else {
                        let vc = UIAlertController(title: "読み取りエラー", message: "「\(message)」は読み込めるデータではありません", preferredStyle: .alert)
                        vc.addAction(UIAlertAction(title: "ok", style: .default, handler: { _ in }))
                        present(vc, animated: true, completion: nil)
                        return
                    }

                    let vc = NewBorrwoingViewController.viewController(viewModel: .init(itemName: borrowing.item, teamName: borrowing.teamName, memo: borrowing.memo), repository: DataRepository(executor: RequestExecuter()))
                    present(vc, animated: true, completion: nil)
                }
            }
        }
    }
}
