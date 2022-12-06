/* Punto 1 */

CREATE TABLE IF NOT EXISTS PELICULAS 
(id SERIAL, nombre VARCHAR(255), anno INTEGER);

CREATE TABLE IF NOT EXISTS TAGS 
(id SERIAL, tag VARCHAR(32));

CREATE TABLE IF NOT EXISTS PELICULAS_TAGS
(id SERIAL, id_pelicula BIGINT, id_tag BIGINT);

/* alter relaciones claves primarias y foraneas */
ALTER TABLE PELICULAS
  ADD CONSTRAINT peliculas_pk
    PRIMARY KEY (id);

ALTER TABLE TAGS
  ADD CONSTRAINT tags_pk
    PRIMARY KEY (id);

ALTER TABLE PELICULAS_TAGS
  ADD CONSTRAINT peliculas_tags_pk
    PRIMARY KEY (id);

/* alter llaves foraneas de peliculas_tags */

ALTER TABLE PELICULAS_TAGS ADD
FOREIGN KEY (id_pelicula)
REFERENCES peliculas (id);

ALTER TABLE PELICULAS_TAGS ADD
FOREIGN KEY (id_tag)
REFERENCES tags (id);


/* Punto 2 */
/* insert peliculas */
INSERT INTO PELICULAS (nombre, anno)
VALUES ('pelicula1', 1980);

INSERT INTO PELICULAS (nombre, anno)
VALUES ('pelicula2', 1981);

INSERT INTO PELICULAS (nombre, anno)
VALUES ('pelicula3', 1982);

INSERT INTO PELICULAS (nombre, anno)
VALUES ('pelicula4', 1983);

INSERT INTO PELICULAS (nombre, anno)
VALUES ('pelicula5', 1984);

/* insert tags */
INSERT INTO TAGS (tag)
VALUES ('drama');

INSERT INTO TAGS (tag)
VALUES ('acción');

INSERT INTO TAGS (tag)
VALUES ('comedia');

INSERT INTO TAGS (tag)
VALUES ('romance');

INSERT INTO TAGS (tag)
VALUES ('ciencia ficción');

/* asociar peliculas con tags */
INSERT INTO PELICULAS_TAGS (id_pelicula, id_tag)
VALUES (1, 1);

INSERT INTO PELICULAS_TAGS (id_pelicula, id_tag)
VALUES (1, 2);

INSERT INTO PELICULAS_TAGS (id_pelicula, id_tag)
VALUES (1, 5);

INSERT INTO PELICULAS_TAGS (id_pelicula, id_tag)
VALUES (2, 3);

INSERT INTO PELICULAS_TAGS (id_pelicula, id_tag)
VALUES (2, 4);


SELECT *
FROM peliculas_tags;

/* Punto 3 */
/* cantidad de tags por pelicula */
SELECT a.id, COUNT(b.id)
FROM PELICULAS a
LEFT JOIN PELICULAS_TAGS b
	ON (a.id = b.id_pelicula)
GROUP BY a.id
ORDER BY a.id;

----------------------
/* Punto 4 */
CREATE TABLE IF NOT EXISTS PREGUNTAS 
(id SERIAL, pregunta VARCHAR(255), respuesta_correcta VARCHAR);

CREATE TABLE IF NOT EXISTS USUARIOS 
(id SERIAL, nombre VARCHAR(255), edad INTEGER);

CREATE TABLE IF NOT EXISTS RESPUESTAS 
(id SERIAL, respuesta VARCHAR(255), usuario_id INTEGER, pregunta_id INTEGER);

/* alteramos las tablas para establecer llaves primarias y foraneas */
ALTER TABLE PREGUNTAS
  ADD CONSTRAINT preguntas_pk
    PRIMARY KEY (id);

ALTER TABLE USUARIOS
  ADD CONSTRAINT usuarios_pk
    PRIMARY KEY (id);

ALTER TABLE RESPUESTAS
  ADD CONSTRAINT respuestas_pk
    PRIMARY KEY (id);

/* y para las llaves foraneas */
ALTER TABLE RESPUESTAS ADD
FOREIGN KEY (usuario_id)
REFERENCES usuarios (id);

ALTER TABLE RESPUESTAS ADD
FOREIGN KEY (pregunta_id)
REFERENCES preguntas (id);

