package utilitarios

class BuscadorService {

    def dbConnectionService

    boolean transactional = true
    def numFilas

    HashMap toMap(dominio) {
        def mapa = [:]
        dominio.properties.declaredFields.each {
            if (it.getName().substring(0, 1) != "\$" && it.getName().substring(0, 1) != "") {
                mapa.put(it.getName(), it.getType())
            }
        }
        return mapa
    }

    def filtro(operador, parametros, common, mapa, ignoreCase) {
        // println "mapa "+mapa
        def parts = []
        parts.add(" where ")
        def comparador =""
        def band=false
        def campo =""
        def dato
        common.eachWithIndex {it,k->

            if (!parametros[it][0]) {
                parametros[it] = [[]]
            }
            if (parametros[it][0].class != java.util.ArrayList) {
//                println "no es array"
                if ((parametros[it][0] != "null" && parametros[it][0] != " " && parametros[it][0] != null && parametros[it][0] != "")) {
//                     println ">>> IF"
                    def temp = []
                    temp.add(parametros[it])
                    parametros[it] = temp
                } else {
//                    println ">>> ELSE"
                    parametros[it] = [[]]
                }
            }

            campo=it.replaceFirst("&","")
            dato=mapa[campo]
//            println "dato "+dato

            if(ignoreCase){
                //println "si ignorecase"
                if(dato =~ "java.lang.String")
                    campo="lower("+campo+")"
            }
            parametros[it].each { par ->
                if (par[0] != "null" && par[0] != " " && par[0] != null && par[0] != "") {
                    // println "parametro "+par[0]+" dato "+dato +"  "+it+" "+" "+par[1]
                    comparador=par[1]
                    if(dato =~ "java.util.Date"){
                        // println "es date"
                        def fecha = par[0]
                        def qrt=[]
                        def str=""
                        def anio="",mes="",dia=""
                        fecha.toCharArray().each {f->
                            if(f.isDigit()){
                                str+=f
                            }else{
                                qrt.add(str)
                                str=""
                            }
                        }
                        qrt.add(str)
                        //println "qrt "+qrt
                        mes=qrt[1]
                        if(qrt[0].size()==4){
                            anio=qrt[0]
                            dia=qrt[2]
                        }else{
                            dia = qrt[0]
                            anio=qrt[2]
                        }
                        def pattern =dia+"-"+mes+"-"+anio
                        try{
                            fecha=new Date().parse("dd-MM-yyyy",pattern)
                        }catch (e){
                            println "error del parse!! en la fecha "+fecha
                            fecha=new Date().parse("dd-MM-yyyy","01-01-2012")
                        }
                        parts[0]+=" "+campo+" "+comparador+" ? "
                        parts.add(fecha)
                        //println "pattern "+pattern

                    }else{
                        if(dato =~"cratos"){
                            parts[0]+=" "+campo+" "+comparador+" "+par[0]
                        }else{
                            if(par[0] instanceof java.lang.String && ignoreCase)
                                par[0]=par[0].toLowerCase()
                            switch (par[1]) {
                                case "like" :
                                    // println "like"
                                    comparador="like '%"+par[0]+"%'"
                                    band=true
                                    break
                                case "like izq":
                                    // println "like 1"
                                    comparador="like '%"+par[0]+"'"
                                    band=true
                                    break
                                case "like der":
                                    // println "like 2"
                                    comparador="like '"+par[0]+"%'"
                                    band=true
                                    break
                                case "not like izq":
                                    //println "like 3"
                                    comparador="not like '%"+par[0]+"'"
                                    band=true
                                    break
                                case "igual" :
                                    // println "like"
                                    comparador=" = '"+par[0]+"'"
                                    band=true
                                    break
                                default:
                                    // println "default"
                                    comparador=par[1]
                                    break
                            }
                            if(band){
                                //println "s like"
                                parts[0]+=" "+campo+" "+comparador
                                band=false
                            } else{
                                //println "no es like "
                                parts[0]+=" "+campo+" "+comparador+" ? "

                                try{
                                    if(dato=~"int" || dato=~"Int" )
                                        par[0]=par[0].toInteger()
                                    if(dato=~"double" || dato=~"Double" )
                                        par[0]=par[0].toDouble()
//                                    println "aqui  "+par[0]+"  "+par[0].class
                                }catch (e){
                                    println " e to double "+e
                                }
                                parts.add(par[0])

                            }

                            comparador=""
                        }

                    }
                    if(k<common.size()-1){
                        if(parts[0].trim() !="where")
                            parts[0]+=" "+operador+" "
                    }

                } /** *********************************************** FIN           ***********************************************************************/
            } /** *** FIN EACH          *********/

        }
        if(parts[1]==null && parts[0].trim()=="where"){
            parts[0]=""
        }
        return  parts
    }

