% …jugador(Nombre, Rating, Civilizacion).
jugador(juli, 2200, jemeres).
jugador(aleP, 1600, mongoles).
jugador(feli, 500000, persas).
jugador(aleC, 1723, otomanos).
jugador(ger, 1729, ramanujanos).
jugador(juan, 1515, britones).
jugador(marti, 1342, argentinos).

% …tiene(Nombre, QueTiene).
tiene(aleP, unidad(samurai, 199)).
tiene(aleP, unidad(espadachin, 10)).
tiene(aleP, unidad(granjero, 10)).
tiene(aleP, recurso(800, 300, 100)).
tiene(aleP, edificio(casa, 40)).
tiene(aleP, edificio(castillo, 1)).
tiene(juan, unidad(granjero, 10)).
tiene(juan, unidad(espadachin, 10)).
tiene(juan, unidad(carreta, 10)).

% militar(Tipo, costo(Madera, Alimento, Oro), Categoria).
militar(espadachin, costo(0, 60, 20), infanteria).
militar(arquero, costo(25, 0, 45), arqueria).
militar(mangudai, costo(55, 0, 65), caballeria).
militar(samurai, costo(0, 60, 30), unica).
militar(keshik, costo(0, 80, 50), unica).
militar(tarcanos, costo(0, 60, 60), unica).
militar(alabardero, costo(25, 35, 0), piquero).

% aldeano(Tipo, produce(Madera, Alimento, Oro)).
aldeano(lenador, produce(23, 0, 0)).
aldeano(granjero, produce(0, 32, 0)).
aldeano(minero, produce(0, 0, 23)).
aldeano(cazador, produce(0, 25, 0)).
aldeano(pescador, produce(0, 23, 0)).
aldeano(alquimista, produce(0, 0, 25)).

% edificio(Edificio, costo(Madera, Alimento, Oro)).
edificio(casa, costo(30, 0, 0)).
edificio(granja, costo(0, 60, 0)).
edificio(herreria, costo(175, 0, 0)).
edificio(castillo, costo(650, 0, 300)).
edificio(maravillaMartinez, costo(10000, 10000, 10000)).

/* ----------1----------
Definir el predicado esUnAfano/2, que nos dice si al jugar el primero contra el segundo, la diferencia de
rating entre el primero y el segundo es mayor a 500.
*/

esUnAfano(UnJugador,OtroJugador):-
rating(UnJugador,RatingJugador1),
rating(OtroJugador,RatingJugador2),
diferenciaMayorA(RatingJugador1,RatingJugador2,500,sinValoresAbsolutos).

rating(UnJugador,Rating):-
jugador(UnJugador, Rating,_).

diferenciaMayorA(ValorAComparar1,ValorAComparar2,ValorDeDiferencia,sinValoresAbsolutos):-
Diferencia is ValorAComparar1 - ValorAComparar2,
Diferencia > ValorDeDiferencia.

diferenciaMayorA(ValorAComparar1,ValorAComparar2,ValorDeDiferencia,conValoresAbsolutos):-
Diferencia is ValorAComparar1 - ValorAComparar2,
abs(Diferencia,DiferenciaAbsoluta),
DiferenciaAbsoluta > ValorDeDiferencia.

/* ----------2----------
Definir el predicado esEfectivo/2, que relaciona dos unidades si la primera puede ganarle a la otra 
según su categoría, dado por el siguiente piedra, papel o tijeras:
La caballería le gana a la arquería.
La arquería le gana a la infantería.
La infantería le gana a los piqueros.
Los piqueros le ganan a la caballería.
Por otro lado, los Samuráis son efectivos contra otras unidades únicas (incluidos los samurái).
Los aldeanos nunca son efectivos contra otras unidades.
*/
esEfectivo(caballeria,arqueria).
esEfectivo(arqueria,infanteria).
esEfectivo(infanteria,piquetero).
esEfectivo(piquetero,caballeria).
esEfectivo(samurai,Atacado):-
militar(Atacado,_,unica).
esEfectivo(Atacante,Atacado):-
aldeano(Atacante,_),
aldeano(Atacado,_).


