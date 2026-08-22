# Inner-page strings: Showroom, Maschinenpark, Kontakt and the two legal pages.
use strict; use warnings; use utf8;
our %T;

# --------------------------------------------------------------- showroom ---
$T{de}{showroom} = { desc=>'Präzisionskomponenten aus der Fertigung der deico AG.',
  eyebrow=>'Showroom', h1=>'Präzisionskomponenten',
  lede=>'Eine Auswahl von Bauteilen und Baugruppen aus unserer Fertigung.',
  count=>'Bauteile in der Galerie' };
$T{fr}{showroom} = { desc=>'Composants de précision issus de la production de deico AG.',
  eyebrow=>'Showroom', h1=>'Composants de précision',
  lede=>'Une sélection de pièces et de sous-ensembles issus de notre production.',
  count=>'pièces dans la galerie' };
$T{it}{showroom} = { desc=>'Componenti di precisione dalla produzione di deico AG.',
  eyebrow=>'Showroom', h1=>'Componenti di precisione',
  lede=>'Una selezione di pezzi e gruppi dalla nostra produzione.',
  count=>'pezzi nella galleria' };
$T{en}{showroom} = { desc=>'Precision components from deico AG production.',
  eyebrow=>'Showroom', h1=>'Precision components',
  lede=>'A selection of parts and assemblies from our production.',
  count=>'parts in the gallery' };

# ---------------------------------------------------------- maschinenpark ---
$T{de}{mp} = { desc=>'Der Maschinenpark der deico AG: CNC Fräsen, CNC Drehen, Schleifen, Sägen und Messtechnik.',
  eyebrow=>'Maschinenpark', h1=>'Unser Maschinenpark',
  lede=>'CNC Fräsen und Drehen mit Roboterautomation, konventionelle Bearbeitung, Schleifen, Sägen und Messtechnik unter einem Dach.',
  caxh=>'CAD, CAM und FEM' };
$T{fr}{mp} = { desc=>'Le parc de machines de deico AG : fraisage CNC, tournage CNC, rectification, sciage et métrologie.',
  eyebrow=>'Parc de machines', h1=>'Notre parc de machines',
  lede=>'Fraisage et tournage CNC avec automatisation robotisée, usinage conventionnel, rectification, sciage et métrologie sous un même toit.',
  caxh=>'CAO, FAO et FEM' };
$T{it}{mp} = { desc=>'Il parco macchine di deico AG: fresatura CNC, tornitura CNC, rettifica, segatura e metrologia.',
  eyebrow=>'Parco macchine', h1=>'Il nostro parco macchine',
  lede=>'Fresatura e tornitura CNC con automazione robotizzata, lavorazione convenzionale, rettifica, segatura e metrologia sotto lo stesso tetto.',
  caxh=>'CAD, CAM e FEM' };
$T{en}{mp} = { desc=>'The deico AG machine park: CNC milling, CNC turning, grinding, sawing and metrology.',
  eyebrow=>'Machine park', h1=>'Our machine park',
  lede=>'CNC milling and turning with robot automation, conventional machining, grinding, sawing and metrology under one roof.',
  caxh=>'CAD, CAM and FEM' };

# machine display names
$T{de}{mach} = {
  fraesen5=>'Fräsen CNC 5-Achsen mit Roboterautomation', fraesen3auto=>'Fräsen CNC 3-Achsen mit Roboterautomation',
  drehenauto=>'Drehen CNC mit Roboterautomation', drehen=>'Drehen CNC', fraesen3=>'Fräsen CNC 3-Achsen',
  fraesenkonv=>'Fräsen konventionell', schleifen=>'Flachschleifen konventionell', saegen=>'Sägen',
  messplatz=>'Messplatz mit Höhenmessgerät' };
$T{fr}{mach} = {
  fraesen5=>'Fraisage CNC 5 axes avec automatisation robotisée', fraesen3auto=>'Fraisage CNC 3 axes avec automatisation robotisée',
  drehenauto=>'Tournage CNC avec automatisation robotisée', drehen=>'Tournage CNC', fraesen3=>'Fraisage CNC 3 axes',
  fraesenkonv=>'Fraisage conventionnel', schleifen=>'Rectification plane conventionnelle', saegen=>'Sciage',
  messplatz=>'Poste de mesure avec colonne de mesure' };
