class CreateFormaPago < ActiveRecord::Migration[5.2]
  def change
    create_table :forma_pagos do |t|
      t.string :descripcion
      t.string :codigo_sat
      t.timestamps
    end
  end
end
