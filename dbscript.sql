--El presente script tiene los scripts de los objetos de la base de datos

CREATE TABLE BENEFICIOS (
    BEN_ID NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY NOT NULL,
    BEN_nombre VARCHAR(100),
    BEN_descripcion VARCHAR(100),
    BEN_fecha_de_inicio DATE,
    BEN_fecha_de_expiracion DATE   
);

alter table BENEFICIOS  add constraint "BEN_PK" primary key (BEN_ID);

CREATE TABLE NIVEL (
    NIV_ID NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY NOT NULL,
    NIV_nombre VARCHAR(30),
    NIV_descripcion varchar(250)
);

alter table NIVEL  add constraint "NIV_PK" primary key (NIV_ID);

CREATE TABLE NIVEL_BENEFICIOS (
    NIV_BEN_ID NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY NOT NULL,
    NIV_ID NUMBER(10) NOT NULL,
    BEN_ID NUMBER(10) NOT NULL
);

alter table NIVEL_BENEFICIOS  add constraint "NIV_BEN_PK" primary key (NIV_BEN_ID);
alter table NIVEL_BENEFICIOS add constraint "NIV_BEN_BEN_FK" foreign key (BEN_ID) references BENEFICIOS(BEN_ID);
alter table NIVEL_BENEFICIOS add constraint "NIV_BEN_NIV_FK " foreign key (NIV_ID) references NIVEL(NIV_ID);

CREATE TABLE PROVINCIA (
    PROV_ID NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY NOT NULL,
    PROV_nombre VARCHAR(30),
    PROV_direccion VARCHAR(50)
);

alter table PROVINCIA add constraint "PROV_PK" primary key (PROV_ID);

CREATE TABLE MUNICIPIO (
    MUN_ID NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY NOT NULL,
    PROV_ID NUMBER(10) NOT NULL,
    MUN_nombre VARCHAR(30)
);

alter table MUNICIPIO add constraint "MUN_PK" primary key (MUN_ID);
alter table MUNICIPIO add constraint "MUN_PROV_FK" foreign key (PROV_ID) references PROVINCIA(PROV_ID);

CREATE TABLE USUARIO (
    USE_ID NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY NOT NULL,
    MUN_ID NUMBER(10) NOT NULL,
    NIV_BEN_ID NUMBER(10) NOT NULL,
    USE_nombre VARCHAR(30),
    USE_apellido VARCHAR(30),
    USE_correo VARCHAR(60),
    USE_telefono VARCHAR(30),
    USE_DNI VARCHAR(30),
    USE_contrasenia VARCHAR(30)
);

alter table USUARIO add constraint "USE_PK" primary key (USE_ID);
alter table USUARIO add constraint "USE_NIV_FK" foreign key (NIV_BEN_ID) references NIVEL_BENEFICIOS(NIV_BEN_ID);
alter table USUARIO add constraint "USE_MUN_FK" foreign key (MUN_ID) references  MUNICIPIO(MUN_ID);

CREATE TABLE ESTADO (
    EST_ID NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY NOT NULL,
    EST_nombre VARCHAR(30),
    EST_descripcion VARCHAR(250)
);

alter table estado add constraint "EST_PK" primary key (EST_ID);

CREATE TABLE CRITICIDAD (
    CRI_ID NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY NOT NULL,
    CRI_nombre VARCHAR(30),
    CRI_descripcion VARCHAR(250)
);

alter table CRITICIDAD  add constraint "CRI_PK" primary key (CRI_ID);

CREATE TABLE GESTOR (
    GES_ID NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY NOT NULL,
    GES_nombre VARCHAR(30),
    GES_apellido VARCHAR(30),
    GES_correo VARCHAR(30),
    GES_telefono VARCHAR(30),
    GES_DNI VARCHAR(30),
    GES_contrasenia VARCHAR(30)
);

alter table GESTOR  add constraint "GES_PK" primary key (GES_ID);

CREATE TABLE CATEGORIA (
    CAT_ID NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY NOT NULL,
    CAT_nombre VARCHAR(30)
);

alter table CATEGORIA  add constraint "CAT_PK" primary key (CAT_ID);


CREATE TABLE RECLAMO (
    REC_ID NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY NOT NULL,
    CAT_ID NUMBER(10) NOT NULL,
    USE_ID NUMBER(10) NOT NULL,
    EST_ID NUMBER(10) NOT NULL,
    CRI_ID NUMBER(10) NOT NULL,
    REC_titulo VARCHAR(30),
    REC_descripcion VARCHAR(250),
    REC_fecha_creacion DATE,
    REC_fecha_actualizacion DATE
);

