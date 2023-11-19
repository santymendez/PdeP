class Usuario {
	
	const nombre
	var memoria
	const chats = []
	const notificaciones = []
	
	method tieneEspacio(mensaje) = self.espacioOcupado() + mensaje.pesoMensaje() <=  memoria
	
	method espacioOcupado() = chats.sum{chat => chat.espacioOcupado()} 

	method buscar(texto) = chats.filter({chat => chat.contiene(texto)})
	
	method contiene(texto) = nombre.contains(texto)

	method mensajesMasPesados() = chats.map({chat => chat.mensajeMasPesado()})

	method recibirNotificacion(notificacion){
		notificaciones.add(notificacion)
	}
	
	method leer(chat){
		notificaciones.filter({n => n.chat() == chat}).forEach({n => n.leer()})
	} 
	
	method notificacionesSinLeer() = notificaciones.filter({n => !n.leida()})
	
}