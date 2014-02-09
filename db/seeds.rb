# encoding: UTF-8

wholsalers_forelle = <<-DATA
235634849 http://www.forelle.com/american-football/helmets/adult/riddell-360-helmets-m-l/10374/
235634849 http://www.forelle.com/american-football/helmets/adult/riddell-360-helmets-xl/10383/
179138937 http://www.forelle.com/american-football/shoes-us-size/moulded/adidas-filthy-speed-fly-low/16375/
164002313 http://www.forelle.com/american-football/gloves/adult/nike-hyperbeast-20/15719/
176259965 http://www.forelle.com/american-football/helmets/adult/rawlings-impulse-helmets-s-m-l/13853/
176259965 http://www.forelle.com/american-football/helmets/adult/rawlings-impulse-helmets-xl/13893/
179141233 http://www.forelle.com/american-football/shoes-us-size/moulded/under-armour-nitro-iii-low-mc/11948/
186475501 http://www.forelle.com/american-football/shoulderpads/single-hook-up/riddell-power-spx10ibp/7939/
186475501 http://www.forelle.com/american-football/shoulderpads/single-hook-up/riddell-power-spx30/7946/
186475501 http://www.forelle.com/american-football/shoulderpads/double-hook-up/riddell-power-spx40/7951/
186475501 http://www.forelle.com/american-football/shoulderpads/single-hook-up/riddell-power-spx50/7915/
163964023 http://www.forelle.com/american-football/helmets/adult/riddell-revolution-helmets-m-l/7219/
163964023 http://www.forelle.com/american-football/helmets/adult/riddell-revolution-helmets-xl/8634/
164009703 http://www.forelle.com/american-football/gloves/adult/cutters-s60-the-shockskin-gamer/15866/
164007995 http://www.forelle.com/american-football/gloves/adult/cutters-s90-shockskin-lineman/15883/
164001567 http://www.forelle.com/american-football/gloves/adult/nike-super-bad-20/12813/
179143693 http://www.forelle.com/american-football/shoes-us-size/moulded/nike-super-bad-shark/11925/
179142745 http://www.forelle.com/american-football/shoes-us-size/moulded/under-armour-surge-ii-58-mc/11940/
164001371 http://www.forelle.com/american-football/gloves/adult/nike-torque/15713/
176330009 http://www.forelle.com/american-football/gloves/adult/nike-vapor-fly/16407/
164001469 http://www.forelle.com/american-football/gloves/adult/nike-vapor-jet-20/12807/
164013821 http://www.forelle.com/american-football/gloves/adult/cutters-x40-c-tack-revolution/11384/
164011635 http://www.forelle.com/american-football/gloves/adult/cutters-x40-s-c-tack-solid/15852/
186467237 http://www.forelle.com/american-football/shoulderpads/single-hook-up/riddell-spk-lbfb/15251/
186467237 http://www.forelle.com/american-football/shoulderpads/single-hook-up/riddell-spk-oldl/15246/
186467237 http://www.forelle.com/american-football/shoulderpads/single-hook-up/riddell-spk-qbwr/15236/
186467237 http://www.forelle.com/american-football/shoulderpads/single-hook-up/riddell-spk-rbdb/15241/
163970683 http://www.forelle.com/american-football/shoulderpads/single-hook-up/riddell-spk-lbfb/15251/
163971035 http://www.forelle.com/american-football/shoulderpads/single-hook-up/riddell-spk-oldl/15246/
163969649 http://www.forelle.com/american-football/shoulderpads/single-hook-up/riddell-spk-qbwr/15236/
163970227 http://www.forelle.com/american-football/shoulderpads/single-hook-up/riddell-spk-rbdb/15241/
176366809 http://www.forelle.com/american-football/shoulderpads/single-hook-up/riddell-power-spx10ibp/7939/
176367113 http://www.forelle.com/american-football/shoulderpads/single-hook-up/riddell-power-spx30/7946/
176367325 http://www.forelle.com/american-football/shoulderpads/double-hook-up/riddell-power-spx40/7951/
176367533 http://www.forelle.com/american-football/shoulderpads/single-hook-up/riddell-power-spx50/7915/
235653821 http://www.forelle.com/american-football/shoulderpads/single-hook-up/riddell-ev15/12870/
235653821 http://www.forelle.com/american-football/shoulderpads/double-hook-up/riddell-ev48/12879/
235653821 http://www.forelle.com/american-football/shoulderpads/double-hook-up/riddell-ev65/12885/
DATA

wholsalers_forelle.split("\n").each do |data|
  shopify_product_id, url = data.split(' ')
  next unless url
  next if WholesalerForelle.where(shopify_product_id: shopify_product_id, url: url).first

  WholesalerForelle.new.tap do |whoesaler|
    whoesaler.shopify_product_id = shopify_product_id
    whoesaler.url = url
    whoesaler.save!
  end
