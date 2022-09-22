DROP DATABASE IF EXISTS movedb;
CREATE DATABASE IF NOT EXISTS movedb;
USE movedb;
show tables;
CREATE TABLE EmpresaMaestro (
  codigoEmpresa INT AUTO_INCREMENT NOT NULL, 
  nombreEmpresa VARCHAR(255), 
  nombreComercial VARCHAR(255), 
  direccionEmpresa VARCHAR(255), 
  NITEmpresa VARCHAR(255), 
  porcentajeIVA FLOAT NULL, 
  PRIMARY KEY PK_codigoEmpresa(codigoEmpresa)
);

CREATE TABLE Usuario (
  codigoUsuario INT AUTO_INCREMENT NOT NULL,
  username VARCHAR(255) NOT NULL,
  correo VARCHAR(255) NOT NULL,
  nombre VARCHAR(255) NOT NULL,
  apellido VARCHAR(255) NOT NULL,
  claveUsuario VARCHAR(255) NOT NULL,
  role VARCHAR(100) NOT NULL,
  PRIMARY KEY PK_codigoUsuario(codigoUsuario)
);

CREATE TABLE ImpuestoAdicional (
  codigoValorImpuesto INT AUTO_INCREMENT NOT NULL, 
  descripcionImpuesto VARCHAR(255), 
  valorImpuesto FLOAT NULL, 
  PRIMARY KEY PK_codigoValorImpuesto(codigoValorImpuesto)
);

CREATE TABLE TipoMovimientoLibroComprasVentas (
  codigoTipoMovimientoLibroComprasVentas INT AUTO_INCREMENT NOT NULL, 
  descripcionMovimiento VARCHAR(255), 
  tipoLibro INTEGER, 
  tipoMovimiento INTEGER, 
  PRIMARY KEY PK_codigoTipoMovimientoLibroComprasVentas (codigoTipoMovimientoLibroComprasVentas)
);

CREATE TABLE CuentaContable (
  codigoCuentaC INT AUTO_INCREMENT NOT NULL,
  codigoCuentaContable VARCHAR(20) NOT NULL, 
  codigoEmpresa INT NOT NULL, 
  nombreCuentaContable VARCHAR(50), 
  tipoCuentaContable INTEGER DEFAULT 0, 
  padreCuentaContable VARCHAR(20), 
  nivelCuentaContable INTEGER DEFAULT 0, 
  recibePartidasCuentaContable INTEGER, 
  PRIMARY KEY PK_codigoCuentaC(codigoCuentaC),
  CONSTRAINT FK_CuentaContable_EmpresaMaestro FOREIGN KEY (codigoEmpresa) REFERENCES EmpresaMaestro (codigoEmpresa)
);

CREATE TABLE PlantillaContableMaestro (
  codigoPlantillaContableMaestro INT AUTO_INCREMENT NOT NULL,
  codigoEmpresa INT NOT NULL, 
  codigoPlantillaContable INTEGER NOT NULL DEFAULT 0, 
  descripcionPlantillaContable VARCHAR(255), 
  caracteristicasPlantillaContable LONGTEXT, 
  tipoPlantilla INTEGER DEFAULT 0, 
  PRIMARY KEY PK_codigoPlantillaContableMestro(codigoPlantillaContableMaestro),
  CONSTRAINT FK_PlantillaContableMaestro_EmpresaMaestro FOREIGN KEY (codigoEmpresa) REFERENCES EmpresaMaestro(codigoEmpresa)
);

CREATE TABLE PlantillaContableDetalle (
  codigoPlantillaContableDetalle INT AUTO_INCREMENT NOT NULL,
  codigoEmpresa INT NOT NULL,
  codigoCuentaC INT NOT NULL,
  codigoPlantillaContableMaestro INT NOT NULL,
  codigoPlantillaContable INTEGER NOT NULL DEFAULT 0, 
  correlativoPlantillaContable INTEGER NOT NULL DEFAULT 0, 
  codigoCuentaContable VARCHAR(20) NOT NULL, 
  tipoMovimientoPlantillaContable INTEGER DEFAULT 0, 
  porcentajeCuentaContable FLOAT NULL DEFAULT 0, 
  PRIMARY KEY PK_codigoPlantillaContableDetalle(codigoPlantillaContableDetalle),
  CONSTRAINT FK_PlantillaContableDetalle_EmpresaMaestro FOREIGN KEY (codigoEmpresa) REFERENCES EmpresaMaestro(codigoEmpresa),
  CONSTRAINT FK_PlantillaContableDetalle_CuentaContable FOREIGN KEY (codigoCuentaC) REFERENCES CuentaContable(codigoCuentaC),
  CONSTRAINT FK_PlantillaContableDetalle_PlantillaContableMaestro FOREIGN KEY (codigoPlantillaContableMaestro) REFERENCES PlantillaContableMaestro(codigoPlantillaContableMaestro)
);

CREATE TABLE LibroComprasVentasMaestro (
  codigoLibroComprasVentasMaestro INT AUTO_INCREMENT NOT NULL,
  codigoEmpresa INT NOT NULL,
  codigoPlantillaContable INT, 
  numeroLibro INTEGER NOT NULL, 
  fechaInicial DATETIME, 
  fechaFinal DATETIME, 
  estadoLibro INTEGER, 
  tipoLibro INTEGER, 
  fechaMinima DATETIME, 
  fechaMaxima DATETIME, 
  PRIMARY KEY PK_codigoLibroComprasVentasMestro(codigoLibroComprasVentasMaestro),
  CONSTRAINT FK_LibroComprasVentasMaestro_EmpresaMaestro FOREIGN KEY (codigoEmpresa) REFERENCES EmpresaMaestro(codigoEmpresa),
  CONSTRAINT FK_LibroComprasVentasMaestro_PlantillaContableMaestro FOREIGN KEY (codigoPlantillaContable) REFERENCES PlantillaContableMaestro (codigoPlantillaContableMaestro)
);

CREATE TABLE LibroComprasVentasDetalle (
  codigoLibroComprasVentasDetalle INT AUTO_INCREMENT NOT NULL,
  codigoLibroComprasVentasMaestro INT NOT NULL,
  codigoValorImpuesto INT NOT NULL,
  numeroLibro INTEGER NOT NULL, 
  correlativoLibro INTEGER NOT NULL, 
  fechaMovimiento DATETIME, 
  NITEntidad VARCHAR(255), 
  valorMovimiento FLOAT NULL, 
  codigoMovimiento INTEGER, 
  numeroDocumento VARCHAR(255), 
  unidadesImpuesto FLOAT NULL, 
  PRIMARY KEY PK_codigoLibroComprasVentasDetalle (codigoLibroComprasVentasDetalle),
  CONSTRAINT FK_LibroComprasVentasDetalle_LibroComprasVentasMaestro FOREIGN KEY (codigoLibroComprasVentasMaestro) 
	REFERENCES LibroComprasVentasMaestro (codigoLibroComprasVentasMaestro),
  CONSTRAINT FK_LibroComprasVentasDetalle_ImpuestoAdicional FOREIGN KEY (codigoValorImpuesto) 
	REFERENCES ImpuestoAdicional(codigoValorImpuesto)	
);

CREATE TABLE Entidad (
  codigoNIT INT AUTO_INCREMENT NOT NULL,
  NITEntidad VARCHAR(12) NOT NULL, 
  nombreEntidad VARCHAR(255), 
  PRIMARY KEY PK_codigoNIT(codigoNIT)
);

CREATE TABLE ActivoFijo (
  codigoActivoFijo INT AUTO_INCREMENT NOT NULL,
  codigoEmpresa INT NOT NULL, 
  fechaAdquisicion DATETIME, 
  numeroDocumento VARCHAR(255), 
  NITEntidad VARCHAR(12), 
  codigoTipo INTEGER, 
  descripcionActivoFijo VARCHAR(255), 
  cantidadActivoFijo INTEGER, 
  valorUnitario FLOAT NULL, 
  valorTotal FLOAT NULL, 
  valorActual FLOAT NULL, 
  depreciacionAcumulada FLOAT NULL, 
  depreciacionActual FLOAT NULL, 
  caracteristicasActivoFijo LONGTEXT, 
  PRIMARY KEY PK_codigoActivoFijo(codigoActivoFijo),
  CONSTRAINT FK_ActivoFijo_EmpresaMaestro FOREIGN KEY (codigoEmpresa) REFERENCES EmpresaMaestro(codigoEmpresa)
);

CREATE TABLE AuxiliarPlantilla (
  codigoAuxiliarPlantilla INT AUTO_INCREMENT NOT NULL, 
  codigoEmpresa INT NOT NULL,
  codigoPlantillaContable INT NOT NULL, 
  descripcionPlantillaAuxiliar VARCHAR(255), 
  PRIMARY KEY PK_codigoAuxiliarPlantilla(codigoAuxiliarPlantilla),
  CONSTRAINT FK_AuxiliarPlantilla_EmpresaMaestro FOREIGN KEY (codigoEmpresa) REFERENCES EmpresaMaestro (codigoEmpresa),
  CONSTRAINT FK_AuxiliarPlantilla_PlantillaContableMaestro FOREIGN KEY (codigoPlantillaContable) REFERENCES PlantillaContableMaestro(codigoPlantillaContableMaestro)
);

CREATE TABLE AuxiliarMaestro (
  codigoAuxiliarMaestro INT AUTO_INCREMENT NOT NULL,
  codigoEmpresa INT NOT NULL, 
  codigoPlantillaAuxiliar INT NOT NULL, 
  numeroAuxiliarMaestro INTEGER NOT NULL, 
  fechaInicial DATETIME, 
  FechaFinal DATETIME, 
  estadoAuxiliar INTEGER, 
  PRIMARY KEY PK_codigoAuxiliarMaestro(codigoAuxiliarMaestro),
  CONSTRAINT FK_AuxiliarMaestro_EmpresaMaestro FOREIGN KEY (codigoEmpresa) REFERENCES EmpresaMaestro (codigoEmpresa),
  CONSTRAINT FK_AuxiliarMaestro_AuxiliarPlantilla FOREIGN KEY (codigoPlantillaAuxiliar) REFERENCES AuxiliarPlantilla (codigoAuxiliarPlantilla)
);

