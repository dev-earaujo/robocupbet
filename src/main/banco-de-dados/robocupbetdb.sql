DROP TABLE usuarios;

CREATE TABLE usuarios(
    id_usuario NUMBER(10) CONSTRAINT usuario_id_pk PRIMARY KEY,
    nome_usuario VARCHAR(200) NOT NULL,
    email_usuario VARCHAR(200) CONSTRAINT usuario_email_uk UNIQUE NOT NULL,
    senha_usuario CHAR(64) NOT NULL,
    pontos_usuario NUMERIC(10) DEFAULT(100) NOT NULL
);

DROP SEQUENCE usuarios_sequence;
DROP TRIGGER tr_insert_id_usuario;

CREATE SEQUENCE usuarios_sequence
START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER tr_insert_id_usuario
BEFORE INSERT ON usuarios FOR EACH ROW
BEGIN
SELECT usuarios_sequence.NEXTVAL
INTO :NEW.id_usuario
FROM DUAL;
END;


DROP TABLE robos;

CREATE TABLE robos(
    id_robo NUMBER(10) CONSTRAINT robo_id_pk PRIMARY KEY,
    nome_robo VARCHAR(50) CONSTRAINT robo_nome_uk UNIQUE NOT NULL,
    peso_robo NUMBER(10,2) NOT NULL,
    altura_robo NUMBER(10,2) NOT NULL,
    largura_robo NUMBER(10,2) NOT NULL,
    comprimento_roob NUMBER(10,2) NOT NULL,
    url_foto_robo VARCHAR(200) CONSTRAINT url_foto_uk UNIQUE NOT NULL
);

DROP SEQUENCE robos_sequence;
DROP TRIGGER tr_insert_id_robo;

CREATE SEQUENCE robos_sequence
START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER tr_insert_id_robo
BEFORE INSERT ON robos FOR EACH ROW
BEGIN
SELECT robos_sequence.NEXTVAL
INTO :NEW.id_robo
FROM DUAL;
END;


DROP TABLE equipes;

CREATE TABLE equipes(
    id_equipe NUMBER(10) CONSTRAINT equipe_id_pk PRIMARY KEY,
    id_partida NUMBER(10),
    id_robo NUMBER(10) NOT NULL UNIQUE,
    nome_equipe VARCHAR(50) CONSTRAINT equipe_nome_uk UNIQUE NOT NULL
);

ALTER TABLE equipes
ADD CONSTRAINT equipe_id_robo_fk 
FOREIGN KEY(id_robo)
REFERENCES robos(id_robo);

DROP SEQUENCE equipes_sequence;
DROP TRIGGER tr_insert_id_equipe;

CREATE SEQUENCE equipes_sequence
START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER tr_insert_id_equipe
BEFORE INSERT ON equipes FOR EACH ROW
BEGIN
SELECT equipes_sequence.NEXTVAL
INTO :NEW.id_equipe
FROM DUAL;
END;


DROP TABLE integrantes;

CREATE TABLE integrantes(
    id_integrante NUMBER(10) CONSTRAINT integrante_id_pk PRIMARY KEY,
    id_equipe NUMBER(10) NOT NULL,
    nome_integrante VARCHAR(200) NOT NULL,
    rm_integrante VARCHAR(10) CONSTRAINT integrante_rm_uk UNIQUE NOT NULL,
    url_foto_integrante VARCHAR(200) NOT NULL
);

ALTER TABLE integrantes
ADD CONSTRAINT integrante_id_equipe_fk
FOREIGN KEY(id_equipe)
REFERENCES equipes(id_equipe);

DROP SEQUENCE integrantes_sequence;
DROP TRIGGER tr_insert_id_integrante;

CREATE SEQUENCE integrantes_sequence
START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER tr_insert_id_integrante
BEFORE INSERT ON integrantes FOR EACH ROW
BEGIN
SELECT integrantes_sequence.NEXTVAL
INTO :NEW.id_integrante
FROM DUAL;
END;


