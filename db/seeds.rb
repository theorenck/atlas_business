#encoding: utf-8

## Widget Types
pie    = WidgetType.create(name:'pie')
status = WidgetType.create(name:'status')
line   = WidgetType.create(name:'line')


## Unities
dinheiro = Unity.create(name: 'Dinheiro', symbol: 'R$')
porcentagem = Unity.create(name: 'Porcentagem', symbol: '%')


## Dashboards
dash   = Dashboard.create(name: 'Dashboard', description: 'Dash description')
dash2   = Dashboard.create(name: 'Dashboard 2', description: 'Dash 2 description')


## Sources
# faturamento
sourceFaturamento = Query.new(name: 'Faturamento', statement: "SELECT SUM(f.valorfluxo) AS \"VALOR_TOTAL_RECEITA\" FROM zw14fflu f WHERE f.modalidade IN ('P','R') AND f.estimativa = 'C' AND f.pagarreceber = 'R' AND {FN TIMESTAMPADD (SQL_TSI_DAY, f.datalancamento-72687, {D '2000-01-01'})} BETWEEN {TS :inicio} AND {TS :fim}")
sourceFaturamento.parameters<<TypedParameter.new(name: 'inicio', datatype:'timestamp' , value:"2000-01-01 00:00:00")
sourceFaturamento.parameters<<TypedParameter.new(name: 'fim', datatype:'timestamp' , value:"2014-12-30 00:00:00")
sourceFaturamento.save
# inadimplencia
sourceInadimplencia = Query.new(name: 'Valor Inadimplencia', statement: "SELECT SUM(f.valorfluxo) AS \"VALOR_INADIMPLENCIA\" FROM zw14fflu f WHERE f.modalidade = 'P' AND f.estimativa = 'C' AND f.pagarreceber = 'R' AND {FN TIMESTAMPADD (SQL_TSI_DAY, f.datafluxo-72687, {D '2000-01-01'})} BETWEEN {TS :inicio} AND {TS :fim}")
sourceInadimplencia.parameters<<TypedParameter.new(name: 'inicio', datatype:'timestamp' , value:"2000-01-01 00:00:00")
sourceInadimplencia.parameters<<TypedParameter.new(name: 'fim', datatype:'timestamp' , value:"2014-12-30 00:00:00")
sourceInadimplencia.save
# novos contratos
sourceNovosContratos = Query.new(name: 'Novos Contratos', statement: "SELECT COUNT(*) AS \"CONTRATOS_PERIODO\" FROM zw14vped p WHERE p.situacao IN(:situacoes) AND {FN TIMESTAMPADD (SQL_TSI_DAY, p.dataemiss-72687, {D '2000-01-01'})} BETWEEN {TS :inicio} AND {TS :fim}")
sourceNovosContratos.parameters<<TypedParameter.new(name: 'inicio', datatype:'timestamp' , value:"2000-01-01 00:00:00")
sourceNovosContratos.parameters<<TypedParameter.new(name: 'fim', datatype:'timestamp' , value:"2014-12-30 00:00:00")
sourceNovosContratos.parameters<<TypedParameter.new(name: 'situacoes', datatype:'varchar' , value:"'LOC Locado', 'LOC Finalizado', 'LOC Cancelado'")
sourceNovosContratos.save
# contratos ativos
sourceContratosAtivos = Query.new(name: 'Contratos Ativos', statement: "SELECT COUNT(*) AS \"CONTRATOS_PERIODO\" FROM zw14vped p WHERE p.situacao IN(:situacao) AND {FN TIMESTAMPADD (SQL_TSI_DAY, p.dataemiss-72687, {D '2000-01-01'})} < {TS :fim} AND p.dataemiss <> 0")
sourceContratosAtivos.parameters<<TypedParameter.new(name: 'inicio', datatype:'timestamp' , value:"2000-01-01 00:00:00")
sourceContratosAtivos.parameters<<TypedParameter.new(name: 'fim', datatype:'timestamp' , value:"2014-12-30 00:00:00")
sourceContratosAtivos.parameters<<TypedParameter.new(name: 'situacao', datatype:'varchar' , value:"'LOC Locado'")
sourceContratosAtivos.save
# novos contratos dia
sourceNovosContratosDia = Query.new(name: 'Novos Contratos Dia', statement: "SELECT {FN CONVERT({FN TIMESTAMPADD (SQL_TSI_DAY, p.dataemiss-72687, {D '2000-01-01'})},SQL_DATE)} AS \"DATA_EMISSAO\", count(*) AS \"QUANTIDADE\" FROM zw14vped p WHERE  p.situacao IN (:situacoes)  AND {FN TIMESTAMPADD (SQL_TSI_DAY, p.dataemiss-72687, {D '2000-01-01'})}   BETWEEN {TS :inicio} AND {TS :fim} GROUP BY  p.dataemiss  ORDER BY  p.dataemiss DESC")
sourceNovosContratosDia.parameters<<TypedParameter.new(name: 'inicio', datatype:'timestamp' , value:"2000-01-01 00:00:00")
sourceNovosContratosDia.parameters<<TypedParameter.new(name: 'fim', datatype:'timestamp' , value:"2014-12-30 00:00:00")
sourceNovosContratosDia.parameters<<TypedParameter.new(name: 'situacoes', datatype:'varchar' , value:"'LOC Locado', 'LOC Finalizado', 'LOC Cancelado'")
sourceNovosContratosDia.save
# pedidos por situacao
sourcePedidosPorSituacao = Query.new(name: 'Pedidos por situacao', statement: "SELECT p.situacao AS \"SITUACAO\", count(*) AS \"QUANTIDADE\" FROM  zw14vped p WHERE p.situacao IS NOT NULL AND {FN TIMESTAMPADD (SQL_TSI_DAY, p.dataemiss-72687, {D '2000-01-01'})} BETWEEN {TS :inicio} AND {TS :fim} GROUP BY   p.situacao")
sourcePedidosPorSituacao.parameters<<TypedParameter.new(name: 'inicio', datatype:'timestamp' , value:"2014-10-30 00:00:00")
sourcePedidosPorSituacao.parameters<<TypedParameter.new(name: 'fim', datatype:'timestamp' , value:"2014-11-30 00:00:00")
sourcePedidosPorSituacao.parameters<<TypedParameter.new(name: 'situacao', datatype:'varchar' , value:"'LOC Locado'")
sourcePedidosPorSituacao.save
# clientes mais locaram
sourceClientesMaisLocaram = Query.new(name: 'Clientes Mais Locaram', statement: "SELECT V.NOMECLIENTE AS \"CLIENTE\", {FN CONVERT({FN ROUND(SUM(V.VALORTOTALGERAL),2)},SQL_FLOAT)} AS \"TOTAL\" FROM ZW14VPED V WHERE V.SITUACAO = :situacao AND {FN TIMESTAMPADD (SQL_TSI_DAY, V.DATAEMISS-72687, {D '2000-01-01'})} BETWEEN {TS :inicio} AND {TS :fim} GROUP BY V.NOMECLIENTE ORDER BY 1")
sourceClientesMaisLocaram.parameters<<TypedParameter.new(name: 'inicio', datatype:'timestamp' , value:"2000-01-01 00:00:00")
sourceClientesMaisLocaram.parameters<<TypedParameter.new(name: 'fim', datatype:'timestamp' , value:"2014-12-30 00:00:00")
sourceClientesMaisLocaram.parameters<<TypedParameter.new(name: 'situacao', datatype:'varchar' , value:"'LOC Locado'")
sourceClientesMaisLocaram.save



