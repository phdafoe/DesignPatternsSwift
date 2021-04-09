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


// Design Pattern Adpter

import EventKit


//Modelos

protocol EventosProtocol: class {
    var titulo: String { get }
    var fechaInicio: String { get }
    var fechaFin: String { get }
}

extension EventosProtocol {
    var description: String {
        return "Nombre \(titulo)\n inicia: \(fechaInicio)\n finaliza: \(fechaFin)"
    }
}

class EventoLocal: EventosProtocol {
    var titulo: String
    var fechaInicio: String
    var fechaFin: String
    
    init(pTitulo: String, pFechaInicio: String, pFechaFin: String) {
        self.titulo = pTitulo
        self.fechaInicio = pFechaInicio
        self.fechaFin = pFechaFin
    }
}

// Adapter

class EKEventAdapter: EventosProtocol {
    
    private var evento: EKEvent
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        return dateFormatter
    }()
    
    var titulo: String {
        return evento.title
    }
    
    var fechaInicio: String {
        return dateFormatter.string(from: evento.startDate)
    }
    
    var fechaFin: String {
        return dateFormatter.string(from: evento.endDate)
    }
    
    init(evento: EKEvent) {
        self.evento = evento
    }
}

// Uso

let dateFormatter = DateFormatter()
dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"

let eventosStore = EKEventStore()
let evento = EKEvent(eventStore: eventosStore)
evento.title = "Twitch con @devswiftlover y @alfonsomiranda"
evento.startDate = dateFormatter.date(from: "04/09/2021 18:00")
evento.endDate = dateFormatter.date(from: "04/09/2021 20:00")

let adapter = EKEventAdapter(evento: evento)
adapter.description