/* Punto 5 */
/* insert usuarios */
INSERT INTO USUARIOS (nombre, edad)
VALUES ('nombre1', 19);

INSERT INTO USUARIOS (nombre, edad)
VALUES ('nombre2', 20);

INSERT INTO USUARIOS (nombre, edad)
VALUES ('nombre3', 21);

INSERT INTO USUARIOS (nombre, edad)
VALUES ('nombre4', 22);

INSERT INTO USUARIOS (nombre, edad)
VALUES ('nombre5', 23);

/* insert preguntas */
INSERT INTO PREGUNTAS (pregunta, respuesta_correcta)
VALUES ('¿Cuántos minutos tiene una hora?', '60');

INSERT INTO PREGUNTAS (pregunta, respuesta_correcta)
VALUES ('¿Cuántas patas tiene una araña?', '8');

INSERT INTO PREGUNTAS (pregunta, respuesta_correcta)
VALUES ('¿Cuál es el río más caudaloso del mundo?', 'Amazonas');

INSERT INTO PREGUNTAS (pregunta, respuesta_correcta)
VALUES ('¿Cada cuántos años tenemos un año bisiesto?', '4');

INSERT INTO PREGUNTAS (pregunta, respuesta_correcta)
VALUES ('¿Qué planeta es el más cercano al Sol?', 'Mercurio');

/* insert respuestas */
INSERT INTO RESPUESTAS (respuesta, usuario_id, pregunta_id)
VALUES ('60', 1, 1);

INSERT INTO RESPUESTAS (respuesta, usuario_id, pregunta_id)
VALUES ('60', 2, 1);

INSERT INTO RESPUESTAS (respuesta, usuario_id, pregunta_id)
VALUES ('8', 3, 2);

INSERT INTO RESPUESTAS (respuesta, usuario_id, pregunta_id)
VALUES ('6', 4, 2);

INSERT INTO RESPUESTAS (respuesta, usuario_id, pregunta_id)
VALUES ('4', 5, 2);

select *
from respuestas;

/* Punto 6 */
SELECT f.id AS usuario_id, COALESCE(sq.num_correctas, 0)
FROM USUARIOS f
LEFT JOIN (SELECT b.usuario_id, COUNT(*) AS num_correctas
		FROM USUARIOS a
		JOIN RESPUESTAS b
			ON(a.id = b.usuario_id)
		JOIN PREGUNTAS c
			ON(b.pregunta_id = c.id)
			AND (b.respuesta = c.respuesta_correcta)
		GROUP BY b.usuario_id) sq
ON (f.id = sq.usuario_id);

/* Punto 7 */
SELECT f.id AS pregunta_id, COALESCE(sq.num_usuarios_correctos, 0)
FROM PREGUNTAS f
LEFT JOIN (SELECT b.pregunta_id, count(DISTINCT b.usuario_id) as num_usuarios_correctos
			FROM USUARIOS a
			JOIN RESPUESTAS b
				ON(a.id = b.usuario_id)
			JOIN PREGUNTAS c
				ON(b.pregunta_id = c.id)
				AND (b.respuesta = c.respuesta_correcta)
			GROUP BY b.pregunta_id) sq
ON (f.id = sq.pregunta_id);

/* pregunta 8 */
ALTER TABLE respuestas DROP CONSTRAINT respuestas_usuario_id_fkey, ADD FOREIGN KEY
(usuario_id) REFERENCES USUARIOS(id) ON DELETE CASCADE;

/* revisamos las respuestas */
SELECT *
FROM RESPUESTAS;

/* borramos el primer usuario */
DELETE FROM USUARIOS
WHERE id = 1;

/* volvemos a revisar las respuestas */
SELECT *
FROM RESPUESTAS;


/* Pregunta 9 */
ALTER TABLE USUARIOS
ADD CHECK (edad>=18);

/* prueba de insert usuario menor a 18 */
INSERT INTO USUARIOS(nombre, edad)
VALUES ('pedrito', 12);


/* Pregunta 10 */
ALTER TABLE USUARIOS
ADD COLUMN email VARCHAR UNIQUE;

/* prueba de unico */
UPDATE USUARIOS
SET email = 'email@gmail.com'
WHERE id = 2;

/* prueba de falla */
UPDATE USUARIOS
SET email = 'email@gmail.com'
WHERE id = 3;