## Indicators
indicatorFaturamento = Indicator.create(unity: dinheiro, name: 'Faturamento', description: "popover", source: sourceFaturamento)
indicatorInadimplencia = Indicator.create(unity: porcentagem, name: 'Porcentagem', description: "valorInadimplencia", source: sourceInadimplencia)
indicatorNovosContratos = Indicator.create(name: 'Novos Contratos', description: "novosContratos", source: sourceNovosContratos)
indicatorContratosAtivos = Indicator.create(name: 'Contratos Ativos', description: "contratosAtivos", source: sourceContratosAtivos)
indicatorNovosContratosDia = Indicator.create(name: 'Contratos Ativos Dia', description: "novosContratosDia", source: sourceNovosContratosDia)
indicatorPedidosPorSituacao = Indicator.create(name: 'Pedidos por situação', description: "pedidosPorSituacao", source: sourcePedidosPorSituacao)
indicatorClientesMaisLocaram = Indicator.create(name: 'Faturamento por Cliente', description: "clientesMaisLocaram", source: sourceClientesMaisLocaram)


## Widgets
Widget.create(name:'Faturamento', description:'Faturamento', widget_type: status, color: 'green', position:2 , size:3, dashboard: dash, indicator: indicatorFaturamento)
Widget.create(name:'Inadimplencia', description:'Inadimplencia', widget_type: status, color: 'red', position:3 , size:3, dashboard: dash, indicator: indicatorInadimplencia)
Widget.create(name:'Novos Contratos', description:'Novos Contratos', widget_type: status, color: 'blue', position:1 , size:3, dashboard: dash, indicator: indicatorNovosContratos)
Widget.create(name:'Contratos Ativos', description:'Contratos Ativos', widget_type: status, color: 'orange', position:0 , size:3, dashboard: dash, indicator: indicatorContratosAtivos)
Widget.create(name:'Novos Contratos Dia', description:'Novos Contratos Dia', widget_type: line, color: 'blue', position:4 , size:12, dashboard: dash, indicator: indicatorNovosContratosDia)
Widget.create(name:'Pedidos por Situacao', description:'Pedidos por Situacao', widget_type: pie, position:6 , size:4, dashboard: dash, indicator: indicatorPedidosPorSituacao)
Widget.create(name:'Clientes Mais Locaram', description:'Clientes Mais Locaram', widget_type: pie, color: 'blue', position:5 , size:4, dashboard: dash, indicator: indicatorClientesMaisLocaram)


