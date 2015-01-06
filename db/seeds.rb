#encoding: utf-8
dash   = Dashboard.create(name: 'Dashboard', description: 'Dash description')
status = WidgetType.create(name:'status')
unity = Unity.create(name: 'Dinheiro', symbol: 'R$')
source = Query.create(name: 'Faturamento', statement: "SELECT SUM(f.valorfluxo) AS \"VALOR_TOTAL_RECEITA\" FROM zw14fflu f WHERE f.modalidade IN ('P','R') AND f.estimativa = 'C' AND f.pagarreceber = 'R' AND {FN TIMESTAMPADD (SQL_TSI_DAY, f.datalancamento-72687, {D '2000-01-01'})} BETWEEN {TS :inicio} AND {TS :fim}")

indicator = Indicator.new(unity: unity, name: 'Faturamento', description: "popover", source: source)
indicator.parameters<<TypedParameter.new(name: 'inicio', datatype:'timestamp' , value:"2000-01-01 00:00:00")
indicator.parameters<<TypedParameter.new(name: 'fim', datatype:'timestamp' , value:"2014-12-30 00:00:00")
indicator.save

Widget.create(name:'Faturamento', description:'Faturamento', widget_type: status, color: 'green', position:2 , size:3, dashboard: dash, indicator: indicator)

user = User.create!(username:"admin", password:"admin", email:"zeta@zeta.com.br", token: '4361a34b6472e4634cd27f8d3f37108e', admin: true)
localhost = DataSourceServer.create(url: "http://localhost:3000/api", name:'localhost', description: 'localhost')
Permission.create(dashboard: dash, data_source_server: localhost, user: user)