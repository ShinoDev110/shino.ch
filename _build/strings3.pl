# Strings introduced by the Axis Industrial rebuild: fact strip, data grid,
# band caption and the mono section labels. German is the source.
use strict; use warnings; use utf8;
our %T;

$T{de}{ax} = {
  band => 'Gefräste Aluminiumkomponente · Werkstatt Wald',
  f1l => 'Losgrösse',       f1u => 'Stück',
  f2l => 'Fräsen',          f2u => 'Achsen',
  f3l => 'Wiederholbarkeit', f3u => 'µm',
  f4l => 'Standort',        f4u => 'Wald ZH',
  b1 => 'Max. Verfahrweg', b1n => 'mm, Awea FCV-620, Fräsen CNC 5-Achsen mit Roboterautomation',
  b2 => 'Wiederholbarkeit', b2n => 'Messplatz mit Höhenmessgerät, Fehlergrenze 2 + 2L/1000 µm',
  b3 => 'Drehdurchmesser', b3n => 'mm, Nakamura-Tome AS200LMYS',
  b4 => 'Spindeldrehzahl', b4n => 'rpm, 60-fach Werkzeugwechsler',
  b5 => 'Maschinen',       b5n => 'Fräsen, Drehen, Schleifen, Sägen, Messtechnik',
  b6 => 'Werkstoffe',
  b6v => 'Stahl · Aluminium · Messing · Kunststoff · Nickelbasislegierungen (Hastelloy, Inconel) · Titanlegierungen',
  zahlen => 'Fertigung in Zahlen', zahlenh => 'Was auf unseren Maschinen möglich ist',
  c1lab => 'Drehen', c2lab => 'Fräsen', c3lab => 'Konstruktion',
  flabs => ['Werkstoffe','Automation','Messtechnik','Logistik','Beschriftung','Oberflächen'],
  dlabs => ['Automation','Konstruktion','Montage'],
};

$T{fr}{ax} = {
  band => 'Composant en aluminium fraisé · Atelier de Wald',
  f1l => 'Taille de lot',  f1u => 'pièce',
  f2l => 'Fraisage',       f2u => 'axes',
  f3l => 'Répétabilité',   f3u => 'µm',
  f4l => 'Site',           f4u => 'Wald ZH',
  b1 => 'Course maximale', b1n => 'mm, Awea FCV-620, fraisage CNC 5 axes avec automatisation robotisée',
  b2 => 'Répétabilité',    b2n => 'Poste de mesure avec colonne de mesure, erreur maximale 2 + 2L/1000 µm',
  b3 => 'Diamètre de tournage', b3n => 'mm, Nakamura-Tome AS200LMYS',
  b4 => 'Vitesse de broche',    b4n => "tr/min, changeur d'outils 60 positions",
  b5 => 'Machines',        b5n => 'Fraisage, tournage, rectification, sciage, métrologie',
  b6 => 'Matériaux',
  b6v => 'Acier · Aluminium · Laiton · Matières plastiques · Alliages à base de nickel (Hastelloy, Inconel) · Alliages de titane',
  zahlen => 'La production en chiffres', zahlenh => 'Ce que permettent nos machines',
  c1lab => 'Tournage', c2lab => 'Fraisage', c3lab => 'Conception',
  flabs => ['Matériaux','Automatisation','Métrologie','Logistique','Marquage','Surfaces'],
  dlabs => ['Automatisation','Conception','Montage'],
};

$T{it}{ax} = {
  band => 'Componente in alluminio fresato · Officina di Wald',
  f1l => 'Lotto',          f1u => 'pezzo',
  f2l => 'Fresatura',      f2u => 'assi',
  f3l => 'Ripetibilità',   f3u => 'µm',
  f4l => 'Sede',           f4u => 'Wald ZH',
  b1 => 'Corsa massima',   b1n => 'mm, Awea FCV-620, fresatura CNC a 5 assi con automazione robotizzata',
  b2 => 'Ripetibilità',    b2n => 'Postazione di misura con altimetro, errore massimo 2 + 2L/1000 µm',
  b3 => 'Diametro di tornitura', b3n => 'mm, Nakamura-Tome AS200LMYS',
  b4 => 'Velocità mandrino',     b4n => 'rpm, cambio utensili a 60 posti',
  b5 => 'Macchine',        b5n => 'Fresatura, tornitura, rettifica, segatura, metrologia',
  b6 => 'Materiali',
  b6v => 'Acciaio · Alluminio · Ottone · Materie plastiche · Leghe a base di nichel (Hastelloy, Inconel) · Leghe di titanio',
  zahlen => 'La produzione in cifre', zahlenh => 'Cosa permettono le nostre macchine',
  c1lab => 'Tornitura', c2lab => 'Fresatura', c3lab => 'Progettazione',
  flabs => ['Materiali','Automazione','Metrologia','Logistica','Marcatura','Superfici'],
  dlabs => ['Automazione','Progettazione','Montaggio'],
};

$T{en}{ax} = {
  band => 'Milled aluminium component · Wald workshop',
  f1l => 'Batch size',     f1u => 'piece',
  f2l => 'Milling',        f2u => 'axes',
  f3l => 'Repeatability',  f3u => 'µm',
  f4l => 'Location',       f4u => 'Wald ZH',
  b1 => 'Maximum travel',  b1n => 'mm, Awea FCV-620, CNC 5-axis milling with robot automation',
  b2 => 'Repeatability',   b2n => 'Measuring station with height gauge, maximum error 2 + 2L/1000 µm',
  b3 => 'Turning diameter', b3n => 'mm, Nakamura-Tome AS200LMYS',
  b4 => 'Spindle speed',   b4n => 'rpm, 60-tool changer',
  b5 => 'Machines',        b5n => 'Milling, turning, grinding, sawing, metrology',
  b6 => 'Materials',
  b6v => 'Steel · Aluminium · Brass · Plastics · Nickel-based alloys (Hastelloy, Inconel) · Titanium alloys',
  zahlen => 'Production in numbers', zahlenh => 'What our machines can do',
  c1lab => 'Turning', c2lab => 'Milling', c3lab => 'Design',
  flabs => ['Materials','Automation','Metrology','Logistics','Marking','Surfaces'],
  dlabs => ['Automation','Design','Assembly'],
};

$T{de}{lb} = { label => "Bildansicht", close => "Schliessen", prev => "Zurück", next => "Weiter" };
$T{fr}{lb} = { label => "Visionneuse d'images", close => "Fermer", prev => "Précédent", next => "Suivant" };
$T{it}{lb} = { label => "Visualizzatore immagini", close => "Chiudi", prev => "Precedente", next => "Successivo" };
$T{en}{lb} = { label => "Image viewer", close => "Close", prev => "Previous", next => "Next" };

1;