CREATE TABLE AuxiliarDetalle (
  codigoAuxiliarDetalle INT AUTO_INCREMENT NOT NULL,
  codigoEmpresa INT NOT NULL, 
  codigoPlantillaAuxiliar INT NOT NULL, 
  numeroAuxiliar INTEGER NOT NULL, 
  correlativoAuxiliar INTEGER NOT NULL, 
  fechaDetalle DATETIME, 
  descripcionDetalle VARCHAR(255), 
  montoDetalle INTEGER, 
  PRIMARY KEY PK_codigoAuxiliarDetalle(codigoAuxiliarDetalle),
  CONSTRAINT FK_AuxiliarDetalle_EmpresaMaestro FOREIGN KEY (codigoEmpresa) REFERENCES EmpresaMaestro (codigoEmpresa),
  CONSTRAINT FK_AuxiliarDetalle_AuxiliarPlantilla FOREIGN KEY (codigoPlantillaAuxiliar) REFERENCES AuxiliarPlantilla (codigoAuxiliarPlantilla)
);

CREATE TABLE TipoActivoFijo (
  codigoTipoActivoFijo INT AUTO_INCREMENT NOT NULL, 
    codigoActivoFijo INT NOT NULL,
  descripcionTipo VARCHAR(255), 
  porcentajeDepreciacion FLOAT NULL, 
  PRIMARY KEY PK_codigoTipoActivoFijo(codigoTipoActivoFijo),
  CONSTRAINT FK_TipoActivoFijo_ActivoFijo FOREIGN KEY (codigoActivoFijo) REFERENCES ActivoFijo (codigoActivoFijo)
);

CREATE TABLE PartidaContableMaestro (
  codigoPartidaContableMaestro INT AUTO_INCREMENT NOT NULL,
  codigoEmpresa INT NOT NULL, 
  numeroPartidaContable INTEGER NOT NULL DEFAULT 0, 
  fechaPartidaContable DATETIME, 
  montoDebePartidaContable FLOAT NULL DEFAULT 0, 
  montoHaberPartidaContable FLOAT NULL DEFAULT 0, 
  caracteristicasPartidaContable LONGTEXT, 
  PRIMARY KEY PK_codigoPartidaContableMaestro(codigoPartidaContableMaestro),
  CONSTRAINT FK_PartidaContableMaestro_EmpresaMaestro FOREIGN KEY (codigoEmpresa) REFERENCES EmpresaMaestro (codigoEmpresa)
);

CREATE TABLE PartidaContableDetalle ( 
  codigoPartidaContableDetalle INT AUTO_INCREMENT NOT NULL,
  codigoEmpresa INT NOT NULL, 
  codigoPartidaContableMaestro INTEGER NOT NULL,
  codigoCuentaContable INT NOT NULL, 
  numeroPartidaContable INTEGER NOT NULL DEFAULT 0, 
  correlativoPartidaContable INTEGER NOT NULL DEFAULT 0, 
  tipoMovimientoPartidaContable INTEGER DEFAULT 0, 
  montoCuentaContable FLOAT NULL DEFAULT 0, 
  PRIMARY KEY PK_codigoPartidaContableDetalle(codigoPartidaContableDetalle),
  CONSTRAINT FK_PartidaContableDetalle_EmpresaMaestro FOREIGN KEY (codigoEmpresa) REFERENCES EmpresaMaestro (codigoEmpresa),
  CONSTRAINT FK_PartidaContableDetalle_PartidaContableMaetro FOREIGN KEY (codigoPartidaContableMaestro) REFERENCES PartidaContableMaestro (codigoPartidaContableMaestro),
  CONSTRAINT FK_PartidaContableDetalle_CuentaContable FOREIGN KEY (codigoCuentaContable) REFERENCES CuentaContable (codigoCuentaC)
);

CREATE TABLE Periodo (
  codigoPeriodo INT AUTO_INCREMENT NOT NULL, 
  codigoEmpresa INTEGER NOT NULL, 
  estadoPeriodo INTEGER, 
  fechaInicial DATETIME, 
  fechaFinal DATETIME, 
  PRIMARY KEY PK_codigoPeriodo(codigoPeriodo),
  CONSTRAINT FK_Periodo_EmpresaMaestro FOREIGN KEY (codigoEmpresa) REFERENCES EmpresaMaestro (codigoEmpresa)
);

CREATE TABLE SaldoContable (
  codigoSaldoContable INT AUTO_INCREMENT NOT NULL,
  codigoEmpresa INTEGER NOT NULL, 
  codigoCuentaC INTEGER NOT NULL,
    codigoPeriodo INTEGER NOT NULL, 
  codigoCuentaContable VARCHAR(20) NOT NULL, 
  saldoInicialDCuentaContable FLOAT NULL, 
  saldoInicialHCuentaContable FLOAT NULL, 
  montoDebeCuentaContable FLOAT NULL DEFAULT 0, 
  montoHaberCuentaContable FLOAT NULL DEFAULT 0, 
  saldoFinalDCuentaContable FLOAT NULL DEFAULT 0, 
  saldoFinalHCuentaContable FLOAT NULL, 
  PRIMARY KEY PK_codigoSaldoContable(codigoSaldoContable),
  CONSTRAINT FK_SaldoContable_EmpresaMaestro FOREIGN KEY (codigoEmpresa) REFERENCES EmpresaMaestro (codigoEmpresa),
  CONSTRAINT FK_SaldoContable_CuentaContable FOREIGN KEY (codigoCuentaC) REFERENCES CuentaContable (codigoCuentaC),
  CONSTRAINT FK_SaldoContable_Periodo FOREIGN KEY (codigoPeriodo) REFERENCES Periodo (codigoPeriodo)
);

CREATE TABLE ReporteMaestro (
  codigoReporte INT NOT NULL DEFAULT 0, 
  nombreReporte VARCHAR(50), 
  PRIMARY KEY PK_codigoReporte (codigoReporte)
);

CREATE TABLE ReporteDetalle (
  codigoReporteDetalle INTEGER NOT NULL DEFAULT 0, 
  codigoReporteMaestro INTEGER NOT NULL,
  correlativoReporte INTEGER NOT NULL DEFAULT 0, 
  ordenReporte INTEGER DEFAULT 0, 
  numeroColumna INTEGER DEFAULT 0, 
  tipoDetalle INTEGER DEFAULT 0, 
  tipoValor INTEGER DEFAULT 0, 
  codigoCuentaContableI VARCHAR(50), 
  codigoCuentaContableF VARCHAR(50), 
  tipoOperacion INTEGER DEFAULT 0, 
  correlativoAnteriorReporte INTEGER DEFAULT 0, 
  lineaArriba INTEGER DEFAULT 0, 
  lineaAbajo INTEGER DEFAULT 0, 
  PRIMARY KEY PK_codigoReporteDetalle(codigoReporteDetalle),
  CONSTRAINT FK_ReporteDetalle_ReporteMaestro FOREIGN KEY (codigoReporteMaestro) REFERENCES ReporteMaestro(codigoReporte)
);

CREATE TABLE ReporteEjecutado (
  codigoReporteEjecutado INTEGER NOT NULL DEFAULT 0, 
  codigoReporteMaestro INTEGER NOT NULL,
  codigoReporteDetalle INTEGER NOT NULL,
  correlativoReporte INTEGER NOT NULL DEFAULT 0, 
  fechaReporte DATETIME NOT NULL, 
  codigoCuentaContable VARCHAR(20), 
  valorColumna1 FLOAT NULL DEFAULT 0, 
  valorColumna2 FLOAT NULL DEFAULT 0, 
  valorColumna3 FLOAT NULL DEFAULT 0, 
  valorColumna4 FLOAT NULL DEFAULT 0, 
  PRIMARY KEY PK_codigoReporteEjecutado(codigoReporteEjecutado),
  CONSTRAINT FK_ReporteEjecutado_ReporteMaestro FOREIGN KEY (codigoReporteMaestro) REFERENCES ReporteMaestro (codigoReporte),
  CONSTRAINT FK_ReporteEjecutado_ReporteDetalle FOREIGN KEY (codigoReporteDetalle) REFERENCES ReporteDetalle (codigoReporteDetalle)
);


-- 					PROCEDIMIENTOS ALMACENADOS				--

/*-- ----------------- EmpresaMaestro ------------------------------
-----------------------------------------------------------*/

-- ------------------------ GET ---------------------------

DROP PROCEDURE IF EXISTS sp_GetEmpresasMaestros;
DELIMITER $$
	CREATE PROCEDURE sp_GetEmpresasMaestros()
		BEGIN
			SELECT 
            EM.codigoEmpresa,
            EM.nombreEmpresa,
            EM.nombreComercial,
            EM.direccionEmpresa,
            EM.NITEmpresa,
            EM.porcentajeIVA
				FROM EmpresaMaestro EM;
        END$$
DELIMITER ;
CALL sp_GetEmpresasMaestros();

-- ------------------------ POST ---------------------------

DROP PROCEDURE IF EXISTS sp_PostEmpresaMaestro;
DELIMITER $$
	CREATE PROCEDURE sp_PostEmpresaMaestro (IN nombreEmpresa VARCHAR (255), IN nombreComercial VARCHAR(255), 
													IN direccionEmpresa VARCHAR(255), IN NITEmpresa VARCHAR(255), IN porcentajeIVA FLOAT)
		BEGIN
			INSERT INTO EmpresaMaestro (nombreEmpresa, nombreComercial, direccionEmpresa, NITEmpresa, porcentajeIVA)
				VALUES (nombreEmpresa, nombreComercial, direccionEmpresa, NITEmpresa, porcentajeIVA);
        END$$
DELIMITER ;
CALL sp_PostEmpresaMaestro('Cemaco', 'La fuente', 'zona 6', '232323-5', 0.21);
CALL sp_GetEmpresasMaestros();

-- ------------------------ PUT ---------------------------

