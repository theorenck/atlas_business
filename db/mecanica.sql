-- 2. [OP 23757] 
--    2.1 - Adicionados novos campos para persistência das totalizações de Orçamento, Ordem de Serviço e Histórico.
--               SubTotal -> Valor da soma dos itens (PE e MO)
--               Total -> Valor da soma dos itens (PE e MO) - Valor do desconto oficina 
--               TotalSeguradora -> Valor da soma dos itens (PE e MO) - (Valor da Franquia - Desconto da seguradora)
--               PercentualDesconto -> (Valor do Desconto Geral / Valor Bruto do Movimento) * 100.00
--               PercentualDescontoMO -> (Valor do Desconto de Mão de Obra / Valor Bruto das Mão de Obra) * 100.00
--               PercentualDescontoPE -> (Valor do Desconto de Peças / Valor Bruto de Peças) * 100.00
--               PercentualDescontoFranquia -> (Valor do desconto oficina / Valor da franquia) * 100.00 
--               PercentualDescontoFranquiaSeg -> (Valor do desconto da seguradora / Valor da franquia) * 100.00 
--    2.2 - Criados arquivos (zw15iot = Totais de itens de Orçamento e zw15ist = Totais de itens de Serviços e Históricos) para persistir o valor das totalizações por tipos de item com os seguintes campos :
--               CodTipoItem          = Corresponde ao código do cadastro do tipo de item (Código zero corresponde ao totalizador geral)
--               TabelaRelacionada    = Corresponde à tabela relacionada com o tipo de item podendo ser (1 - Peças, 2 - Serviços e 0 - Totalizador geral)
--               DescricaoTipoItem    = Descrição do tipo de item
--               Total                = Valor total do item
--               CustoTotal           = Custo total do item
--               Diferenca            = Valor da diferença entre valor total e custo total
--               TotalComDesconto     = Valor líquido do item
--               DiferencaComDesconto = Valor líquido com desconto
--               PercDiferenca        = Percentual correspondente à diferença.
--    2.3 - Criada ferramenta para popular estes campos de totais em Ctrl+Alt+z -> Ferramentas -> Guia totais -> Iniciar.
--               Obs.: Esta mesma ferramenta foi disponibilizada como gerador publicada dentro da pasta de conversores do release "g_mecanica279.exe" que possibilita a geração destes dados no momento da atualização do sistema.

-- 1. FATURAMENTO POR TIPO ITEM PECA (615)
SELECT SUM ((i.valorsubtotal - i.desconto + i.acrescimo)*(1-(s.percdescontogeral/100))*(1-(s.percdescontope/100))*(1-(s.descontofranquia/s.subtotalsemfranquia))) AS "FATURAMENTO_TIPO_ITEM_PECA"
FROM zw15ser s 
   JOIN zw15its i
   ON s.codservico = i.codservico
WHERE {FN TIMESTAMPADD (SQL_TSI_DAY, s.datasaida-72687, {D '2000-01-01'})} BETWEEN {TS '2014-12-01 00:00:00'} AND {TS '2014-12-31 00:00:00'}
   AND i.cobrar = 1
   AND i.tipoitem = 1
   AND i.codtipoitem = 1
   AND s.aberto = 'N'
   
-- 2. FATURAMENTO POR TIPO ITEM MAO DE OBRA (615)
SELECT 0.8*SUM ((i.valorsubtotal - i.desconto + i.acrescimo)*(1-(s.percdescontogeral/100))*(1-(s.percdescontomo/100))*(1-(s.descontofranquia/s.subtotalsemfranquia))) AS "FATURAMENTO_TIPO_ITEM_SERVICO"
FROM zw15ser s 
   JOIN zw15its i
   ON s.codservico = i.codservico
WHERE {FN TIMESTAMPADD (SQL_TSI_DAY, s.datasaida-72687, {D '2000-01-01'})} BETWEEN {TS '2014-12-01 00:00:00'} AND {TS '2014-12-31 00:00:00'}
   AND i.cobrar = 1
   AND i.tipoitem = 1
   AND i.codtipoitem = 2
   AND s.aberto = 'N'
   
