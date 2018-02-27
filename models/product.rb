class Product < ActiveRecord::Base
  CATEGORIES = {
    schalen_koerbe: { name: 'Schalen & Körbe', id: 'schalen_koerbe', path: '1_schalen_und_koerbe' },
    taschen_beutel: { name: 'Taschen & Beutel', id: 'taschen_beutel', path: '2_taschen_beutel' },
    glaswaren: { name: 'Glaswaren', id: 'glaswaren', path: '3_glaswaren' },
    beschriftungen: { name: 'Beschriftungen', id: 'Beschriftungen', path: '4_beschriftungen' },
    diverses: { name: 'Diverses', id: 'diverses', path: '5_diverses' }
  }
  has_many :order_items
  has_many :orders, through: :order_items

  validates_presence_of :name, :price

  def self.ordered
    order(:name)
  end

  def self.search(query)
    query = query.downcase
    where('lower(identifier) LIKE ? OR lower(name) LIKE ?', "#{query}%", "%#{query}%")
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
      product.new('Fruchtschalen', :schalen_koerbe, 'fruchtschalen.jpg', {
        'Fruchtschale weiss 3.5kg': 0.85,
        'Fruchtschale weiss 3.5kg, Bund à 20 Stk.': 17,

        'Fruchtschale weiss 2.5kg': 0.65,
        'Fruchtschale weiss 2.5kg, Bund à 20 Stk.': 13,

        'Fruchtkorb mit Henkel 1kg': 0.25,
        'Fruchtkorb mit Henkel 1kg, Bund à 25 Stk.': 6.25,

        'Fruchtschale ohne Henkel 1kg': 0.20,
        'Fruchtschale ohne Henkel 1kg, Karton à 250 Stk.': 50,

        'Fruchtschale ohne Henkel 500g': 0.15,
        'Fruchtschale ohne Henkel 500g, Karton à 330 Stk.': 49.50,

        'Fruchtschale ohne Henkel 250g': 0.13,
        'Fruchtschale ohne Henkel 250g, Karton à 560 Stk.': 72.80
      }),
      product.new('Spankörbe mit Henkel', :schalen_koerbe, 'korb_henkel.jpg', {
        "Spankorb mit Henkel 45 x 20 x 12 cm": 5.30,
        "Spankorb mit Henkel 37 x 14 x 11 cm": 3.90,
        "Spankorb mit Henkel 32 x 13 x 8 cm": 3.30,
        "Spankorb mit Henkel 17 x 9.5 x 6 cm": 2.70,
        "Spankorb mit Henkel 23 x 14 x 7.5 cm": 2.90
      }),
      product.new('Spankörbe ohne Henkel', :schalen_koerbe, 'korb.jpg', {
        "Spankorb ohne Henkel 35 x 28 x 8 cm": 4.30,
        "Spankorb ohne Henkel 35 x 18 x 8 cm": 3.70,
        "Spankorb ohne Henkel 35 x 11 x 8 cm": 3.30
      }),
      product.new('Geschenkkörbe', :schalen_koerbe, 'geschenkkorb.jpg', {
        "Geschenkkorb gross 48 x 40 x 15 cm": 19,
        "Geschenkkorb mittel 40 x 35 x 13 cm": 15,
        "Geschenkkorb gross 35 x 30 x 11 cm": 10,
      }),
      product.new('Eierverpackungen', :schalen_koerbe, 'eierverpackungen.jpg', {
        'Eierschachtel 10er neutral': 0.27,
        'Eierschachtel 10er neutral, Bund à 130 Stk.': 35.10,
        'Eierschachtel 6er neutral': 0.15,
        'Eierschachtel 6er neutral, Bund à 260 Stk.': 39,
        'Aufkleber für Eierschachtel 10er': 0.80,
        'Aufkleber für Eierschachtel 10er, Schachtel à 100 Bogen': 80,
        'Aufkleber für Eierschachtel 6er': 0.80,
        'Aufkleber für Eierschachtel 6er, Schachtel à 100 Bogen': 80,
      }),


      product.new('Früchtebeutel', :taschen_beutel, 'fruechtebeutel_einzeln.jpg', {
        'Früchtebeutel 2kg, 100 Stück': 13,
        'Früchtebeutel 2kg, Pack à 500 Stück': 65,

        'Früchtebeutel 1kg, 100 Stück': 10,
        'Früchtebeutel 1kg, Pack à 500 Stück': 50,
      }),
      product.new('Knotenbeutel', :taschen_beutel, 'knotenbeutel.jpg', {
        'Knotenbeutel weiss bedruckt, 100 Stk.': 2.80,
        'Knotenbeutel weiss bedruckt, Karton à 1000 Stk.': 28,
      }),
      product.new('Früchte-Tragtaschen', :taschen_beutel, 'fruechte_tragtaschen.jpg', {
        'Früchte-Tragtasche transparent 3kg, 100 Stk.': 22.50,
        'Früchte-Tragtasche transparent 3kg, Karton à 500 Stk.': 112.50
      }),
      product.new('Papiertragtaschen', :taschen_beutel, 'papiertragtaschen.jpg', {
        'Papiertragtasche weiss 10kg, 100 Stk.': 29,
        'Papiertragtasche weiss 10kg, Karton à 250 Stk.': 72.50,
        'Papiertragtasche weiss 5kg, 100 Stk.': 19.50,
        'Papiertragtasche weiss 5kg, Karton à 250 Stk.': 48.75,
        'Papiertragtasche weiss 3kg, 100 Stk.': 17.50,
        'Papiertragtasche weiss 3kg, Karton à 250 Stk.': 43.75,
        'Papiertragtasche braun 10kg, 100 Stk.': 27.40,
        'Papiertragtasche braun 10kg, Karton à 250 Stk.': 68.50,
        'Papiertragtasche braun 5kg, 100 Stk.': 19.00,
        'Papiertragtasche braun 5kg, Karton à 250 Stk.': 47.50,
        'Papiertragtasche braun 3kg, 100 Stk.': 17.00,
        'Papiertragtasche braun 3kg, Karton à 250 Stk.': 42.50
      }),
      product.new('Brotpapiersäcke', :taschen_beutel, 'brotpapiersack.jpg', {
        'Brotpapiersack gross mit Logo, Bund à 100 Stk.': 7.50,
        'Brotpapiersack gross mit Logo, Pack à 500 Stk.': 37.50,
        'Brotpapiersack klein mit Logo, Bund à 100 Stk.': 5,
        'Brotpapiersack klein mit Logo, Pack à 500 Stk.': 50
      }),
      product.new('Vakuumbeutel', :taschen_beutel, 'vakuumbeutel.jpg', {
        'Vakuumbeutel 25 x 35 cm, Pack à 50 Stk.': 17,
        'Vakuumbeutel 20 x 30 cm, Pack à 50 Stk.': 11.50,
        'Vakuumbeutel 16 x 25 cm, Pack à 50 Stk.': 9.50,
        'Vakuumbeutel 15 x 30 cm, Pack à 50 Stk.': 9.90,
        'Vakuumbeutel 10 x 30 cm, Pack à 50 Stk.': 9
      }),
      product.new('Frischhaltebeutel', :taschen_beutel, 'frischhaltebeutel.jpg', {
        'Frischhaltebeutel gross 18 x 30 cm, Bund à 100 Stk.': 16.20,
        'Frischhaltebeutel mittel 12.5 x 25 cm, Bund à 100 Stk.': 11.60,
        'Frischhaltebeutel klein 10 x 17.5 cm, Bund à 100 Stk.': 7.80,

        'Frischhaltebeutel "Brezeli" 14.5 x 23.5 cm, Bund à 100 Stk.': 12.60,

        'Drahtverschlüsse weiss, Pack à 1000 Stk.': 35
      }),

      product.new('Konfitüregläser und Deckel', :glaswaren, 'glaswaren.jpg', {
        'Konfiglas 410 ml mit Deckel To-82': 0.90,
        'Konfiglas 390 ml mit Deckel To-70': 0.80,
        'Konfiglas 225 ml mit Deckel To-63': 0.60,
        'Konfiglas 205 ml mit Deckel To-58': 0.72,
        'Konfiglas 105 ml mit Deckel To-48': 0.60,
        'Konfiglas 60 ml mit Deckel To-43': 0.95,
        'Deckel To-82 (410 ml)': 0.25,
        'Deckel To-70 (390 ml)': 0.25,
        'Deckel To-60': 0.25,
        'Deckel To-63 (225 ml)': 0.25,
        'Deckel To-58 (205 ml)': 0.20,
        'Deckel To-48 (105 ml)': 0.20,
        'Deckel To-43 (60 ml)': 0.20,
      }),
      product.new('Sirupflaschen', :glaswaren, 'glaswaren.jpg', {
        'Sirupflasche 5 dl mit Deckel': 0.95,
        'Sirupflasche 3.5 dl mit Deckel': 0.95,
        'Sirupflasche 2.5 dl mit Deckel': 0.95,
        'Deckel für Sirupflasche': 0.12
      }),
      product.new('Likörflaschen', :glaswaren, 'glaswaren.jpg', {
        'Bordeaux Platin weiss 5 dl mit Korkzapfen': 2.05,
        'Bordeaux Platin weiss 3.5 dl mit Korkzapfen': 2.00,
        'Bordeaux Platin weiss 2 dl mit Korkzapfen': 1.85,
        'Bordeaux Platin weiss 1 dl mit Korkzapfen': 1.55,
        'Korkzapfen zu Bordeaux Platin 5/3.5/2 dl': 0.20,
        'Korkzapfen zu Bordeaux Platin 1 dl': 0.20,
      }),

      product.new('Schilder', :beschriftungen, 'beschriftungen_schilder.jpg', {
        'Preishalter Plexiglas gross, 7.9 x 10.3 cm': 6.50,
        'Preishalter Plexiglas klein, 5.4 x 9.7 cm': 5.50,

        'Anpreistafel schwarz A5, 21 x 14.8 cm': 9.90,
        'Anpreistafel schwarz gross, 9.5 x 5.7 cm': 2.60,
        'Anpreistafel schwarz mittel, 8.0 x 4.7 cm': 2.40,
        'Anpreistafel schwarz klein, 3.0 x 4.5 cm': 2.30,

        'Kreidetafel schwarz A6, 10.5 x 14.8 cm': 0.90,
        'Kreidetafel schwarz A7, 7.4 x 10.5 cm': 0.60,
      }),
      product.new('Beschriftungsmaterial', :beschriftungen, 'beschriftungsmaterial.jpg', {
        'Kreidemarker Wasserlöslich weiss': 3.90,
        'Kreidemarker Wasserlöslich grün': 3.90,
        'Kreidemarker Wasserlöslich orange': 3.90,
      }),

      product.new('Etiketten "Vom Hof"', :diverses, 'etiketten_vom_hof.jpg', {
        'Logo-Etiketten im Kartonspender, Rolle à 500 Stk.': 20,
      }),
      product.new('Etiketten "Hausgemacht"', :diverses, 'siegeletiketten_hausgemacht.jpg', {
        "Beschriftungsetiketten 8 x 4.4 cm, Bogen à 12 Stk.": 1.10,

        "Verschluss-Etikette gold, Rolle à 500 Stk.": 17,
        "Verschluss-Etikette Edelweiss, Rolle à 500 Stk.": 17,

        "Siegeletikette gold, Rolle à 200 Stk.": 10,
        "Siegeletikette Edelweiss, Rolle à 200 Stk.": 10
      }),
      product.new('Klebeband', :diverses, 'klebeband.jpg', {
        'Klebebandrolle, 6.6m': 4.20
      }),
      product.new('Quittierblöcke', :diverses, 'quittierblock.jpg', {
        'Rechnungs-Quittierblock A5': 4.70
      }),
      product.new('Wickelpapiere', :diverses, 'wickelpapier.jpg', {
        'Einwickelpapier 70 x 100 cm, Karton mit ca. 230 Bogen': 54.50,
        'Käse-Fleischwickelpapier 50 x 37.5 cm, Karton mit ca. 230 Bogen': 36
      }),
      product.new('Verpackungen Most', :diverses, 'most_bag_in_box.jpg', {
        "Ersatzbeutel Vitop Premium 10 L": 1.30,
        "Ersatzbeutel Vitop Premium 5 L": 1.05,

        "Box Apfelsaft 10 L": 1.55,
        "Box Apfelsaft 5 L": 1.05,

        "Pet-flasche 1.5 L ohne Deckel": 0.45,
        "Deckel Rot zu Pet-flasche": 0.10
      })
    ]
  end

  def self.product
    @product ||= Struct.new(:name, :category, :photo, :variants)
  end
end