DROP PROCEDURE IF EXISTS sp_PutEmpresaMaestro;
DELIMITER $$
	CREATE PROCEDURE sp_PutEmpresaMaestro (IN codEmpre INTEGER, IN nomEmpre VARCHAR(255), IN nomComercial VARCHAR(255), 
												IN direccion VARCHAR(255), IN NIT VARCHAR(255), IN IVA FLOAT)
		BEGIN
			UPDATE EmpresaMaestro SET
			codigoEmpresa = codEmpre,
			nombreEmpresa = nomEmpre,
			nombreComercial = nomComercial,
			direccionEmpresa = direccion,
			NITEmpresa = NIT,
			porcentajeIVA = IVA
				WHERE codigoEmpresa= codEmpre;
		END$$
DELIMITER ;
CALL sp_PutEmpresaMaestro(1, 'COMNET', 'Sankris Mall', 'Zona 8 de mixco San Cristobal', '212121-8', 0.21);
CALL sp_GetEmpresasMaestros();

-- ------------------------ DELETE ---------------------------

DROP PROCEDURE IF EXISTS sp_DeleteEmpresaMaestro;
DELIMITER $$
	CREATE PROCEDURE sp_DeleteEmpresaMaestro (IN codEmpre INT)
		BEGIN
			DELETE FROM EmpresaMaestro WHERE codigoEmpresa = codEmpre;
        END$$
DELIMITER ;
CALL sp_DeleteEmpresaMaestro(1);
CALL sp_GetEmpresasMaestros();

/*-- ----------------- Usuario ------------------------------
-----------------------------------------------------------*/

-- ------------------------ GET ------------------------- --

DROP PROCEDURE IF EXISTS sp_GetUsuarios;
DELIMITER $$
	CREATE PROCEDURE sp_GetUsuarios()
		BEGIN
			SELECT 
            U.codigoUsuario,
            U.username,
            U.correo,
            U.nombre,
            U.apellido,
            U.claveUsuario
				FROM Usuario U;
        END$$
DELIMITER ;
CALL sp_GetUsuarios();

-- ------------------------ POST ------------------------- --

DROP PROCEDURE IF EXISTS sp_PostUsuario;
DELIMITER $$
	CREATE PROCEDURE sp_PostUsuario(IN username VARCHAR(255), IN correo VARCHAR(255), IN nombre VARCHAR(255), IN apellido VARCHAR(255), IN claveUsuario VARCHAR(255))
		BEGIN
			INSERT INTO Usuario (username, correo, nombre, apellido, claveUsuario)
				VALUES (username, correo, nombre, apellido, claveUsuario);
        END$$
DELIMITER ;
CALL sp_PostUsuario('cashito', 'cashito@correo.com', 'Juan', 'Lopez', '123');
CALL sp_GetUsuarios();

-- ------------------------ PUT ------------------------- --

DROP PROCEDURE IF EXISTS sp_PutUsuario;
DELIMITER $$
	CREATE PROCEDURE sp_PutUsuario(IN codUser VARCHAR(12), IN userNa VARCHAR(255), IN email VARCHAR(255), IN nom VARCHAR(255), IN lastname VARCHAR(255), IN pass VARCHAR(255))
		BEGIN
			UPDATE Usuario SET
				codigoUsuario = codUser,
                username = userNa,
                correo = email,
                nombre = nom,
                apellido = lastname,
                claveUsuario = pass
					WHERE codigoUsuario = codUser;
        END$$
DELIMITER ;
CALL sp_PutUsuario(1, 'TurboCash', 'turboCash@correo.com', 'Turbo', 'Cash', '87654321');
CALL sp_GetUsuarios();

-- ------------------------ DELETE ------------------------- --

DROP PROCEDURE IF EXISTS sp_DeleteUser;
DELIMITER $$
	CREATE PROCEDURE sp_DeleteUser(IN codUser VARCHAR(12))
		BEGIN
			DELETE FROM Usuario WHERE codigoUsuario = codUser;
        END$$
DELIMITER ;

CALL sp_DeleteUser(1);
CALL sp_GetUsuarios();

/*-- ----------------- Impuesto adicional ------------------------------
-----------------------------------------------------------*/

-- ------------------------ GET ------------------------- --

DROP PROCEDURE IF EXISTS sp_GetImpuestosAdicionales;
DELIMITER $$
	CREATE PROCEDURE sp_GetImpuestosAdicionales()
		BEGIN
			SELECT 
            IA.codigoValorImpuesto,
            IA.descripcionImpuesto,
            IA.valorImpuesto
				FROM ImpuestoAdicional IA;
        END$$
DELIMITER ;
CALL sp_GetImpuestosAdicionales();

-- ------------------------ POST ------------------------- --

DROP PROCEDURE IF EXISTS sp_PostImpuestoAdicional;
DELIMITER $$
	CREATE PROCEDURE sp_PostImpuestoAdicional(IN descripcionImpuesto VARCHAR(255), IN valorImpuesto FLOAT)
		BEGIN
			INSERT INTO ImpuestoAdicional(descripcionImpuesto, valorImpuesto)
				VALUES(descripcionImpuesto, valorImpuesto);
        END$$
DELIMITER ;
CALL sp_PostImpuestoAdicional('Impuestode la gasolina', 0.30);
CALL sp_GetImpuestosAdicionales();

-- ------------------------ PUT ------------------------- --

DROP PROCEDURE IF EXISTS sp_PutImpuestoAdicional;
DELIMITER $$
	CREATE PROCEDURE sp_PutImpuestoAdicional(IN codImpuesto INTEGER, IN descImpuesto VARCHAR(255), IN valImpuesto FLOAT)
		BEGIN
			UPDATE ImpuestoAdicional SET
				codigoValorImpuesto = codImpuesto,
                descripcionImpuesto = descImpuesto,
                valorImpuesto = valImpuesto
					WHERE codigoValorImpuesto = codImpuesto;
        END$$
DELIMITER ;
CALL sp_PutImpuestoAdicional(1, 'El 30% de gasolina por galon.', 0.3);
CALL sp_GetImpuestosAdicionales();

-- ------------------------ DELETE ------------------------- --

DROP PROCEDURE IF EXISTS sp_DeleteImpuestoAdicional;
DELIMITER $$
	CREATE PROCEDURE sp_DeleteImpuestoAdicional(IN codImpuesto INTEGER)
		BEGIN	
			DELETE FROM ImpuestoAdicional WHERE codigoValorImpuesto = codImpuesto;
        END$$
DELIMITER ;
CALL sp_DeleteImpuestoAdicional(1);
CALL sp_GetImpuestosAdicionales();

/*-- ----------------- Tipo movimiento libro compras ventas ------------------------------
----------------------------------------------------------------------------------------*/

-- ------------------------ GET ------------------------- --

DROP PROCEDURE IF EXISTS sp_GetTiposMovimientosLibrosComprasVentas;
DELIMITER $$
	CREATE PROCEDURE sp_GetTiposMovimientosLibrosComprasVentas()
		BEGIN
			SELECT 
            T.codigoTipoMovimientoLibroComprasVentas,
            T.descripcionMovimiento,
            T.tipoLibro,
            T.tipoMovimiento
			FROM TipoMovimientoLibroComprasVentas T;
        END$$
DELIMITER ;
CALL sp_GetTiposMovimientosLibrosComprasVentas();

-- ------------------------ POST ------------------------- --

DROP PROCEDURE IF EXISTS sp_PostTipoMovimientoLibroComprasVentas;
DELIMITER $$
	CREATE PROCEDURE sp_PostTipoMovimientoLibroComprasVentas(IN descripcionMovimiento VARCHAR(255), IN tipoLibro INTEGER, IN tipoMovimiento INTEGER)
		BEGIN
			INSERT INTO TipoMovimientoLibroComprasVentas(descripcionMovimiento,
															tipoLibro, tipoMovimiento)
				VALUES(descripcionMovimiento, tipoLibro, tipoMovimiento);
        END$$
DELIMITER ;
CALL sp_PostTipoMovimientoLibroComprasVentas('Movimiento de un libro', 3, 3);
CALL sp_GetTiposMovimientosLibrosComprasVentas();

-- ------------------------ PUT ------------------------- --

DROP PROCEDURE IF EXISTS sp_PutTipoMovimientoLibroComprasVentas;
DELIMITER $$	
	CREATE PROCEDURE sp_PutTipoMovimientoLibroComprasVentas(IN codigoTMLCV INTEGER, IN descMovimiento VARCHAR(255), IN libroTipo INTEGER, IN tipoMov INTEGER)
		BEGIN
			UPDATE TipoMovimientoLibroComprasVentas SET 
				codigoTipoMovimientoLibroComprasVentas = codigoTMLCV,
                descripcionMovimiento = descMovimiento,
                tipoLibro = libroTipo,
                tipoMovimiento = tipoMov
					WHERE codigoTipoMovimientoLibroComprasVentas = codigoTMLCV;
        END$$
DELIMITER ;
CALL sp_PutTipoMovimientoLibroComprasVentas(1, 'Es una nueva descripcion del movimiento', 2, 5);
CALL sp_GetTiposMovimientosLibrosComprasVentas();

-- ------------------------ DELETE ------------------------- --

DROP PROCEDURE IF EXISTS sp_DeleteTipoMovimientoLibroComprasVentas;
DELIMITER $$
	CREATE PROCEDURE sp_DeleteTipoMovimientoLibroComprasVentas(IN codTMLCV INTEGER)
		BEGIN
			DELETE FROM TipoMovimientoLibroComprasVentas WHERE codigoTipoMovimientoLibroComprasVentas = codTMLCV;
        END$$
DELIMITER ;
CALL sp_DeleteTipoMovimientoLibroComprasVentas(1);
CALL sp_GetTiposMovimientosLibrosComprasVentas();


/*-- ----------------- Cuenta contable ------------------------------
----------------------------------------------------------------------------------------*/

-- ------------------------ GET ------------------------- --

DROP PROCEDURE IF EXISTS sp_GetCuentasContables;
DELIMITER $$
	CREATE PROCEDURE sp_GetCuentasContables()
		BEGIN
			SELECT 
            CC.codigoCuentaC,
            CC.codigoCuentaContable,
            CC.codigoEmpresa,
            CC.nombreCuentaContable,
            CC.tipoCuentaContable,
            CC.padreCuentaContable,
            CC.nivelCuentaContable,
            CC.recibePartidasCuentaContable
				FROM CuentaContable CC;
        END$$