$T{it}{mach} = {
  fraesen5=>'Fresatura CNC a 5 assi con automazione robotizzata', fraesen3auto=>'Fresatura CNC a 3 assi con automazione robotizzata',
  drehenauto=>'Tornitura CNC con automazione robotizzata', drehen=>'Tornitura CNC', fraesen3=>'Fresatura CNC a 3 assi',
  fraesenkonv=>'Fresatura convenzionale', schleifen=>'Rettifica in piano convenzionale', saegen=>'Segatura',
  messplatz=>'Postazione di misura con altimetro' };
$T{en}{mach} = {
  fraesen5=>'CNC 5-axis milling with robot automation', fraesen3auto=>'CNC 3-axis milling with robot automation',
  drehenauto=>'CNC turning with robot automation', drehen=>'CNC turning', fraesen3=>'CNC 3-axis milling',
  fraesenkonv=>'Conventional milling', schleifen=>'Conventional surface grinding', saegen=>'Sawing',
  messplatz=>'Measuring station with height gauge' };

# machine image alt text
$T{de}{machalt} = {
  fraesen5=>'CNC 5-Achsen Fräsmaschine Awea FCV-620', fraesen3auto=>'CNC 3-Achsen Fräsmaschine Emco E350',
  drehenauto=>'CAD-Modell der CNC-Drehmaschine mit Roboterautomation', drehen=>'Drehmaschine XYZ Proturn 350 beim Drehen einer Welle mit Lünette',
  fraesen3=>'Fräsmaschine Mikron WF40C in der Werkstatt', fraesenkonv=>'Konventionelle Fräsmaschine in der Werkstatt',
  schleifen=>'Konventionelle Flachschleifmaschine', saegen=>'Säge beim Trennen von Stangenmaterial',
  messplatz=>'Höhenmessgerät Micro-Hite beim Messen einer Welle' };
$T{fr}{machalt} = {
  fraesen5=>'Fraiseuse CNC 5 axes Awea FCV-620', fraesen3auto=>'Fraiseuse CNC 3 axes Emco E350',
  drehenauto=>'Modèle CAO du tour CNC avec automatisation robotisée', drehen=>"Tour XYZ Proturn 350 tournant un arbre avec lunette",
  fraesen3=>"Fraiseuse Mikron WF40C dans l'atelier", fraesenkonv=>"Fraiseuse conventionnelle dans l'atelier",
  schleifen=>'Rectifieuse plane conventionnelle', saegen=>'Scie tronçonnant de la barre',
  messplatz=>"Colonne de mesure Micro-Hite mesurant un arbre" };
$T{it}{machalt} = {
  fraesen5=>'Fresatrice CNC a 5 assi Awea FCV-620', fraesen3auto=>'Fresatrice CNC a 3 assi Emco E350',
  drehenauto=>'Modello CAD del tornio CNC con automazione robotizzata', drehen=>'Tornio XYZ Proturn 350 durante la tornitura di un albero con lunetta',
  fraesen3=>"Fresatrice Mikron WF40C in officina", fraesenkonv=>'Fresatrice convenzionale in officina',
  schleifen=>'Rettificatrice in piano convenzionale', saegen=>'Sega durante il taglio di materiale in barre',
  messplatz=>'Altimetro Micro-Hite durante la misura di un albero' };
$T{en}{machalt} = {
  fraesen5=>'Awea FCV-620 CNC 5-axis milling machine', fraesen3auto=>'Emco E350 CNC 3-axis milling machine',
  drehenauto=>'CAD model of the CNC lathe with robot automation', drehen=>'XYZ Proturn 350 lathe turning a shaft with a steady rest',
  fraesen3=>'Mikron WF40C milling machine in the workshop', fraesenkonv=>'Conventional milling machine in the workshop',
  schleifen=>'Conventional surface grinding machine', saegen=>'Saw cutting bar stock',
  messplatz=>'Micro-Hite height gauge measuring a shaft' };

