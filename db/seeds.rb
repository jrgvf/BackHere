# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

StatusType.create(code: :undefined,          label: "Não definido")
StatusType.create(code: :new_order,          label: "Novo Pedido")
StatusType.create(code: :awaiting_payment,   label: "Aguardando Pagamento")
StatusType.create(code: :payment_declined,   label: "Pagamento Recusado")
StatusType.create(code: :payment_approved,   label: "Pagamento Aprovado")
StatusType.create(code: :shipped_order,      label: "Enviado ao cliente")
StatusType.create(code: :delivered_order,    label: "Entregue ao cliente")
StatusType.create(code: :strayed_order,      label: "Extraviado após o envio")
StatusType.create(code: :returned_order,     label: "Devolvido pelo cliente")
StatusType.create(code: :cancelled_order,    label: "Cancelado")
StatusType.create(code: :finalized_order,    label: "Finalizado")