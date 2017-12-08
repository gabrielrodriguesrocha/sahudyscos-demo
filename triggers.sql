CREATE OR REPLACE FUNCTION warn_low_stock() RETURNS TRIGGER AS $$
  BEGIN
    IF NEW.qtd_disponivel < TG_ARGV[0]::bigint THEN
      RAISE NOTICE 'Quantidade disponível da versão % abaixo do valor mínimo (% unidades).', NEW.cod_barras, TG_ARGV[0]::bigint;
      
      IF (SELECT SUM(qtd_disponivel) FROM versao WHERE cod_album = NEW.cod_album GROUP BY cod_album) < TG_ARGV[1]::bigint THEN
        RAISE NOTICE 'Quantidade disponível do álbum % (Cod. %) abaixo do valor mínimo (% unidades).',
        (SELECT nome FROM album WHERE cod_album = NEW.cod_album), NEW.cod_album, TG_ARGV[1]::bigint;
        
        IF (SELECT SUM(qtd_disponivel) FROM versao WHERE cod_gravadora = NEW.cod_gravadora GROUP BY cod_gravadora) < TG_ARGV[2]::bigint THEN
          RAISE NOTICE 'Quantidade disponível da gravadora % (Cod. %) abaixo do valor mínimo (% unidades).', 
          (SELECT nome FROM gravadora WHERE cod_identificacao = NEW.cod_gravadora), NEW.cod_gravadora, TG_ARGV[2]::bigint;
         END IF;
      
      END IF;
    
    END IF;
    RETURN NEW;
  END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER warn_low_stock
  BEFORE UPDATE ON versao
  FOR EACH ROW EXECUTE PROCEDURE warn_low_stock(1, 5, 10);
