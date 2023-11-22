class Hechizo {
	
	method condiciones(bot) = true
	
}

class Comun inherits Hechizo {
	
	var cargaDisminuida
	
	method hechizar(bot){
		bot.cargaElectrica(bot.cargaElectrica() - cargaDisminuida)
	}
	
	override method condiciones(bot) = bot.cargaElectrica() > cargaDisminuida
	
}

object inmobilus inherits Hechizo {
	
	method hechizar(bot){
		bot.cargaElectrica(bot.cargaElectrica() - 50)
	}
	
}

object sectumSempra inherits Hechizo {
	
	method hechizar(bot){
		if(bot.aceitePuro())
			bot.ensuciarAceite()
	}
	
	override method condiciones(bot) = bot.experimentado()
	
}

object avadakedabra inherits Hechizo {
	
	method hechizar(bot){
		bot.cargaElectrica(0)
	}
	
	override method condiciones(bot) = bot.casa().esPeligrosa() or not bot.aceitePuro()
	
}