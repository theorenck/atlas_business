#encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

# # valorTotalReceita
# vlTotReQuery = Query.new(type: '', statement: "SELECT SUM(f.valorfluxo) AS \"VALOR_TOTAL_RECEITA\" FROM zw14fflu f WHERE f.modalidade IN ('P','R') AND f.estimativa = 'C' AND f.pagarreceber = 'R' AND {FN TIMESTAMPADD (SQL_TSI_DAY, f.datafluxo-72687, {D '2000-01-01'})} BETWEEN {TS :inicio} AND {TS :fim}")
# Parameter.create(name: 'inicio',data_type:'datetime' ,default_value:"'2000-01-01 00:00:00'", query: vlTotReQuery)
# Parameter.create(name: 'fim',data_type:'datetime' ,default_value:"'2014-12-30 00:00:00'", query: vlTotReQuery )
# vlTotReIndicator = Indicator.create(name: 'Faturamento', description: 'valorTotalReceita', query: vlTotReQuery)

# # volumeVendasTotal
# vlVendasTotQuery = Query.new(type: '', statement: "SELECT {FN CONVERT(SUM(p.valortotal), SQL_FLOAT)} AS \"VOLUME_VENDAS\" FROM zw14vped p WHERE p.situacao = :situacao AND {FN TIMESTAMPADD (SQL_TSI_DAY, p.dataemiss-72687, {D '2000-01-01'})} BETWEEN {TS :inicio} AND {TS :fim}")
# Parameter.create(name: 'inicio',data_type:'datetime' ,default_value:"'2000-01-01 00:00:00'", query: vlVendasTotQuery)
# Parameter.create(name: 'fim',data_type:'datetime' ,default_value:"'2014-12-30 00:00:00'", query: vlVendasTotQuery )
# Parameter.create(name: 'situacao',data_type:'string' ,default_value:"'LOC Locado'", query: vlVendasTotQuery)
# vlVendasTotIndicator = Indicator.create(description: 'volumeVendasTotal', query: vlVendasTotQuery)

dash   = Dashboard.create(name: 'Dashboard', description: 'Dash description')
pie    = WidgetType.create(name:'pie')
status = WidgetType.create(name:'status')
line   = WidgetType.create(name:'line')

# faturamento
fatQuery = SingleValueQuery.new(statement: "SELECT SUM(f.valorfluxo) AS \"VALOR_TOTAL_RECEITA\" FROM zw14fflu f WHERE f.modalidade IN ('P','R') AND f.estimativa = 'C' AND f.pagarreceber = 'R' AND {FN TIMESTAMPADD (SQL_TSI_DAY, f.datalancamento-72687, {D '2000-01-01'})} BETWEEN {TS :inicio} AND {TS :fim}")
Parameter.create(name: 'inicio', data_type:'datetime' ,default_value:"'2000-01-01 00:00:00'", query: fatQuery)
Parameter.create(name: 'fim', data_type:'datetime' ,default_value:"'2014-12-30 00:00:00'", query: fatQuery )
fatIndicator = Indicator.create(unity: 'R$',name: 'Faturamento', description: "popover", query: fatQuery)
Widget.create(name:'ta vazio', description:'tambem ta vazio', widget_type: status, color: 'green', position:2 , size:3, dashboard: dash, indicator: fatIndicator)

# valorInadimplencia
vlInadimplenciaQuery = SingleValueQuery.new(statement: "SELECT SUM(f.valorfluxo) AS \"VALOR_INADIMPLENCIA\" FROM zw14fflu f WHERE f.modalidade = 'P' AND f.estimativa = 'C' AND f.pagarreceber = 'R' AND {FN TIMESTAMPADD (SQL_TSI_DAY, f.datafluxo-72687, {D '2000-01-01'})} BETWEEN {TS :inicio} AND {TS :fim}")
Parameter.create(name: 'inicio',data_type:'datetime' ,default_value:"'2000-01-01 00:00:00'", query: vlInadimplenciaQuery)
Parameter.create(name: 'fim',data_type:'datetime' ,default_value:"'2014-12-30 00:00:00'", query: vlInadimplenciaQuery )
vlInadimplenciaIndicator = Indicator.create(unity: '%', name: 'Inadimplencia', description: 'valorInadimplencia', query: vlInadimplenciaQuery)
Widget.create(name:'ta vazio', description:'tambem ta vazio', widget_type: status, color: 'red', position:3 , size:3, dashboard: dash, indicator: vlInadimplenciaIndicator)

# novosContratos
novosContratosQuery = SingleValueQuery.new(statement: "SELECT COUNT(*) AS \"CONTRATOS_PERIODO\" FROM zw14vped p WHERE p.situacao IN(:situacoes) AND {FN TIMESTAMPADD (SQL_TSI_DAY, p.dataemiss-72687, {D '2000-01-01'})} BETWEEN {TS :inicio} AND {TS :fim}")
Parameter.create(name: 'situacoes',data_type:'string' ,default_value:"'LOC Locado', 'LOC Finalizado', 'LOC Cancelado'", query: novosContratosQuery)
Parameter.create(name: 'inicio',data_type:'datetime' ,default_value:"'2000-01-01 00:00:00'", query: novosContratosQuery)
Parameter.create(name: 'fim',data_type:'datetime' ,default_value:"'2014-12-30 00:00:00'", query: novosContratosQuery )
novosContratosIndicator = Indicator.create(name: 'Novos contratos', description: 'novosContratos', query: novosContratosQuery)
Widget.create(name:'ta vazio', description:'tambem ta vazio', widget_type: status, color: 'blue', position:1, size:3, dashboard: dash, indicator: novosContratosIndicator)