DROP TABLE partidas;

CREATE TABLE partidas(
    id_partida NUMBER(10) CONSTRAINT partida_id_pk PRIMARY KEY,
    id_equipe_vencedora NUMBER(10),
    inicio_partida DATE NOT NULL,
    partida_finalizada NUMBER(1) CONSTRAINT partida_finalizada_bool CHECK(partida_finalizada IN(0,1)) NOT NULL
);

ALTER TABLE partidas
MODIFY(partida_finalizada DEFAULT(0));

ALTER TABLE partidas
ADD CONSTRAINT partida_id_equipe_vencedora_fk
FOREIGN KEY(id_equipe_vencedora)
REFERENCES equipes(id_equipe);

ALTER TABLE equipes
ADD CONSTRAINT equipe_id_partida_fk
FOREIGN KEY(id_partida)
REFERENCES partidas(id_partida);

DROP SEQUENCE partidas_sequence;
DROP TRIGGER tr_insert_id_partida;

CREATE SEQUENCE partidas_sequence
START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER tr_insert_id_partida
BEFORE INSERT ON partidas FOR EACH ROW
BEGIN
SELECT partidas_sequence.NEXTVAL
INTO :NEW.id_partida
FROM DUAL;
END;


DROP TABLE apostas;

CREATE TABLE apostas(
    id_aposta NUMBER(10) CONSTRAINT aposta_id_pk PRIMARY KEY,
    id_usuario NUMBER(10) NOT NULL,
    id_partida NUMBER(10) NOT NULL,
    valor_aposta NUMBER(10) CONSTRAINT valor_aposta_ck CHECK (valor_aposta > 0) NOT NULL,
    aposta_ativa NUMBER(1) CONSTRAINT aposta_ativa_bool CHECK (aposta_ativa IN(0, 1)) NOT NULL,
    venceu_aposta NUMBER(1) CONSTRAINT venceu_aposta_bool CHECK (venceu_aposta IN(0, 1)) NOT NULL
);

ALTER TABLE apostas
MODIFY(aposta_ativa DEFAULT(0));

ALTER TABLE apostas
MODIFY(venceu_aposta DEFAULT(0));

ALTER TABLE apostas
ADD CONSTRAINT aposta_id_usuario_fk
FOREIGN KEY(id_usuario)
REFERENCES usuarios(id_usuario);

ALTER TABLE apostas
ADD CONSTRAINT aposta_id_partida_fk
FOREIGN KEY(id_partida)
REFERENCES partidas(id_partida);

DROP SEQUENCE apostas_sequence;
DROP TRIGGER tr_insert_id_aposta;

CREATE SEQUENCE apostas_sequence
START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER tr_insert_id_aposta
BEFORE INSERT ON apostas FOR EACH ROW
BEGIN
SELECT apostas_sequence.NEXTVAL
INTO :NEW.id_aposta
FROM DUAL;
END;


DROP TABLE premio;

CREATE TABLE premio(
    id_premio NUMBER(10) CONSTRAINT premio_id_pk PRIMARY KEY,
    nome_premio VARCHAR(100) CONSTRAINT nome_premio_uk UNIQUE NOT NULL,
    desc_premio VARCHAR(500) NOT NULL,
    valor_premio NUMBER(10) CONSTRAINT valor_premio_ck CHECK(valor_premio > 0) NOT NULL,
    quantidade_premio NUMBER(10) CONSTRAINT quantidade_premio_ck CHECK(quantidade_premio >= 0) NOT NULL
);

DROP SEQUENCE premios_sequence;
DROP TRIGGER tr_insert_id_premio;

CREATE SEQUENCE premios_sequence
START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER tr_insert_id_premio
BEFORE INSERT ON premio FOR EACH ROW
BEGIN
SELECT premios_sequence.NEXTVAL
INTO :NEW.id_premio
FROM DUAL;
END;