import SwiftUI
import AVFoundation

struct CameraView: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> UIViewController {
        let controller = UIViewController()
        let session = AVCaptureSession()
        
        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device) else {
            return controller
        }
        
        session.addInput(input)
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        
        // ✅ FIX ICI
        previewLayer.frame = controller.view.bounds
        
        controller.view.layer.addSublayer(previewLayer)
        
        session.startRunning()
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
