class Nave{
    var velocidad
    var direccion
    var combustible

    method estaTranquila() = (combustible>=4000) && (velocidad<12000)
    method estaDeRelajo() = self.estaTranquila() && self.tienePocaActividad()
    method tienePocaActividad()


    method acelerar(cuanto){
        velocidad = 100000.min(velocidad+cuanto)
    }
    method desacelerar(cuanto){
        velocidad = 0.max(velocidad-cuanto)
    }
    method irHaciaElSol(){
        direccion = 10
    }
    method escaparDelSol(){
        direccion = -10
    }
    method ponerseParaleloAlSol(){
        direccion = 0
    }
    method acercarseUnPocoAlSol(){
        direccion = 10.min(direccion+1)
    }
    method alejarseUnPocoDelSol(){
        direccion = -10.max(direccion-1)
    }
    method prepararViaje(){
        combustible += 30000
        self.acelerar(5000)
    }
    
    method recibirAmenaza(){
        self.escapar()
        self.avisar()
    }
    method escapar()
    method avisar()

}
class NaveBaliza inherits Nave{
    var baliza = "rojo"
    const coloresQueTuvo = [baliza]

    override method estaTranquila(){
        return super() && (baliza != "rojo")
    }

    // method baliza() = baliza
    method cambiarColorDeBaliza(nuevoColor){
        baliza = nuevoColor
        coloresQueTuvo.add(baliza)
    }
    override method prepararViaje(){
        super()
        self.cambiarColorDeBaliza("verde")
        self.ponerseParaleloAlSol()
    }
    override method escapar(){
        self.irHaciaElSol()
    }
    override method avisar(){
        self.cambiarColorDeBaliza("rojo")
    }

    override method estaDeRelajo() = coloresQueTuvo.size()==1
}
class NavesDePasajeros inherits Nave{
    const cantidadPasajeros
    var racionesComida = 0
    var racionesBebida = 0

    var racionesComidaServidas = 0
    
    override method tienePocaActividad() = racionesComidaServidas < 50

    method cargarComida(cantidad){
        racionesComida += cantidad
    }
    method descargarComida(cantidad){
        racionesComida -= cantidad
    }
    method cargarBebida(cantidad){
        racionesBebida += cantidad
    }
    method descargarBebida(cantidad){
        racionesBebida -= cantidad
    }
    override method prepararViaje(){
        super()
        self.cargarComida(4*cantidadPasajeros)
        self.cargarBebida(6*cantidadPasajeros)
        self.acercarseUnPocoAlSol()
    }

    override method escapar(){
        velocidad *= 2
    }
    override method avisar(){
// Validar que no baje de 0? o asumir que alcanza y fue.
        self.servirComida(cantidadPasajeros)
        racionesBebida -= cantidadPasajeros*2
    }
    method servirComida(cantidad){
        racionesComida -= cantidad
        racionesComidaServidas += cantidad
    }
}
class NaveDeCombate inherits Nave{
    var estaInvisible
    var estanDesplegadosLosMisiles
    const mensajesEmitidos = []

    override method estaTranquila(){
        return super() && (!estanDesplegadosLosMisiles)
    }

    method estaInvisible() = estaInvisible
    method misilesDesplegados() = estanDesplegadosLosMisiles
    method mensajesEmitidos() = mensajesEmitidos
    method primerMensajeEmitido() = mensajesEmitidos.first()
    method ultimoMensajeEmitido() = mensajesEmitidos.last()
    method esEscueta() = mensajesEmitidos.all({m => m.size()<=30})
    method emitioMensaje(mensaje) = mensajesEmitidos.contains(mensaje)

    method ponerseVisible(){
        estaInvisible = false
    }
    method ponerseInvisible() {
        estaInvisible = true
    }
    
    method desplegarMisiles(){
        estanDesplegadosLosMisiles = true
    }
    method replegarMisiles(){
        estanDesplegadosLosMisiles = false
    }

    method emitirMensaje(mensaje){
        mensajesEmitidos.add(mensaje)
    }

    override method prepararViaje(){
        super()
        self.ponerseVisible()
        self.replegarMisiles()
        self.acelerar(15000)
        self.emitirMensaje("Saliendo en misión")
    }

    override method escapar(){
        self.acercarseUnPocoAlSol()
        self.acercarseUnPocoAlSol()
    }
    override method avisar(){
        self.emitirMensaje("Amenaza recibida")
    }
}

class NaveHospital inherits NavesDePasajeros{
    var tienePreparadosLosQuirofanos = false

    method prepararQuirofanos(){
        tienePreparadosLosQuirofanos = true
    }
    override method estaTranquila(){
        return super() && (!tienePreparadosLosQuirofanos)
    }

    override method recibirAmenaza(){
        super()
        self.prepararQuirofanos()
    }
}

class NaveCombateSigilosa inherits NaveDeCombate{
    override method estaTranquila(){
        return super() && !self.estaInvisible()
    }
    override method escapar(){
        super()
        self.desplegarMisiles()
        self.ponerseInvisible()
    }
}