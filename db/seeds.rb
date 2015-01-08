#encoding: utf-8

## Widget Types
pie    = WidgetType.create(name:'pie')
status = WidgetType.create(name:'status')
line   = WidgetType.create(name:'line')

## Unities
dinheiro = Unity.create(name: 'Dinheiro', symbol: 'R$')
porcentagem = Unity.create(name: 'Porcentagem', symbol: '%')

## Dashboards
dashboards = Dashboard.create([
  #dashboards[0]
  {
    name: 'Dashboard', 
    description: 'Dash description'
  },
  #dashboards[1]
  {
    name: 'Dashboard 2', 
    description: 'Dash 2 description'
  }
])

## Sources
queries = Query.create([
  #queries[0] - faturamento
  {
    code: "valor_faturamento",
    name: 'Faturamento', 
    statement: "SELECT SUM(f.valorfluxo) AS \"VALOR_TOTAL_RECEITA\" FROM zw14fflu f WHERE f.modalidade IN ('P','R') AND f.estimativa = 'C' AND f.pagarreceber = 'R' AND {FN TIMESTAMPADD (SQL_TSI_DAY, f.datalancamento-72687, {D '2000-01-01'})} BETWEEN {TS :inicio} AND {TS :fim}",
    parameters_attributes: [
      {
        name: 'inicio', datatype:'timestamp' , value:"2000-01-01 00:00:00"
      },
      {
        name: 'fim', datatype:'timestamp' , value:"2014-12-30 00:00:00"
      }
    ]
  },
  #queries[1] - inadimplencia
  {
    code: "valor_inadimplencia",
    name: 'Valor Inadimplencia', 
    statement: "SELECT SUM(f.valorfluxo) AS \"VALOR_INADIMPLENCIA\" FROM zw14fflu f WHERE f.modalidade = 'P' AND f.estimativa = 'C' AND f.pagarreceber = 'R' AND {FN TIMESTAMPADD (SQL_TSI_DAY, f.datafluxo-72687, {D '2000-01-01'})} BETWEEN {TS :inicio} AND {TS :fim}",
    parameters_attributes: [
      {
        name: 'inicio', datatype:'timestamp' , value:"2000-01-01 00:00:00"
      },
      {
        name: 'fim', datatype:'timestamp' , value:"2014-12-30 00:00:00"
      }
    ]
  },
  #queries[2] - novos contratos
  {
    name: 'Novos Contratos', 
    statement: "SELECT COUNT(*) AS \"CONTRATOS_PERIODO\" FROM zw14vped p WHERE p.situacao IN(:situacoes) AND {FN TIMESTAMPADD (SQL_TSI_DAY, p.dataemiss-72687, {D '2000-01-01'})} BETWEEN {TS :inicio} AND {TS :fim}",
    parameters_attributes: [
      {
        name: 'inicio', datatype:'timestamp' , value:"2000-01-01 00:00:00"
      },
      {
        name: 'fim', datatype:'timestamp' , value:"2014-12-30 00:00:00"
      },
      {
        name: 'situacoes', datatype:'varchar' , value:"'LOC Locado', 'LOC Finalizado', 'LOC Cancelado'"
      }
    ]
  },
  #queries[3] - contratos ativos
  {
    name: 'Contratos Ativos', 
    statement: "SELECT COUNT(*) AS \"CONTRATOS_PERIODO\" FROM zw14vped p WHERE p.situacao IN(:situacao) AND {FN TIMESTAMPADD (SQL_TSI_DAY, p.dataemiss-72687, {D '2000-01-01'})} < {TS :fim} AND p.dataemiss <> 0",
    parameters_attributes: [
      {
        name: 'inicio', datatype:'timestamp' , value:"2000-01-01 00:00:00"
      },
      {
        name: 'fim', datatype:'timestamp' , value:"2014-12-30 00:00:00"
      },
      {
        name: 'situacao', datatype:'varchar' , value:"'LOC Locado'"
      }
    ]
  },
  #queries[4] - novos contratos dia
  {
    name: 'Novos Contratos Dia', 
    statement: "SELECT {FN CONVERT({FN TIMESTAMPADD (SQL_TSI_DAY, p.dataemiss-72687, {D '2000-01-01'})},SQL_DATE)} AS \"DATA_EMISSAO\", count(*) AS \"QUANTIDADE\" FROM zw14vped p WHERE  p.situacao IN (:situacoes)  AND {FN TIMESTAMPADD (SQL_TSI_DAY, p.dataemiss-72687, {D '2000-01-01'})}   BETWEEN {TS :inicio} AND {TS :fim} GROUP BY  p.dataemiss  ORDER BY  p.dataemiss DESC",    
    parameters_attributes: [
      {
        name: 'inicio', datatype:'timestamp' , value:"2000-01-01 00:00:00"
      },
      {
        name: 'fim', datatype:'timestamp' , value:"2014-12-30 00:00:00"
      },
      {
        name: 'situacoes', datatype:'varchar' , value:"'LOC Locado', 'LOC Finalizado', 'LOC Cancelado'"
      }
    ]
  },
  #queries[5] - pedidos por situacao
  {
    name: 'Pedidos por situacao', 
    statement: "SELECT p.situacao AS \"SITUACAO\", count(*) AS \"QUANTIDADE\" FROM  zw14vped p WHERE p.situacao IS NOT NULL AND {FN TIMESTAMPADD (SQL_TSI_DAY, p.dataemiss-72687, {D '2000-01-01'})} BETWEEN {TS :inicio} AND {TS :fim} GROUP BY   p.situacao",
    parameters_attributes: [
      {
        name: 'inicio', datatype:'timestamp' , value:"2014-10-30 00:00:00"
      },
      {
        name: 'fim', datatype:'timestamp' , value:"2014-11-30 00:00:00"
      },
      {
        name: 'situacao', datatype:'varchar' , value:"'LOC Locado'"
      }
    ]
  },
  #queries[6] - clientes mais locaram
  {
    name: 'Clientes Mais Locaram', 
    statement: "SELECT V.NOMECLIENTE AS \"CLIENTE\", {FN CONVERT({FN ROUND(SUM(V.VALORTOTALGERAL),2)},SQL_FLOAT)} AS \"TOTAL\" FROM ZW14VPED V WHERE V.SITUACAO = :situacao AND {FN TIMESTAMPADD (SQL_TSI_DAY, V.DATAEMISS-72687, {D '2000-01-01'})} BETWEEN {TS :inicio} AND {TS :fim} GROUP BY V.NOMECLIENTE ORDER BY 1",
    parameters_attributes: [
      {
        name: 'inicio', datatype:'timestamp' , value:"2000-01-01 00:00:00"
      },
      {
        name: 'fim', datatype:'timestamp' , value:"2014-12-30 00:00:00"
      },
      {
        name: 'situacao', datatype:'varchar' , value:"'LOC Locado'"
      }
    ]
  }
])