DELIMITER ;
CALL sp_GetCuentasContables();
-- ------------------------ POST ------------------------- --

DROP PROCEDURE IF EXISTS sp_PostCuentaContable;
DELIMITER $$
	CREATE PROCEDURE sp_PostCuentaContable(IN codigoCuentaContable VARCHAR(20), IN codigoEmpresa INTEGER,
												IN nombreCuentaContable VARCHAR(50), IN tipoCuentaContable INTEGER, IN padreCuentaContable VARCHAR(20),
													IN nivelCuentaContable INTEGER, IN recibePartidasCuentaContable INTEGER)
		BEGIN
			INSERT INTO CuentaContable (codigoCuentaContable, codigoEmpresa, nombreCuentaContable, tipoCuentaContable,
											padreCuentaContable, nivelCuentaContable, recibePartidasCuentaContable)
				VALUES (codigoCuentaContable, codigoEmpresa, nombreCuentaContable, tipoCuentaContable, padreCuentaContable, 
							nivelCuentaContable, recibePartidasCuentaContable);
        END$$
DELIMITER ;
CALL sp_PostCuentaContable('2.2.2', 2, 'Activo', 2, 'Padre activo', 1, 2);
CALL sp_GetCuentasContables();
CALL sp_GetEmpresasMaestros();

-- ------------------------ PUT ------------------------- --

DROP PROCEDURE IF EXISTS sp_PutCuentaContable;
DELIMITER $$
	CREATE PROCEDURE sp_PutCuentaContable(IN codCC INTEGER, IN codigoCC VARCHAR(20), IN codEmpre INTEGER, IN nomCC VARCHAR(50),
											IN tipoCC INTEGER, IN padreCC VARCHAR(20), IN nivelCC INTEGER, IN recibePCC INTEGER)
		BEGIN
			UPDATE CuentaContable SET
            codigoCuentaC = codCC,
            codigoCuentaContable = codigoCC,
            codigoEmpresa = codEmpre,
            nombreCuentaContable = nomCC,
            tipoCuentaContable = tipoCC,
            padreCuentaContable = padreCC,
            nivelCuentaContable = nivelCC,
            recibePartidasCuentaContable = recibePCC
				WHERE codigoCuentaC = codCC;
        END$$
DELIMITER ;
CALL sp_PutCuentaContable(1, '1.1.1', 2, 'PASIVO', 3, 'Padre pasivo', 4, 8);
CALL sp_GetCuentasContables();

-- ------------------------ DELETE ------------------------- --

DROP PROCEDURE IF EXISTS sp_DeleteCuentaContable;
DELIMITER $$
	CREATE PROCEDURE sp_DeleteCuentaContable(IN codCC INTEGER)
		BEGIN
			DELETE FROM CuentaContable WHERE codigoCuentaC = codCC;
        END$$
DELIMITER ;
CALL sp_DeleteCuentaContable(2);
CALL sp_GetCuentasContables();

/*-- ----------------- Plantilla contable maestro ------------------------------
-------------------------------------------------------------------------------*/

-- ------------------------ GET ------------------------- --

DROP PROCEDURE IF EXISTS sp_GetPlantillasContablesMaestros;
DELIMITER $$
	CREATE PROCEDURE sp_GetPlantillasContablesMaestros()
		BEGIN
			SELECT 
            PCM.codigoPlantillaContableMaestro,
            PCM.codigoEmpresa,
            PCM.codigoPlantillaContable,
            PCM.descripcionPlantillaContable,
            PCM.caracteristicasPlantillaContable,
            PCM.tipoPlantilla
				FROM PlantillaContableMaestro PCM;
        END$$
DELIMITER ;
CALL sp_GetPlantillasContablesMaestros();

-- ------------------------ POST ------------------------- --

DROP PROCEDURE IF EXISTS sp_PostPlantillaContableMaestro;
DELIMITER $$
	CREATE PROCEDURE sp_PostPlantillaContableMaestro(IN codigoEmpresa INTEGER, IN codigoPlantillaContable INTEGER,
														IN descripcionPlantillaContable VARCHAR(255), IN caracteristicasPlantillaContable LONGTEXT,
															IN tipoPlantilla INTEGER)
		BEGIN
			INSERT INTO PlantillaContableMaestro (codigoEmpresa, codigoPlantillaContable, descripcionPlantillaContable,
														caracteristicasPlantillaContable, tipoPlantilla)
				VALUES(codigoEmpresa, codigoPlantillaContable, descripcionPlantillaContable, 
							caracteristicasPlantillaContable, tipoPlantilla);
        END$$
DELIMITER ;
CALL sp_PostPlantillaContableMaestro(2, 4, 'Es una plantilla contable', 'Es una caracteristica de una plantilla contable', 2);
CALL sp_GetPlantillasContablesMaestros();
CALL sp_GetEmpresasMaestros();

-- ------------------------ PUT ------------------------- --

DROP PROCEDURE IF EXISTS sp_PutPlantillaContableMaestro;
DELIMITER $$
	CREATE PROCEDURE sp_PutPlantillaContableMaestro(IN codPCM INTEGER, IN codEmpresa INTEGER, IN codPC INTEGER, IN descPC VARCHAR(255), IN caraPC VARCHAR(255), IN tipoP INTEGER)
		BEGIN
			UPDATE PlantillaContableMaestro SET
				codigoPlantillaContableMaestro = codPCM,
                codigoEmpresa = codEmpresa,
                codigoPlantillaContable = codPC,
                descripcionPlantillaContable = descPC,
                caracteristicasPlantillaContable = caraPC,
                tipoPlantilla = tipoP
					WHERE codigoPlantillaContableMaestro = codPCM;
        END$$
DELIMITER ;
CALL sp_PutPlantillaContableMaestro(2, 2, 5, 'Es una plantillaContable edited', 'Es una caracteristica de una plantilla edited', 4);
CALL sp_GetPlantillasContablesMaestros();

-- ------------------------ DELETE ------------------------- --

DROP PROCEDURE IF EXISTS sp_DeletePlantillaContableMaestro;
DELIMITER $$
	CREATE PROCEDURE sp_DeletePlantillaContableMaestro(IN codPCM INTEGER)
		BEGIN
			DELETE FROM PlantillaContableMaestro WHERE codigoPlantillaContableMaestro = codPCM;
        END$$
DELIMITER ;
CALL sp_DeletePlantillaContableMaestro(3);
CALL sp_GetPlantillasContablesMaestros();

/*-- ----------------- Plantilla contable detalle ------------------------------
-------------------------------------------------------------------------------*/

-- ------------------------ GET ------------------------- --

DROP PROCEDURE IF EXISTS sp_GetPlantillasContablesDetalles;
DELIMITER $$
	CREATE PROCEDURE sp_GetPlantillasContablesDetalles()
		BEGIN
			SELECT 
            PCD.codigoPlantillaContableDetalle,
            PCD.codigoEmpresa,
            PCD.codigoCuentaC,
            PCD.codigoPlantillaContableMaestro,
            PCD.codigoPlantillaContable,
            PCD.correlativoPlantillaContable,
            PCD.codigoCuentaContable,
            PCD.tipoMovimientoPlantillaContable,
            PCD.porcentajeCuentaContable
				FROM PlantillaContableDetalle PCD;
        END$$
DELIMITER ;
CALL sp_GetPlantillasContablesDetalles();

-- ------------------------ POST ------------------------- --

DROP PROCEDURE IF EXISTS sp_PostPlantillaContableDetalle;
DELIMITER $$
	CREATE PROCEDURE sp_PostPlantillaContableDetalle(IN codigoEmpresa INT,
														IN codigoCuentaC INT, IN codigoPlantillaContableMaestro INT,
															IN codigoPlantillaContable INTEGER, IN correlativoPlantillaContable INTEGER,
																IN codigoCuentaContable VARCHAR(20), IN tipoMovimientoPlantillaContable INTEGER, 
																	IN porcentajeCuentaContable FLOAT)
		BEGIN
			INSERT INTO PlantillaContableDetalle (codigoEmpresa, codigoCuentaC, codigoPlantillaContableMaestro,
													codigoPlantillaContable, correlativoPlantillaContable, codigoCuentaContable,
														tipoMovimientoPlantillaContable, porcentajeCuentaContable)
				VALUES (codigoEmpresa, codigoCuentaC, codigoPlantillaContableMaestro,
							codigoPlantillaContable, correlativoPlantillaContable, codigoCuentaContable,
									tipoMovimientoPlantillaContable, porcentajeCuentaContable);
        END$$
DELIMITER ;
CALL sp_PostPlantillaContableDetalle(4, 4, 4, 4, 4, '1.1.1', 2, 0.26);
CALL sp_GetPlantillasContablesDetalles();
CALL sp_GetPlantillasContablesMaestros();
CALL sp_GetEmpresasMaestros();
CALL sp_GetCuentasContables();

-- ------------------------ PUT ------------------------- --

DROP PROCEDURE IF EXISTS sp_PutPlantillaContableDetalle;
DELIMITER $$
	CREATE PROCEDURE sp_PutPlantillaContableDetalle(IN codPCD INT, IN codEmpresa INT, IN codCC INT, IN codPCM INTEGER, IN codPC INTEGER, IN correlativoPC INTEGER,
														IN codigoCC VARCHAR(20), IN tipoMPC INTEGER, IN porcentajeCC FLOAT)
		BEGIN
			UPDATE PlantillaContableDetalle SET
				codigoPlantillaContableDetalle = codPCD, 
                codigoEmpresa = codEmpresa, 
                codigoCuentaC = codCC, 
                codigoPlantillaContableMaestro = codPCM,
				codigoPlantillaContable = codPC, 
                correlativoPlantillaContable = correlativoPC, 
                codigoCuentaContable = codigoCC,
				tipoMovimientoPlantillaContable = tipoMPC, 
                porcentajeCuentaContable = porcentajeCC
					WHERE codigoPlantillaContableDetalle = codPCD;
        END$$
DELIMITER ;
CALL sp_PutPlantillaContableDetalle(2, 2, 3, 2, 2, 2, '2.2.2', 1, 0.28);
CALL sp_GetPlantillasContablesDetalles();
CALL sp_GetPlantillasContablesMaestros();
CALL sp_GetCuentasContables();


