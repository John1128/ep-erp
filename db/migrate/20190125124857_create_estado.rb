class CreateEstado < ActiveRecord::Migration[5.2]
  def change
    create_table :estados do |t|
      t.string :nombre
    end
  end
end
