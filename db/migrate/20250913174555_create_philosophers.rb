class CreatePhilosophers < ActiveRecord::Migration[8.0]
  def change
    create_table :philosophers do |t|
      t.string :p_fname
      t.string :p_lname
      t.integer :birth_year
      t.integer :death_year
      t.text :biography

      t.timestamps
    end
  end
end