-- ------------------------ DELETE ------------------------- --

DROP PROCEDURE IF EXISTS sp_DeletePlantillaContableDetalle;
DELIMITER $$
	CREATE PROCEDURE sp_DeletePlantillaContableDetalle (IN codPCD INTEGER)
		BEGIN
			DELETE FROM PlantillaContableDetalle WHERE codigoPlantillaContableDetalle = codPCD;
        END$$
DELIMITER ;
CALL sp_DeletePlantillaContableDetalle(1);
CALL sp_GetPlantillasContablesDetalles();

/*-- -----------------  Libro compras ventas Maestro------------------------------
--------------------------------------------------------------------------------*/

-- ------------------------ GET ------------------------- --

DROP PROCEDURE IF EXISTS sp_GetLibroComprasVentasMaestros;
DELIMITER $$
	CREATE PROCEDURE sp_GetLibroComprasVentasMaestros()
		BEGIN
			SELECT 
            LCVM.codigoLibroComprasVentasMaestro,
            LCVM.codigoEmpresa,
            LCVM.numeroLibro,
            LCVM.fechaInicial,
            LCVM.fechaFinal,
            LCVM.estadoLibro,
            LCVM.tipoLibro,
            LCVM.codigoPlantillaContable,
            LCVM.fechaMinima,
            LCVM.fechaMaxima
				FROM LibroComprasVentasMaestro LCVM;
        END$$
DELIMITER ;
CALL sp_GetLibroComprasVentasMaestros();

-- ------------------------ POST ------------------------- --

DROP PROCEDURE IF EXISTS sp_PostLibroComprasVentasMaestro;
DELIMITER $$
	CREATE PROCEDURE sp_PostLibroComprasVentasMaestro( IN codigoEmpresa INTEGER, IN codigoPlantillaContable INTEGER, IN numeroLibro INTEGER,
														IN fechaInicial DATETIME, IN fechaFinal DATETIME, IN estadoLibro INTEGER, IN tipoLibro INTEGER, 
															IN fechaMinima DATETIME, fechaMaxima DATETIME)
		BEGIN
			INSERT INTO LibroComprasVentasMaestro(codigoLibroComprasVentasMaestro, codigoEmpresa, numeroLibro, fechaInicial, fechaFinal, estadoLibro, tipoLibro, codigoPlantillaContable, fechaMinima, fechaMaxima)
				VALUES(codigoLibroComprasVentasMaestro, codigoEmpresa, numeroLibro, fechaInicial, fechaFinal, estadoLibro, tipoLibro, codigoPlantillaContable, fechaMinima, fechaMaxima);
        END$$
DELIMITER ;
CALL sp_PostLibroComprasVentasMaestro(2, 2, 3,'2020-02-04', '2020-04-04', 1, 3, '2020-02-02', '2020-06-06');
CALL sp_GetLibroComprasVentasMaestros();
CALL sp_GetPlantillasContablesMaestros();
CALL sp_GetEmpresasMaestros();

-- ------------------------ PUT ------------------------- --

DROP PROCEDURE IF EXISTS sp_PutLibroComprasVentasMaestro;
DELIMITER $$
	CREATE PROCEDURE sp_PutLibroComprasVentasMaestro(IN codLCVM INT, IN codEmpre INTEGER, IN codPC INTEGER, IN numLibro INTEGER,
														IN feInicial DATETIME, IN feFinal DATETIME, IN statusL INTEGER, IN tipoL INTEGER, 
															IN feMin DATETIME, feMax DATETIME )
		BEGIN
			UPDATE LibroComprasVentasMaestro SET
				codigoLibroComprasVentasMaestro = codLCVM,
                codigoEmpresa = codEmpre,
                codigoPlantillaContable = codPC,
                numeroLibro = numLibro,
                fechaInicial = feInicial,
                fechaFinal = feFinal,
                estadoLibro = statusL,
                tipoLibro = tipoL,
                fechaMinima = feMin,
                fechaMaxima = feMax
					WHERE codigoLibroComprasVentasMaestro = codLCVM;
        END$$
DELIMITER ;
CALL sp_PutLibroComprasVentasMaestro(1,2, 2, 3,'2020-02-04', '2020-04-04', 1, 3, '2020-02-02', '2020-06-08');
CALL sp_GetLibroComprasVentasMaestros();

-- ------------------------ DELETE ------------------------- --

DROP PROCEDURE IF EXISTS sp_DeleteLibroComprasVentasMaestro;
DELIMITER $$
	CREATE PROCEDURE sp_DeleteLibroComprasVentasMaestro(IN codigoLCVM INT)
		BEGIN
			DELETE FROM LibroComprasVentasMaestro WHERE codigoLibroComprasVentasMaestro = codigoLCVM;
        END$$
DELIMITER ;
CALL sp_DeleteLibroComprasVentasMaestro(1);
CALL sp_GetLibroComprasVentasMaestros();

/*-- -----------------  Libro compras ventas detalle------------------------------
--------------------------------------------------------------------------------*/

-- ------------------------ GET ------------------------- --

DROP PROCEDURE IF EXISTS sp_GetLibroComprasVentasDetalles;
DELIMITER $$
	CREATE PROCEDURE sp_GetLibroComprasVentasDetalles()
		BEGIN
			SELECT 
            LCVD.codigoLibroComprasVentasDetalle,
            LCVD.codigoLibroComprasVentasMaestro,
            LCVD.codigoValorImpuesto,
            LCVD.numeroLibro,
            LCVD.correlativoLibro,
            LCVD.fechaMovimiento,
            LCVD.fechaMovimiento,
            LCVD.NITEntidad,
            LCVD.valorMovimiento,
            LCVD.codigoMovimiento,
            LCVD.numeroDocumento,
            LCVD.unidadesImpuesto
				FROM LibroComprasVentasDetalle LCVD;
        END$$
DELIMITER ;
CALL sp_GetLibroComprasVentasDetalles();

-- ------------------------ POST ------------------------- --

DROP PROCEDURE IF EXISTS sp_PostLibroComprasVentasDetalle;
DELIMITER $$
	CREATE PROCEDURE sp_PostLibroComprasVentasDetalle(IN codigoLibroComprasVentasMaestro INT, IN codigoValorImpuesto INT, IN numeroLibro INTEGER,
														IN correlativoLibro INTEGER, IN fechaMovimiento DATETIME, IN NITEntidad VARCHAR(255), IN valorMovimiento FLOAT, IN codigoMovimiento INTEGER, 
															IN numeroDocumento VARCHAR(255), IN unidadesImpuesto FLOAT)
		BEGIN
			INSERT INTO LibroComprasVentasDetalle(codigoLibroComprasVentasMaestro, codigoValorImpuesto, numeroLibro, correlativoLibro, fechaMovimiento, NITEntidad, valorMovimiento, codigoMovimiento, numeroDocumento, unidadesImpuesto)
				VALUES (codigoLibroComprasVentasMaestro, codigoValorImpuesto, numeroLibro, correlativoLibro, fechaMovimiento, NITEntidad, valorMovimiento, codigoMovimiento, numeroDocumento, unidadesImpuesto);
        END$$
DELIMITER ;
CALL sp_PostLibroComprasVentasDetalle(2, 2, 3, 21, '2022-02-09','6411372-8', 21.21, 20, 'ACTIVO', 21.21);
CALL sp_GetLibroComprasVentasDetalles();
CALL sp_GetLibroComprasVentasMaestros();
CALL sp_GetImpuestosAdicionales();

-- ------------------------ PUT ------------------------- --

DROP PROCEDURE IF EXISTS sp_PutLibroComprasVentasDetalle;
DELIMITER $$
	CREATE PROCEDURE sp_PutLibroComprasVentasDetalle(IN codLCVD INT, IN codLCVM INT, IN codVI INT, IN numL INTEGER,
														IN correlativoLibro1 INTEGER, IN fechaMovimiento1 DATETIME, IN NITEntidad1 VARCHAR(255), IN valorMovimiento1 FLOAT, IN codigoMovimiento1 INTEGER, 
															IN numeroDocumento1 VARCHAR(255), IN unidadesImpuesto1 FLOAT)
		BEGIN
			UPDATE LibroComprasVentasDetalle SET
            codigoLibroComprasVentasDetalle = codLCVD,
            codigoLibroComprasVentasMaestro = codLCVM,
            codigoValorImpuesto = codVI,
            numeroLibro = numL,
            correlativoLibro = correlativoLibro1,
            fechaMovimiento = fechaMovimiento1,
            NITEntidad = NITEntidad1,
            valorMovimiento = valorMovimiento1,
            codigoMovimiento = codigoMovimiento1,
            numeroDocumento = numeroDocumento1,
            unidadesImpuesto = unidadesImpuesto1
				WHERE codigoLibroComprasVentasDetalle = codLCVD;
        END$$
DELIMITER ;
CALL sp_PutLibroComprasVentasDetalle(3, 2, 2, 3, 21, '2022-02-09','6411372-8', 21.21, 20, 'ACTIVO', 21.22);
CALL sp_GetLibroComprasVentasDetalles();
CALL sp_GetLibroComprasVentasMaestros();
CALL sp_GetImpuestosAdicionales();

-- ------------------------ DELETE ------------------------- --

DROP PROCEDURE IF EXISTS sp_DeleteLibroComprasVentasDetalle;
DELIMITER $$
	CREATE PROCEDURE sp_DeleteLibroComprasVentasDetalle(IN codLCVD INT)
		BEGIN
			DELETE FROM LibroComprasVentasDetalle WHERE codigoLibroComprasVentasDetalle = codLCVD;
        END$$
DELIMITER ;
CALL sp_DeleteLibroComprasVentasDetalle(2);
CALL sp_GetLibroComprasVentasDetalles();

/*-- -----------------  Entidad --------------------------------------------------
--------------------------------------------------------------------------------*/

-- ------------------------ GET ------------------------- --

DROP PROCEDURE IF EXISTS sp_GetEntidades;
DELIMITER $$
	CREATE PROCEDURE sp_GetEntidades()
		BEGIN
			SELECT 
            E.codigoNIT,
            E.NITEntidad,
            E.nombreEntidad
				FROM Entidad E;
        END$$