-- 3. FATURAMENTO POR TIPO ITEM SERVICO TERCEIROS (615)
SELECT SUM ((i.valorsubtotal - i.desconto + i.acrescimo)*(1-(s.percdescontogeral/100))*(1-(s.percdescontomo/100))*(1-(s.descontofranquia/s.subtotalsemfranquia))) AS "FATURAMENTO_TIPO_ITEM_SERVICO_TERCEIROS"
FROM zw15ser s 
   JOIN zw15its i
   ON s.codservico = i.codservico
WHERE {FN TIMESTAMPADD (SQL_TSI_DAY, s.datasaida-72687, {D '2000-01-01'})} BETWEEN {TS '2014-12-01 00:00:00'} AND {TS '2014-12-31 00:00:00'}
   AND i.cobrar = 1
   AND i.tipoitem = 1
   AND i.codtipoitem = 4
   AND s.aberto = 'N'

-- 4. FATURAMENTO POR TIPO ITEM MATERIAL CONSUMO (615)
SELECT 0.2*SUM ((i.valorsubtotal - i.desconto + i.acrescimo)*(1-(s.percdescontogeral/100))*(1-(s.percdescontomo/100))*(1-(s.descontofranquia/s.subtotalsemfranquia))) AS "FATURAMENTO_TIPO_ITEM_SERVICO"
FROM zw15ser s 
   JOIN zw15its i
   ON s.codservico = i.codservico
WHERE {FN TIMESTAMPADD (SQL_TSI_DAY, s.datasaida-72687, {D '2000-01-01'})} BETWEEN {TS '2014-12-01 00:00:00'} AND {TS '2014-12-31 00:00:00'}
   AND i.cobrar = 1
   AND i.tipoitem = 1
   AND i.codtipoitem = 2
   AND s.aberto = 'N'

-- 5. VALOR DEVOLUCAO DE PECAS (FLUXO)
SELECT 
   SUM(f.valorfluxo) AS "VALOR_DEVOLUCAO_PECAS"
FROM zw15fflu f   
   JOIN zw15fcop o
   ON {FN SUBSTRING({FN CONVERT(o.codigo+100000,SQL_CHAR)},2,5)} = f.codigoorigem
WHERE {FN TIMESTAMPADD (SQL_TSI_DAY, f.competenciaorigem-72687, {D '2000-01-01'})} BETWEEN {TS '2014-12-01 00:00:00'} AND {TS '2014-12-31 00:00:00'}
   AND f.tipoorigem = 'P'
   AND o.classe = '013002004' 
   AND o.tipoclasse = 'I'
GROUP BY o.codigo

-- 6. VALOR CUSTO PECAS (FLUXO)
SELECT
   SUM(f.valorfluxo) AS "VALOR_CUSTO"
FROM zw15fflu f   
   JOIN zw15fcop o
   ON {FN SUBSTRING({FN CONVERT(o.codigo+100000,SQL_CHAR)},2,5)} = f.codigodestino
WHERE {FN TIMESTAMPADD (SQL_TSI_DAY, f.competenciaorigem-72687, {D '2000-01-01'})} BETWEEN {TS '2014-12-01 00:00:00'} AND {TS '2014-12-31 00:00:00'}
   AND f.tipodestino = 'P'
   AND o.classe = '013002004' 
   AND o.tipoclasse = 'I'

-- 7. VALOR CUSTO PESSOAL DE PRODUCAO (FLUXO)
SELECT
   SUM(f.valorfluxo) AS "VALOR_CUSTO"
FROM zw15fflu f   
   JOIN zw15fcop o
   ON {FN SUBSTRING({FN CONVERT(o.codigo+100000,SQL_CHAR)},2,5)} = f.codigodestino
WHERE {FN TIMESTAMPADD (SQL_TSI_DAY, f.competenciaorigem-72687, {D '2000-01-01'})} BETWEEN {TS '2014-12-01 00:00:00'} AND {TS '2014-12-31 00:00:00'}
   AND f.tipodestino = 'P'
   AND o.classe = '013002004' --PESSOAL DE PRODUCAO
   AND o.tipoclasse = 'I'

