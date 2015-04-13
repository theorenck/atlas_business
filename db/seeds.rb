#encoding: utf-8

## Widget Types
pie    = WidgetType.create(name:'pie')
status = WidgetType.create(name:'status')
line   = WidgetType.create(name:'line')

## Unities
dinheiro = Unity.create(name: 'Moeda', symbol: 'R$')
porcentagem = Unity.create(name: 'Porcentagem', symbol: '%')

## Dashboards
dashboards = Dashboard.create([
  #dashboards[0]
  {
    name: 'RM Locações',
    description: 'Dashboard da RM'
  },
  #dashboards[1]
  {
    name: 'Duetto',
    description: 'Dashboard da Duetto'
  }
])

## Sources
queries = Query.create([
  #queries[0] - faturamento
  {
    code: "rm_valor_faturamento",
    name: 'RM - Valor do Faturamento',
    statement: "SELECT SUM(f.valorfluxo) AS \"VALOR_TOTAL_RECEITA\"\nFROM zw14fflu f\nWHERE f.modalidade IN ('P',\n                       'R')\n  AND f.estimativa = 'C'\n  AND f.pagarreceber = 'R'\n  AND {FN TIMESTAMPADD (SQL_TSI_DAY, f.datalancamento-72687, {D '2000-01-01'})} BETWEEN :inicio AND :fim",
    parameters_attributes: [
      {
        name: 'inicio', datatype:'timestamp' , value: nil
      },
      {
        name: 'fim', datatype:'timestamp' , value: nil
      }
    ]
  },
  #queries[1] - inadimplencia
  {
    code: "rm_valor_inadimplencia",
    name: 'RM - Valor Inadimplência',
    statement: "SELECT SUM(f.valorfluxo) AS \"VALOR_INADIMPLENCIA\"\nFROM zw14fflu f\nWHERE f.modalidade = 'P'\n  AND f.estimativa = 'C'\n  AND f.pagarreceber = 'R'\n  AND {FN TIMESTAMPADD (SQL_TSI_DAY, f.datafluxo-72687, {D '2000-01-01'})} BETWEEN :inicio AND :fim",
    parameters_attributes: [
      {
        name: 'inicio', datatype:'timestamp' , value: 'Date.parse(:inicio) - 1.year' , evaluated: true
      },
      {
        name: 'fim', datatype:'timestamp' , value: ':inicio'
      }
    ]
  },
  #queries[2] - novos contratos
  {
    code: 'rm_novos_contratos',
    name: 'RM - Novos Contratos',
    statement: "SELECT COUNT(*) AS \"CONTRATOS_PERIODO\"\nFROM zw14vped p\nWHERE p.situacao IN(:situacoes)\n  AND {FN TIMESTAMPADD (SQL_TSI_DAY, p.dataemiss-72687, {D '2000-01-01'})} BETWEEN :inicio AND :fim",
    parameters_attributes: [
      {
        name: 'inicio', datatype:'timestamp' , value: nil
      },
      {
        name: 'fim', datatype:'timestamp' , value: nil
      },
      {
        name: 'situacoes', datatype:'integer' , value:"'LOC Locado','LOC Finalizado','LOC Cancelado'"
      }
    ]
  },
  #queries[3] - contratos ativos
  {
    code: 'rm_contratos_ativos',
    name: 'RM - Contratos Ativos',
    statement: "SELECT COUNT(*) AS \"CONTRATOS_PERIODO\" FROM zw14vped p WHERE p.situacao IN(:situacao) AND {FN TIMESTAMPADD (SQL_TSI_DAY, p.dataemiss-72687, {D '2000-01-01'})} < :fim AND p.dataemiss <> 0",
    parameters_attributes: [
      {
        name: 'inicio', datatype:'timestamp' , value: nil
      },
      {
        name: 'fim', datatype:'timestamp' , value: nil
      },
      {
        name: 'situacao', datatype:'varchar' , value:"LOC Locado"
      }
    ]
  },
  #queries[4] - novos contratos dia
  {
    code: 'rm_novos_contratos_dia',
    name: 'RM - Novos Contratos por Dia',
    statement: "SELECT {FN CONVERT({FN TIMESTAMPADD (SQL_TSI_DAY, p.dataemiss-72687, {D '2000-01-01'})},SQL_DATE)} AS \"DATA_EMISSAO\", count(*) AS \"QUANTIDADE\" FROM zw14vped p WHERE  p.situacao IN (:situacoes)  AND {FN TIMESTAMPADD (SQL_TSI_DAY, p.dataemiss-72687, {D '2000-01-01'})}   BETWEEN :inicio AND :fim GROUP BY  p.dataemiss  ORDER BY  p.dataemiss DESC",
    parameters_attributes: [
      {
        name: 'inicio', datatype:'timestamp' , value: nil
      },
      {
        name: 'fim', datatype:'timestamp' , value: nil
      },
      {
        name: 'situacoes', datatype:'integer' , value:"'LOC Locado', 'LOC Finalizado', 'LOC Cancelado'"
      }
    ]
  },
  #queries[5] - pedidos por situacao
  {
    code: 'rm_pedidos_por_situacao',
    name: 'RM - Pedidos por situação',
    statement: "SELECT p.situacao AS \"SITUACAO\", count(*) AS \"QUANTIDADE\" FROM  zw14vped p WHERE p.situacao IS NOT NULL AND {FN TIMESTAMPADD (SQL_TSI_DAY, p.dataemiss-72687, {D '2000-01-01'})} BETWEEN :inicio AND :fim GROUP BY p.situacao",
    parameters_attributes: [
      {
        name: 'inicio', datatype:'timestamp' , value: nil
      },
      {
        name: 'fim', datatype:'timestamp' , value: nil
      },
      {
        name: 'situacao', datatype:'varchar' , value:"LOC Locado"
      }
    ]
  },
  #queries[6] - faturamento por cliente
  {
    code: 'rm_faturamento_por_cliente',
    name: 'RM - Faturamento por cliente',
    statement: "SELECT V.NOMECLIENTE AS \"CLIENTE\", {FN CONVERT({FN ROUND(SUM(V.VALORTOTALGERAL),2)},SQL_FLOAT)} AS \"TOTAL\" FROM ZW14VPED V WHERE V.SITUACAO = :situacao AND {FN TIMESTAMPADD (SQL_TSI_DAY, V.DATAEMISS-72687, {D '2000-01-01'})} BETWEEN :inicio AND :fim GROUP BY V.NOMECLIENTE ORDER BY 1",
    parameters_attributes: [
      {
        name: 'inicio', datatype:'timestamp' , value: nil
      },
      {
        name: 'fim', datatype:'timestamp' , value: nil
      },
      {
        name: 'situacao', datatype:'varchar' , value: "LOC Locado"
      }
    ]
  },
  #queries[7] - valor total da receita
  {
    code: 'dt_faturamento',
    name: 'Duetto - Faturamento',
    statement: "SELECT SUM(f.valorfluxo) AS \"VALOR_TOTAL_RECEITA\"\nFROM zw20fflu f\nWHERE f.modalidade IN ('P','R')\n  AND f.estimativa = 'C'\n  AND f.pagarreceber = 'R'\n  AND (f.tipoorigem = 'S' OR f.tipodestino = 'S' )\n  AND {FN TIMESTAMPADD (SQL_TSI_DAY, f.datafluxo-72687, {D '2000-01-01'})} BETWEEN :inicio AND :fim",
    parameters_attributes: [
      {
        name: 'inicio', datatype:'timestamp' , value: nil
      },
      {
        name: 'fim', datatype:'timestamp' , value: nil
      },
    ]
  },
  #queries[8] - valor total do RH
  {
    code: 'dt_rh',
    name: 'Duetto - RH',
    statement: "SELECT SUM(f.valorfluxo) AS \"VALOR_TOTAL_RH\"\nFROM zw20fflu f\nWHERE f.modalidade IN ('P','R')\n  AND f.estimativa = 'C'\n  AND f.tipodestino = 'P'\n  AND {FN CONVERT(f.codigodestino, SQL_INTEGER)} IN (36,37,38,39,41,42,43,44,45,47,48,49,51,89,120,154,156,158,159,161,167,168,171,172,228,231,240,255,264,267,269,273)\n  AND {FN TIMESTAMPADD (SQL_TSI_DAY, f.competenciaorigem-72687, {D '2000-01-01'})}\n       BETWEEN :inicio AND :fim",
    parameters_attributes: [
      {
        name: 'inicio', datatype:'timestamp' , value: nil
      },
      {
        name: 'fim', datatype:'timestamp' , value: nil
      },
    ]
  },
  #queries[9] - RM - valor total receita para inadimplencia
  {
    code: 'rm_valor_total_receita_para_inadimplencia',
    name: 'RM - valor total receita para inadimplencia',
    statement: "SELECT SUM(f.valorfluxo) AS \"VALOR_TOTAL_RECEITA\"\nFROM zw14fflu f\nWHERE f.modalidade IN ('P',\n'R')\n  AND f.estimativa = 'C'\n  AND f.pagarreceber = 'R'\n  AND {FN TIMESTAMPADD (SQL_TSI_DAY, f.datalancamento-72687, {D '2000-01-01'})} BETWEEN :inicio AND :fim",
    parameters_attributes: [
      {
        name: 'inicio', datatype:'timestamp' , value: "Date.parse(:inicio) - 1.year", evaluated: true
      },
      {
        name: 'fim', datatype:'timestamp' , value: ":inicio"
      },
    ]
  },
  #queries[10] - valor da despesa total
  {
    code: 'dt_despesa_total',
    name: 'Duetto - Despesa Total',
    statement: "SELECT SUM(f.valorfluxo) AS \"VALOR_TOTAL_DESPESA\"\nFROM zw20fflu f\nWHERE f.modalidade IN ('P','R')\n  AND f.estimativa = 'C'\n  AND f.pagarreceber = 'P'\n  AND (f.tipoorigem = 'P' OR f.tipodestino = 'P' )\n  AND {FN TIMESTAMPADD (SQL_TSI_DAY, f.competenciaorigem-72687, {D '2000-01-01'})} BETWEEN :inicio AND :fim",
    parameters_attributes: [
      {
        name: 'inicio', datatype:'timestamp' , value: nil
      },
      {
        name: 'fim', datatype:'timestamp' , value: nil
      },
    ]
  },
  #queries[11] - valor total de impostos
  {
    code: 'dt_impostos',
    name: 'Duetto - Impostos',
    statement: "SELECT SUM(f.valorfluxo) AS \"VALOR_TOTAL_IMPOSTOS\"\nFROM zw20fflu f\nWHERE f.modalidade IN ('P','R')\n  AND f.estimativa = 'C'\n  AND f.tipodestino = 'S'\n  AND {FN CONVERT(f.codigodestino, SQL_INTEGER)} IN (53,56,57,58,59)\n  AND {FN TIMESTAMPADD (SQL_TSI_DAY, f.datafluxo-72687, {D '2000-01-01'})}\n      BETWEEN :inicio AND :fim",
    parameters_attributes: [
      {
        name: 'inicio', datatype:'timestamp' , value: nil
      },
      {
        name: 'fim', datatype:'timestamp' , value: nil
      },
    ]
  },
  #queries[12] - valor total ADM
  {
    code: 'dt_adm',
    name: 'Duetto - ADM',
    statement: "SELECT SUM(f.valorfluxo) AS \"VALOR_TOTAL_ADM\"\nFROM zw20fflu f\nWHERE f.modalidade IN ('P','R')\n  AND f.estimativa = 'C'\n  AND f.tipoorigem = 'P'\n  AND {FN CONVERT(f.codigoorigem, SQL_INTEGER)} = 137\n  AND {FN TIMESTAMPADD (SQL_TSI_DAY, f.competenciaorigem-72687, {D '2000-01-01'})}\n      BETWEEN :inicio AND :fim",
    parameters_attributes: [
      {
        name: 'inicio', datatype:'timestamp' , value: nil
      },
      {
        name: 'fim', datatype:'timestamp' , value: nil
      },
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
    name:'Inadimplência',
    description:'Inadimplência',
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
  },
  # datasources[1]
  {
    url: "http://zetainfo.dyndns.info:9010",
    name:'Dashboard',
    description: 'Dashboard Default',
    alive: true
  },
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
  },
  {
    dashboard: dashboards[0],
    data_source_server: datasources[1],
    user: users[0]
  }
])