alter table RECLAMO  add constraint "REC_PK" primary key (REC_ID);

alter table RECLAMO add constraint "REC_CAT_FK" foreign key (CAT_ID) references CATEGORIA(CAT_ID);
alter table RECLAMO add constraint "REC_USE_FK" foreign key (USE_ID) references USUARIO(USE_ID);
alter table RECLAMO add constraint "REC_EST_FK" foreign key (EST_ID) REFERENCES ESTADO(EST_ID);
alter table RECLAMO add constraint "REC_CRI_FK" foreign key (CRI_ID) references CRITICIDAD(CRI_ID);


CREATE TABLE COMENTARIO (
    COM_ID NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY NOT NULL,
    REC_ID NUMBER(10) NOT NULL,
    GES_ID NUMBER(10),
    USE_ID NUMBER(10),
    COM_fecha_creacion DATE,
    COM_fecha_actualizacion DATE,
    COM_texto VARCHAR(250)
);

ALTER TABLE COMENTARIO ADD CONSTRAINT COM_PK PRIMARY KEY (COM_ID);

ALTER TABLE COMENTARIO ADD CONSTRAINT COM_REC_FK FOREIGN KEY (REC_ID) REFERENCES RECLAMO(REC_ID);
ALTER TABLE COMENTARIO ADD CONSTRAINT COM_GES_FK FOREIGN KEY (GES_ID) REFERENCES GESTOR(GES_ID);
ALTER TABLE COMENTARIO ADD CONSTRAINT COM_USE_FK FOREIGN KEY (USE_ID) REFERENCES USUARIO(USE_ID);

ALTER TABLE COMENTARIO ADD CONSTRAINT COM_USER_GESTOR_CHECK CHECK (GES_ID IS NOT NULL OR USE_ID IS NOT NULL);


INSERT INTO ESTADO (EST_ID,EST_NOMBRE, EST_DESCRIPCION)
values(1,'CREADO', 'El reclamo fue creado con éxito y está pendiende a ser atendido por uno de nuestros gestores.');
INSERT INTO ESTADO (EST_ID,EST_NOMBRE, EST_DESCRIPCION)
values(2,'EN REVISIÓN GESTOR', 'El reclamo fue asignado a uno de nuestros gestores. Se encuentra en evaluación.');
INSERT INTO ESTADO (EST_ID,EST_NOMBRE, EST_DESCRIPCION)
values(3,'EN ESPERA DE RESPUESTA USUARIO', 'El gestor atendió el reclamo pero necesita de la ayuda del reportador.');
INSERT INTO ESTADO (EST_ID,EST_NOMBRE, EST_DESCRIPCION)
values(4,'ESCALADO', 'El reclamo fue escalado para un mejor análisis.');
INSERT INTO ESTADO (EST_ID,EST_NOMBRE, EST_DESCRIPCION)
values(5,'RESUELTO', 'El reclamo fue resuelto con éxito.');
INSERT INTO ESTADO (EST_ID,EST_NOMBRE, EST_DESCRIPCION)
values(6,'DESESTIMADO', 'El reclamo fue rechazado por el agente.');

INSERT INTO CATEGORIA (CAT_ID,CAT_NOMBRE)
values(1,'SALUD');
INSERT INTO CATEGORIA (CAT_ID,CAT_NOMBRE)
values(2,'AMBIENTAL');
INSERT INTO CATEGORIA (CAT_ID,CAT_NOMBRE)
values(3,'MALTRARO ANIMAL');
INSERT INTO CATEGORIA (CAT_ID,CAT_NOMBRE)
values(4,'INFRAESTRUCTURA');

INSERT INTO PROVINCIA (PROV_ID,PROV_NOMBRE,PROV_DIRECCION)
values(1,'La Rioja','F5300 La Rioja');
INSERT INTO PROVINCIA (PROV_ID,PROV_NOMBRE,PROV_DIRECCION)
values(2,'Catamarca','sanfernando den valle de catamarca,Catamarca');

INSERT INTO MUNICIPIO  (MUN_ID,PROV_ID,MUN_NOMBRE)
values(1,2,'Municipalidad de Belen');
INSERT INTO MUNICIPIO  (MUN_ID,PROV_ID,MUN_NOMBRE)
values(2,2,'Municipalidad de tinogasta');
INSERT INTO MUNICIPIO  (MUN_ID,PROV_ID,MUN_NOMBRE)
values(3,1,'Municipalidad de Chilecito');
INSERT INTO MUNICIPIO  (MUN_ID,PROV_ID,MUN_NOMBRE)
values(4,1,'Municipalidad de capita');
INSERT INTO MUNICIPIO  (MUN_ID,PROV_ID,MUN_NOMBRE)
values(5,1,'Municiapalidad Famatina');

