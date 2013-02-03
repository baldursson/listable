ActiveRecord::Schema.define do
  self.verbose = false

  create_table :pages, :force => true do |t|
    t.string :title
    t.text :body
    t.timestamps
  end

  create_table :employees, :force => true do |t|
    t.string :first_name
    t.string :last_name
    t.text :biography
    t.timestamps
  end

  create_table :news_articles, :force => true do |t|
    t.string :headline
    t.text :body
    t.timestamps
  end

end