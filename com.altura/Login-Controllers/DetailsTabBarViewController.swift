//
//  DetailsTabBarViewController.swift
//  com.altura
//
//  Created by adrian aguilar on 2/7/18.
//  Copyright © 2018 Altura S.A. All rights reserved.
//

import UIKit

class DetailsTabBarViewController: UITabBarController {
    
    var contrato = ""
    var servicio = ""
    var detailtAccountItem :detailAccount = detailAccount.init(facturas_vencidas: "", deuda_diferida: "", max_fecha_pago: "", tipo_medidor: "", serie_medidor: "", consumo: "", estado_corte: "", contrato: "", cliente: "", uso_servicio: "", direccion: "", ci_ruc: "", id_direccion: "", id_direccion_contrato: "", id_producto: "", id_cliente: "", deuda_pendiente: "", servicio: "", alias: "")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //contrato = ""
        // Do any additional setup after loading the view.
    }



}