# specification labels
$T{de}{spec} = { typ=>'Typ', verfahrwege=>'Maximale Verfahrwege (X × Y × Z)', aufspannflaeche=>'Aufspannfläche',
  werkzeugwechsler=>'Werkzeugwechsler', spindel=>'Spindel', steuerung=>'Steuerung', spezielles=>'Spezielles',
  drehdurchmesser=>'Drehdurchmesser', drehdurchmesserschlitten=>'Drehdurchmesser über Schlitten',
  drehdurchmesserbett=>'Drehdurchmesser über Bett', stangendurchlass=>'Stangendurchlass', spitzenweite=>'Spitzenweite',
  drehlaenge=>'Drehlänge', werkzeugplaetze=>'Werkzeugplätze', anwendungsbereich=>'Anwendungsbereich',
  fehlergrenze=>'Fehlergrenze', wiederholbarkeit=>'Wiederholbarkeit', rund=>'Rund', viereckig=>'Viereckig',
  rechteckig=>'Rechteckig', arbeitsflaeche=>'Arbeitsfläche mit Magnetplatte',
  abstand=>'Grösste Entfernung zwischen Tischfläche und Schleifspindel', werkstueckgewicht=>'Maximales Werkstückgewicht' };
$T{fr}{spec} = { typ=>'Type', verfahrwege=>'Courses maximales (X × Y × Z)', aufspannflaeche=>'Surface de serrage',
  werkzeugwechsler=>"Changeur d'outils", spindel=>'Broche', steuerung=>'Commande', spezielles=>'Particularités',
  drehdurchmesser=>'Diamètre de tournage', drehdurchmesserschlitten=>'Diamètre de tournage au-dessus du chariot',
  drehdurchmesserbett=>'Diamètre de tournage au-dessus du banc', stangendurchlass=>'Passage de barre', spitzenweite=>'Distance entre pointes',
  drehlaenge=>'Longueur de tournage', werkzeugplaetze=>"Postes d'outils", anwendungsbereich=>'Plage de mesure',
  fehlergrenze=>'Erreur maximale tolérée', wiederholbarkeit=>'Répétabilité', rund=>'Rond', viereckig=>'Carré',
  rechteckig=>'Rectangulaire', arbeitsflaeche=>'Surface de travail avec plateau magnétique',
  abstand=>'Distance maximale entre la table et la broche de rectification', werkstueckgewicht=>'Poids maximal de la pièce' };
$T{it}{spec} = { typ=>'Tipo', verfahrwege=>'Corse massime (X × Y × Z)', aufspannflaeche=>'Superficie di serraggio',
  werkzeugwechsler=>'Cambio utensili', spindel=>'Mandrino', steuerung=>'Controllo', spezielles=>'Caratteristiche particolari',
  drehdurchmesser=>'Diametro di tornitura', drehdurchmesserschlitten=>'Diametro di tornitura sopra il carro',
  drehdurchmesserbett=>'Diametro di tornitura sopra il banco', stangendurchlass=>'Passaggio barra', spitzenweite=>'Distanza tra le punte',
  drehlaenge=>'Lunghezza di tornitura', werkzeugplaetze=>'Posti utensile', anwendungsbereich=>'Campo di misura',
  fehlergrenze=>'Errore massimo ammesso', wiederholbarkeit=>'Ripetibilità', rund=>'Tondo', viereckig=>'Quadro',
  rechteckig=>'Rettangolare', arbeitsflaeche=>'Superficie di lavoro con piano magnetico',
  abstand=>'Distanza massima tra tavola e mandrino di rettifica', werkstueckgewicht=>'Peso massimo del pezzo' };
$T{en}{spec} = { typ=>'Type', verfahrwege=>'Maximum travels (X × Y × Z)', aufspannflaeche=>'Clamping area',
  werkzeugwechsler=>'Tool changer', spindel=>'Spindle', steuerung=>'Control', spezielles=>'Special features',
  drehdurchmesser=>'Turning diameter', drehdurchmesserschlitten=>'Turning diameter over the carriage',
  drehdurchmesserbett=>'Turning diameter over the bed', stangendurchlass=>'Bar capacity', spitzenweite=>'Distance between centres',
  drehlaenge=>'Turning length', werkzeugplaetze=>'Tool stations', anwendungsbereich=>'Measuring range',
  fehlergrenze=>'Maximum permissible error', wiederholbarkeit=>'Repeatability', rund=>'Round', viereckig=>'Square',
  rechteckig=>'Rectangular', arbeitsflaeche=>'Working area with magnetic chuck',
  abstand=>'Maximum distance between table and grinding spindle', werkstueckgewicht=>'Maximum workpiece weight' };

