//
//  DetaillThreeViewController.swift
//  com.altura
//
//  Created by adrian aguilar on 2/7/18.
//  Copyright © 2018 Altura S.A. All rights reserved.
//

import UIKit
//import Highcharts
import Charts
import SQLite

class DetailThreeViewController: UIViewController {

    let dbase = DBase();
    var db: Connection!
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var barView: BarChartView!
    
    /*var chartView: HIChartView!
    let options = HIOptions()
    let chart = HIChart()
    let meses = HIColumn()
    let credits = HICredits()
    let title_c = HITitle()
    let exporting = HIExporting()
    let xAxis = HIXAxis()
    let yAxis = HIYAxis()
    let tooltip = HITooltip()
    let plotOptions = HIPlotOptions()*/
    
    var data = [BarChartDataEntry]()
    var money:[Double] = []
    var money_month:[String] = []
    var consumo:[Double] = []
    var consumo_month:[String] = []
    
    var colors:[UIColor] = []
    var type = true
    
    let meses = ["Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Septiembre","Octubre","Noviembre","Diciembre"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let detailController = tabBarController as! DetailsTabBarViewController
        
        let detailAccountItem = detailController.detailtAccountItem
        let titleView = detailAccountItem.alias
        let title2View = detailAccountItem.contrato
        //String(describing: detailController.contrato)
        navigationBar.title = " \(titleView) - \(title2View)"
        
        
        let status = dbase.connect_db()
        if( status.value ){
            print("entra a buscar detalles faturas")
            
            let bills_list = self.dbase.getBillsAccount(service: detailAccountItem.servicio)
            
            for item in bills_list{
                print(item.consumo_kwh)
                print(Double(item.consumo_kwh)!)
                
                money.append(Double(item.monto_factura)!)
                money_month.append(getOnlyMonthString(date: item.fecha_emision,2))
                
                consumo.append(Double(item.consumo_kwh)!)
                consumo_month.append(getOnlyMonthString(date: item.fecha_emision,2))
                
            }
            money.reverse()
            money_month.reverse()
            consumo.reverse()
            consumo_month.reverse()
            
        }
        print(money)
        print(consumo)
        
        colors.append(UIColor(red:103.00/255.00, green:58.00/255.00, blue:183.00/255.00, alpha: 1))
        colors.append(UIColor(red:255.00/255.00, green:152.00/255.00, blue:0.00/255.00, alpha: 1))
        colors.append(UIColor(red:63.00/255.00, green:81.00/255.00, blue:181.00/255.00, alpha: 1))
        colors.append(UIColor(red:33.00/255.00, green:150.00/255.00, blue:243.00/255.00, alpha: 1))
        colors.append(UIColor(red:255.00/255.00, green:193.00/255.00, blue:7.00/255.00, alpha: 1))
        colors.append(UIColor(red:0.00/255.00, green:188.00/255.00, blue:212.00/255.00, alpha: 1))
        colors.append(UIColor(red:205.00/255.00, green:220.00/255.00, blue:57.00/255.00, alpha: 1))
        colors.append(UIColor(red:49.00/255.00, green:27.00/255.00, blue:146.00/255.00, alpha: 1))
        colors.append(UIColor(red:230.00/255.00, green:81.00/255.00, blue:0.00/255.00, alpha: 1))       //#E65100
        colors.append(UIColor(red:26.00/255.00, green:35.00/255.00, blue:126.00/255.00, alpha: 1))      //#1A237E
        colors.append(UIColor(red:21.00/255.00, green:101.00/255.00, blue:192.00/255.00, alpha: 1))     //#1565C0
        colors.append(UIColor(red:255.00/255.00, green:111.00/255.00, blue:0.00/255.00, alpha: 1))      //#FF6F00
        colors.append(UIColor(red:230.00/255.00, green:81.00/255.00, blue:0.00/255.00, alpha: 1))       //#E65100
        colors.append(UIColor(red:26.00/255.00, green:35.00/255.00, blue:126.00/255.00, alpha: 1))      //#1A237E
        colors.append(UIColor(red:21.00/255.00, green:101.00/255.00, blue:192.00/255.00, alpha: 1))     //#1565C0
        colors.append(UIColor(red:255.00/255.00, green:111.00/255.00, blue:0.00/255.00, alpha: 1))      //#FF6F00
        colors.append(UIColor(red:230.00/255.00, green:81.00/255.00, blue:0.00/255.00, alpha: 1))       //#E65100
        colors.append(UIColor(red:26.00/255.00, green:35.00/255.00, blue:126.00/255.00, alpha: 1))      //#1A237E
        colors.append(UIColor(red:21.00/255.00, green:101.00/255.00, blue:192.00/255.00, alpha: 1))     //#1565C0
        colors.append(UIColor(red:255.00/255.00, green:111.00/255.00, blue:0.00/255.00, alpha: 1))      //#FF6F00
        
        //barView.delegate = self
        barView.drawBarShadowEnabled = false
        barView.drawValueAboveBarEnabled = false
        
        
        //        chartView.legend = l
        
        
        
       
        updateChartData()
        
    }
    
