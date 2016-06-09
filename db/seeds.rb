# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

StatusType.find_or_create_by(code: :undefined,          label: "Não definido")
StatusType.find_or_create_by(code: :new_order,          label: "Novo Pedido")
StatusType.find_or_create_by(code: :awaiting_payment,   label: "Aguardando Pagamento")
StatusType.find_or_create_by(code: :payment_declined,   label: "Pagamento Recusado")
StatusType.find_or_create_by(code: :payment_approved,   label: "Pagamento Aprovado")
StatusType.find_or_create_by(code: :invoiced,           label: "Pedido Faturado")
StatusType.find_or_create_by(code: :shipped_order,      label: "Enviado ao cliente")
StatusType.find_or_create_by(code: :delivered_order,    label: "Entregue ao cliente")
StatusType.find_or_create_by(code: :strayed_order,      label: "Extraviado após o envio")
StatusType.find_or_create_by(code: :returned_order,     label: "Devolvido pelo cliente")
StatusType.find_or_create_by(code: :cancelled_order,    label: "Cancelado")
StatusType.find_or_create_by(code: :finalized_order,    label: "Finalizado")