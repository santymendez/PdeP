class Personaje {
	
	var copas
	
	method realizarMision(copasEnJuego){
		copas += copasEnJuego
	}
	
	method copas() = copas
	
}

class Arquero inherits Personaje{
	
	var agilidad
	var rango
	
	method destreza() = agilidad * rango
	
	method tieneEstrategia() = rango > 100
	
}

class Guerrera inherits Personaje {
	
	var estrategia
	var fuerza
	
	method tieneEstrategia() = estrategia
	
	method destreza() = fuerza * 1.5
	
}

class Ballestero inherits Arquero{
	
	override method destreza() = 2 * super()
	
}