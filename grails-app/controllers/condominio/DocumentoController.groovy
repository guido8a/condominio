package condominio

import groovy.json.JsonBuilder
import seguridad.Shield

import javax.imageio.ImageIO
import java.awt.image.BufferedImage

import static java.awt.RenderingHints.KEY_INTERPOLATION
import static java.awt.RenderingHints.VALUE_INTERPOLATION_BICUBIC


/**
 * Controlador que muestra las pantallas de manejo de Documento
 */
class DocumentoController  extends Shield {

    def dbConnectionService

    def subirArchivo_ajax() {

//        println("params.> " + params)

        def condominio = Condominio.get(params.id)
        def anio = new Date().format("yyyy")
//        def path = servletContext.getRealPath("/") + "documentos/" + condominio?.id + "/" + anio + "/"
        def path = "/var/condominio/documentos/${condominio?.id}/"
        new File(path).mkdirs()
        def f = request.getFile('file')  //archivo = name del input type file
        def imageContent = ['image/png': "png", 'image/jpeg': "jpeg", 'image/jpg': "jpg"]
        def okContents = [
                'image/png'                                                                : "png",
                'image/jpeg'                                                               : "jpeg",
                'image/jpg'                                                                : "jpg",

                'application/pdf'                                                          : 'pdf',
                'application/download'                                                     : 'pdf',
                'application/vnd.ms-pdf'                                                   : 'pdf',

                'application/excel'                                                        : 'xls',
                'application/vnd.ms-excel'                                                 : 'xls',
                'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'        : 'xlsx',

                'application/mspowerpoint'                                                 : 'pps',
                'application/vnd.ms-powerpoint'                                            : 'pps',
                'application/powerpoint'                                                   : 'ppt',
                'application/x-mspowerpoint'                                               : 'ppt',
                'application/vnd.openxmlformats-officedocument.presentationml.slideshow'   : 'ppsx',
                'application/vnd.openxmlformats-officedocument.presentationml.presentation': 'pptx',

                'application/msword'                                                       : 'doc',
                'application/vnd.openxmlformats-officedocument.wordprocessingml.document'  : 'docx',

                'application/vnd.oasis.opendocument.text'                                  : 'odt',

                'application/vnd.oasis.opendocument.presentation'                          : 'odp',

                'application/vnd.oasis.opendocument.spreadsheet'                           : 'ods'
        ]

        if (f && !f.empty) {
            def fileName = f.getOriginalFilename() //nombre original del archivo
            def ext

            def parts = fileName.split("\\.")
            fileName = ""
            parts.eachWithIndex { obj, i ->
                if (i < parts.size() - 1) {
                    fileName += obj
                }
            }

            if (okContents.containsKey(f.getContentType())) {
                ext = okContents[f.getContentType()]
                fileName = fileName.size() < 40 ? fileName : fileName[0..39]
                fileName = fileName.tr(/áéíóúñÑÜüÁÉÍÓÚàèìòùÀÈÌÒÙÇç .!¡¿?&#°"'/, "aeiounNUuAEIOUaeiouAEIOUCc_")

                def nombre = fileName + "." + ext
                def pathFile = path + nombre
                def fn = fileName
                def src = new File(pathFile)
                def i = 1
                while (src.exists()) {
                    nombre = fn + "_" + i + "." + ext
                    pathFile = path + nombre
                    src = new File(pathFile)
                    i++
                }
                try {
                    f.transferTo(new File(pathFile)) // guarda el archivo subido al nuevo path
                } catch (e) {
                    println "error al subir el archivo\n" + e
                }

                if (imageContent.containsKey(f.getContentType())) {
                    /* RESIZE */
                    def img = ImageIO.read(new File(pathFile))

                    def scale = 0.5

                    def minW = 200
                    def minH = 200

                    def maxW = minW * 4
                    def maxH = minH * 4

                    def w = img.width
                    def h = img.height

                    if (w > maxW || h > maxH) {
                        int newW = w * scale
                        int newH = h * scale
                        int r = 1
                        if (w > h) {
                            r = w / maxW
                            newW = maxW
                            newH = h / r
                        } else {
                            r = h / maxH
                            newH = maxH
                            newW = w / r
                        }

                        new BufferedImage(newW, newH, img.type).with { j ->
                            createGraphics().with {
                                setRenderingHint(KEY_INTERPOLATION, VALUE_INTERPOLATION_BICUBIC)
                                drawImage(img, 0, 0, newW, newH, null)
                                dispose()
                            }
                            ImageIO.write(j, ext, new File(pathFile))
                        }
                    }
                    /* fin resize */
                } //si es imagen hace resize para que no exceda 800x800

                def documento = new Documento()
                documento.condominio = condominio
                documento.tipoDocumento = TipoDocumento.get(params.tipoDocumento.toInteger())
                documento.clave = ''
                documento.descripcion = params.descripcion
                documento.resumen = params.resumen
                documento.ruta = nombre
                documento.fecha = new Date()

                def data = []
                if (documento.save(flush: true)) {
                } else {
                    println "error al guardar: " + documento.errors
                }
                def json = new JsonBuilder(data)
                render json
            } //ok contents
            else {
                println "llego else no se acepta"
                def data = []
                def json = new JsonBuilder(data)
                render json
            }
        } //f && !f.empty

    }

    def descargar() {
        def doc = Documento.get(params.id)
        def condominio = doc.condominio
        def anio = doc.fecha.format("yyyy")


//        def path = servletContext.getRealPath("/") + "documentos/" + condominio.id + "/" + anio + "/" + doc.ruta
        def path = "/var/condominio/documentos/${condominio?.id}/${doc.ruta}"
        def tipo = doc.ruta.split("\\.")
        tipo = tipo[1]
        switch (tipo) {
            case "jpeg":
            case "gif":
            case "jpg":
            case "bmp":
            case "png":
                tipo = "application/image"
                break;
            case "pdf":
                tipo = "application/pdf"
                break;
            case "doc":
            case "docx":
            case "odt":
                tipo = "application/msword"
                break;
            case "xls":
            case "xlsx":
                tipo = "application/vnd.ms-excel"
                break;
            default:
                tipo = "application/pdf"
                break;
        }
        try {
            def file = new File(path)
            def b = file.getBytes()
            response.setContentType(tipo)
            response.setHeader("Content-disposition", "attachment; filename=" + (doc.ruta))
            response.setContentLength(b.length)
            response.getOutputStream().write(b)
        } catch (e) {
            response.sendError(404)
        }
    }

    def borrarArchivo_ajax() {
        println("borrar archivo " + params)
        def documento = Documento.get(params.id)
        def condominio = documento.condominio
        def anio = documento.fecha.format("yyyy")

//        def path = servletContext.getRealPath("/") + "documentos/" + condominio.id + "/" + anio + "/" + documento.ruta
        def path = "/var/condominio/documentos/${condominio?.id}/${documento.ruta}"

        try{
            documento.delete(flush: true)
            new File(path).delete()
            render "ok"
        }catch(e){
            println("error al borrar el archivo " + e)
            render "no"
        }
    }


    def form_ajax(){
        println("params " + params)
        def documento = Documento.get(params.id)
        return[documento: documento]
    }


    def guardarInfoDocumento_ajax(){
        println("params " + params)
        def documento = Documento.get(params.id)
        documento.properties = params

        if(!documento.save(flush:true)){
            println("error al guardar " + documento.errors)
            render "no"
        }else{
            render "ok"
        }
    }

    /**
     * Acción llamada con ajax que muestra y permite modificar los documentos de un proyecto
     */
    def listDocu() {
        def condominio = Condominio.get(session.condominio.id)
        return [condominio: condominio]
    }

    def list(){
        def condominio = Condominio.get(params.id)
        def documentos = Documento.findAllByCondominio(condominio)
        return[condominio: condominio, documentos: documentos]
    }

    /**
     * Acción llamada con ajax que llena la tabla de los documentos de un proyecto
     */
    def tablaDocu_ajax() {
        def condominio = Condominio.get(params.id)
        def cn = dbConnectionService.getConnection()
        def busca = params.search? "%${params.search}%" : "%"
        def sql = "select tpdcdscr, dcmt__id, dcmtdscr, dcmtclve, dcmtrsmn, dcmtfcha from dcmt, tpdc " +
                "where cndm__id = ${condominio.id} and  tpdc.tpdc__id = dcmt.tpdc__id and " +
                "(dcmtdscr ilike '${busca}' or " +
                "tpdcdscr ilike '${busca}' or dcmtclve ilike '${busca}' or dcmtrsmn ilike '${busca}') " +
                "order by dcmtdscr"
        println "sql: $sql"
        def dcmt = cn.rows(sql.toString())
        return [documentos: dcmt]
    }

    /**
     * Acción llamada con ajax que muestra un formulario para crear o modificar un elemento
     * @return documentoInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def formDocu_ajax() {
        println "formDocu_ajax: $params"
        def condominio = Condominio.get(params.condominio)
        def documentoInstance = new Documento()
        if (params.id) {
            documentoInstance = Documento.get(params.id)
            if (!documentoInstance) {
                documentoInstance = new Documento()
            }
        }
        return [documentoInstance: documentoInstance, condominio: condominio]
    } //form para cargar con ajax en un dialog


    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {
        println "save_ajax: $params"
        def condominio = Condominio.get(params.condominio)

        def pathSave = ""
        def path = "/var/condominio/documentos/"
        if (condominio) {
            path += "${condominio.id}/" + pathSave
        }

        //web-app/archivos
        new File(path).mkdirs()
        def f = request.getFile('documento')  //archivo = name del input type file
        def imageContent = ['image/png': "png", 'image/jpeg': "jpeg", 'image/jpg': "jpg"]
        def okContents = [
                'image/png'                                                                : "png",
                'image/jpeg'                                                               : "jpeg",
                'image/jpg'                                                                : "jpg",

                'application/pdf'                                                          : 'pdf',
                'application/download'                                                     : 'pdf',
                'application/vnd.ms-pdf'                                                   : 'pdf',

//                'application/excel'                                                        : 'xls',
                'application/vnd.ms-excel'                                                 : 'xls',
                'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'        : 'xlsx',

                'application/mspowerpoint'                                                 : 'pps',
                'application/vnd.ms-powerpoint'                                            : 'pps',
                'application/powerpoint'                                                   : 'ppt',
                'application/x-mspowerpoint'                                               : 'ppt',
                'application/vnd.openxmlformats-officedocument.presentationml.slideshow'   : 'ppsx',
                'application/vnd.openxmlformats-officedocument.presentationml.presentation': 'pptx',

                'application/msword'                                                       : 'doc',
                'application/vnd.openxmlformats-officedocument.wordprocessingml.document'  : 'docx',

                'application/vnd.oasis.opendocument.text'                                  : 'odt',

                'application/vnd.oasis.opendocument.presentation'                          : 'odp',

                'application/vnd.oasis.opendocument.spreadsheet'                           : 'ods',
                'application/zip'                                                          : 'zip',
                'application/x-zip-compressed'                                             : 'zip',
                'multipart/x-zip'                                                          : 'zip'
        ]

        if (f && !f.empty) {
            def fileName = f.getOriginalFilename() //nombre original del archivo
            def ext

            def parts = fileName.split("\\.")
            fileName = ""
            parts.eachWithIndex { obj, i ->
                if (i < parts.size() - 1) {
                    fileName += obj
                }
            }

//            println("-----> " + f.getContentType())

            if (okContents.containsKey(f.getContentType())) {
                ext = okContents[f.getContentType()]
                fileName = fileName.size() < 40 ? fileName : fileName[0..39]
                fileName = fileName.tr(/áéíóúñÑÜüÁÉÍÓÚàèìòùÀÈÌÒÙÇç .!¡¿?&#°"'/, "aeiounNUuAEIOUaeiouAEIOUCc_")

                def nombre = fileName + "." + ext
                def pathFile = path + nombre
                def fn = fileName
                def src = new File(pathFile)
                def i = 1
                println "---> $pathFile"
                while (src.exists()) {
                    nombre = fn + "_" + i + "." + ext
                    pathFile = path + nombre
                    src = new File(pathFile)
                    i++
                }
                try {
                    f.transferTo(new File(pathFile)) // guarda el archivo subido al nuevo path
                } catch (e) {
                    println "????????\n" + e + "\n???????????"
                }

                if (imageContent.containsKey(f.getContentType())) {
                    /* RESIZE */
                    def img = ImageIO.read(new File(pathFile))

                    def scale = 0.5

                    def minW = 200
                    def minH = 200

                    def maxW = minW * 4
                    def maxH = minH * 4

                    def w = img.width
                    def h = img.height

                    if (w > maxW || h > maxH) {
                        int newW = w * scale
                        int newH = h * scale
                        int r = 1
                        if (w > h) {
                            r = w / maxW
                            newW = maxW
                            newH = h / r
                        } else {
                            r = h / maxH
                            newH = maxH
                            newW = w / r
                        }

                        new BufferedImage(newW, newH, img.type).with { j ->
                            createGraphics().with {
                                setRenderingHint(KEY_INTERPOLATION, VALUE_INTERPOLATION_BICUBIC)
                                drawImage(img, 0, 0, newW, newH, null)
                                dispose()
                            }
                            ImageIO.write(j, ext, new File(pathFile))
                        }
                    }
                    /* fin resize */
                } //si es imagen hace resize para que no exceda 800x800
//                println "llego hasta aca"

