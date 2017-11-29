--RD1: Listar todos os álbuns de determinada banda
CREATE OR REPLACE FUNCTION list_by_band(banda int) RETURNS
TABLE (
	cod_album	bigint,
    nome		varchar(40),
    descricao	text
)
AS 
$func$
BEGIN
	RETURN QUERY
    SELECT tf.cod_album, tf.nome, tf.descricao FROM ((SELECT gravacao.cod_album FROM gravacao WHERE cod_banda = banda) AS t1 NATURAL JOIN album) AS tf ORDER BY tf.cod_album;
END
$func$ LANGUAGE plpgsql;

--RD2: Listar todos os álbuns determinada gravadora
CREATE OR REPLACE FUNCTION list_by_label(gravadora int) RETURNS
TABLE (
	cod_album	bigint,
    nome		varchar(40),
    descricao	text
)
AS 
$func$
BEGIN
	RETURN QUERY
    SELECT tf.cod_album, tf.nome, tf.descricao FROM ((SELECT versao.cod_album FROM gravacao WHERE cod_gravadora = gravadora) AS t1 NATURAL JOIN album) AS tf ORDER BY tf.cod_album;
END
$func$ LANGUAGE plpgsql;

--RD3.1: Retornar a versão de álbum com o maior preço de determinada banda

CREATE OR REPLACE FUNCTION most_expensive_version(banda int) RETURNS
TABLE (
    cod_barras	bigint,
    nome		varchar(40),
    preco		numeric
)
AS 
$func$
BEGIN
	RETURN QUERY
    WITH t1 AS (SELECT versao.cod_barras, gravacao.cod_album, versao.preco FROM gravacao NATURAL JOIN versao WHERE cod_banda = banda)
    SELECT tf.cod_barras, tf.nome, tf.preco FROM
       (t1 NATURAL JOIN (SELECT MAX(t1.preco) as preco FROM t1) as t2 NATURAL JOIN album)
    as tf;
END
$func$ LANGUAGE plpgsql;

--RD3.2: Retornar a versão de álbum com o maior preço de determinada banda

CREATE OR REPLACE FUNCTION most_expensive_version(banda int) RETURNS
TABLE (
    cod_barras	bigint,
    nome		varchar(40),
    preco		numeric
)
AS 
$func$
BEGIN
	RETURN QUERY
    WITH t1 AS (SELECT versao.cod_barras, gravacao.cod_album, versao.preco FROM gravacao NATURAL JOIN versao WHERE cod_banda = banda)
    SELECT tf.cod_barras, tf.nome, tf.preco FROM
       (t1 NATURAL JOIN (SELECT MIN(t1.preco) as preco FROM t1) as t2 NATURAL JOIN album)
    as tf;
END
$func$ LANGUAGE plpgsql;

--RD4: Retornar versões de um determinado álbum que estão em promoção na semana corrente

CREATE OR REPLACE FUNCTION list_on_sale(album int) RETURNS
TABLE (
	cod_barras	bigint,
    preco		numeric
)
AS 
$func$
BEGIN
	RETURN QUERY
    SELECT cod_barras, preco FROM versao WHERE cod_album = album AND promocao = TRUE;
END
$func$ LANGUAGE plpgsql;

--RD5: Informar versões de um álbum cujas quantidades disponíveis estão abaixo de umacerta quantidade mínima

CREATE OR REPLACE FUNCTION list_low_stock(album int) RETURNS
TABLE (
	cod_barras	bigint,
    preco		numeric
)
AS 
$func$
BEGIN
	RETURN QUERY
    SELECT cod_barras, preco FROM versao WHERE qtd_disponivel >= qtd_minima AND promocao = TRUE;
END
$func$ LANGUAGE plpgsql;

--RD6: Listar álbuns por determinado gênero

CREATE OR REPLACE FUNCTION list_by_genre(genero varchar(40), subgenero varchar(40)) RETURNS
TABLE (
	cod_album	int,
    nome		varchar(40)
)
AS 
$func$
BEGIN
	RETURN QUERY
    SELECT cod_album, nome FROM album WHERE genero1 = genero OR genero2 = subgenero;
END
$func$ LANGUAGE plpgsql;

--RD7: Informar a quantidade de vendas de versões de álbuns por gravadora

CREATE OR REPLACE FUNCTION sales_by_label() RETURNS
TABLE (
	qtd_total	numeric
)
AS 
$func$
BEGIN
	RETURN QUERY
    SELECT sum(qtd_vendida) FROM versao GROUP BY cod_gravadora;
END
$func$ LANGUAGE plpgsql;

--RD8: Informar a avaliação média por banda

CREATE OR REPLACE FUNCTION avg_rating_band() RETURNS
TABLE (
    cod_banda 	bigint,
	media 		numeric
)
AS 
$func$
BEGIN
	RETURN QUERY
    SELECT tf.cod_banda, AVG(tf.avaliacao) as media FROM (album NATURAL JOIN gravacao) AS tf GROUP BY tf.cod_banda ORDER BY media DESC;
END
$func$ LANGUAGE plpgsql;

--RD9: Retornar versões de álbuns de determinada banda conforme o tipo desejado

CREATE OR REPLACE FUNCTION get_by_type(banda int, tipo varchar(40)) RETURNS
TABLE (
	cod_barras 	bigint,
    nome		varchar(40),
    preco		numeric
)
AS 
$func$
BEGIN
	RETURN QUERY
    SELECT tf.cod_barras, tf.nome, tf.preco FROM (versao NATURAL JOIN (SELECT t1.cod_album, album.nome FROM (SELECT cod_album FROM gravacao WHERE cod_banda = banda) as t1 NATURAL JOIN album) AS t2) AS tf WHERE tf.tipo_versao = tipo;
END
$func$ LANGUAGE plpgsql;

--RD10: Recuperar álbuns publicados em determinada faixa temporal

CREATE OR REPLACE FUNCTION get_by_period(de date, ate date) RETURNS
TABLE (
	cod_album	int,
    nome		varchar(40),
    descricao	text
)
AS 
$func$
BEGIN
	RETURN QUERY
    SELECT cod_album, nome, descricao FROM album WHERE data_publicacao >= de AND data_publicacao <= ate;
END
$func$ LANGUAGE plpgsql;