indicators = Indicator.create([
  #indicators[0] - indicatorFaturamento
  {
    unity: dinheiro, 
    name: 'Faturamento', 
    description: "popover", 
    source: queries[0]
  },
  #indicators[1] - indicatorInadimplencia
  {
    unity: porcentagem, 
    name: 'Porcentagem', 
    description: "valorInadimplencia", 
    source: queries[1]
  },
  #indicators[2] - indicatorNovosContratos
  {
    name: 'Novos Contratos', 
    description: "novosContratos", 
    source: queries[2]
  },
  #indicators[3] - indicatorContratosAtivos
  {
    name: 'Contratos Ativos', 
    description: "contratosAtivos", 
    source: queries[3]
  },
  #indicators[4] - indicatorNovosContratosDia 
  {
    name: 'Contratos Ativos Dia', 
    description: "novosContratosDia", 
    source: queries[4]
  },
  #indicators[5] - indicatorPedidosPorSituacao
  {
    name: 'Pedidos por situação', 
    description: "pedidosPorSituacao", 
    source: queries[5]
  },
  #indicators[6] - indicatorClientesMaisLocaram
  {
    name: 'Faturamento por Cliente', 
    description: "clientesMaisLocaram", 
    source: queries[6]
  }
])

Widget.create([
  {
    name:'Faturamento', 
    description:'Faturamento', 
    widget_type: status, 
    color: 'green', 
    position:2 , 
    size:3, 
    dashboard: dashboards[0], 
    indicator: indicators[0]
  },
  {
    name:'Inadimplencia', 
    description:'Inadimplencia', 
    widget_type: status, 
    color: 'red', 
    position:3 , 
    size:3, 
    dashboard: dashboards[0], 
    indicator: indicators[1]
  },
  {
    name:'Novos Contratos', 
    description:'Novos Contratos', 
    widget_type: status, 
    color: 'blue', 
    position:1 , 
    size:3, 
    dashboard: dashboards[0], 
    indicator: indicators[2]
  },
  {
    name:'Contratos Ativos', 
    description:'Contratos Ativos', 
    widget_type: status, 
    color: 'orange', 
    position:0 , 
    size:3, 
    dashboard: dashboards[0], 
    indicator: indicators[3]
  },
  {
    name:'Novos Contratos Dia', 
    description:'Novos Contratos Dia', 
    widget_type: line, 
    color: 'blue', 
    position:4 , 
    size:12, 
    dashboard: dashboards[0], 
    indicator: indicators[4]
  },
  {
    name:'Pedidos por Situacao', 
    description:'Pedidos por Situacao', 
    widget_type: pie, 
    position:6 , 
    size:4, 
    dashboard: dashboards[0], 
    indicator: indicators[5]    
  },
  {
    name:'Clientes Mais Locaram', 
    description:'Clientes Mais Locaram', 
    widget_type: pie, 
    color: 'blue', 
    position:5 , 
    size:4, 
    dashboard: dashboards[0], 
    indicator: indicators[6]
  }
])

