SELECT TO_CHAR(data_hora, 'DD-MM-YYYY HH24:mi'), FITXER
FROM pirates_sensor
WHERE data_hora BETWEEN '11 Mar 2022' AND '18 Mar 2022'
-- Sabem que el dia 11 la caixa forta estava intacta, per tant ha d'haver passat entre l'11 i el 18
-- Hem de trobar qui hi ha accedit abans de quarts de dues.

SELECT *
FROM pirates_accessos
WHERE data_hora =
	(SELECT MAX(data_hora)
	FROM pirates_accessos
	WHERE data_hora < TO_DATE('16-03-2022 01:36', 'DD-MM-YYYY HH24:mi'))
-- Busquem qui ha fet l'ultim accés abans del robatori
-- Mirem de qui és la clau

SELECT *
FROM pirates_poseeix NATURAL JOIN pirates_empleats
WHERE CLAU_ID = 'opCOpQSDXUie'
-- Sembla que ja tenim al culpable, però veiem que va la clau ha estat desactivada
-- Per descubrir el perquè, busquem als tiquets.

SELECT *
FROM pirates_tiquets
WHERE empleat_id = 108
-- Va perdre la clau i l'Oliver l'ha trobat en un Seat Blau.
-- Busquem qui va agafar aquell Seat abans que ho fes l'Oliver.

SELECT empleat_id
FROM pirates_empleats
WHERE nom = 'Oliver'
-- Abans, però, hem de saber quin id té l'Oliver.
-- Una vegada en sabem l'id, ja podem consultar qui va agafar el cotxe abans que ell

SELECT empleat_id, nom, cognoms
FROM pirates_condueix
NATURAL JOIN pirates_vehicles
NATURAL JOIN pirates_empleats
WHERE marca = 'Seat' AND color = 'blau' AND data_hora = 
	(SELECT MAX(data_hora)
	FROM pirates_condueix
	NATURAL JOIN pirates_vehicles
	WHERE marca = 'Seat' AND color = 'blau' AND data_hora < 
		(SELECT MAX(data_hora)
		FROM pirates_condueix
		NATURAL JOIN pirates_vehicles
		WHERE marca = 'Seat'
		AND color = 'blau'
		AND empleat_id = 119))
-- Primer hem de saber quan va ser l'última vegada que l'Oliver va agafar aquest cotxe. I amb això, busquem l'última persona que hi va pujar abans que ell.
-- D'aquí ja traiem la informació de l'empleat que hi va pujar, i s'hi va deixar la clau robada.