## Data Sources
localhost = DataSourceServer.create(url: "http://localhost:3000/api", name:'localhost', description: 'localhost', alive: true)


## Users and Permissions
admin = User.create!(username:"admin", password:"admin", email:"zeta@zeta.com.br", token: '4361a34b6472e4634cd27f8d3f37108e', admin: true)
user = User.create!(username:"user", password:"user", email:"zeta@zeta.com.br", token: 'user', admin: false)
Permission.create(dashboard: dash, data_source_server: localhost, user: admin)


## Aggregations
functions = Function.create([
  {
    name: "execute",
    parameters_attributes: [
      {type: "Parameter", name: "statement"}
    ]
  },
  {
    name: "inject",
    parameters_attributes: [
      {type: "Parameter", name: "from"},
      {type: "Parameter", name: "into"}
    ]
  }
])

source = Aggregation.new(name: 'Inadimplência')
query = Query.new(name: 'Faturamento', statement: "SELECT SUM(f.valorfluxo) AS \"VALOR_TOTAL_RECEITA\" FROM zw14fflu f WHERE f.modalidade IN ('P','R') AND f.estimativa = 'C' AND f.pagarreceber = 'R' AND {FN TIMESTAMPADD (SQL_TSI_DAY, f.datalancamento-72687, {D '2000-01-01'})} BETWEEN {TS :inicio} AND {TS :fim}")
query.parameters<<TypedParameter.new(name: 'inicio', datatype:'timestamp' , value:"2000-01-01 00:00:00")
query.parameters<<TypedParameter.new(name: 'fim', datatype:'timestamp' , value:"2014-12-30 00:00:00")
source.sources << query
query = Query.new(name: 'Faturamento', statement: "SELECT SUM(f.valorfluxo) AS \"VALOR_TOTAL_RECEITA\" FROM zw14fflu f WHERE f.modalidade IN ('P','R') AND f.estimativa = 'C' AND f.pagarreceber = 'R' AND {FN TIMESTAMPADD (SQL_TSI_DAY, f.datalancamento-72687, {D '2000-01-01'})} BETWEEN {TS :inicio} AND {TS :fim}")
query.parameters<<TypedParameter.new(name: 'inicio', datatype:'timestamp' , value:"2000-01-01 00:00:00")
query.parameters<<TypedParameter.new(name: 'fim', datatype:'timestamp' , value:"2014-12-30 00:00:00")

source.sources << query

execution = Execution.new(function: functions[0])
execution.parameters << ValuedParameter.new(name: 'statement', value:"Faturamento")
source.executions << execution

source.save