    func updateChartData(){
        
        let xAxis = barView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.granularity = 1
        xAxis.labelCount = 7
        //xAxis.valueFormatter = DayAxisValueFormatter(chart: barView)
        
        
        let l = barView.legend
        l.horizontalAlignment = .left
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        l.form = .circle
        l.formSize = 9
        l.font = UIFont(name: "HelveticaNeue-Light", size: 11)!
        l.xEntrySpace = 4
        
        let leftAxisFormatter = NumberFormatter()
        
        var i = 0
        data = []
        var months = [String]()
        if type {
            
            leftAxisFormatter.minimumFractionDigits = 0
            leftAxisFormatter.maximumFractionDigits = 1
            leftAxisFormatter.positivePrefix = ""
            leftAxisFormatter.negativePrefix = ""
            
            months = consumo_month
            for item in consumo{
                
                let detail = BarChartDataEntry(x: Double(i), y: item)
                data.append(detail)
                i+=1
            }
        }else{
            
            leftAxisFormatter.minimumFractionDigits = 0
            leftAxisFormatter.maximumFractionDigits = 1
            leftAxisFormatter.negativePrefix = "$ "
            leftAxisFormatter.positivePrefix = "$ "
            
            months = money_month
            for item in money{
              
                let detail = BarChartDataEntry(x: Double(i), y: item)
                data.append(detail)
                i+=1
            }
        }
        
        let leftAxis = barView.leftAxis
        leftAxis.labelFont = .systemFont(ofSize: 10)
        leftAxis.labelCount = 8
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
        leftAxis.labelPosition = .outsideChart
        leftAxis.spaceTop = 0.15
        leftAxis.axisMinimum = 0 // FIXME: HUH?? this replaces startAtZero = YES
        
        let rightAxis = barView.rightAxis
        rightAxis.enabled = true
        rightAxis.labelFont = .systemFont(ofSize: 10)
        rightAxis.labelCount = 8
        rightAxis.valueFormatter = leftAxis.valueFormatter
        rightAxis.spaceTop = 0.15
        rightAxis.axisMinimum = 0
        
        let dataSet = BarChartDataSet(values: self.data, label: nil)
        let charData = BarChartData(dataSet: dataSet)
        
        
        
        dataSet.colors = colors
        
        barView.data = charData
        barView.xAxis.valueFormatter = IndexAxisValueFormatter(values:months)
        barView.xAxis.granularity = 1
        //barView.centerText = "prueba data"
        //barView.drawCenterTextEnabled = true
        
    }

    @IBAction func exit(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }

    @IBAction func changeView(_ sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex)
        if(sender.selectedSegmentIndex == 0){
            self.type = true
            updateChartData()
        }else{
            self.type = false
            updateChartData()
        }
        
    }
    
}
