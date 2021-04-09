// Patrones de diseño: Builder

import Foundation

// Modelos
enum CategoriaPlato {
    case entradas, platoPrincipal, guarnisiones, bebidas
}

struct Plato {
    var nombre: String
    var precio: Float
}

struct ArticuloOrdenado {
    var plato: Plato
    var cuantos: Int
}

struct Orden {
    var entradas: [ArticuloOrdenado] = []
    var platoPrincipal: [ArticuloOrdenado] = []
    var guarnisiones: [ArticuloOrdenado] = []
    var bebidas: [ArticuloOrdenado] = []
    
    var precio: Float {
        let articulos = entradas + platoPrincipal + guarnisiones + bebidas
        return articulos.reduce(Float(0), { $0 + $1.plato.precio * Float($1.cuantos) })
    }
}

// Builder

class OrdenBuilder {
    private var orden: Orden?
    
    func resetear() {
        orden = Orden()
    }
    
    func setEntradas(plato: Plato) {
        set(plato: plato, con: orden?.entradas, conCategory: .entradas)
    }
    
    func setPlatoPrincipal(plato: Plato) {
        set(plato: plato, con: orden?.platoPrincipal, conCategory: .platoPrincipal)
    }
    
    func setGuarnisiones(plato: Plato) {
        set(plato: plato, con: orden?.guarnisiones, conCategory: .guarnisiones)
    }
    
    func setBebidas(plato: Plato) {
        set(plato: plato, con: orden?.bebidas, conCategory: .bebidas)
    }
    
    func getResultado() -> Orden? {
        return orden ?? nil
    }
    
    private func set(plato: Plato, con categoriaOrden: [ArticuloOrdenado]?, conCategory categoriaPlato: CategoriaPlato) {
        guard let categoriaOrdenDes = categoriaOrden else {
            return
        }
        
        var articulo: ArticuloOrdenado! = categoriaOrdenDes.filter( { $0.plato.nombre == plato.nombre }).first
        
        guard articulo == nil else {
            articulo.cuantos += 1
            return
        }
        
        articulo = ArticuloOrdenado(plato: plato, cuantos: 1)
        
        switch categoriaPlato {
        case .entradas:
            orden?.entradas.append(articulo)
        case .platoPrincipal:
            orden?.platoPrincipal.append(articulo)
        case .guarnisiones:
            orden?.guarnisiones.append(articulo)
        default:
            orden?.bebidas.append(articulo)
        }
        
        
    }
}


// Uso

let filete = Plato(nombre: "Filete", precio: 12.30)
let patatasFritas = Plato(nombre: "Patatas fritas", precio: 4.20)
let cerveza = Plato(nombre: "Cerveza", precio: 3.50)

let builder = OrdenBuilder()
builder.resetear()
builder.setPlatoPrincipal(plato: filete)
builder.setGuarnisiones(plato: patatasFritas)
builder.setBebidas(plato: cerveza)

let miOrden = builder.getResultado()
miOrden?.precio
