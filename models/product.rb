class Product < ActiveRecord::Base
  has_many :order_items
  has_many :orders, through: :order_items

  validates_presence_of :name, :price

  def self.ordered
    order(:name)
  end

  def self.search(query)
    query = query.downcase
    where('identifier LIKE ? OR lower(name) LIKE ? OR lower(name) LIKE ?', "#{query}", "%#{query} %", "%#{query}%")
  end

  def to_s
    name
  end

  def price_f(options = {})
    return nil unless price
    options[:currency] ? ("CHF %.2f" % price) : ('%.2f' % price)
  end

  def as_json(options)
    super.merge(price_f: price_f)
  end

  def self.categories
    @categories ||= CATEGORIES
  end

  def self.products
    @products ||= [
      product.new('Fruchtschalen', :schalen_koerbe, 'fruchtschalen.jpg'),
      product.new('Spankörbe mit Henkel', :schalen_koerbe, 'korb_henkel.jpg'),
      product.new('Spankörbe ohne Henkel', :schalen_koerbe, 'korb.jpg'),
      product.new('Geschenkkörbe', :schalen_koerbe, 'geschenkkorb.jpg'),
      product.new('Eierverpackungen', :schalen_koerbe, 'eierverpackungen.png'),


      product.new('Früchtebeutel', :taschen_beutel, 'fruechtebeutel_einzeln.jpg'),
      product.new('Knotenbeutel', :taschen_beutel, 'knotenbeutel.jpg'),
      product.new('Früchte-Tragtaschen', :taschen_beutel, 'fruechte_tragtaschen.jpg'),
      product.new('Papiertragtaschen', :taschen_beutel, 'papiertragtaschen.jpg'),
      product.new('Brotpapiersäcke', :taschen_beutel, 'brotpapiersack.jpg'),
      product.new('Vakuumbeutel', :taschen_beutel, 'vakuumbeutel.jpg'),
      product.new('Frischhaltebeutel', :taschen_beutel, 'frischhaltebeutel.jpg'),
      product.new('Geschenktaschen', :taschen_beutel, 'geschenktasche.jpg'),

      product.new('Konfitüregläser', :glaswaren, 'konfituereglaeser.png'),
      product.new('Sirupflaschen', :glaswaren, 'sirupflaschen.png'),
      product.new('Likörflaschen', :glaswaren, 'likoerflaschen.png'),
      product.new('Spirituoseflaschen', :glaswaren, 'spirituosenflaschen.png'),
      product.new('Konfitueredeckel Schwarz', :glaswaren, 'schraubdeckel_schwarz.png'),
      product.new('Konfitueredeckel Schwarz', :glaswaren, 'schraubdeckel_weiss.png'),
      product.new('Sirupdeckel', :glaswaren, 'deckel_sirupflaschen.png'),
      product.new('Korkzapfen', :glaswaren, 'korkzapfen.png'),
      product.new('Verschluss Spirituosenflaschen', :glaswaren, 'verschluss_spirituosen.png'),

      product.new('Schilder', :beschriftungen, 'beschriftungen_schilder.jpg'),
      product.new('Beschriftungsmaterial', :beschriftungen, 'beschriftungsmaterial.jpg'),

      product.new('Etiketten "Vom Hof"', :diverses, 'etiketten_vom_hof.jpg'),
      product.new('Etiketten "Hausgemacht"', :diverses, 'siegeletiketten_hausgemacht.jpg'),
      product.new('Klebeband', :diverses, 'klebeband.jpg'),
      product.new('Quittierblöcke', :diverses, 'quittierblock.jpg'),
      product.new('Wickelpapiere', :diverses, 'wickelpapier.jpg'),
      product.new('Petflasche', :diverses, 'petflasche.png'),
      product.new('Deckel Petflasche', :diverses, 'deckel_petflasche.png'),
      product.new('Ersatzbeutel Most', :diverses, 'mostbeutel.png'),
    ]
  end

  def self.product
    @product ||= Struct.new(:name, :category, :photo, :variants)
  end
end