datasources = DataSourceServer.create([
  # datasources[0]
  {
    url: "http://localhost:3000/api", 
    name:'localhost', 
    description: 'localhost', 
    alive: true
  }
])

users = User.create!([
  # users[0] - admin
  {
    username:"admin", 
    password:"admin", 
    email:"zeta@zeta.com.br", 
    token: '4361a34b6472e4634cd27f8d3f37108e', 
    admin: true
  },
  # users[1] - user
  {
    username:"user", 
    password:"user", 
    email:"zeta@zeta.com.br", 
    token: 'user', 
    admin: false
  }
])

Permission.create([
  {
    dashboard: dashboards[0], 
    data_source_server: datasources[0], 
    user: users[0]
  }
])

# Aggregations
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

Aggregation.create({
  code: "percentual_inadimplencia",
  name: "Percentual de Inadimplência",
  description: "Realiza o cálculo do percentual de inadimplência dividindo o valor do faturamento pelo valor da inadimplência no período.",
  parameters_attributes: [
    {
      name: "inicio",
      value: "Time.now.begginig_of_month",
      datatype: "timestamp",
      evaluated: true
    },
    {
      name: "fim",
      value: "Time.now.end_of_month",
      datatype: "timestamp",
      evaluated: true
    }
  ],
  aggregated_sources_attributes:[
    { source: queries[0] },
    { source: queries[1] }
  ],
  executions_attributes:[
    {
      function: functions[0],
      parameters_attributes:[
        {
          name: "statement",
          value: "inadimplencia",
        }
      ]
    },
    {
      function: functions[1],
      parameters_attributes:[
        {
          name: "from",
          value: "?",
        },
         {
          name: "into",
          value: "?",
        }
      ]
    },
    {
      function: functions[0],
      parameters_attributes:[
        {
          name: "statement",
          value: "inadimplencia",
        }
      ]
    }
  ],
  result: "valor_inadimplencia.rows",
})