                //aqui guarda el obj en la base
                def documentoInstance = new Documento()
                if (params.id) {
                    documentoInstance = Documento.get(params.id)
                    if (!documentoInstance) {
                        documentoInstance = new Documento()
                        println "ERROR*No se encontró Documento."
                    }
                }
                params.remove("documento")
                documentoInstance.properties = params
                documentoInstance.ruta = pathSave + nombre

                println "archivo --> $pathSave  + $nombre"
                if (condominio) {
                    documentoInstance.condominio = condominio
                    println "condominio --> $condominio"
                }
                if (!documentoInstance.save(flush: true)) {
                    render "ERROR*Ha ocurrido un error al guardar Documento: " + renderErrors(bean: documentoInstance)
                    def file = new File(pathFile)
                    file.delete()
                    return
                }
                render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de Documento exitosa."
                return
            } //ok contents
            else {
                println "llego else no se acepta"
                render "ERROR*Extensión no permitida."
                return
            }
        } //f && !f.empty
        else {
            if (params.id) {
//                def documentoInstance = new Documento()
                def documentoInstance = Documento.get(params.id)
                if (!documentoInstance) {
                    documentoInstance = new Documento()
                    println "ERROR*No se encontró Documento."
                }
                params.remove("documento")
                documentoInstance.properties = params
                if (!documentoInstance.save(flush: true)) {
                    render "ERROR*Ha ocurrido un error al guardar Documento: " + renderErrors(bean: documentoInstance)
                    return
                }
                render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de Documento exitosa."
                return
            } else {
                render "ERROR*No se encontró un Documento que modificar"
                return
            }
        }
    } //save para grabar desde ajax


}
