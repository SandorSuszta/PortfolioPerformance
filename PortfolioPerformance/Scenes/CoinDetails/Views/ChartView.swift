import UIKit
import Charts

final class ChartView: LineChartView {
    
    private let dataSet = LineChartDataSet(entries: [])
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .systemBackground
        configureDataSet()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    
    private func configureDataSet() {
        dataSet.drawCirclesEnabled = false // Disable data points
        dataSet.mode = .linear
        dataSet.lineWidth = 1.5
        dataSet.cubicIntensity = 0.5
        dataSet.drawHorizontalHighlightIndicatorEnabled = false
        dataSet.highlightEnabled = false
        //dataSet.highlightLineWidth = 1.5
        //dataSet.setColor(color)
    }
}
