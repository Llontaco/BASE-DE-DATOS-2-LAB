1. Sizing de la Base de Datos (5 años)
El sizing estima cuánto espacio ocupará nuestra BD. Para simplificar (porque no me dan
datos exactos), se hace con supuestos razonables:
Ciclistas: 200 ciclistas (40 equipos × 5 ciclistas en promedio). Crecimiento: +20/año →
300 al final de 5 años.
Equipos: 40 equipos, +5 cada año → 65 equipos al final de 5 años.
Pruebas: 5 grandes vueltas por año (ej. Tour, Giro, Vuelta, más otras) × 5 años = 25
pruebas.
Participaciones de equipos en pruebas: cada prueba tiene en promedio 20 equipos → 25
× 20 = 500 registros.
Estimación de espacio (supuesto de bytes por registro):
Ciclistas: 200 B × 300 ≈ 60 KB
Equipos: 200 B × 65 ≈ 13 KB
Pruebas: 300 B × 25 ≈ 7.5 KB
Participaciones: 150 B × 500 ≈ 75 KB
Total aproximado: ~200 KB (más índices y margen).
Se recomienda multiplicar ×10 para 5 años + contingencia → 2 MB de datos.

CREACION DE TABLESPACE
-- Tablespace de datos
CREATE TABLESPACE ciclismo_tbs
DATAFILE 'ciclismo_tbs01.dbf'
SIZE 10M
AUTOEXTEND ON
NEXT 5M
MAXSIZE UNLIMITED;
-- Tablespace temporal
CREATE TEMPORARY TABLESPACE ciclismo_temp
TEMPFILE 'ciclismo_temp01.dbf'
SIZE 5M
AUTOEXTEND ON
NEXT 5M
MAXSIZE UNLIMITED;
-- Usuario asignado
CREATE USER ciclismo IDENTIFIED BY ciclismo123
DEFAULT TABLESPACE ciclismo_tbs
TEMPORARY TABLESPACE ciclismo_temp
QUOTA UNLIMITED ON ciclismo_tbs;
GRANT CONNECT, RESOURCE TO ciclismo;

3. CREACION DE OBJETOS(TABLAS)
-- Tabla de equipos
CREATE TABLE Equipo (
idEquipo INT PRIMARY KEY,
nombre VARCHAR2(100) NOT NULL,
nacionalidad VARCHAR2(50),
director VARCHAR2(100)
);
-- Tabla de ciclistas
CREATE TABLE Ciclista (
idCiclista INT PRIMARY KEY,
nombre VARCHAR2(100) NOT NULL,
nacionalidad VARCHAR2(50),
fechaNacimiento DATE,
idEquipo INT,
fechaInicio DATE,
fechaFin DATE,
FOREIGN KEY (idEquipo) REFERENCES Equipo(idEquipo)

);
-- Tabla de pruebas
CREATE TABLE Prueba (
idPrueba INT PRIMARY KEY,
nombre VARCHAR2(100) NOT NULL,
anio NUMBER(4),
numEtapas INT,
kmTotales NUMBER(6,2),
idGanador INT,
FOREIGN KEY (idGanador) REFERENCES Ciclista(idCiclista)
);
-- Participaciones de equipos en pruebas
CREATE TABLE Participacion (
idParticipacion INT PRIMARY KEY,
idPrueba INT,
idEquipo INT,
puestoFinal INT,
FOREIGN KEY (idPrueba) REFERENCES Prueba(idPrueba),
FOREIGN KEY (idEquipo) REFERENCES Equipo(idEquipo)
);
4.INSERCION Y CONSULTAS
-- Equipos
INSERT INTO Equipo VALUES (1, 'Movistar', 'España', 'Juan Pérez');
INSERT INTO Equipo VALUES (2, 'Ineos', 'Reino Unido', 'Carlos López');
-- Ciclistas
INSERT INTO Ciclista VALUES (1, 'Alejandro Valverde', 'España', DATE '1980-04-25', 1,
DATE '2010-01-01', NULL);
INSERT INTO Ciclista VALUES (2, 'Egan Bernal', 'Colombia', DATE '1997-01-13', 2, DATE
'2018-01-01', NULL);
-- Pruebas
INSERT INTO Prueba VALUES (1, 'Tour de Francia', 2023, 21, 3500.50, 2);
INSERT INTO Prueba VALUES (2, 'Giro de Italia', 2024, 21, 3450.75, 1);
-- Participación
INSERT INTO Participacion VALUES (1, 1, 1, 5);
INSERT INTO Participacion VALUES (2, 1, 2, 1);