DELIMITER ;
CALL sp_GetEntidades();

-- ------------------------ POST ------------------------- --

DROP PROCEDURE IF EXISTS sp_PostEntidad;
DELIMITER $$
	CREATE PROCEDURE sp_PostEntidad(IN NITEntidad VARCHAR(12), IN nombreEntidad VARCHAR(255))
		BEGIN
			INSERT INTO Entidad (NITEntidad, nombreEntidad)
				VALUES(NITEntidad, nombreEntidad);
        END$$
DELIMITER ;
CALL sp_PostEntidad('6411372-8', 'SOFTWARE S.A');
CALL sp_GetEntidades();

-- ------------------------ PUT ------------------------- --

DROP PROCEDURE IF EXISTS sp_PutEntidad;
DELIMITER $$
	CREATE PROCEDURE sp_PutEntidad(IN NITCodigo INT,IN  NITEntidad1 VARCHAR(255), IN nombreEntidad1 VARCHAR(255))
		BEGIN
			UPDATE Entidad SET
            codigoNIT = NITCodigo,
            NITEntidad = NITEntidad1,
            nombreEntidad = nombreEntidad1
				WHERE codigoNIT = NITCodigo;
        END$$
DELIMITER ;
CALL sp_PUTEntidad(1, '6411377-9', 'Dev');
CALL sp_GetEntidades();

-- ------------------------ DELETE ------------------------- --

DROP PROCEDURE IF EXISTS sp_DeleteEntidad;
DELIMITER $$
	CREATE PROCEDURE sp_DeleteEntidad(IN codEnti INT)
		BEGIN
			DELETE FROM Entidad WHERE codigoNIT = codEnti;
        END$$
DELIMITER ;
CALL sp_DeleteEntidad(2);
CALL sp_GetEntidades();

/*-- -----------------  Activo fijo --------------------------------------------------
--------------------------------------------------------------------------------*/

-- ------------------------ GET ------------------------- --

DROP PROCEDURE IF EXISTS sp_GetActivosFijos;
DELIMITER $$
	CREATE PROCEDURE sp_GetActivosFijos()
		BEGIN
			SELECT 
            AF.codigoActivoFijo,
            AF.codigoEmpresa,
            AF.fechaAdquisicion,
            AF.numeroDocumento,
            AF.NITEntidad,
            AF.codigoTipo,
            AF.descripcionActivoFijo,
            AF.cantidadActivoFijo,
            AF.valorUnitario,
            AF.valorTotal,
            AF.valorActual,
            AF.depreciacionAcumulada,
            AF.depreciacionActual,
            AF.caracteristicasActivoFijo
				FROM ActivoFijo AF;
        END$$
DELIMITER ;
CALL sp_GetActivosFijos();

-- ------------------------ POST ------------------------- --
DROP PROCEDURE IF EXISTS sp_PostActivoFijo;
DELIMITER $$
	CREATE PROCEDURE sp_PostActivoFijo(IN codigoEmpresa INT, IN fechaAdquisicion DATETIME, IN numeroDocumento VARCHAR(255), 
											IN NITEntidad VARCHAR(12), IN codigoTipo INTEGER, IN descripcionActivoFijo VARCHAR(255),
												IN cantidadActivoFijo INTEGER, IN valorUnitario FLOAT, IN valorTotal FLOAT, IN valorActual FLOAT, 
													IN depreciacionAcumulada FLOAT, IN depreciacionActual FLOAT, IN caracteristicasActivoFijo LONGTEXT)
		BEGIN
			INSERT INTO ActivoFijo (codigoEmpresa, fechaAdquisicion, numeroDocumento, NITEntidad, codigoTipo, descripcionActivoFijo, cantidadActivoFijo, valorUnitario, valorTotal, valorActual, depreciacionAcumulada, depreciacionActual, caracteristicasActivoFijo)
				VALUES (codigoEmpresa, fechaAdquisicion, numeroDocumento, NITEntidad, codigoTipo, descripcionActivoFijo, cantidadActivoFijo, valorUnitario, valorTotal, valorActual, depreciacionAcumulada, depreciacionActual, caracteristicasActivoFijo);
        END$$
DELIMITER ;
CALL sp_PostActivoFijo(2, '2022-08-02', 'ACTIVO FIJO', '64113213-2', 1, 'Es un activo fijo', 2, 21.21, 100, 34, 12, 65, 'Es una descripcion de activo fijo');
CALL sp_GetActivosFijos();
CALL sp_GetEmpresasMaestros();

-- ------------------------ PUT ------------------------- --

DROP PROCEDURE IF EXISTS sp_PutActivoFijo;
DELIMITER $$
	CREATE PROCEDURE sp_PutActivoFijo(IN codAF INT, IN codigoEmpresa1 INT, IN fechaAdquisicion1 DATETIME, IN numeroDocumento1 VARCHAR(255), 
											IN NITEntidad1 VARCHAR(12), IN codigoTipo1 INTEGER, IN descripcionActivoFijo1 VARCHAR(255),
												IN cantidadActivoFijo1 INTEGER, IN valorUnitario1 FLOAT, IN valorTotal1 FLOAT, IN valorActual1 FLOAT, 
													IN depreciacionAcumulada1 FLOAT, IN depreciacionActual1 FLOAT, IN caracteristicasActivoFijo1 LONGTEXT)
		BEGIN
			UPDATE ActivoFijo SET 
            codigoActivoFijo = codAF,
            codigoEmpresa = codigoEmpresa1,
            fechaAdquisicion = fechaAdquisicion1,
            numeroDocumento = numeroDocumento1,
            NITEntidad = NITEntidad1,
            codigoTipo = codigoTipo1,
            descripcionActivoFijo = descripcionActivoFijo1,
            cantidadActivoFijo = cantidadActivoFijo1,
            valorUnitario = valorUnitario1,
            valorTotal = valorTotal1,
            valorActual = valorActual1,
            depreciacionAcumulada = depreciacionAcumulada1,
            depreciacionActual = depreciacionActual1,
            caracteristicasActivoFijo = caracteristicasActivoFijo1
				WHERE codigoActivoFijo = codAF;
        END$$
DELIMITER ;
CALL sp_PutActivoFijo(1, 2, '2022-08-02', 'ACTIVO FIJO', '64113213-2', 1, 'Es un activo fijo', 2, 21.21, 100, 34, 12, 65, 'Es una descripcion de activo fijo updated');
CALL sp_GetActivosFijos();
CALL sp_GetEmpresasMaestros();

-- ------------------------ DELETE ------------------------- --

DROP PROCEDURE IF EXISTS sp_DeleteActivoFijo;
DELIMITER $$
	CREATE PROCEDURE sp_DeleteActivoFijo(IN codAF INT)
		BEGIN
			DELETE FROM ActivoFijo WHERE codigoActivoFijo = codAF;
        END$$
DELIMITER ;
CALL sp_DeleteActivoFijo(2);
CALL sp_GetActivosFijos();

/*-- -----------------  Auxiliar plantilla --------------------------------------------------
--------------------------------------------------------------------------------*/

-- ------------------------ GET ------------------------- --

DROP PROCEDURE IF EXISTS sp_GetAuxiliaresPlantillas;
DELIMITER $$
	CREATE PROCEDURE sp_GetAuxiliaresPlantillas()
    BEGIN
		SELECT 
        AP.codigoAuxiliarPlantilla,
        AP.codigoEmpresa,
        AP.codigoPlantillaContable,
        AP.descripcionPlantillaAuxiliar
			FROM AuxiliarPlantilla AP;
    END$$
DELIMITER ;
CALL sp_GetAuxiliaresPlantillas();

-- ------------------------ POST ------------------------- --

DROP PROCEDURE IF EXISTS sp_PostAuxiliarPlantilla;
DELIMITER $$
	CREATE PROCEDURE sp_PostAuxiliarPlantilla(IN codigoEmpresa INT, IN codigoPlantillaContable INT, IN descripcionPlantillaAuxiliar VARCHAR(255))
		BEGIN
			INSERT INTO AuxiliarPlantilla(codigoEmpresa, codigoPlantillaContable, descripcionPlantillaAuxiliar)
				VALUES(codigoEmpresa, codigoPlantillaContable, descripcionPlantillaAuxiliar);
        END$$
DELIMITER ;
CALL sp_PostAuxiliarPlantilla(2,2, 'Es una herramienta para un auxiliar de contabilidad');
CALL sp_GetAuxiliaresPlantillas();
CALL sp_GetEmpresasMaestros();
CALL sp_GetPlantillasContablesMaestros();

-- ------------------------ PUT ------------------------- --

DROP PROCEDURE IF EXISTS sp_PutAuxiliarPlantilla;
DELIMITER $$
	CREATE PROCEDURE sp_PutAuxiliarPlantilla(IN codAP INT, IN codEmpresa1 INT, IN descrip VARCHAR(255))
		BEGIN
			UPDATE AuxiliarPlantilla SET
            codigoAuxiliarPlantilla = codAP,
            codigoEmpresa = codEmpresa1,
            descripcionPlantillaAuxiliar = descrip
				WHERE codigoAuxiliarPlantilla = codAP;
        END$$
DELIMITER ;
CALL sp_PutAuxiliarPlantilla(2, 2, 'Es una herramienta para un auxiliar edit');
CALL sp_GetAuxiliaresPlantillas();

-- ------------------------ DELETE ------------------------- --

DROP PROCEDURE IF EXISTS sp_DeleteAuxiliarPlantilla;
DELIMITER $$
	CREATE PROCEDURE sp_DeleteAuxiliarPlantilla(IN codAP INT)
		BEGIN
			DELETE FROM AuxiliarPlantilla WHERE codigoAuxiliarPlantilla = codAP;
        END$$
DELIMITER ;
CALL sp_DeleteAuxiliarPlantilla(1);
CALL sp_GetAuxiliaresPlantillas();

/*-- -----------------  Auxiliar maestro --------------------------------------------------
--------------------------------------------------------------------------------*/

-- ------------------------ GET ------------------------- --