# ---------------------------------------------------------------- kontakt ---
$T{de}{kontakt} = { desc=>'Kontakt zur deico AG Präzisionsmechanik in Wald, Zürcher Oberland.',
  eyebrow=>'Kontakt', h1=>'Wir freuen uns auf Ihre Anfrage',
  lede=>'Senden Sie uns Ihre 3D-Daten oder Zeichnung und wir erstellen Ihnen ein unverbindliches Angebot.',
  people=>'Ansprechpartner', gf=>'Dipl. Ing. FH, Geschäftsführer', sgf=>'Dipl. Ing. FH, stv. Geschäftsführer',
  reach=>'So erreichen Sie uns', phone=>'Telefon', langs=>'Deutsch und Englisch', email=>'E-Mail',
  addresses=>'Adressen', delivery=>'Lieferadresse und Werkstatt', billing=>'Rechnungsadresse', vat=>'MWST-Nummer',
  formh=>'Kontaktformular',
  formnote=>'Dieses Formular ist ein Entwurf für die Abnahme und versendet nichts. Bitte nutzen Sie in der Zwischenzeit Telefon oder E-Mail.',
  f_company=>'Firma', f_name=>'Name', f_email=>'E-Mail', f_message=>'Nachricht',
  f_required=>'Pflichtfeld', f_submit=>'Nachricht senden',
  f_privacy=>'Es gilt die Datenschutzerklärung.' };
$T{fr}{kontakt} = { desc=>'Contact deico AG mécanique de précision à Wald, Oberland zurichois.',
  eyebrow=>'Contact', h1=>'Nous nous réjouissons de votre demande',
  lede=>'Envoyez-nous vos données 3D ou votre plan et nous vous établirons une offre sans engagement.',
  people=>'Interlocuteurs', gf=>'Dipl. Ing. FH, directeur', sgf=>'Dipl. Ing. FH, directeur adjoint',
  reach=>'Comment nous joindre', phone=>'Téléphone', langs=>'allemand et anglais', email=>'E-mail',
  addresses=>'Adresses', delivery=>'Adresse de livraison et atelier', billing=>'Adresse de facturation', vat=>'Numéro de TVA',
  formh=>'Formulaire de contact',
  formnote=>"Ce formulaire est une maquette destinée à la validation et n'envoie rien. Merci d'utiliser le téléphone ou l'e-mail en attendant.",
  f_company=>'Entreprise', f_name=>'Nom', f_email=>'E-mail', f_message=>'Message',
  f_required=>'Champ obligatoire', f_submit=>'Envoyer le message',
  f_privacy=>'La politique de confidentialité s\'applique.' };
$T{it}{kontakt} = { desc=>'Contatto deico AG meccanica di precisione a Wald, Oberland zurighese.',
  eyebrow=>'Contatto', h1=>'Attendiamo la vostra richiesta',
  lede=>"Inviateci i vostri dati 3D o il disegno e vi prepareremo un'offerta senza impegno.",
  people=>'Referenti', gf=>'Dipl. Ing. FH, direttore', sgf=>'Dipl. Ing. FH, vicedirettore',
  reach=>'Come raggiungerci', phone=>'Telefono', langs=>'tedesco e inglese', email=>'E-mail',
  addresses=>'Indirizzi', delivery=>'Indirizzo di consegna e officina', billing=>'Indirizzo di fatturazione', vat=>'Numero IVA',
  formh=>'Modulo di contatto',
  formnote=>'Questo modulo è una bozza per la validazione e non invia nulla. Nel frattempo vi preghiamo di usare il telefono o l\'e-mail.',
  f_company=>'Azienda', f_name=>'Nome', f_email=>'E-mail', f_message=>'Messaggio',
  f_required=>'Campo obbligatorio', f_submit=>'Invia messaggio',
  f_privacy=>'Si applica l\'informativa sulla privacy.' };
