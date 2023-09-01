object homero {
	
	var cantidadDonas = 0
	
	method comprarDonas(){
		cantidadDonas = cantidadDonas + 12	
	}
	
	method cantidadDonas() = cantidadDonas
	
	method comerDonas(){
		cantidadDonas = cantidadDonas - 1
	}
	
	method estaDistraido() = cantidadDonas < 2
	
}

object plantaNuclear {
	
	var barrasUranio = 0
	var encargado = homero
	
	method estaEnPeligro() = barrasUranio > 10000 and encargado.estaDistraido() or mrBurns.esPobre() 

	method recibirCargamento(cantidad) {
		barrasUranio = barrasUranio + cantidad
	}
	
	method encargado(nuevoEncargado) {
		encargado = nuevoEncargado
	}
	
}

object patoBalancin {
	
	method estaDistraido() = false

}

object lenny {
	var cervezasTomadas = 0
	
	method tomarCerveza(){
		cervezasTomadas = cervezasTomadas + 1
	}
	
	method estaDistraido() = cervezasTomadas > 3

}

object mrBurns {

	var esMillonario = true
	
	method despojarRiquezas(){
		esMillonario = false
	}
	
	method esPobre() = !esMillonario

}