    List buscar(dominio, tabla, tipo, params, ignoreCase,extras="") {
//        println "params "+params
        def sql = "from " + tabla
        def mapa = toMap(dominio)
        def parametros =[:]
        def alterna =[:]
        def common
        def lista = []
        def orderby = ""
        def sort = params.ordenado
        def order = params.orden
        if (sort) {
            orderby = " ORDER BY ${sort} ${order}"
        }
        if(params.campos instanceof java.lang.String){
            parametros.put(params.campos,[params.criterios,params.operadores])
        }else{
            params.campos.eachWithIndex{p,i->
                if(parametros[p])
                    alterna.put(p+"&",[params.criterios[i],params.operadores[i]])
                else
                    parametros.put(p,[params.criterios[i],params.operadores[i]])
            }
        }

        common=parametros.keySet().intersect(mapa.keySet())
        alterna.each {

            def llave = it.key.toString().replaceFirst("&","")
            if(common.contains(llave)){
                parametros.put(it.key,it.value)
                common.add(it.key)
            }
        }
        def res
        if(tipo=="excluyente")
            res = filtro("and", parametros, common, mapa, ignoreCase)
        else
            res = filtro("or", parametros, common, mapa, ignoreCase)

        sql += res[0]
        res.remove(0)
        if(extras.size()>1){
            if(sql=~"where")
                sql += extras
            else
                sql+= " where "+extras.replaceFirst(" and ","").replaceFirst(" or ","")
        }
        println "sql " + sql  + orderby+" --> pars "+res
        lista = dominio.findAll((sql+orderby).toString(), res,[max: 200])
//        println "lista "+lista
        lista.add(lista.size())
        if (lista.size() < 1 && tipo != "excluyente") {
            res = filtro("or", parametros, common, mapa, ignoreCase)
            sql ="from " + tabla+" "+res[0]
            res.remove(0)
            lista = dominio.refresh().findAll(sql+orderby, res,[max: 200])
            lista.add(lista.size())
        }
        return lista
    }


    def parmProcesos () {
        [[campo: 'prsnnmbr', nombre: 'Nombre',        operador: "contiene:contiene,inicia:inicia con"],
         [campo: 'prsnapll', nombre: 'Apellido',      operador: "contiene:contiene,inicia:inicia con"],
         [campo: 'prsndpto', nombre: 'Deparatamento',      operador: "inicia:inicia con, contiene:contiene"],
//         [campo: 'prsndpto', nombre: 'Núm. Departamento',         operador: "eqStr:Igual a, contiene:contiene"],
        ]
    }

    def parmEgrs () {
        [[campo: 'egrsdscr', nombre: 'Concepto',      operador: "contiene:contiene,inicia:inicia con"],
         [campo: 'prvenmbr', nombre: 'Proveedor',     operador: "contiene:contiene,inicia:inicia con"],
         [campo: 'egrsvlor', nombre: 'Valor',         operador: "gteq:mayor a,lteq:menor a"],
         [campo: 'egrssldo', nombre: 'Saldo',         operador: "gteq:mayor a,lteq:menor a"]
        ]
    }

    def parmIngr () {
        [[campo: 'ingrdscr', nombre: 'Concepto',      operador: "contiene:contiene,inicia:inicia con"],
         [campo: 'ingrprsn', nombre: 'Persona',       operador: "contiene:contiene,inicia:inicia con"],
         [campo: 'ingrvlor', nombre: 'Valor',         operador: "gteq:mayor a,lteq:menor a"],
         [campo: 'ingrsldo', nombre: 'Saldo',         operador: "gteq:mayor a,lteq:menor a,eq:igual a"]
        ]
    }

    def operadores() {   //operadores usados en la opción operador
        [[valor: 'contiene', operador: 'ilike', strInicio: "'%", strFin: "%'"],
         [valor: 'inicia', operador: 'ilike', strInicio: "'", strFin: "%'"],
         [valor: 'eq', operador: '=', strInicio: '', strFin: ''],
         [valor: 'eqStr', operador: '=', strInicio: "'", strFin: "'"],
         [valor: 'gt', operador: '>', strInicio: '', strFin: ''],
         [valor: 'gteq', operador: '>=', strInicio: '', strFin: ''],
         [valor: 'lt', operador: '<', strInicio: '', strFin: ''],
         [valor: 'lteq', operador: '<=', strInicio: '', strFin: ''],
         [valor: 'gtfc', operador: '>=', strInicio: "'", strFin: "'"],
         [valor: 'ltfc', operador: '<=', strInicio: "'", strFin: "'"]
        ]
    }

    def limpiaCriterio(criterio) {
        if (!criterio) {
            criterio = ""
        }
//        println "limpiaCriterio: entra: "+criterio
        criterio = criterio.toLowerCase()
        criterio = criterio.replaceAll(";", "")
        criterio = criterio.replaceAll(":", "")
        criterio = criterio.replaceAll("select", "")
        criterio = criterio.replaceAll("\\*", "")
        criterio = criterio.replaceAll("#", "")
//        criterio = criterio.replaceAll("%", "")
//        criterio = criterio.replaceAll("/", "")
        criterio = criterio.replaceAll("drop", "")
        criterio = criterio.replaceAll("table", "")
        criterio = criterio.replaceAll("from", "")
        criterio = criterio.replaceAll("'", "")
        criterio = criterio.replaceAll('"', "")
        criterio = criterio.replaceAll("\\\\", "")
        criterio = criterio.trim()
//        println "sale: "+criterio
        return criterio
    }

}