-- 8. VALOR CUSTO SERVICOS TERCEIROS (FLUXO)
SELECT
   SUM(f.valorfluxo) AS "VALOR_CUSTO"
FROM zw15fflu f   
   JOIN zw15fcop o
   ON {FN SUBSTRING({FN CONVERT(o.codigo+100000,SQL_CHAR)},2,5)} = f.codigodestino
WHERE {FN TIMESTAMPADD (SQL_TSI_DAY, f.competenciaorigem-72687, {D '2000-01-01'})} BETWEEN {TS '2014-12-01 00:00:00'} AND {TS '2014-12-31 00:00:00'}
   AND f.tipodestino = 'P'
   AND o.classe = '013002004' --SERVICOS TERCEIROS
   AND o.tipoclasse = 'I'

-- 9. VALOR CUSTO INSUMOS PINTURA (FLUXO)
SELECT
   SUM(f.valorfluxo) AS "VALOR_CUSTO"
FROM zw15fflu f   
   JOIN zw15fcop o
   ON {FN SUBSTRING({FN CONVERT(o.codigo+100000,SQL_CHAR)},2,5)} = f.codigodestino
WHERE {FN TIMESTAMPADD (SQL_TSI_DAY, f.competenciaorigem-72687, {D '2000-01-01'})} BETWEEN {TS '2014-12-01 00:00:00'} AND {TS '2014-12-31 00:00:00'}
   AND f.tipodestino = 'P'
   AND o.classe = '013002004' --INSUMOS PINTURA
   AND o.tipoclasse = 'I'

-- 10. FATURAMENTO 
SELECT
   SUM(s.totalcomdescontooficina)
FROM
   zw15ser s 
WHERE 
   s.aberto = 'N' 
   AND {FN TIMESTAMPADD (SQL_TSI_DAY, s.datasaida-72687, {D '2000-01-01'})}
      BETWEEN {TS '2014-12-01 00:00:00'} AND {TS '2014-12-31 00:00:00'}

-- 11. QUANTIDADE DE OS NO PERIODO
SELECT 
   count(*) AS "QUANTIDADE_OS"
FROM 
   zw15ser s 
WHERE 
   {FN TIMESTAMPADD (SQL_TSI_DAY, s.datasaida-72687, {D '2000-01-01'})} 
      BETWEEN {TS '2014-12-20 00:00:00'} AND {TS '2014-12-31 00:00:00'}

-- 12. TICKET MEDIO PC
SELECT 
   SUM((i.valorsubtotal - i.desconto + i.acrescimo)*(1-(s.percdescontogeral/100))*(1-(s.percdescontope/100))*(1-(s.descontofranquia/(s.subtotalsemfranquia))))/:quantidade_os AS "MEDIA_TICKET_PC"
FROM 
   zw15ser s 
JOIN 
   zw15its i
ON 
   s.codservico = i.codservico
WHERE 
   {FN TIMESTAMPADD (SQL_TSI_DAY, s.datasaida-72687, {D '2000-01-01'})} BETWEEN {TS '2014-12-20 00:00:00'} AND {TS '2014-12-31 00:00:00'}
   AND i.cobrar = 1
   AND i.tipoitem = 1
   AND i.codtipoitem = 1

-- 12. TICKET MEDIO MO
SELECT 
   47961.88/40 AS "TICKET_MEDIO_MO" 
FROM 
   zw15fcop 
WHERE
   codigo = 10

-- 13. NOVAS OS POR DIA  (dataentrada)
-- 14. FATURAMENTO CLIENTE
   -- TOTAL DE OS POR CLIENTE codcliente e totalcomdescontooficina
-- 15. FATURAMENTO SEGURADORA
   -- TOTAL DE OS POR SEGURADORA  e totalcomdescontooficina


-- RENTABILIDADE PECAS = (1/(6-5))
-- RENTABILIDADE MAO DE OBRA = (2/7)
-- RENTABILIDADE TERCEIROS = (3/8)
-- RENTABILIDADE MATERIAL DE CONSUMO = (4/9)