DROP PROCEDURE IF EXISTS sp_GetAuxiliaresMaestros;
DELIMITER $$
	CREATE PROCEDURE sp_GetAuxiliaresMaestros()
		BEGIN
			SELECT 
            AM.codigoAuxiliarMaestro,
            AM.codigoEmpresa,
            AM.codigoPlantillaAuxiliar,
            AM.numeroAuxiliarMaestro,
            AM.fechaInicial,
            AM.FechaFinal,
            AM.estadoAuxiliar
				FROM AuxiliarMaestro AM;
        END$$
DELIMITER ;
CALL sp_GetAuxiliaresMaestros();

-- ------------------------ POST ------------------------- --

DROP PROCEDURE IF EXISTS sp_PostAuxiliarMaestro;
DELIMITER $$
	CREATE PROCEDURE sp_PostAuxiliarMaestro(IN codigoEmpresa INT, IN codigoPlantillaAuxiliar INT, IN numeroAuxiliarMaestro INTEGER, IN fechaInicial DATETIME, IN FechaFinal DATETIME, IN estadoAuxiliar INTEGER)
		BEGIN
			INSERT INTO AuxiliarMaestro(codigoEmpresa, codigoPlantillaAuxiliar, numeroAuxiliarMaestro, fechaInicial, fechaFinal, estadoAuxiliar)
				VALUES(codigoEmpresa, codigoPlantillaAuxiliar, numeroAuxiliarMaestro, fechaInicial, fechaFinal, estadoAuxiliar);
        END$$
DELIMITER ;
CALL sp_PostAuxiliarMaestro(2, 2, 2, '2022-08-02', '2023-01-01', 0 );
CALL sp_GetAuxiliaresMaestros();
CALL sp_GetEmpresasMaestros();
CALL sp_GetAuxiliaresPlantillas();

-- ------------------------ PUT ------------------------- --

DROP PROCEDURE IF EXISTS sp_PutAuxiliarMaestro;
DELIMITER $$
	CREATE PROCEDURE sp_PutAuxiliarMaestro(IN codAM INT, IN codigoEmpresa1 INT, IN codigoPlantillaAuxiliar1 INT, IN numeroAuxiliarMaestro1 INTEGER, IN fechaInicial1 DATETIME, IN FechaFinal1 DATETIME, IN estadoAuxiliar1 INTEGER)
    BEGIN
		UPDATE AuxiliarMaestro SET
			codigoAuxiliarMaestro = codAM,
            codigoEmpresa = codigoEmpresa1,
            codigoPlantillaAuxiliar = codigoPlantillaAuxiliar1,
            numeroAuxiliarMaestro = numeroAuxiliarMaestro1,
			fechaInicial = fechaInicial1,
            fechaFinal = fechaFinal1,
            estadoAuxiliar = estadoAuxiliar1
				WHERE codigoAuxiliarMaestro = codAM;
    END$$
DELIMITER ;
CALL sp_PutAuxiliarMaestro(1,2, 2, 1, '2022-08-02', '2023-01-01', 1 );
CALL sp_GetAuxiliaresMaestros();

-- ------------------------ DELETE ------------------------- --

DROP PROCEDURE IF EXISTS sp_DeleteAuxiliarMaestro;
DELIMITER $$
	CREATE PROCEDURE sp_DeleteAuxiliarMaestro(IN codAM INT)
		BEGIN
			DELETE FROM AuxiliarMaestro WHERE codigoAuxiliarMaestro = codAM;
        END$$
DELIMITER ;
CALL sp_DeleteAuxiliarMaestro(2);
CALL sp_GetAuxiliaresMaestros();

/*-- -----------------  Auxiliar detalle --------------------------------------------------
--------------------------------------------------------------------------------*/

-- ------------------------ GET ------------------------- --

DROP PROCEDURE IF EXISTS sp_GetAuxiliaresDetalles;
DELIMITER $$
	CREATE PROCEDURE sp_GetAuxiliaresDetalles()
		BEGIN
			SELECT 
            AD.codigoAuxiliarDetalle,
            AD.codigoEmpresa,
            AD.codigoPlantillaAuxiliar,
            AD.numeroAuxiliar,
            AD.correlativoAuxiliar,
            AD.fechaDetalle,
            AD.descripcionDetalle,
            AD.montoDetalle
				FROM AuxiliarDetalle AD;
        END$$
DELIMITER ;
CALL sp_GetAuxiliaresDetalles();

-- ------------------------ POST ------------------------- --

DROP PROCEDURE IF EXISTS sp_PostAuxiliarDetalle;
DELIMITER $$
	CREATE PROCEDURE sp_PostAuxiliarDetalle (IN codigoEmpresa INT, IN codigoPlantillaAuxiliar INT, IN numeroAuxiliar INTEGER, IN correlativoAuxiliar INTEGER, 
												IN fechaDetalle DATETIME, IN descripcionDetalle VARCHAR(255), IN montoDetalle INTEGER)
		BEGIN
			INSERT INTO AuxiliarDetalle(codigoEmpresa, codigoPlantillaAuxiliar, numeroAuxiliar, correlativoAuxiliar, fechaDetalle, descripcionDetalle, montoDetalle)
				VALUES(codigoEmpresa, codigoPlantillaAuxiliar, numeroAuxiliar, correlativoAuxiliar, fechaDetalle, descripcionDetalle, montoDetalle);
        END$$
DELIMITER ;
CALL sp_PostAuxiliarDetalle(2, 3, 21, 12, '2022-06-02', 'Esto es un auxiliar detalle', 100);
CALL sp_GetAuxiliaresDetalles();
CALL sp_GetEmpresasMaestros();
CALL sp_GetAuxiliaresPlantillas();

-- ------------------------ PUT ------------------------- --

DROP PROCEDURE IF EXISTS sp_PutAuxiliarDetalle;
DELIMITER $$
	CREATE PROCEDURE sp_PutAuxiliarDetalle(IN codAD INT, IN codigoEmpresa1 INT, IN codigoPlantillaAuxiliar1 INT, IN numeroAuxiliar1 INTEGER, IN correlativoAuxiliar1 INTEGER, 
												IN fechaDetalle1 DATETIME, IN descripcionDetalle1 VARCHAR(255), IN montoDetalle1 INTEGER)
		BEGIN
			UPDATE AuxiliarDetalle SET
            codigoAuxiliarDetalle = codAD,
            codigoEmpresa = codigoEmpresa1,
            codigoPlantillaAuxiliar = codigoPlantillaAuxiliar1,
            numeroAuxiliar = numeroAuxiliar1,
            correlativoAuxiliar = correlativoAuxiliar1,
            fechaDetalle = fechaDetalle1,
            descripcionDetalle = descripcionDetalle1,
            montoDetalle = montoDetalle1
				WHERE codigoAuxiliarDetalle = codAD;
        END$$
DELIMITER ;
CALL sp_PutAuxiliarDetalle(1, 2, 2, 21, 12, '2022-06-02', 'Esto es un auxiliar detalle edited', 100);
CALL sp_GetAuxiliaresDetalles();
CALL sp_GetEmpresasMaestros();
CALL sp_GetAuxiliaresPlantillas();

-- ------------------------ DELETE ------------------------- --

DROP PROCEDURE IF EXISTS sp_DeleteAuxiliarDetalle;
DELIMITER $$
	CREATE PROCEDURE sp_DeleteAuxiliarDetalle(IN codAD INT)
		BEGIN
			DELETE FROM AuxiliarDetalle WHERE codigoAuxiliarDetalle =codAD;
        End$$
DELIMITER ;
CALL sp_DeleteAuxiliarDetalle(2);
CALL sp_GetAuxiliaresDetalles();

/*-- -----------------  Tipo activo fijo --------------------------------------------------
--------------------------------------------------------------------------------*/

-- ------------------------ GET ------------------------- --

DROP PROCEDURE IF EXISTS sp_GetTiposActivosFijos;
DELIMITER $$
	CREATE PROCEDURE sp_GetTiposActivosFijos()
    BEGIN
		SELECT 
        TAF.codigoTipoActivoFijo,
        TAF.codigoActivoFijo,
        TAF.descripcionTipo,
        TAF.porcentajeDepreciacion
			FROM TipoActivoFijo TAF;
    END$$
DELIMITER ;
CALL sp_GetTiposActivosFijos();

-- ------------------------ POST ------------------------- --

DROP PROCEDURE IF EXISTS sp_PostTipoActivoFijo;
DELIMITER $$
	CREATE PROCEDURE sp_PostTipoActivoFijo(IN codigoActivoFijo INT, IN descripcionTipo VARCHAR(255), IN porcentajeDepreciacion FLOAT)
		BEGIN
			INSERT INTO TipoActivoFijo(codigoActivoFijo, descripcionTipo, porcentajeDepreciacion)
				VALUES(codigoActivoFijo, descripcionTipo, porcentajeDepreciacion);
        END$$
DELIMITER ;
CALL sp_PostTipoActivoFijo(2, 'Buenos dias', 0.69);
CALL sp_GetTiposActivosFijos();
CALL sp_GetActivosFijos();

-- ------------------------ PUT ------------------------- --

DROP PROCEDURE IF EXISTS sp_PutTipoActivoFijo;
DELIMITER $$
	CREATE PROCEDURE sp_PutTipoActivoFijo(IN codTAF INT, IN codigoActivoFijo1 INT, IN descripcionTipo1 VARCHAR(255), IN porcentajeDepreciacion1 FLOAT)
		BEGIN
			UPDATE TipoActivoFijo SET
            codigoTipoActivoFijo = codTAF,
            codigoActivoFijo = codigoActivoFijo1,
            descripcionTipo = descripcionTipo1,
            porcentajeDepreciacion = porcentajeDepreciacion1
				WHERE codigoTipoActivoFijo = codTAF;
        END$$
DELIMITER ;
CALL sp_PutTipoActivoFijo(2, 2, 'Buenos tardes', 0.21);
CALL sp_GetTiposActivosFijos();

-- ------------------------ DELETE ------------------------- --

DROP PROCEDURE IF EXISTS sp_DeleteTipoActivoFijo;
DELIMITER $$
	CREATE PROCEDURE sp_DeleteTipoActivoFijo(IN codTAF INT)
		BEGIN
			DELETE FROM TipoActivoFijo WHERE codigoTipoActivoFijo = codTAF;
        END$$
DELIMITER ;
CALL sp_DeleteTipoActivoFijo(3);
CALL sp_GetTiposActivosFijos();