# Aggregations
functions = Function.create!([
  {
    name: "execution",
    parameters_attributes: [
      {type: "ValuedParameter", name: "value", value: "value"}
    ]
  },
  {
    name: "script",
    parameters_attributes: [
      {type: "ValuedParameter", name: "value", value: "value"}
    ]
  }
])

Aggregation.create({
  code: "percentual_inadimplencia",
  name: "Percentual de Inadimplência",
  description: "Realiza o cálculo do percentual de inadimplência dividindo o valor do faturamento pelo valor da inadimplência no período.",
  aggregated_sources_attributes:[
    { source: queries[1] },
    { source: queries[9] }
  ],
  executions_attributes:[
    {
      order: "0",
      function: functions[0],
      parameters_attributes:[
        {
          type: "ValuedParameter",
          name: "value",
          value: "0"
        }
      ]
    },
    {
      order: "1",
      function: functions[0],
      parameters_attributes:[
        {
          type: "ValuedParameter",
          name: "value",
          value: "1"
        }
      ]
    },
    {
      order: "2",
      function: functions[1],
      parameters_attributes:[
        {
          type: "ValuedParameter",
          name: "value",
          value: "results[0][:resultset][:rows][0][0] = (results[0][:resultset][:rows][0][0] / results[1][:resultset][:rows][0][0]) * 100"
        }
      ]
    }
  ],
  result: "results[0]"
})