INSERT INTO GESTOR (GES_ID,GES_NOMBRE, GES_APELLIDO, GES_CORREO, GES_TELEFONO,GES_DNI,GES_CONTRASENIA) VALUES
(1,'Peter','Parker', 'PPARKER@gmail.com', '34535479', '23010166','1234');
INSERT INTO GESTOR (GES_ID,GES_NOMBRE, GES_APELLIDO, GES_CORREO, GES_TELEFONO,GES_DNI,GES_CONTRASENIA) VALUES
(2,'Bruce','Banner', 'BBANNER@gmail.com', '345426664', '26087566','2345');
INSERT INTO GESTOR (GES_ID,GES_NOMBRE, GES_APELLIDO, GES_CORREO, GES_TELEFONO,GES_DNI,GES_CONTRASENIA) VALUES
(3,'Matt','Murdock', 'MMURDOCK@gmail.com', '344566664', '27943166','3456');
INSERT INTO GESTOR (GES_ID,GES_NOMBRE, GES_APELLIDO, GES_CORREO, GES_TELEFONO,GES_DNI,GES_CONTRASENIA) VALUES
(4,'Stephen','Strange', 'SSTRANGE@gmail.com', '345373164', '20791249','4567');

INSERT  INTO NIVEL  (NIV_ID,NIV_nombre, NIV_descripcion) values
(1,'Nivel principiante', 'Nivel para usuarios creados recientemente.');
INSERT  INTO NIVEL  (NIV_ID,NIV_nombre, NIV_descripcion) values
(2,'Nivel intermedio', 'Nivel para usuarios con 5 reclamos resueltos.');
INSERT  INTO NIVEL  (NIV_ID,NIV_nombre, NIV_descripcion) values
(3,'Nivel avanzado', 'Nivel para usuarios con 15 reclamos resueltos.');
INSERT  INTO NIVEL  (NIV_ID,NIV_nombre, NIV_descripcion) values
(4,'Nivel experto', 'Nivel para usuarios con 30 reclamos resueltos.');

INSERT INTO BENEFICIOS (BEN_ID,BEN_NOMBRE, BEN_DESCRIPCION, BEN_FECHA_DE_INICIO, BEN_FECHA_DE_EXPIRACION) 
VALUES (1,'Descuento supermercado SpaceX', 'El beneficio tiene un descuento del 30% sin tope de reintegro en todos los supermercados SpaceX', TO_DATE('2024-04-24', 'YYYY-MM-DD'), TO_DATE('2024-12-31', 'YYYY-MM-DD'));
INSERT INTO BENEFICIOS (BEN_ID,BEN_NOMBRE, BEN_DESCRIPCION, BEN_FECHA_DE_INICIO, BEN_FECHA_DE_EXPIRACION) 
VALUES (2,'Descuento Ferreteria', 'El beneficio tiene un descuento del 20% sin tope de reintegro en todas las Ferreterias', TO_DATE('2024-04-24', 'YYYY-MM-DD'), TO_DATE('2024-12-31', 'YYYY-MM-DD'));
INSERT INTO BENEFICIOS (BEN_ID,BEN_NOMBRE, BEN_DESCRIPCION, BEN_FECHA_DE_INICIO, BEN_FECHA_DE_EXPIRACION) 
VALUES (3,'Descuento Corralon', 'beneficio tiene un descuento del 15% sin tope de reintegro en todos los corralones de construccion', TO_DATE('2024-04-24', 'YYYY-MM-DD'), TO_DATE('2024-12-31', 'YYYY-MM-DD'));


INSERT INTO NIVEL_BENEFICIOS (NIV_BEN_ID,NIV_ID,BEN_ID) VALUES (1,1,1);
INSERT INTO NIVEL_BENEFICIOS (NIV_BEN_ID,NIV_ID,BEN_ID) VALUES (2,1,2);

INSERT INTO NIVEL_BENEFICIOS (NIV_BEN_ID,NIV_ID,BEN_ID) VALUES (3,2,1);
INSERT INTO NIVEL_BENEFICIOS (NIV_BEN_ID,NIV_ID,BEN_ID) VALUES (4,2,2);
INSERT INTO NIVEL_BENEFICIOS (NIV_BEN_ID,NIV_ID,BEN_ID) VALUES (5,2,3);
INSERT INTO NIVEL_BENEFICIOS (NIV_BEN_ID,NIV_ID,BEN_ID) VALUES (6,2,3);

