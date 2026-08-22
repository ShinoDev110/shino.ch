# Content model for the deico site: all four languages in one place.
# German is the source; FR, IT and EN are translations of it.
# Shared data (image names, machine specifications, numbers) lives outside the
# per-language hashes so a number is only ever written once.
use strict; use warnings; use utf8;

our @LANGS = qw(de fr it en);
our %TAG   = (de => 'de-CH', fr => 'fr-CH', it => 'it-CH', en => 'en');
our %NAME  = (de => 'Deutsch', fr => 'Français', it => 'Italiano', en => 'English');
our $SITE  = 'deico AG Präzisionsmechanik';

our @SLUGS = ('', 'showroom', 'maschinenpark', 'kontakt', 'impressum', 'datenschutz');

# --- Homepage images. Shared across languages; German media is the placeholder
#     until localised assets arrive. -----------------------------------------
our %IMG = (
  hero        => { file => 'hero-praezisionskomponente',      w => [480,768,1152,1600], src => 768,  dim => '768x576' },
  drehen      => { file => 'cnc-drehen-drehteile',            w => [480,768],           src => 768,  dim => '768x576' },
  fraesen     => { file => 'cnc-fraesen-aluminiumplatte',     w => [480,768],           src => 768,  dim => '768x576' },
  fem         => { file => 'fem-simulation-federbein',        w => [480,768],           src => 768,  dim => '768x434' },
  zeichnung   => { file => 'konstruktion-fertigungszeichnung',w => [480,768,1152],      src => 768,  dim => '768x543' },
  werkstoffe  => { file => 'werkstoffe-hastelloy',            w => [480,768],           src => 480,  dim => '480x640' },
  automation  => { file => 'automation-fertigungszelle',      w => [480,768],           src => 480,  dim => '480x317' },
  messung     => { file => 'oberflaechenmessung-marsurf',     w => [480,768],           src => 480,  dim => '480x640' },
  lieferung   => { file => 'lieferservice-fahrzeuge',         w => [480,768],           src => 480,  dim => '480x270' },
  laser       => { file => 'laserbeschriftung-massstaebe',    w => [480,768],           src => 480,  dim => '480x360' },
  oberflaeche => { file => 'oberflaechenbehandlung-eloxiert', w => [480,768],           src => 480,  dim => '480x640' },
  roboter     => { file => 'roboterzubehoer-greifer',         w => [480,768],           src => 768,  dim => '768x614' },
  blech       => { file => 'blechkonstruktion-cad',           w => [480,768],           src => 768,  dim => '768x417' },
  montage     => { file => 'montage-vorrichtungen',           w => [480,768],           src => 768,  dim => '768x576' },
);

