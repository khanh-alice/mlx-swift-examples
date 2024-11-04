import Foundation
import LLM
import MLX

final class DeviceStat: ObservableObject, @unchecked Sendable {

    @Published
    private(set) var gpuUsage: MLX.GPU.Snapshot?

    private let initialGPUSnapshot = GPU.snapshot()
    private var timer: Timer?

    init() {
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            self?.updateGPUUsages()
        }
    }

    deinit {
        timer?.invalidate()
    }

    private func updateGPUUsages() {
        let gpuSnapshotDelta = initialGPUSnapshot.delta(GPU.snapshot())
        DispatchQueue.main.async { [weak self] in
            self?.gpuUsage = gpuSnapshotDelta
        }
    }
}