/*-- -----------------  Partida contable maestro --------------------------------------------------
--------------------------------------------------------------------------------*/

-- ------------------------ GET ------------------------- --

DROP PROCEDURE IF EXISTS sp_GetPartidasContablesMaestros;
DELIMITER $$
	CREATE PROCEDURE sp_GetPartidasContablesMaestros()
		BEGIN
			SELECT
            PCM.codigoPartidaContableMaestro,
            PCM.codigoEmpresa,
            PCM.numeroPartidaContable,
            PCM.fechaPartidaContable,
            PCM.montoDebePartidaContable,
            PCM.montoHaberPartidaContable,
            PCM.caracteristicasPartidaContable
				FROM PartidaContableMaestro PCM;
        END$$
DELIMITER ;
CALL sp_GetPartidasContablesMaestros();

-- ------------------------ POST ------------------------- --

DROP PROCEDURE IF EXISTS sp_PostPartidaContableMaestro;
DELIMITER $$
	CREATE PROCEDURE sp_PostPartidaContableMaestro(IN codigoEmpresa INT, IN numeroPartidaContable INTEGER, IN fechaPartidaContable DATETIME, 
														IN montoDebePartidaContable FLOAT, IN montoHaberPartidaContable FLOAT, 
															IN caracteristicasPartidaContable LONGTEXT)
		BEGIN
			INSERT INTO PartidaContableMaestro(codigoEmpresa, numeroPartidaContable, fechaPartidaContable, montoDebePartidaContable, montoHaberPartidaContable, caracteristicasPartidaContable)
				VALUES (codigoEmpresa, numeroPartidaContable, fechaPartidaContable, montoDebePartidaContable, montoHaberPartidaContable, caracteristicasPartidaContable);
        END$$
DELIMITER ;
CALL sp_PostPartidaContableMaestro(2, 21, '2020-02-07', 210.11, 100.09, 'Esta es una caracteristica de las partidas');
CALL sp_GetPartidasContablesMaestros();
CALL sp_GetEmpresasMaestros();

-- ------------------------ PUT ------------------------- --

DROP PROCEDURE IF EXISTS sp_PutPartidaContableMaestro;
DELIMITER $$
	CREATE PROCEDURE sp_PutPartidaContableMaestro(IN codPCM INT, IN codigoEmpresa1 INT, IN numeroPartidaContable1 INTEGER, IN fechaPartidaContable1 DATETIME, 
														IN montoDebePartidaContable1 FLOAT, IN montoHaberPartidaContable1 FLOAT, 
															IN caracteristicasPartidaContable1 LONGTEXT)
		BEGIN
			UPDATE PartidaContableMaestro SET
            codigoPartidaContableMaestro = codPCM,
            codigoEmpresa = codigoEmpresa1,
            numeroPartidaContable = numeroPartidaContable1,
            fechaPartidaContable = fechaPartidaContable1,
            montoDebePartidaContable = montoDebePartidaContable1,
            montoHaberPartidaContable = montoHaberPartidaContable1,
            caracteristicasPartidaContable = caracteristicasPartidaContable1
				WHERE codigoPartidaContableMaestro = codPCM;
        END$$
DELIMITER ;
CALL sp_PutPartidaContableMaestro(1, 2, 21, '2020-02-07', 745.3, 22.2, 'Esta es una caracteristica de las partidas edit');
CALL sp_GetPartidasContablesMaestros();

-- ------------------------ DELETE ------------------------- --

DROP PROCEDURE IF EXISTS sp_DeletePartidaContableMaestro;
DELIMITER $$
	CREATE PROCEDURE sp_DeletePartidaContableMaestro(IN codPCM INT)
		BEGIN
			DELETE FROM PartidaContableMaestro WHERE codigoPartidaContableMaestro = codPCM;
        END$$
DELIMITER ;
CALL sp_DeletePartidaContableMaestro(3);
CALL sp_GetPartidasContablesMaestros();

/*-- -----------------  Partida contable detalle --------------------------------------------------
--------------------------------------------------------------------------------*/

-- ------------------------ GET ------------------------- --

DROP PROCEDURE IF EXISTS sp_GetPartidasContablesDetalles;
DELIMITER $$
	CREATE PROCEDURE sp_GetPartidasContablesDetalles()
		BEGIN
			SELECT 
            PCD.codigoPartidaContableDetalle,
            PCD.codigoEmpresa,
            PCD.codigoPartidaContableMaestro,
            PCD.numeroPartidaContable,
            PCD.correlativoPartidaContable,
            PCD.codigoCuentaContable,
            PCD.tipoMovimientoPartidaContable,
            PCD.montoCuentaContable
				FROM PartidaContableDetalle PCD;
        END$$
DELIMITER ;
CALL sp_GetPartidasContablesDetalles();

-- ------------------------ POST ------------------------- --

DROP PROCEDURE IF EXISTS sp_PostPartidaContableDetalle;
DELIMITER $$
	CREATE PROCEDURE sp_PostPartidaContableDetalle (IN codigoEmpresa INT, IN codigoPartidaContableMaestro INTEGER, IN codigoCuentaContable INT, IN numeroPartidaContable INTEGER, 
														IN correlativoPartidaContable INTEGER, IN tipoMovimientoPartidaContable INTEGER, IN montoCuentaContable FLOAT)
		BEGIN
			INSERT INTO PartidaContableDetalle (codigoEmpresa, codigoPartidaContableMaestro, numeroPartidaContable, correlativoPartidaContable, codigoCuentaContable, tipoMovimientoPartidaContable, montoCuentaContable)
				VALUES (codigoEmpresa, codigoPartidaContableMaestro, numeroPartidaContable, correlativoPartidaContable, codigoCuentaContable, tipoMovimientoPartidaContable, montoCuentaContable);
        END$$
DELIMITER ;
CALL sp_PostPartidaContableDetalle(2, 2, 4, 50, 121, 2, 100.00);
CALL sp_GetPartidasContablesDetalles();
CALL sp_GetEmpresasMaestros();
CALL sp_GetPartidasContablesMaestros();
CALL sp_GetCuentasContables();

-- ------------------------ PUT ------------------------- --

DROP PROCEDURE IF EXISTS sp_PutPartidaContableDetalle;
DELIMITER $$
	CREATE PROCEDURE sp_PutPartidaContableDetalle(IN codPCD INT, IN codigoEmpresa1 INT, IN codigoPartidaContableMaestro1 INTEGER, IN codigoCuentaContable1 INT, IN numeroPartidaContable1 INTEGER, 
														IN correlativoPartidaContable1 INTEGER, IN tipoMovimientoPartidaContable1 INTEGER, IN montoCuentaContable1 FLOAT)
		BEGIN
			UPDATE PartidaContableDetalle SET
				codigoPartidaContableDetalle = codPCD,
                codigoEmpresa = codigoEmpresa1,
                codigoPartidaContableMaestro = codigoPartidaContableMaestro1,
                codigoCuentaContable = codigoCuentaContable1,
                numeroPartidaContable = numeroPartidaContable1,
                correlativoPartidaContable = correlativoPartidaContable1,
                tipoMovimientoPartidaContable = tipoMovimientoPartidaContable1,
                montoCuentaContable = montoCuentaContable1
					WHERE codigoPartidaContableDetalle = codPCD;
        End$$
DELIMITER ;
CALL sp_PutPartidaContableDetalle(1,2, 2, 4, 50, 121, 2, 200.00);
CALL sp_GetPartidasContablesDetalles();

-- ------------------------ DELETE ------------------------- --

DROP PROCEDURE IF EXISTS sp_DeletePartidaContableDetalle;
DELIMITER $$
	CREATE PROCEDURE sp_DeletePartidaContableDetalle(IN codPCD INT)
		BEGIN
			DELETE FROM PartidaContableDetalle WHERE codigoPartidaContableDetalle = codPCD;
        END$$
DELIMITER ;
CALL sp_DeletePartidaContableDetalle(3);
CALL sp_GetPartidasContablesDetalles();

/*-- -----------------  Periodo ---------------------------------
--------------------------------------------------------------------------------*/

-- ------------------------ GET ------------------------- --

DROP PROCEDURE IF EXISTS sp_GetPeriodos;
DELIMITER $$
	CREATE PROCEDURE sp_GetPeriodos()
		BEGIN
			SELECT 
            P.codigoPeriodo,
            P.codigoEmpresa,
            P.estadoPeriodo,
            P.fechaInicial,
            P.fechaFinal
				FROM Periodo P;
        END$$
DELIMITER ;
CALL sp_GetPeriodos();

-- ------------------------ POST ------------------------- --

DROP PROCEDURE IF EXISTS sp_PostPeriodo;
DELIMITER $$
	CREATE PROCEDURE sp_PostPeriodo(IN codigoEmpresa INT, IN estadoPeriodo INTEGER, IN fechaInicial DATETIME, IN fechaFinal DATETIME)
		BEGIN
			INSERT INTO Periodo(codigoEmpresa, estadoPeriodo, fechaInicial, fechaFinal)
				VALUES(codigoEmpresa, estadoPeriodo, fechaInicial, fechaFinal);
        END$$
DELIMITER ;
CALL sp_PostPeriodo(2, 2, '2020-02-09', '2020-03-10');
CALL sp_GetPeriodos();
CALL sp_GetEmpresasMaestros();

-- ------------------------ PUT ------------------------- --

DROP PROCEDURE IF EXISTS sp_PutPeriodo;
DELIMITER $$
	CREATE PROCEDURE sp_PutPeriodo(IN codP INT, IN codigoEmpresa1 INT, IN estadoPeriodo1 INTEGER, IN fechaInicial1 DATETIME, IN fechaFinal1 DATETIME)
		BEGIN
			UPDATE Periodo SET
				codigoPeriodo = codP,
                codigoEmpresa = codigoEmpresa1,
                estadoPeriodo = estadoPeriodo1,
                fechaInicial = fechaInicial1,
                fechaFinal = fechaFinal1
					WHERE codigoPeriodo = codP;
        END$$
DELIMITER ;
CALL sp_PutPeriodo(1,2, 1, '2022-02-09', '2020-03-10');
CALL sp_GetPeriodos();
