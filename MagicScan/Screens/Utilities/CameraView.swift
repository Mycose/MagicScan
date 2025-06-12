import SwiftUI
@preconcurrency import AVFoundation

struct CameraView: UIViewRepresentable {
    class Coordinator: NSObject, @preconcurrency AVCaptureVideoDataOutputSampleBufferDelegate {
        let parent: CameraView

        init(_ parent: CameraView) {
            self.parent = parent
        }

        @MainActor func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
            guard !parent.isProcessing else { return }

            parent.isProcessing = true

            guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
                parent.isProcessing = false
                return
            }
            
            if parent.isEnabled {
                let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
                let context = CIContext()
                if let cgImage = context.createCGImage(ciImage, from: ciImage.extent) {
                    let uiImage = UIImage(cgImage: cgImage)
                    
                    Task {
                        if let titles = await parent.cardRecognizer.recognizeTitlesFromImage(uiImage) {
                            DispatchQueue.main.async {
                                self.parent.onRecognized(titles)
                            }
                        }
                        parent.isProcessing = false
                    }
                } else {
                    parent.isProcessing = false
                }
            }
        }
    }

    let cardRecognizer: CardRecognizer
    let isEnabled: Bool
    var onRecognized: ([String]) -> Void

    @State var isProcessing = false

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UIView {
        let view = UIView()

        let session = AVCaptureSession()
        session.sessionPreset = .photo

        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device),
              session.canAddInput(input) else {
            return view
        }

        session.addInput(input)

        let output = AVCaptureVideoDataOutput()
        output.setSampleBufferDelegate(context.coordinator, queue: DispatchQueue(label: "cameraQueue"))
        session.addOutput(output)

        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = view.bounds
        view.layer.addSublayer(previewLayer)

        DispatchQueue.global(qos: .userInitiated).async {
            session.startRunning()
        }

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        if let previewLayer = uiView.layer.sublayers?.compactMap({ $0 as? AVCaptureVideoPreviewLayer }).first {
            previewLayer.frame = uiView.bounds
        }
    }
}
