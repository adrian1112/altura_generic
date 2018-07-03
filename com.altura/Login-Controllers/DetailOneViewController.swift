//
//  DetaillOneViewController.swift
//  com.altura
//
//  Created by adrian aguilar on 2/7/18.
//  Copyright © 2018 Altura S.A. All rights reserved.
//

import UIKit
import Highcharts

struct data_pie {
    var name : String
    var y : Double
    
    init(name:String, y:Double) {
        self.name = name
        self.y = y
    }
}

class DetailOneViewController: UIViewController {

    @IBOutlet weak var dataView: UIView!
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    var chartView: HIChartView!
    let options = HIOptions()
    let chart = HIChart()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let detailController = tabBarController as! DetailsTabBarViewController
        
        let titleView = String(describing: detailController.contrato)
        navigationBar.title = titleView
        
        //setea los limites del view hichart
        let bound = CGRect(x: self.view.bounds.minX, y: self.view.bounds.minY, width: self.view.bounds.width, height: self.view.bounds.height-100)
        
        dataView.isHidden = true
        print(bound)
        self.chartView = HIChartView(frame: bound)
        
        
        
        
        chart.plotBackgroundColor = HIColor()
        chart.plotBorderWidth = NSNumber()
        chart.plotShadow = false
        chart.type = "pie"
        
        //options.chart = chart
        
        let legend = HILegend()
        legend.enabled = false
        
        //-----
        let title = HITitle()
        title.text = "Detalle de Deudas"
        
        //let subtitle = HISubtitle()
        //subtitle.text = "Team statistics"
        //options.title = title
        //options.subtitle = subtitle
        
        //-----
        //let xAxis = HIXAxis()
        //xAxis.categories = ["Goals","Assists","Shots On Goal","Shots"]
        //options.xAxis = [xAxis]
        
        //let yAxis = HIYAxis()
        //yAxis.min = 0
        //yAxis.title = HITitle()
        //yAxis.title.text = "Number"
        //options.yAxis = [yAxis]
        
        //-----
     
        //tooltip.pointFormat = @"{series.name}: <b>{point.percentage:.1f}%</b>";
        
        let tooltip = HITooltip()
        //tooltip.headerFormat = "<span style=\"0font-size: 15px\";\">{point.key}</span>"
        tooltip.pointFormat = "{series.name}: <b>{point.percentage:.1f}%</b>"
        //tooltip.footerFormat = "<table><tbody><tr><td style=\"0color: {series.color}; padding: 0\";\">{series.name}:</td><td style=\"0padding: 0\";\"><b>{point.y}</b></td></tr></tbody></table>"
        tooltip.shared = true
        tooltip.useHTML = true
        //options.tooltip = tooltip
        
        var plotoptions = HIPlotOptions()
        plotoptions.pie = HIPie()
        plotoptions.pie.allowPointSelect = true
        plotoptions.pie.cursor = "pointer"
        plotoptions.pie.dataLabels = HIDataLabels()
        plotoptions.pie.dataLabels.enabled = false
        plotoptions.pie.showInLegend = true
        
        var pie = HIPie()
        pie.name = "Microsoft Internet Explorer";
        pie.data = [ 56.33]
        
        var pie1 = HIPie()
        pie1.name = "Chrome";
        pie1.data = [ 24.03]
        
        var pie2 = HIPie()
        pie2.name = "Firefox";
        pie2.data = [ 10.38]
        
        var pie3 = HIPie()
        pie3.name = "Safari";
        pie3.data = [ 4.77]
        
        var pie4 = HIPie()
        pie4.name = "Opera";
        pie4.data = [ 0.91]
        
        var pie5 = HIPie()
        pie5.name = "Proprietary or Undetectable";
        pie5.data = [ 0.2]
        
        
        options.chart = chart;
        options.title = title;
        options.tooltip = tooltip;
        options.plotOptions = plotoptions;
        options.series = [pie,pie1,pie2,pie3,pie4,pie5];
        
        //chartView.options = options;
        
       //--
        
        self.chartView.options = options
        //self.dataView = self.chartView
        self.view.addSubview(self.chartView)
        // Do any additional setup after loading the view.
    }

    @IBAction func exit(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }

}