/* ----------3----------
Definir el predicado alarico/1 que se cumple para un jugador si solo tiene unidades de infantería.
*/
alarico(UnJugador):-
jugador(UnJugador,_,_),
todasSusUnidadesSonDe(infanteria,UnJugador).

todasSusUnidadesSonDe(CategoriaDeUnidad,UnJugador):-
forall(tiene(UnJugador, unidad(TipoDeUnidad,_)),militar(TipoDeUnidad,_, CategoriaDeUnidad)).

/* ----------4----------
Definir el predicado leonidas/1, que se cumple para un jugador si solo tiene unidades de piqueros.
*/
leonidas(UnJugador):-
jugador(UnJugador,_,_),
todasSusUnidadesSonDe(piquetero,UnJugador).

/* ----------5----------
Definir el predicado nomada/1, que se cumple para un jugador si no tiene casas.
*/

nomada(UnJugador):-
jugador(UnJugador,_,_),
not(tieneAlgunEdificioDe(casa,UnJugador)).

tieneAlgunEdificioDe(Edificio,UnJugador):-
tiene(UnJugador,edificio(Edificio,_)).

/* ----------6----------
Definir el predicado cuantoCuesta/2, que relaciona una unidad o edificio con su costo. De las unidades militares y 
de los edificios conocemos sus costos. Los aldeanos cuestan 50 unidades de alimento. Las carretas y urnas mercantes 
cuestan 100 unidades de madera y 50 de oro cada una.
*/
cuantoCuesta(Objeto,Valor):-
militar(Objeto,Valor,_).
cuantoCuesta(Objeto,Valor):-
edificio(Objeto,Valor).
cuantoCuesta(Objeto,(0,50,0)):-
aldeano(Objeto,_).
cuantoCuesta(carreta,(100,0,50)).
cuantoCuesta(urnaMercante,(100,0,50)).

/* ----------7----------
Definir el predicado produccion/2, que relaciona una unidad con su producción de recursos por minuto. De los aldeanos, 
según su profesión, se conoce su producción. Las carretas y urnas mercantes producen 32 unidades de oro por minuto. 
Las unidades militares no producen ningún recurso, salvo los Keshiks, que producen 10 de oro por minuto.
*/
produccion(Unidad,(Madera,Alimento,Oro)):-
aldeano(Unidad,produce(Madera,Alimento,Oro)).
produccion(carreta,(0,0,32)).
produccion(urnaMercante,(0,0,32)).
produccion(keshik,(0,0,32)).

/* ----------8----------
Definir el predicado produccionTotal/3 que relaciona a un jugador con su producción total por minuto de cierto recurso,
que se calcula como la suma de la producción total de todas sus unidades de ese recurso.
*/
% produce(Madera, Alimento, Oro)
%produccionTotal(juan,oro,ProduccionDelRecurso).
produccionTotal(UnJugador,Recurso,ProduccionDelRecurso):-
jugador(UnJugador,_,_),
recurso(Recurso),
findall(ValorDelRecurso,(tiene(UnJugador,unidad(Unidad,Cuantas)),calcularValorDelRecurso(Unidad,Cuantas,Recurso,ValorDelRecurso)),ValorEnUnaLista),
sumlist(ValorEnUnaLista,ProduccionDelRecurso).

recurso(madera).
recurso(alimento).
recurso(oro).

calcularValorDelRecurso(Unidad,Cuantas,Recurso,ValorDelRecurso):-
produccion(Unidad,ProduccionDelaUnidad),
produccionDelRecurso(Recurso,ProduccionDelaUnidad,RecursoUnaSolaUnidad),
ValorDelRecurso is RecursoUnaSolaUnidad * Cuantas.

produccionDelRecurso(madera,(Recurso,_,_),Recurso).
produccionDelRecurso(alimento,(_,Recurso,_),Recurso).
produccionDelRecurso(oro,(_,_,Recurso),Recurso).