INSERT INTO USUARIO (USE_ID,mun_id, niv_ben_id, USE_NOMBRE, USE_APELLIDO, USE_CORREO, USE_TELEFONO,USE_DNI,USE_CONTRASENIA) VALUES
(1,2,1, 'Maximiliano Javier','Julio', 'maxijulio@gmail.com', '345356664', '43010166','WEWQwmmdQ1!!d');
INSERT INTO USUARIO (USE_ID,mun_id, niv_ben_id, USE_NOMBRE, USE_APELLIDO, USE_CORREO, USE_TELEFONO,USE_DNI,USE_CONTRASENIA) VALUES
(2,2,1, 'Leonardo','Zalazar', 'leoCapo2024@gmail.com', '345356664', '39020346','qwerty12345');

INSERT INTO CRITICIDAD (CRI_ID,CRI_NOMBRE,CRI_DESCRIPCION) VALUES 
(1,'URGENTE','deberia ser antendido en los proximos minutos u horas');
INSERT INTO CRITICIDAD (CRI_ID,CRI_NOMBRE,CRI_DESCRIPCION) VALUES 
(2,'PELIGROSO','deberia ser antendido en las proximos horas');
INSERT INTO CRITICIDAD (CRI_ID,CRI_NOMBRE,CRI_DESCRIPCION) VALUES 
(3,'MOLESTIA','podria ser atentido en dias');

INSERT INTO RECLAMO (REC_ID,cat_id,use_id,est_id,cri_id,REC_TITULO,REC_DESCRIPCION,REC_FECHA_CREACION,REC_FECHA_ACTUALIZACION) VALUES
(1,4,1,1,3,'Manguera rota','una manguera pierde agua',TO_DATE('2024-05-09', 'YYYY-MM-DD'),TO_DATE('2024-05-09', 'YYYY-MM-DD'));
INSERT INTO RECLAMO (REC_ID,cat_id,use_id,est_id,cri_id,REC_TITULO,REC_DESCRIPCION,REC_FECHA_CREACION,REC_FECHA_ACTUALIZACION) VALUES
(2,4,2,1,3,'Maceta rota','se rompio una maceta',TO_DATE('2024-05-07', 'YYYY-MM-DD'),TO_DATE('2024-05-07', 'YYYY-MM-DD'));
INSERT INTO RECLAMO (REC_ID,cat_id,use_id,est_id,cri_id,REC_TITULO,REC_DESCRIPCION,REC_FECHA_CREACION,REC_FECHA_ACTUALIZACION) VALUES
(3,4,1,1,2,'pozo en el puente','bache en el puente',TO_DATE('2024-05-02', 'YYYY-MM-DD'),TO_DATE('2024-05-02', 'YYYY-MM-DD'));

INSERT INTO COMENTARIO (COM_ID,rec_id,use_id,COM_FECHA_CREACION,COM_FECHA_ACTUALIZACION,COM_TEXTO) VALUES
(1,1,1,TO_DATE('2024-05-09', 'YYYY-MM-DD'), TO_DATE('2024-05-09', 'YYYY-MM-DD'),'hay una fuga de agua');
INSERT INTO COMENTARIO (COM_ID,rec_id,use_id,COM_FECHA_CREACION,COM_FECHA_ACTUALIZACION,COM_TEXTO) VALUES
(2,2,1,TO_DATE('2024-05-07', 'YYYY-MM-DD'), TO_DATE('2024-05-07', 'YYYY-MM-DD'),'hay un perro abandonado');
INSERT INTO COMENTARIO (COM_ID,rec_id,use_id,COM_FECHA_CREACION,COM_FECHA_ACTUALIZACION,COM_TEXTO) VALUES
(3,3,2,TO_DATE('2024-05-02', 'YYYY-MM-DD'),TO_DATE('2024-05-02', 'YYYY-MM-DD'),'hay un pozo en el puente!!');

INSERT INTO COMENTARIO (COM_ID,rec_id,ges_id,COM_FECHA_CREACION,COM_FECHA_ACTUALIZACION,COM_TEXTO) VALUES
(4,1,2,TO_DATE('2024-05-02', 'YYYY-MM-DD'),TO_DATE('2024-05-02', 'YYYY-MM-DD'),'Se rompio la 5ta manguera');
INSERT INTO COMENTARIO (COM_ID,rec_id,ges_id,COM_FECHA_CREACION,COM_FECHA_ACTUALIZACION,COM_TEXTO) VALUES
(5,2,3,TO_DATE('2024-05-02', 'YYYY-MM-DD'),TO_DATE('2024-05-02', 'YYYY-MM-DD'),'Ya tenemos al perro');