$T{en}{kontakt} = { desc=>'Contact deico AG precision engineering in Wald, Zurich Oberland.',
  eyebrow=>'Contact', h1=>'We look forward to your enquiry',
  lede=>'Send us your 3D data or drawing and we will prepare a quotation without obligation.',
  people=>'Contacts', gf=>'Dipl. Ing. FH, Managing Director', sgf=>'Dipl. Ing. FH, Deputy Managing Director',
  reach=>'How to reach us', phone=>'Telephone', langs=>'German and English', email=>'Email',
  addresses=>'Addresses', delivery=>'Delivery address and workshop', billing=>'Billing address', vat=>'VAT number',
  formh=>'Contact form',
  formnote=>'This form is a draft for review and does not send anything. Please use the telephone or email in the meantime.',
  f_company=>'Company', f_name=>'Name', f_email=>'Email', f_message=>'Message',
  f_required=>'Required field', f_submit=>'Send message',
  f_privacy=>'The privacy policy applies.' };

# ------------------------------------------------------------------ legal ---
# Placeholder pages only. Real legal wording must come from the client or
# their lawyer; nothing here is drafted as if it were binding text.
$T{de}{legal} = { placeholder=>'Platzhalter',
  note=>'Dieser Text ist ein Platzhalter. Der verbindliche Wortlaut muss von der deico AG beziehungsweise deren Rechtsberatung geliefert werden.',
  imp_items=>['Firmenname und Rechtsform','Vollständige Adresse','Telefon und E-Mail','Handelsregisternummer','MWST-Nummer','Vertretungsberechtigte Personen'],
  ds_items=>['Verantwortliche Stelle','Welche Daten erhoben werden','Zweck der Bearbeitung','Rechtsgrundlage','Weitergabe an Dritte','Aufbewahrungsdauer','Rechte der betroffenen Personen','Kontakt für Datenschutzanfragen'],
  imp_intro=>'Auf dieser Seite stehen die Angaben zum Betreiber der Website. Zu erfassen sind mindestens:',
  ds_intro=>'Diese Seite beschreibt die Bearbeitung von Personendaten nach dem revidierten Schweizer Datenschutzgesetz. Zu erfassen sind mindestens:' };
$T{fr}{legal} = { placeholder=>'Espace réservé',
  note=>"Ce texte est un espace réservé. La formulation contraignante doit être fournie par deico AG ou par son conseil juridique.",
  imp_items=>["Raison sociale et forme juridique",'Adresse complète','Téléphone et e-mail','Numéro du registre du commerce','Numéro de TVA','Personnes habilitées à représenter'],
  ds_items=>['Responsable du traitement','Quelles données sont collectées','Finalité du traitement','Base légale','Transmission à des tiers','Durée de conservation','Droits des personnes concernées','Contact pour les questions de protection des données'],
  imp_intro=>"Cette page contient les informations sur l'exploitant du site. Doivent y figurer au minimum :",
  ds_intro=>'Cette page décrit le traitement des données personnelles selon la loi suisse révisée sur la protection des données. Doivent y figurer au minimum :' };
$T{it}{legal} = { placeholder=>'Segnaposto',
  note=>'Questo testo è un segnaposto. La formulazione vincolante deve essere fornita da deico AG o dalla sua consulenza legale.',
  imp_items=>['Ragione sociale e forma giuridica','Indirizzo completo','Telefono ed e-mail','Numero di registro di commercio','Numero IVA','Persone autorizzate a rappresentare'],
  ds_items=>['Titolare del trattamento','Quali dati vengono raccolti','Finalità del trattamento','Base giuridica','Trasmissione a terzi','Periodo di conservazione','Diritti degli interessati','Contatto per questioni di protezione dei dati'],
  imp_intro=>'Questa pagina contiene le informazioni sul gestore del sito. Devono figurare almeno:',
  ds_intro=>'Questa pagina descrive il trattamento dei dati personali secondo la legge svizzera riveduta sulla protezione dei dati. Devono figurare almeno:' };
$T{en}{legal} = { placeholder=>'Placeholder',
  note=>'This text is a placeholder. The binding wording must be supplied by deico AG or their legal advisers.',
  imp_items=>['Company name and legal form','Full address','Telephone and email','Commercial register number','VAT number','Authorised representatives'],
  ds_items=>['Data controller','What data is collected','Purpose of processing','Legal basis','Disclosure to third parties','Retention period','Rights of data subjects','Contact for data protection enquiries'],
  imp_intro=>'This page carries the details of the site operator. It must state at least:',
  ds_intro=>'This page describes the processing of personal data under the revised Swiss Data Protection Act. It must state at least:' };

1;
