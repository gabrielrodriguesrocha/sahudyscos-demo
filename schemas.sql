CREATE TABLE album (
    cod_album		serial PRIMARY KEY,
    nome			varchar(40) NOT NULL,
    pais			varchar(40) NOT NULL,
    descricao		text,
    avaliacao		float,
    capa			text,
    data_publicacao	date NOT NULL CHECK ((data_publicacao >= '1889-01-01') AND (data_publicacao <= CURRENT_DATE)),
    genero1			varchar(40) NOT NULL,
    genero2			varchar(40)
);

CREATE TABLE banda (
    cod_banda		serial PRIMARY KEY,
    nome			varchar(40) NOT NULL,
    data_fundacao	date NOT NULL CHECK (data_fundacao <= CURRENT_DATE),
    descricao		text,
    genero1			varchar(40) NOT NULL,
    genero2			varchar(40)
);

CREATE TABLE gravadora (
    cod_identificacao	serial PRIMARY KEY,
    nome				varchar(40) NOT NULL,
    email				text NOT NULL CHECK (email LIKE '%@%.%'),
    data_fundacao		date NOT NULL CHECK (data_fundacao <= CURRENT_DATE),
    genero1				varchar(40) NOT NULL,
    genero2				varchar(40),
    telefone1			varchar(15) NOT NULL CHECK (telefone1 LIKE '+%'),
    telefone2			varchar(15) CHECK (telefone2 LIKE '+%')
);

CREATE TABLE versao (
    cod_barras		bigint NOT NULL,
    cod_album		bigint NOT NULL REFERENCES album(cod_album),
    cod_gravadora	bigint NOT NULL REFERENCES gravadora(cod_identificacao),
    formato			varchar(15) NOT NULL CHECK (formato = 'vinil' OR formato = 'cassete' OR formato = 'cd'),
    tipo_versao		varchar(20) NOT NULL CHECK (tipo_versao = 'original' OR tipo_versao = 'remasterizada' OR tipo_versao = 'aniversário'),
    preco			numeric NOT NULL CHECK (preco >= 0),
    qtd_vendida		bigint NOT NULL CHECK (qtd_vendida >= 0),
    qtd_disponivel	bigint NOT NULL CHECK (qtd_disponivel >= 0),
    promocao		boolean NOT NULL,
    data_lancamento date NOT NULL CHECK ((data_lancamento >= '1889-01-01') AND (data_lancamento <= CURRENT_DATE)),
    PRIMARY KEY (cod_barras, cod_album)
);

CREATE TABLE gravacao (
    cod_album 	bigint NOT NULL REFERENCES album(cod_album),
    cod_banda 	bigint NOT NULL REFERENCES banda(cod_banda),
    PRIMARY KEY (cod_album, cod_banda)
);

CREATE TABLE contrato (
    cod_banda 		bigint NOT NULL REFERENCES banda(cod_banda),
    cod_gravadora	bigint NOT NULL REFERENCES gravadora(cod_identificacao),
    PRIMARY KEY (cod_banda, cod_gravadora)
);

