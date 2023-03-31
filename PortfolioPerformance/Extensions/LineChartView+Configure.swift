import UIKit
import Charts

extension LineChartView {
    public func createNewChart(entries: [ChartDataEntry], color: UIColor) {
        alpha = 1.0
        
        let dataSet = LineChartDataSet(entries: entries)
        dataSet.drawCirclesEnabled = false // Disable data points
        dataSet.mode = .cubicBezier
        dataSet.lineWidth = 1.5
        dataSet.cubicIntensity = 0.5
        dataSet.drawHorizontalHighlightIndicatorEnabled = false
        dataSet.highlightEnabled = false
        dataSet.highlightLineWidth = 1.5
        dataSet.setColor(color)

        data = LineChartData(dataSet: dataSet)
        data?.setDrawValues(false)
        backgroundColor = .systemBackground
        leftAxis.enabled = false // Disable right axis
        xAxis.labelPosition = .bottom // Labels on the bottom
        xAxis.drawGridLinesEnabled = false // Disable vertical grids
        rightAxis.drawAxisLineEnabled = false
        xAxis.drawAxisLineEnabled = false
        rightAxis.gridColor = .clear
        legend.enabled = false // Disable legend
        //xAxis.setLabelCount(4, force: true) // How many labels on axis
        rightAxis.setLabelCount(4, force: false)
        xAxis.avoidFirstLastClippingEnabled = true
        
        // Disable zooming
        doubleTapToZoomEnabled = false
        pinchZoomEnabled = false
        scaleXEnabled = false
        scaleYEnabled = false
       
        //animate(xAxisDuration: 1)
        
        //Gradient
        let gradientColors = [color.cgColor, UIColor.PPSystemBackground.cgColor] as CFArray // Colors of the gradient
        let colorLocations:[CGFloat] = [1.0, 0.0] // Positioning of the gradient
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) // Gradient Object
        dataSet.fill = LinearGradientFill(gradient: gradient!, angle: 90.0) // Set gradient
        dataSet.drawFilledEnabled = true // Draw the Gradient
    }
}
