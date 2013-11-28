#encoding: utf-8

FITTING_HELMET_1 = "<h3>Nimm deine Kopfmaße</h3>
Messe mit einem Maßband deinen Kopfumfang etwa 2,5cm über deinen Augenbrauen. Falls du kein Maßband zur Hand hast, nimm einfach eine Schnur, markiere die Stellen an der sie sich kreuzt und messe den Abstand.
Vergleiche den gemessenen Wert mit der nebenstehenden Tabelle, um deine Helmgröße zu bestimmen."

FITTING_HELMET_2B = "Helmgröße;Kopfumfang
S;48cm - 52cm
M;52cm - 56cm
L;56cm - 60cm
XL;ab 60cm"

FITTING_PAD_1 = "<h3>Nimm deine Schulter- und Brustmaße</h3>
Messe mit einem Maßband den Abstand von der Spitze deines linken Oberarmknochens zur Spitze deines rechten Oberarmknochens. Danach messe mit dem Maßband deinen Brustumfang auf Höhe deiner Brustwarzen. Falls du kein Maßband zur Hand hast, nimm einfach eine Schnur, markiere die Stellen an der sie sich kreuzt und messe den Abstand.
Vergleiche die gemessenen Werte mit der nebenstehenden Tabelle, um die Größe für dein Schulterpolster zu bestimmen"

FITTING_PAD_2 = "Padgröße;Schulterbreite;Brustumfang
S  (17-18‘‘);28cm - 30,5cm;66cm – 71cm
M (18-19‘‘);30,5cm – 33cm;71cm – 76cm
L (19-20‘‘);33cm - 35,5cm;76cm – 81cm
XL (20-21‘‘);35,5cm – 38cm;81cm – 86cm
XXL (21-22‘‘);38cm - 40,5cm;91cm – 96cm
XXXL (22-23‘‘);ab 40,5cm ab;96cm"

FITTING_NIKE_1 = "Die richtige Größe für Nike Footballhandschuhe lassen sich durch den Umfang deiner Hand bestimmen. Um die für dich richtige Größe zu ermitteln, messe mit einem Maßband den Umfang deiner Hand auf Höhe deiner Fingerknöchel. Falls du kein Maßband zur Hand hast, nimm einfach eine Schnur, markiere die Stellen an der sie sich kreuzt und messe den Abstand.
Vergleiche den gemessenen Wert mit der nebenstehenden Tabelle, um deine Nike Handschuhgröße zu bestimmen."

FITTING_NIKE_2 = "
Handschuhgröße;Handumfang
S;18cm – 19cm
M;19cm - 19,5cm
L;19,5cm - 20,5cm
XL;20,5cm – 21,5cm
XXL;ab 21,5cm"

FITTING_CUTTERS = "Die richtige Größe für Cutters Footballhandschuhe lassen sich durch das nebenstehende Cutters Größendiagramm ermitteln. Klicke auf das Dokument, um es zu öffnen und drucke es auf DIN A4 Größe aus. Lege anschließend deine Hand auf das Größendiagramm und achte dabei darauf, dass das untere Ende deiner Handfläche genau mit der abgebildeten Hand abschließt. Lese nun ab welchen Kreis dein Mittelfinger erreicht, um deine Cutters Handschuhgröße zu bestimmen"

FITTING_SHOES = "US-Größe;EUR-Größe
6,5;39
7,0;40
7,5;40,5
8,0;41
8,5;42
9,0;42,5
9,5;43
10,0;44
10,5;44,5
11,0;45
11,5;45,5
12,0;46
12,5;47
13,0;47,5
13,5;48
14,0;48,5
14,5;49"

module ProductsHelper
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

  def defaults_hash
    {
      # 163964023
      176259965 => {
        "fitting" => [FITTING_HELMET_1, FITTING_HELMET_2B],
      },
      #  EVOLUTION
      163972709 => {
        "features"    => default_features('pad_evolution'),
        "accessories" => ['180716833,180711969,180715553','180717561','180719109'],
        "fitting"     => [FITTING_PAD_1, FITTING_PAD_2],
      },
      163973197 => {
        "features"    => default_features('pad_evolution'),
        "accessories" => ['180716833,180711969,180715553','180717561','180719109'],
        "fitting"     => [FITTING_PAD_1, FITTING_PAD_2],
      },
      163973513 => {
        "features"    => default_features('pad_evolution'),
        "accessories" => ['180716833,180711969,180715553','180717561','180719109'],
        "fitting"     => [FITTING_PAD_1, FITTING_PAD_2],
      },

      # SPK
      163970683 => {
        "features"    => default_features('pad_spk'),
        "accessories" => ['180716833,180711969,180715553','180717561','180719109'],
        "fitting"     => [FITTING_PAD_1, FITTING_PAD_2],
      },
      163969649 => {
        "features"    => default_features('pad_spk'),
        "accessories" => ['180716833,180711969,180715553','180717561','180719109'],
        "fitting"     => [FITTING_PAD_1, FITTING_PAD_2],
      },
      163971035 => {
        "features"    => default_features('pad_spk'),
        "accessories" => ['180716833,180711969,180715553','180717561','180719109'],
        "fitting"     => [FITTING_PAD_1, FITTING_PAD_2],
      },
      163970227 => {
        "features"    => default_features('pad_spk'),
        "accessories" => ['180716833,180711969,180715553','180717561','180719109'],
        "fitting"     => [FITTING_PAD_1, FITTING_PAD_2],
      },

      # SPX
      176366809 => {
        "features"    => default_features('pad_spx'),
        "accessories" => ['180716833,180711969,180715553','180717561','180719109'],
        "fitting"     => [FITTING_PAD_1, FITTING_PAD_2],
      },
      176367113 => {
        "features"    => default_features('pad_spx'),
        "accessories" => ['180716833,180711969,180715553','180717561','180719109'],
        "fitting"     => [FITTING_PAD_1, FITTING_PAD_2],
      },
      176367325 => {
        "features"    => default_features('pad_spx'),
        "accessories" => ['180716833,180711969,180715553','180717561','180719109'],
        "fitting"     => [FITTING_PAD_1, FITTING_PAD_2],
      },
      176367533 => {
        "features"    => default_features('pad_spx'),
        "accessories" => ['180716833,180711969,180715553','180717561','180719109'],
        "fitting"     => [FITTING_PAD_1, FITTING_PAD_2],
      },
    }
  end

  def default_features(id)
    default_features_hash[id]
  end

  def default_features_hash
"163964023;png;Verlängerte Helmschale;Veränderte Schalenform für Schutz der Kieferpartie vor seitlichen Schlägen
163964023;png;Versetztes Schalendesign;Stärker versetzte Form für verbesserte Stablilität der Helmschale
163964023;png;Innenpolsterung Herausnehmbare Polsterung für hervorragenden Tragekompfort
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
pad_evolution;png;Flat Pad;Flaches Pad-Design für höhere Bewegungsfreiheit und athletischeren Look".split("\n").inject({}) do |hash, line|
  key, prefix, title, text = line.split(';')
  hash[key] ||= []
  index = hash[key].size + 1
  hash[key] << ["#{key}_#{index}.#{prefix}", title, text]
  hash
    end
  end
end