end

__END__

features = %w(
163963715;png;Flex Impact System;Facemask und seitlich angebrachte Clips reduzieren die Wucht des frontalen Aufpralls
163963715;png;Verlängerte Helmschale; Veränderte Schalenform für Schutz der Kieferpartie vor seitlichen Schlägen
163963715;png;Ideal Fit Technologie;Optimale Anpassung an den Hinterkopf für zusätzlichen Schutz und verbesserten Halt
163963715;png;Versetztes Schalendesign;Stärker versetzte Form für verbesserte Stablilität der Helmschale
163963715;png;Innenpolsterung;Herausnehmbare Polsterung für hervorragenden Tragekompfort
163963715;png;Light Weight Technologie;Leichtes Schalen- und Facemaskmaterial verbessern den Tragekompfort
163963715;png;Aufblasbare Polsterung;Individuell aufblasbare Luftkammern sorgen für einen optimalen Sitz des Helms
163963715;png;Quick-Release-Clips;Schnelle Demontage des Facemasks für direkten Zugang zum Spieler
163964023;png;Verlängerte Helmschale;Veränderte Schalenform für Schutz der Kieferpartie vor seitlichen Schlägen
163964023;png;Versetztes Schalendesign;Stärker versetzte Form für verbesserte Stablilität der Helmschale
163964023;png;Innenpolsterung;Herausnehmbare Polsterung für hervorragenden Tragekompfort
163964023;png;Light Weight Technologie;Leichtes Schalen- und Facemaskmaterial verbessern den Tragekompfort
163964023;png;Aufblasbare Polsterung;Individuell aufblasbare Luftkammern sorgen für einen optimalen Sitz des Helms
163964023;png;Quick-Release-Clips;Schnelle Demontage der seitlichen Clips für direkten Zugang zum Spieler
pad_spk;png;RipKord Technologie;Durch lösen eines am Rand verlaufden Kabels ist ein schneller Zugang zum Spieler möglich
pad_spk;png;Air Management;Luftkammern in der Polsterung verteilen den Aufprall strategisch über die gesamte Rüstung
pad_spk;png;Stac System; Übereinander geschichtete Schulterklappen leiten die Wucht von der Schulterpartie weg
pad_spk;png;Flat Pad;Flaches Pad-Design für höhere Bewegungsfreiheit und athletischeren Look
pad_spx;jpg;Air Management;Luftkammern in der Polsterung verteilen den Aufprall strategisch über die gesamte Rüstung
pad_spx;jpg;Stac System;Übereinander geschichtete Schulterklappen leiten die Wucht von der Schulterpartie weg
pad_spx;jpg;Flat Pad;Flaches Pad-Design für höhere Bewegungsfreiheit und athletischeren Look
pad_evolution;png;Air Management;Luftkammern in der Polsterung verteilen den Aufprall strategisch über die gesamte Rüstung
pad_evolution;png;Flat Pad;Flaches Pad-Design für höhere Bewegungsfreiheit und athletischeren Look
)



Product.new({
  :shopify_id => 163963715
})

  def defaults_hash
    {
      #  => {
      #   "features" => default_features('163963715'),
      #   "fitting"  => [FITTING_HELMET_1, FITTING_HELMET_2A],
      # },
      # 163964023 => {
      #   "features" => default_features('163964023'),
      #   "fitting"  => [FITTING_HELMET_1, FITTING_HELMET_2A],
      # },
      # 176259965 => {
      #   "fitting" => [FITTING_HELMET_1, FITTING_HELMET_2B],
      # },
      # #  EVOLUTION
      # [186464681] => { #163972709, 163973197, 163973513
      #   "features"    => default_features('pad_evolution'),
      #   # "accessories" => ['180716833,180711969,180715553','180717561','180719109'],
      #   "fitting"     => [FITTING_PAD_1, FITTING_PAD_2],
      # },

      # # SPK
      # [186467237] => { #163970683, 163969649, 163971035, 163970227
      #   "features"    => default_features('pad_spk'),
      #   # "accessories" => ['180716833,180711969,180715553','180717561','180719109'],
      #   "fitting"     => [FITTING_PAD_1, FITTING_PAD_2],
      # },

      # # SPX
      # [186475501] => { #, 176366809, 176367113, 176367325, 176367533] => {
      #   "features"    => default_features('pad_spx'),
      #   # "accessories" => ['180716833,180711969,180715553','180717561','180719109'],
      #   "fitting"     => [FITTING_PAD_1, FITTING_PAD_2],
      # },

      # Hands
      [164011635, 164013821, 164007995, 164009703]  => {
        "fitting"     => [FITTING_CUTTERS, FITTING_CUTTERS2],
      },
      # [164002313, 164001567, 164001371, 176330009, 164001469]  => {
      #   "fitting"     => [FITTING_NIKE_1, FITTING_NIKE_2],
      # },

      # # Shoes
      # [179138937, 179142745, 179143693, 179141233]  => {
      #   "fitting"     => [],
      # },

    }
  end


