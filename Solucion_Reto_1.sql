create table peliculas (
id_pelicula integer, 
titulo varchar2(180),
sinopsis varchar2(400),
CONSTRAINT pk_id_pelicula PRIMARY KEY (id_pelicula));

create table sala (
  id_sala integer,
  id_pelicula integer,
  numero_asiento integer,
  CONSTRAINT pk1_id_sala PRIMARY KEY (id_sala), 
  CONSTRAINT FK1_id_pelicula FOREIGN KEY (id_pelicula) 
  references peliculas (id_pelicula)
);
--               describe sala;

create sequence sec_pelicula
start with 1
increment by 1
nomaxvalue;

create sequence sec_sala
start with 1
increment by 1
nomaxvalue;

CREATE OR REPLACE PROCEDURE GUARDAR_PELICULA(my_id out integer,my_titulo IN varchar2,my_sinopsis IN varchar2)
AS
BEGIN
SELECT sec_pelicula.nextval INTO my_id from dual;
    insert into peliculas(id_pelicula,titulo,sinopsis) values(my_id,my_titulo,my_sinopsis);
END;

CREATE OR REPLACE PROCEDURE GUARDAR_SALA(my_id_sala out integer,my_id_pelicula IN integer,my_numero_de_asientos IN integer)
AS
BEGIN
SELECT sec_sala.nextval INTO my_id_sala from dual;
    insert into sala(id_sala,id_pelicula,numero_asiento) values(my_id_sala,my_id_pelicula,my_numero_de_asientos);
END;

DECLARE 
id_pelicula integer;
id_sala integer;
BEGIN
  
    GUARDAR_PELICULA(id_pelicula,'Son como Niños','Pues esta ineteresante y no me aburre');
    GUARDAR_SALA(id_sala,id_pelicula,10);
    GUARDAR_PELICULA(id_pelicula,'Machete','Esta si esta fea pero da risa');
    GUARDAR_SALA(id_sala,id_pelicula,10);
    GUARDAR_PELICULA(id_pelicula,'Birdman','Pues esta para llorar el asunto jaja');
    GUARDAR_SALA(id_sala,id_pelicula,10);
    END;
    
select * from peliculas;
select * from sala;
CREATE OR REPLACE PROCEDURE COMPRAR_BOLETOS(my_titulo IN varchar2,my_id_sala IN integer,my_boletos IN integer)
AS
asientos_actuales integer;
asientos_restantes integer;
BEGIN
  SELECT numero_asiento into asientos_actuales from sala where id_sala = my_id_sala;
  asientos_restantes := asientos_actuales - my_boletos;
  
  IF asientos_restantes < 0 THEN 
    RAISE_APPLICATION_ERROR(-20001,'Lo siento ya no hay asientos disponibles');
END IF;

UPDATE sala SET numero_asiento = asientos_restantes WHERE id_sala = my_id_sala;

END;

BEGIN
  
  COMPRAR_BOLETOS('MACHETE',2,11);
END;
    