# contratosAtivos
contratosAtivosQuery = SingleValueQuery.new(statement: "SELECT COUNT(*) AS \"CONTRATOS_PERIODO\" FROM zw14vped p WHERE p.situacao IN(:situacao) AND {FN TIMESTAMPADD (SQL_TSI_DAY, p.dataemiss-72687, {D '2000-01-01'})} < {TS :fim} AND p.dataemiss <> 0")
Parameter.create(name: 'situacao',data_type:'string' ,default_value:"'LOC Locado'", query: contratosAtivosQuery)
Parameter.create(name: 'fim',data_type:'datetime' ,default_value:"'2014-12-30 00:00:00'", query: contratosAtivosQuery )
novosContratosAtivosIndicator = Indicator.create(name: 'Contratos Ativos', description: 'novosContratosAtivos', query: contratosAtivosQuery)
Widget.create(name:'ta vazio', description:'tambem ta vazio', widget_type: status, color: 'orange', position:0, size:3, dashboard: dash, indicator: novosContratosAtivosIndicator)

# novosContratosDia
novosContratosDiaQuery = ResultQuery.new(statement: "SELECT {FN CONVERT({FN TIMESTAMPADD (SQL_TSI_DAY, p.dataemiss-72687, {D '2000-01-01'})},SQL_DATE)} AS \"DATA_EMISSAO\", count(*) AS \"QUANTIDADE\" FROM zw14vped p WHERE  p.situacao IN (:situacoes)  AND {FN TIMESTAMPADD (SQL_TSI_DAY, p.dataemiss-72687, {D '2000-01-01'})}   BETWEEN {TS :inicio} AND {TS :fim} GROUP BY  p.dataemiss  ORDER BY  p.dataemiss DESC")
Parameter.create(name: 'situacoes',data_type:'string' ,default_value:"'LOC Locado', 'LOC Finalizado', 'LOC Cancelado'", query: novosContratosDiaQuery)
Parameter.create(name: 'inicio',data_type:'datetime' ,default_value:"'2000-01-01 00:00:00'", query: novosContratosDiaQuery)
Parameter.create(name: 'fim',data_type:'datetime' ,default_value:"'2014-12-30 00:00:00'", query: novosContratosDiaQuery )
novosContratosDiaIndicator = Indicator.create(name: 'Novos contratos por dia',description: 'novosContratosDia', query: novosContratosDiaQuery)
Widget.create(widget_type: line, color: 'blue', position:4, size:12, dashboard: dash, indicator: novosContratosDiaIndicator)

# clientesMaisLocaram
clientesMaisLocaramQuery = ResultQuery.new(statement: "SELECT V.NOMECLIENTE AS \"CLIENTE\", {FN CONVERT({FN ROUND(SUM(V.VALORTOTALGERAL),2)},SQL_FLOAT)} AS \"TOTAL\" FROM ZW14VPED V WHERE V.SITUACAO = :situacao AND {FN TIMESTAMPADD (SQL_TSI_DAY, V.DATAEMISS-72687, {D '2000-01-01'})} BETWEEN {TS :inicio} AND {TS :fim} GROUP BY V.NOMECLIENTE ORDER BY 1")
Parameter.create(name: 'inicio',data_type:'datetime' ,default_value:"'2000-01-01 00:00:00'", query: clientesMaisLocaramQuery)
Parameter.create(name: 'fim',data_type:'datetime' ,default_value:"'2014-12-30 00:00:00'", query: clientesMaisLocaramQuery )
Parameter.create(name: "situacao",data_type:'string' ,default_value:"'LOC Locado'", query: clientesMaisLocaramQuery)
clientesMaisLocaramIndicator = Indicator.create(name: 'Faturamento por Cliente', description: 'clientesMaisLocaram', query: clientesMaisLocaramQuery)
Widget.create(widget_type: pie, position:5, size:4, dashboard: dash, indicator: clientesMaisLocaramIndicator)

# pedidosPorSituacao
pedidosPorSituacaoQuery = ResultQuery.new(statement: "SELECT p.situacao AS \"SITUACAO\", count(*) AS \"QUANTIDADE\" FROM  zw14vped p WHERE p.situacao IS NOT NULL AND {FN TIMESTAMPADD (SQL_TSI_DAY, p.dataemiss-72687, {D '2000-01-01'})} BETWEEN {TS :inicio} AND {TS :fim} GROUP BY   p.situacao")
Parameter.create(name: 'inicio',data_type:'datetime' ,default_value:"'2014-10-30 00:00:00'", query: pedidosPorSituacaoQuery)
Parameter.create(name: 'fim',data_type:'datetime' ,default_value:"'2014-11-30 00:00:00'", query: pedidosPorSituacaoQuery )
pedidosPorSituacaoIndicator = Indicator.create(name: "Pedidos por situação", description: 'pedidosPorSituacao', query: pedidosPorSituacaoQuery)
Widget.create(widget_type: pie, position:6, size:4, dashboard: dash, indicator: pedidosPorSituacaoIndicator)

user = User.create!(username:"admin", password:"admin", email:"zeta@zeta.com.br", token: '4361a34b6472e4634cd27f8d3f37108e', admin: true)
rmpoa = APIServer.create(url: "http://prod-04:3000/api", name:'RM POA', description: '')
Permission.create(dashboard: dash, api_server: rmpoa, user: user)