FITTING_HELMET_1 = "<h3>Nimm deinen Kopfumfang</h3>
Messe mit einem Maßband deinen Kopfumfang etwa 2,5 cm über deinen Augenbrauen. Falls du kein Maßband zur Hand hast, nimm einfach eine Schnur, markiere die Stellen an der sie sich kreuzt und messe den Abstand.
Vergleiche den gemessenen Wert mit der nebenstehenden Tabelle, um deine Helmgröße zu bestimmen."

FITTING_HELMET_2A = "Helmgröße;Kopfumfang
M;51 - 56 cm
L;56 - 59 cm
XL;ab 59 cm"

FITTING_HELMET_2B = "Helmgröße;Kopfumfang
S;48 - 52 cm
M;52 - 56 cm
L;56 - 60 cm
XL;ab 60 cm"

FITTING_PAD_1 = "<h3>Nimm deine Schulterbreite und Brustumfang</h3>
Messe mit einem Maßband den Abstand von der Spitze deines linken Oberarmknochens zur Spitze deines rechten Oberarmknochens. Danach messe mit dem Maßband deinen Brustumfang auf Höhe deiner Brustwarzen. Falls du kein Maßband zur Hand hast, nimm einfach eine Schnur, markiere die Stellen an der sie sich kreuzt und messe den Abstand.
Vergleiche die gemessenen Werte mit der nebenstehenden Tabelle, um die Größe für dein Schulterpolster zu bestimmen"

FITTING_PAD_2 = "Padgröße;Schulterbreite;Brustumfang
S  (17-18\");28 - 30,5 cm;66 - 71 cm
M (18-19\");30,5 - 33 cm;71 - 76 cm
L (19-20\");33 - 35,5 cm;76 - 81 cm
XL (20-21\");35,5 - 38 cm;81 - 86 cm
XXL (21-22\");38 - 40,5 cm;91 - 96 cm
XXXL (22-23\");ab 40,5 cm;ab 96 cm"

FITTING_NIKE_1 = "<h3>Nimm deinen Handumfang</h3>
Die richtige Größe für Nike Footballhandschuhe lassen sich durch den Umfang deiner Hand bestimmen. Um die für dich richtige Größe zu ermitteln, messe mit einem Maßband den Umfang deiner Hand auf Höhe deiner Fingerknöchel. Falls du kein Maßband zur Hand hast, nimm einfach eine Schnur, markiere die Stellen an der sie sich kreuzt und messe den Abstand.
Vergleiche den gemessenen Wert mit der nebenstehenden Tabelle, um deine Nike Handschuhgröße zu bestimmen."

FITTING_NIKE_2 = "
Handschuhgröße;Handumfang
S;18 - 19 cm
M;19 - 19,5 cm
L;19,5 - 20,5 cm
XL;20,5 - 21,5 cm
XXL;ab 21,5 cm"

FITTING_CUTTERS = "Die richtige Größe für Cutters Footballhandschuhe lassen sich durch das nebenstehende Cutters Größendiagramm ermitteln. Klicke auf das Dokument, um es zu öffnen und drucke es auf DIN A4 Größe aus. Lege anschließend deine Hand auf das Größendiagramm und achte dabei darauf, dass das untere Ende deiner Handfläche genau mit der abgebildeten Hand abschließt. Lese nun ab welchen Kreis dein Mittelfinger erreicht, um deine Cutters Handschuhgröße zu bestimmen"

cdn = '//cdn.shopify.com/s/files/1/0240/1531/t/5/assets/'
FITTING_CUTTERS2 = 'Lade <a href="fitting_cutters.pdf" target="_blank">hier das Cutters Größendiagramm</a> runter: <a href="fitting_cutters.pdf" target="_blank"><img src="fitting_cutters.jpg" alt="Cutters Größendiagramm"></a>'.gsub('="', '="' + cdn)



  def collapse_table(value)
    if value.to_s.include?('<table>')
      value.gsub('</td><td>', ';').gsub('</th><th>', ';').gsub('</tr>', "\n").gsub(/<\/?t[a-z]+>/, '')
    else
      value
    end
  end

  def defaults(id)
    defaults_hash[id.to_i]
  end


  def default_features(id)
    default_features_hash[id]
  end

  def default_features_hash
    FEATURES.split("\n").inject({}) do |hash, line|
      key, prefix, title, text = line.split(';')
      hash[key] ||= []
      index = hash[key].size + 1
      hash[key] << ["#{key}_#{index}.#{prefix}", title, text]
      hash
    end
  end

