class Hechizo {
	
	
	
}

object inmobilus inherits Hechizo {
	
	method hechizar(bot){
		if(not bot.esProfesor())
			bot.cargaElectrica(bot.cargaElectrica() - 50)
	}
	
	method condiciones(bot) = true
	
}

object sectumSempra inherits Hechizo {
	
	method hechizar(bot){
		if(bot.aceitePuro())
			bot.ensuciarAceite()
	}
	
	method condiciones(bot) = bot.experimentado()
	
}

object avadakedabra inherits Hechizo {
	
	method hechizar(bot){
		if(bot.esProfesor())
			bot.cargaElectrica(bot.cargaElectrica() / 2)
		else
			bot.cargaElectrica(0)
	}
	
}

