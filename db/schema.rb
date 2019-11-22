# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_11_21_170549) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "clave_unidads", force: :cascade do |t|
    t.string "nombre"
    t.string "clave"
    t.string "codigo_sat"
    t.string "simbolo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "clientes", force: :cascade do |t|
    t.string "rfc"
    t.string "razon_social"
    t.string "telefono"
    t.string "email"
    t.bigint "municipio_id"
    t.string "colonia"
    t.string "codigo_postal"
    t.string "calle"
    t.string "numero_interior"
    t.string "numero_exterior"
    t.string "localidad"
    t.string "referencia"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "pais_id"
    t.index ["municipio_id"], name: "index_clientes_on_municipio_id"
    t.index ["pais_id"], name: "index_clientes_on_pais_id"
  end

  create_table "concepto_impuestos", force: :cascade do |t|
    t.bigint "concepto_id"
    t.bigint "tipo_impuesto_id"
    t.float "base"
    t.bigint "impuesto_id"
    t.bigint "tipo_factor_id"
    t.float "tasa_cuota"
    t.float "importe"
    t.index ["concepto_id"], name: "index_concepto_impuestos_on_concepto_id"
    t.index ["impuesto_id"], name: "index_concepto_impuestos_on_impuesto_id"
    t.index ["tipo_factor_id"], name: "index_concepto_impuestos_on_tipo_factor_id"
    t.index ["tipo_impuesto_id"], name: "index_concepto_impuestos_on_tipo_impuesto_id"
  end

  create_table "conceptos", force: :cascade do |t|
    t.bigint "factura_id"
    t.bigint "producto_id"
    t.bigint "clave_unidad_id"
    t.integer "cantidad"
    t.float "importe"
    t.float "descuento"
    t.float "valor_unitario"
    t.string "unidad_medida"
    t.string "identificacion"
    t.index ["clave_unidad_id"], name: "index_conceptos_on_clave_unidad_id"
    t.index ["factura_id"], name: "index_conceptos_on_factura_id"
    t.index ["producto_id"], name: "index_conceptos_on_producto_id"
  end

  create_table "emisors", force: :cascade do |t|
    t.string "rfc"
    t.string "razon_social"
    t.string "nombre_comercial"
    t.string "telefono"
    t.string "email"
    t.bigint "municipio_id"
    t.string "colonia"
    t.string "codigo_postal"
    t.string "calle"
    t.string "numero_interior"
    t.string "numero_exterior"
    t.string "localidad"
    t.string "referencia"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["municipio_id"], name: "index_emisors_on_municipio_id"
  end

  create_table "estados", force: :cascade do |t|
    t.string "nombre"
  end

  create_table "facturas", force: :cascade do |t|
    t.bigint "tipo_comprobante_id"
    t.bigint "emisor_id"
    t.bigint "cliente_id"
    t.integer "estatus"
    t.bigint "forma_pago_id"
    t.bigint "metodo_pago_id"
    t.string "nota"
    t.string "serie"
    t.string "folio"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "regimen_fiscal_id"
    t.bigint "uso_cfdi_id"
    t.bigint "tipo_relacion_id"
    t.bigint "moneda_id"
    t.float "total"
    t.float "subtotal"
    t.float "descuento"
    t.boolean "emisor_domicilio"
    t.boolean "receptor_domicilio"
    t.string "receptor_reg_trib"
    t.string "condicion_pago"
    t.string "notas_pie"
    t.boolean "cfdi_relacionado"
    t.string "folios_relacionados"
    t.string "uuid"
    t.string "pdf_url"
    t.string "xml_url"
    t.datetime "cancelada"
    t.string "justificacion"
    t.date "fecha_corte"
    t.index ["cliente_id"], name: "index_facturas_on_cliente_id"
    t.index ["emisor_id"], name: "index_facturas_on_emisor_id"
    t.index ["forma_pago_id"], name: "index_facturas_on_forma_pago_id"
    t.index ["metodo_pago_id"], name: "index_facturas_on_metodo_pago_id"
    t.index ["moneda_id"], name: "index_facturas_on_moneda_id"
    t.index ["regimen_fiscal_id"], name: "index_facturas_on_regimen_fiscal_id"
    t.index ["tipo_comprobante_id"], name: "index_facturas_on_tipo_comprobante_id"
    t.index ["tipo_relacion_id"], name: "index_facturas_on_tipo_relacion_id"
    t.index ["uso_cfdi_id"], name: "index_facturas_on_uso_cfdi_id"
  end

  create_table "forma_pagos", force: :cascade do |t|
    t.string "descripcion"
    t.string "codigo_sat"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "impuestos", force: :cascade do |t|
    t.string "descripcion"
    t.string "codigo_sat"
  end

  create_table "metodo_pagos", force: :cascade do |t|
    t.string "descripcion"
    t.string "codigo_sat"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "monedas", force: :cascade do |t|
    t.string "descripcion"
    t.string "codigo_sat"
  end

  create_table "municipios", force: :cascade do |t|
    t.string "nombre"
    t.bigint "estado_id"
    t.index ["estado_id"], name: "index_municipios_on_estado_id"
  end

  create_table "pais", force: :cascade do |t|
    t.string "nombre"
    t.string "codigo_sat"
  end

  create_table "productos", force: :cascade do |t|
    t.string "codigo_sat"
    t.string "descripcion"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "regimen_fiscals", force: :cascade do |t|
    t.string "descripcion"
    t.string "codigo_sat"
    t.boolean "fisica"
    t.boolean "moral"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tipo_comprobantes", force: :cascade do |t|
    t.string "descripcion"
    t.string "codigo_sat"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tipo_factors", force: :cascade do |t|
    t.string "descripcion"
  end

  create_table "tipo_impuestos", force: :cascade do |t|
    t.string "descripcion"
  end

  create_table "tipo_relacions", force: :cascade do |t|
    t.string "descripcion"
    t.string "codigo_sat"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.string "name"
    t.boolean "is_active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "uso_cfdis", force: :cascade do |t|
    t.string "descripcion"
    t.string "codigo_sat"
  end

end