/* ----------9----------
Definir el predicado estaPeleado/2 que se cumple para dos jugadores cuando no es un afano para ninguno,
tienen la misma cantidad de unidades y la diferencia de valor entre su producción total de recursos por minuto es menor a 100. 
¡Pero cuidado! No todos los recursos valen lo mismo: 
el oro vale cinco veces su cantidad; 
la madera, tres veces;  
los alimentos, dos veces.
*/
estaPeleado(UnJugador,OtroJugador):-
jugador(UnJugador, _, _),
jugador(OtroJugador, _, _),
UnJugador\= OtroJugador,
not(esUnAfano(UnJugador,OtroJugador)),
not(esUnAfano(OtroJugador,UnJugador)),
produccionTotalDeRecursos(UnJugador,RecursosTotalesUnJugador),
produccionTotalDeRecursos(OtroJugador,RecursosTotalesOtroJugador),
not(diferenciaMayorA(RecursosTotalesUnJugador,RecursosTotalesOtroJugador,100,conValoresAbsolutos)).

produccionTotalDeRecursos(UnJugador,RecursosTotalesDelJugador):-
findall(Valor,valorDeLosRecursos(UnJugador,Valor),ValoresDeLosRecursos),
sumlist(ValoresDeLosRecursos,RecursosTotalesDelJugador).

valorDeLosRecursos(UnJugador,ValorDelRecurso):-
produccionTotal(UnJugador,Recurso,ProduccionDelRecurso),
multiplicarRecursoPorSuValor(Recurso,ProduccionDelRecurso,ValorDelRecurso).

multiplicarRecursoPorSuValor(oro,CantidadDelRecurso,ValorDelRecurso):-
ValorDelRecurso is CantidadDelRecurso * 5.

multiplicarRecursoPorSuValor(madera,CantidadDelRecurso,ValorDelRecurso):-
ValorDelRecurso is CantidadDelRecurso * 3.

multiplicarRecursoPorSuValor(alimento,CantidadDelRecurso,ValorDelRecurso):-
ValorDelRecurso is CantidadDelRecurso * 2.

/* ----------10----------
Definir el predicado avanzaA/2 que relaciona un jugador y una edad si este puede avanzar a ella:
Siempre se puede avanzar a la edad media.
Puede avanzar a edad feudal si tiene al menos 500 unidades de alimento y una casa.
Puede avanzar a edad de los castillos si tiene al menos 800 unidades de alimento y 200 de oro. 
También es necesaria una herrería, un establo o una galería de tiro.
Puede avanzar a edad imperial con 1000 unidades de alimento, 800 de oro, un castillo y una universidad.

*/
edificioNecesario(edadDeLosCastillos, herreria).
edificioNecesario(edadDeLosCastillos, establo).
edificioNecesario(edadDeLosCastillos, galeriaDeTiro).
edificioNecesario(edadImperial, castillo).
edificioNecesario(edadImperial, universidad).

avanza(UnJugador,edadMedia):-
jugador(UnJugador,_,_).
avanza(UnJugador,Edad):-
jugador(UnJugador,_,_),
condicionesParaAvanzarDeEdad(UnJugador,Edad).

condicionesParaAvanzarDeEdad(UnJugador, edadFeudal):-
tiene(UnJugador,alimento,500),
not(nomada(UnJugador)).

condicionesParaAvanzarDeEdad(UnJugador, edadDeLosCastillos):-
tiene(UnJugador,alimento,800),
tiene(UnJugador,oro,200),
tieneEdificioNecesario(edadDeLosCastillos,UnJugador).

condicionesParaAvanzarDeEdad(UnJugador,edadImperial):-
tiene(UnJugador,alimento,1000),
tiene(UnJugador,oro, 800),
tieneEdificioNecesario(edadImperial,UnJugador).

tiene(UnJugador,Recurso,Cantidad):-
produccionTotal(UnJugador,Recurso,ProduccionDelRecurso),
Cantidad >= ProduccionDelRecurso.

tieneEdificioNecesario(Edad,UnJugador):-
edificioNecesario(Edad,Edificio),
tiene(UnJugador, edificio(Edificio, _)).