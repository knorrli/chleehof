class Product < ActiveRecord::Base
  CATEGORIES = {
    schalen_koerbe: { name: 'Schalen & Körbe', id: 'schalen_koerbe', path: '1_schalen_und_koerbe' },
    beutel: { name: 'Beutel', id: 'beutel', path: '2_beutel' },
    taschen: { name: 'Taschen', id: 'taschen', path: '3_taschen' },
    glaswaren: { name: 'Glaswaren', id: 'glaswaren', path: '4_glaswaren' },
    beschriftungen: { name: 'Beschriftungen', id: 'Beschriftungen', path: '5_beschriftungen' },
    diverses: { name: 'Diverses', id: 'diverses', path: '6_diverses' }
  }
  has_many :order_items
  has_many :orders, through: :order_items

  has_one :photo
  accepts_nested_attributes_for :photo

  validates_presence_of :name, :price, :photo

  def self.ordered
    order(:created_at)
  end

  def self.categories
    @categories ||= CATEGORIES
  end

  def self.products
    @products ||= [
      product.new('Fruchtkorb mit Henkel', :schalen_koerbe, 'fruchtschalen.jpg'),
      product.new('Eierverpackungen', :schalen_koerbe, 'eierverpackungen.jpg'),

      product.new('Früchtebeutel', :beutel, 'fruechtebeutel_einzeln.jpg'),
      product.new('Knotenbeutel', :beutel, 'knotenbeutel.jpg'),
      product.new('Brotpapiersäcke', :beutel, 'brotpapiersack.jpg'),
      product.new('Frischhaltebeutel', :beutel, 'frischhaltebeutel.jpg'),
      product.new('Vakuumbeutel', :beutel, 'vakuumbeutel.jpg'),

      product.new('Knotenbeutel', :taschen, 'knotenbeutel.jpg'),
      product.new('Früchte-Tragtaschen', :taschen, 'fruechte_tragtaschen.jpg'),
      product.new('Papiertragtaschen', :taschen, 'papiertragtaschen.jpg'),

      product.new('Konfitüregläser', :glaswaren, 'glaswaren.jpg'),
      product.new('Sirupflaschen', :glaswaren, 'glaswaren.jpg'),
      product.new('Likörlaschen', :glaswaren, 'glaswaren.jpg'),

      product.new('Schilder', :beschriftungen, 'beschriftungen_schilder.jpg'),
      product.new('Beschriftungsmaterial', :beschriftungen, 'beschriftungsmaterial.jpg'),
      product.new('Etiketten "Vom Hof"', :beschriftungen, 'etiketten_vom_hof.jpg'),
      product.new('Siegeletiketten "Hausgemacht"', :beschriftungen, 'siegeletiketten_hausgemacht.jpg'),

      product.new('Klebeband', :diverses, 'klebeband.jpg'),
      product.new('Quittierblock', :diverses, 'quittierblock.jpg'),
      product.new('Wickelpapier', :diverses, 'wickelpapier.jpg'),
      product.new('Verpackung Most', :diverses, 'most_bag_in_box.jpg')
    ]
  end

  def self.product
    @product ||= Struct.new(:name, :category, :photo)
  end

  def to_s
    name
  end
end
