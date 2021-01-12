package utilitarios

import grails.transaction.Transactional
import com.lowagie.text.Image
import seguridad.Persona

@Transactional
class FirmasService {

    def qrCodeService

    def poneFirma(usuario, pago) {
        println "crea el archivo de la firma QR, usuario: $usuario"
        def user = Persona.get(usuario.id)
            try {
                def now = new Date()
                def key = ""
                def texto = ""
                def pathQr = '/var/condominio/firmas/'
                def nombre = "pago_${pago.ingreso.persona.departamento}_" + now.format("dd_MM_yyyy_mm_ss") + ".png"
                new File(pathQr).mkdirs()
                texto += "Cobra: ${user.nombre} ${user.apellido}. Paga dpto: ${pago.ingreso.persona.departamento} " +
                        "${pago.ingreso.observaciones} valor: ${pago.valor}"
                def fos = new FileOutputStream(pathQr + nombre)
                qrCodeService.renderPng(texto, 100, fos)
                fos.close()
                return nombre
            } catch (e) {
                println "error al generar la firma \n " + e
                return "ERROR*No se pudo generar la firma"
            }

    }

}