-- TICKET MEDIO PECAS 11.QUANTIDADE_OS -> 12.QUANTIDADE_OS


-- CONSULTA POR TIPO ITEM PECA (615)
SELECT SUM ((i.valorsubtotal - i.desconto + i.acrescimo)*(1-(s.percdescontogeral/100))*(1-(s.percdescontope/100))*(1-(s.descontofranquia/s.subtotalsemfranquia))) AS "FATURAMENTO_TIPO_ITEM_PECA"
FROM zw15ser s 
   JOIN zw15its i
   ON s.codservico = i.codservico
WHERE {FN TIMESTAMPADD (SQL_TSI_DAY, s.dataentrada-72687, {D '2000-01-01'})} BETWEEN {TS '2014-12-01 00:00:00'} AND {TS '2014-12-31 00:00:00'}
   AND i.cobrar = 1
   AND i.tipoitem = 1
   AND i.codtipoitem = 1
   
  
-- CONSULTA POR TIPO ITEM SERVICO (615)
SELECT SUM ((i.valorsubtotal - i.desconto + i.acrescimo)*(1-(s.percdescontogeral/100))*(1-(s.percdescontomo/100))*(1-(s.descontofranquia/s.subtotalsemfranquia))) AS "FATURAMENTO_TIPO_ITEM_SERVICO"
FROM zw15ser s 
   JOIN zw15its i
   ON s.codservico = i.codservico
WHERE {FN TIMESTAMPADD (SQL_TSI_DAY, s.dataentrada-72687, {D '2000-01-01'})} BETWEEN {TS '2014-12-01 00:00:00'} AND {TS '2014-12-31 00:00:00'}
   AND i.cobrar = 1
   AND i.tipoitem = 1
   AND i.codtipoitem = 2
   
   
-- CONSULTA POR TIPO ITEM SERVICO TERCEIROS (615)
SELECT SUM ((i.valorsubtotal - i.desconto + i.acrescimo)*(1-(s.percdescontogeral/100))*(1-(s.percdescontomo/100))*(1-(s.descontofranquia/s.subtotalsemfranquia))) AS "FATURAMENTO_TIPO_ITEM_SERVICO_TERCEIROS"
FROM zw15ser s 
   JOIN zw15its i
   ON s.codservico = i.codservico
WHERE {FN TIMESTAMPADD (SQL_TSI_DAY, s.dataentrada-72687, {D '2000-01-01'})} BETWEEN {TS '2014-12-01 00:00:00'} AND {TS '2014-12-31 00:00:00'}
   AND i.cobrar = 1
   AND i.tipoitem = 1
   AND i.codtipoitem = 4


-- CONSULTA POR DEVOLUCAO DE PECAS (FLUXO)
SELECT o.codigo, SUM(f.valorfluxo)
FROM zw15fflu f   
   JOIN zw15fcop o
   ON {FN SUBSTRING({FN CONVERT(o.codigo+100000,SQL_CHAR)},2,5)} = f.codigoorigem
WHERE {FN TIMESTAMPADD (SQL_TSI_DAY, f.competenciaorigem-72687, {D '2000-01-01'})} BETWEEN {TS '2014-12-01 00:00:00'} AND {TS '2014-12-31 00:00:00'}
   AND f.tipoorigem = 'P'
   AND o.classe = '013002004' 
   AND o.tipoclasse = 'I'
GROUP BY o.codigo


-- CONSULTA POR PECAS (FLUXO)
SELECT o.codigo, SUM(f.valorfluxo)
FROM zw15fflu f   
   JOIN zw15fcop o
   ON {FN SUBSTRING({FN CONVERT(o.codigo+100000,SQL_CHAR)},2,5)} = f.codigodestino
WHERE {FN TIMESTAMPADD (SQL_TSI_DAY, f.competenciaorigem-72687, {D '2000-01-01'})} BETWEEN {TS '2014-12-01 00:00:00'} AND {TS '2014-12-31 00:00:00'}
   AND f.tipodestino = 'P'
   AND o.classe = '013002004' 
   AND o.tipoclasse = 'I'
GROUP BY o.codigo


