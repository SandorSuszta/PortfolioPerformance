import UIKit
import Charts

final class PPLineChartView: LineChartView {
    
    private var dataSet = LineChartDataSet(entries: [])
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        configure()
        configureDataSet()
        disableZooming()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    
    private func configure() {
        backgroundColor = .systemBackground
        alpha = 0
        data?.setDrawValues(false)
        legend.enabled = false // Disable legend
        leftAxis.enabled = false // Disable left axis
        rightAxis.drawAxisLineEnabled = false
        rightAxis.gridColor = .clear
        rightAxis.setLabelCount(4, force: false)
        xAxis.labelPosition = .bottom // Labels on the bottom
        xAxis.drawGridLinesEnabled = false // Disable vertical grids
        xAxis.drawAxisLineEnabled = false
        xAxis.setLabelCount(4, force: true) // How many labels on axis
        xAxis.avoidFirstLastClippingEnabled = true
    }
    
    private func configureDataSet() {
        dataSet.drawCirclesEnabled = false // Disable data points
        dataSet.mode = .linear
        dataSet.lineWidth = 1.5
        dataSet.cubicIntensity = 0.5
        dataSet.drawHorizontalHighlightIndicatorEnabled = false
        dataSet.highlightEnabled = false
        //dataSet.highlightLineWidth = 1.5
    }
    
    private func disableZooming() {
        doubleTapToZoomEnabled = false
        pinchZoomEnabled = false
        scaleXEnabled = false
        scaleYEnabled = false
    }
    
    private func addGradient(mainColor: UIColor) {
        let gradientColors = [mainColor.cgColor, UIColor.PPSystemBackground.cgColor] as CFArray // Colors of the gradient
        let colorLocations:[CGFloat] = [1.0, 0.0] // Positioning of the gradient
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) // Gradient Object
        dataSet.fill = LinearGradientFill(gradient: gradient!, angle: 90.0) // Set gradient
        dataSet.drawFilledEnabled = true // Draw the Gradient
    }
    
    
    // MARK: - API
    
    func setChartData(_ data: [ChartDataEntry]) {
        dataSet = LineChartDataSet(entries: data)
        self.data = LineChartData(dataSet: dataSet)
        configure()
        configureDataSet()
    }
    
    func setChartColor(_ color: UIColor) {
        dataSet.setColor(color)
        addGradient(mainColor: color)
    }
}