# --- Machines. Values are shared unless a hashref gives per-language text. ---
our @MACHINES = (
  { img => 'maschine-awea-fcv620', key => 'fraesen5',
    specs => [
      [ 'typ',              'Awea FCV-620' ],
      [ 'verfahrwege',      '635 x 535 x 460 mm' ],
      [ 'aufspannflaeche',  'Ø 500 / 650 mm' ],
      [ 'werkzeugwechsler', { de=>'60-fach', fr=>'60 outils', it=>'60 posti', en=>'60 tools' } ],
      [ 'spindel',          "15'000 rpm" ],
      [ 'steuerung',        { de=>'Heidenhain iTNC530 mit Glasmassstäben',
                              fr=>'Heidenhain iTNC530 avec règles de verre',
                              it=>'Heidenhain iTNC530 con righe ottiche',
                              en=>'Heidenhain iTNC530 with glass scales' } ],
    ] },
  { img => 'maschine-emco-e350', key => 'fraesen3auto',
    specs => [
      [ 'typ',              'Emco E350' ],
      [ 'verfahrwege',      '350 x 250 x 300 mm' ],
      [ 'aufspannflaeche',  'Ø 520 / 300 mm' ],
      [ 'werkzeugwechsler', { de=>'20-fach', fr=>'20 outils', it=>'20 posti', en=>'20 tools' } ],
      [ 'spindel',          "10'000 rpm" ],
      [ 'steuerung',        'Siemens' ],
    ] },
  { img => 'maschine-nakamura-as200', key => 'drehenauto',
    specs => [
      [ 'typ',               'Nakamura-Tome AS200LMYS' ],
      [ 'drehdurchmesser',   'max. 340 mm' ],
      [ 'stangendurchlass',  '65 mm' ],
      [ 'spitzenweite',      '800 mm' ],
      [ 'drehlaenge',        'max. 570 mm' ],
      [ 'werkzeugplaetze',   '12 / 24' ],
      [ 'steuerung',         'Fanuc Oi-TF' ],
      [ 'spezielles',        { de=>'Y-Achse, Gegenspindel und angetriebene Werkzeuge (Fräsfunktion)',
                               fr=>'Axe Y, contre-broche et outils motorisés (fonction fraisage)',
                               it=>'Asse Y, contromandrino e utensili motorizzati (funzione di fresatura)',
                               en=>'Y axis, sub-spindle and driven tools (milling function)' } ],
    ] },
  { img => 'maschine-xyz-proturn-350', key => 'drehen',
    specs => [
      [ 'typ',                    'XYZ Proturn 350' ],
      [ 'drehdurchmesserschlitten', '190 mm' ],
      [ 'drehdurchmesserbett',    '350 mm' ],
      [ 'stangendurchlass',       '53 mm' ],
      [ 'spitzenweite',           '1000 mm' ],
    ] },
  { img => 'maschine-mikron-wf40c', key => 'fraesen3',
    specs => [
      [ 'typ',             'Mikron WF40C Retrofit' ],
      [ 'verfahrwege',     '585 x 585 x 480 mm' ],
      [ 'aufspannflaeche', '550 x 900 mm' ],
      [ 'spezielles',      { de=>'4. Achse', fr=>'4e axe', it=>'4° asse', en=>'4th axis' } ],
    ] },
  { img => 'maschine-fraesen-konventionell', key => 'fraesenkonv',
    specs => [
      [ 'verfahrwege',     '250 x 400 x 400 mm' ],
      [ 'aufspannflaeche', '300 x 600 mm' ],
    ] },
  { img => 'maschine-flachschleifen', key => 'schleifen',
    specs => [
      [ 'arbeitsflaeche',     '300 x 150 mm' ],
      [ 'verfahrwege',        'X = 400 mm, Y = 160 mm' ],
      [ 'abstand',            '400 mm' ],
      [ 'werkstueckgewicht',  '45 kg' ],
    ] },
  { img => 'maschine-saege', key => 'saegen',
    specs => [
      [ 'rund',        '270 mm' ],
      [ 'viereckig',   '270 x 270 mm' ],
      [ 'rechteckig',  '300 x 250 mm' ],
    ] },
  { img => 'maschine-messplatz-micro-hite', key => 'messplatz',
    specs => [
      [ 'typ',               '2D' ],
      [ 'anwendungsbereich', '770 mm' ],
      [ 'fehlergrenze',      '2 + 2L/1000 µm' ],
      [ 'wiederholbarkeit',  '≤ 1 µm' ],
    ] },
);

our @CAX = (
  [ 'CAD', 'Autodesk Inventor' ],
  [ 'FEM', 'Autodesk Inventor Nastran' ],
  [ 'CAM', 'Autodesk Inventor HSM' ],
);

our %CONTACT = (
  company  => 'deico AG',
  street   => 'Huebstrasse 24',
  city     => '8636 Wald',
  workshop => 'Huebstrasse 25',
  workcity => 'CH-8636 Wald',
  billing  => 'Huebstrasse 24',
  billcity => 'CH-8636 Wald',
  phone    => '+41 55 535 55 50',
  phoneraw => '+41555355550',
  email    => 'mail@deico.ch',
  vat      => 'CHE-432.738.804 MWST',
);

our @PEOPLE = (
  { name => 'Daniel Eicher',   role => 'gf'  },
  { name => 'Matthias Eicher', role => 'sgf' },
);

1;
