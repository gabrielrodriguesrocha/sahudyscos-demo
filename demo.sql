-- Busca pela banda Pink Floyd
SELECT cod_banda FROM banda WHERE nome = 'Pink Floyd';

-- Verifica se o álbum More está cadastrado
SELECT cod_album FROM list_by_band(2) WHERE nome = 'More';

-- Há alguma versão do More em promoção?
SELECT * FROM list_on_sale(9);

-- Quais versões do More estão abaixo de 2 unidades?
SELECT * FROM list_low_stock(9, 2);

-- O More é o álbum mais barato?
SELECT * FROM cheapest_version(2);

-- Seleciona a(s) gravadora(s) de diferentes versões do More
SELECT cod_gravadora FROM versao WHERE cod_album = 9;

-- Mostra o ranking de gravadoras por venda
SELECT * FROM sales_by_label();

-- Qual a avaliação média do Pink Floyd?
SELECT cod_banda, media, nome FROM avg_rating_band() NATURAL JOIN banda ORDER BY cod_banda ASC;

-- Há albuns originais à venda?
SELECT * FROM get_by_type(2, 'original');

-- Os álbuns mais caros são originais?
SELECT * FROM (get_by_type(2, 'original') NATURAL JOIN most_expensive_version(2)) WHERE cod_barras NOT IN (SELECT cod_barras FROM most_expensive_version(2));

-- O Pink Floyd já fez algum álbum Pop?
SELECT * FROM list_by_genre('Pop', '') NATURAL JOIN gravacao where cod_banda = 2;

-- Que álbuns foram publicados nos anos 80 e são do Pink Floyd?
SELECT * FROM get_by_period('1980-01-01', '1989-12-12') NATURAL JOIN list_by_band(2);

-- Finalmente, vamos comprar todos os More
UPDATE versao SET qtd_disponivel = 0 WHERE cod_album = 9;