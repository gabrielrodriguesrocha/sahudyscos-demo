CREATE OR REPLACE FUNCTION warn_low_stock() RETURNS TRIGGER AS $$
	BEGIN
    	IF NEW.qtd_disponivel < TG_ARGV[0]::bigint THEN
        	RAISE NOTICE 'Quantidade disponível da versão % abaixo do valor mínimo.', NEW.cod_barras;
            
			IF (SELECT SUM(qtd_disponivel) FROM versao GROUP BY NEW.cod_album) < TG_ARGV[1]::bigint THEN
            	RAISE NOTICE 'Quantidade disponível do álbum % (Cod. %) abaixo do valor mínimo.',
			   	(SELECT nome FROM album WHERE cod_album = NEW.cod_album), NEW.cod_album;
                
				IF (SELECT SUM(qtd_disponivel) FROM versao GROUP BY NEW.cod_gravadora) < TG_ARGV[2]::bigint THEN
                	RAISE NOTICE 'Quantidade disponível da gravadora % (Cod. %) abaixo do valor mínimo.', 
					(SELECT nome FROM gravadora WHERE cod_identificacao = NEW.cod_gravadora), NEW.cod_gravadora;
                END IF;
            
			END IF;
        
		END IF;
        RETURN NEW;
	END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER warn_low_stock
	BEFORE INSERT OR UPDATE ON versao
    FOR EACH ROW EXECUTE PROCEDURE warn_low_stock(1, 5, 10);
