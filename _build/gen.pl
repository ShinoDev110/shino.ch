#!/usr/bin/perl
# Generates all 24 language pages for deico in the Axis Industrial language.
# /deico/index.html (the language gate) and /deico/styleguide.html are
# hand-written and untouched here.
use strict; use warnings; use utf8;
binmode(STDOUT, ':encoding(UTF-8)');

my $SP = "C:/Repo/WebSites/shino.ch/_build";
my $ROOT = "C:/Repo/WebSites/shino.ch/deico";

require "$SP/content.pl";
require "$SP/strings.pl";
require "$SP/strings2.pl";
require "$SP/strings3.pl";
require "$SP/strings4.pl";

our (@LANGS, %TAG, %NAME, $SITE, @SLUGS, %IMG, @MACHINES, @CAX, %CONTACT, @PEOPLE, %T);

# --- generated image manifests ----------------------------------------------
my (@MPIMG, @SR, %ALT);
{
  open my $f, '<:encoding(UTF-8)', "$SP/mp-built.tsv" or die $!;
  while (<$f>) { chomp; my @c = split /\t/; push @MPIMG, { name=>$c[1], dim=>$c[2], w=>[split /,/, $c[3]] }; }
  close $f;
  open my $g, '<:encoding(UTF-8)', "$SP/sr-built.tsv" or die $!;
  while (<$g>) { chomp; my @c = split /\t/; push @SR, { name=>$c[1], dim=>$c[2], w=>[split /,/, $c[3]], alt=>$c[4] }; }
  close $g;
  open my $h, '<:encoding(UTF-8)', "$SP/alt-i18n.tsv" or die $!;
  while (<$h>) { chomp; next unless length; my @c = split /\t/; $ALT{$c[0]} = { de=>$c[0], fr=>$c[1], it=>$c[2], en=>$c[3] }; }
  close $h;
}

# Showroom photo descriptions, keyed by image name. Edit
# _build/showroom-descriptions.tsv; comment lines start with #.
our %DESC;
{
  open my $d, '<:encoding(UTF-8)', "$SP/showroom-descriptions.tsv" or die $!;
  while (my $l = <$d>) {
    chomp $l;
    next if $l =~ /^\s*(#|$)/;
    my ($id, $name, $de, $fr, $it, $en) = split /\t/, $l;
    next unless $name;
    $DESC{$name} = { de=>$de, fr=>$fr, it=>$it, en=>$en };
  }
  close $d;
}
my %MPBY = map { $_->{name} => $_ } @MPIMG;

sub esc { my $s = shift // ''; $s =~ s/&/&amp;/g; $s =~ s/</&lt;/g; $s =~ s/>/&gt;/g; $s =~ s/"/&quot;/g; return $s; }

sub picture {
  my (%o) = @_;
  my ($p,$file,$ws,$src,$dim,$alt,$sizes,$lazy,$prio) = @o{qw(prefix file widths src dim alt sizes lazy priority)};
  my ($w,$h) = split /x/, $dim;
  my $webp = join(', ', map { "${p}assets/img/$file-$_.webp $_" . "w" } @$ws);
  my $jpg  = join(', ', map { "${p}assets/img/$file-$_.jpg $_" . "w" } @$ws);
  my $attr = $lazy ? ' loading="lazy" decoding="async"' : ($prio ? ' fetchpriority="high"' : '');
  return '<picture>'
    . qq{<source srcset="$webp" sizes="$sizes" type="image/webp">}
    . qq{<img src="${p}assets/img/$file-$src.jpg" srcset="$jpg" sizes="$sizes" width="$w" height="$h"$attr alt="} . esc($alt) . '">'
    . '</picture>';
}

my $SZ_CARD  = '(min-width: 768px) 30vw, calc(100vw - 2rem)';
my $SZ_MEDIA = '(min-width: 768px) 46vw, calc(100vw - 2rem)';
my $SZ_GAL   = '(min-width: 1024px) 22vw, (min-width: 600px) 30vw, calc(50vw - 1.5rem)';

sub img_for {
  my ($key,$lang,$p,%o) = @_;
  my $i = $IMG{$key};
  return picture(prefix=>$p, file=>$i->{file}, widths=>$i->{w}, src=>$i->{src},
                 dim=>$i->{dim}, alt=>$T{$lang}{alt}{$key}, %o);
}

# --------------------------------------------------------------- chrome ----
sub head_html {
  my ($lang,$si,$title,$desc,$p) = @_;
  my $slug = $SLUGS[$si];
  my $o = qq{<!DOCTYPE html>\n<html lang="$TAG{$lang}" class="no-js">\n<head>\n};
  $o .= qq{<meta charset="utf-8">\n<meta name="viewport" content="width=device-width, initial-scale=1">\n};
  $o .= qq{<meta name="robots" content="noindex, nofollow">\n};
  $o .= '<title>' . esc($title) . "</title>\n";
  $o .= qq{<meta name="description" content="} . esc($desc) . qq{">\n\n};
  for my $l (@LANGS) {
    my $href = $slug eq '' ? "$p$l/" : "$p$l/$slug/";
    $o .= qq{<link rel="alternate" hreflang="$TAG{$l}" href="$href">\n};
  }
  $o .= qq{<link rel="alternate" hreflang="x-default" href="} . ($slug eq '' ? "${p}de/" : "${p}de/$slug/") . qq{">\n\n};
  $o .= qq{<link rel="icon" href="${p}favicon.ico" sizes="16x16 32x32 48x48">\n};
  $o .= qq{<link rel="icon" type="image/png" sizes="192x192" href="${p}assets/icon/icon-192.png">\n};
  $o .= qq{<link rel="icon" type="image/png" sizes="512x512" href="${p}assets/icon/icon-512.png">\n};
  $o .= qq{<link rel="apple-touch-icon" href="${p}assets/icon/apple-touch-icon.png">\n};
  $o .= qq{<meta name="theme-color" content="#5E61ED">\n\n};
  $o .= qq{<link rel="preload" as="font" type="font/woff2" href="${p}assets/fonts/space-grotesk-latin.woff2" crossorigin>\n};
  $o .= qq{<link rel="preload" as="font" type="font/woff2" href="${p}assets/fonts/jetbrains-mono-latin.woff2" crossorigin>\n\n};
  $o .= qq{<link rel="stylesheet" href="${p}css/reset.css?v=2">\n};
  $o .= qq{<link rel="stylesheet" href="${p}css/tokens.css?v=2">\n};
  $o .= qq{<link rel="stylesheet" href="${p}css/main.css?v=2">\n};
  $o .= qq{<script>document.documentElement.className = "js";</script>\n</head>\n<body>\n\n};
  return $o;
}

sub header_html {
  my ($lang,$si,$p) = @_;
  my $ui = $T{$lang}{ui}; my $nav = $T{$lang}{nav};
  my $o = qq{<a class="skip-link" href="#main">} . esc($ui->{skip}) . qq{</a>\n\n};
  $o .= qq{<header class="head">\n  <div class="wrap head__in">\n};
  $o .= qq{    <a class="head__logo" href="$p$lang/" aria-label="} . esc("$SITE, $ui->{homelabel}") . qq{">\n};
  $o .= qq{      <picture><source srcset="${p}assets/logo/deico-logo-340.webp 340w, ${p}assets/logo/deico-logo-680.webp 680w" sizes="(min-width: 1024px) 91px, 79px" type="image/webp">};
  $o .= qq{<img src="${p}assets/logo/deico-logo-340.png" width="340" height="120" alt="} . esc($SITE) . qq{"></picture>\n    </a>\n\n};
  $o .= qq{    <button class="navtoggle" type="button" aria-expanded="false" aria-controls="nav">\n};
  $o .= qq{      <span class="navtoggle__bars"></span>\n      <span class="visually-hidden">} . esc($ui->{menu}) . qq{</span>\n    </button>\n\n};
  $o .= qq{    <nav class="nav" id="nav" aria-label="} . esc($ui->{navlabel}) . qq{">\n      <ul>\n};
  for my $k (0..3) {
    my $href = $SLUGS[$k] eq '' ? "$p$lang/" : "$p$lang/$SLUGS[$k]/";
    my $cur = ($k == $si) ? ' aria-current="page"' : '';
    $o .= qq{        <li><a href="$href"$cur>} . esc($nav->[$k]) . qq{</a></li>\n};
  }
  $o .= qq{      </ul>\n    </nav>\n\n};
  $o .= qq{    <details class="lang">\n      <summary aria-label="} . esc($ui->{langlabel}) . qq{">} . uc($lang) . qq{</summary>\n      <ul class="lang-list">\n};
  for my $l (@LANGS) {
    my $href = $SLUGS[$si] eq '' ? "$p$l/" : "$p$l/$SLUGS[$si]/";
    my $cur = ($l eq $lang) ? ' aria-current="true"' : '';
    $o .= qq{        <li><a href="$href" hreflang="$TAG{$l}" lang="$TAG{$l}"$cur>} . esc($NAME{$l}) . qq{ <span class="lang-code">$l</span></a></li>\n};
  }
  $o .= qq{      </ul>\n    </details>\n  </div>\n</header>\n\n};
  return $o;
}

sub footer_html {
  my ($lang,$p) = @_;
  my $ui = $T{$lang}{ui}; my $nav = $T{$lang}{nav};
  my $o = qq{<footer class="foot">\n  <div class="wrap">\n    <div class="foot__grid">\n};
  $o .= qq{      <div>\n        <p class="foot__title">$CONTACT{company}</p>\n};
  $o .= qq{        <address>$CONTACT{street}<br>$CONTACT{city}<br>} . esc($ui->{country}) . qq{</address>\n};
  $o .= qq{        <p class="mt-1"><a href="tel:$CONTACT{phoneraw}">$CONTACT{phone}</a><br><a href="mailto:$CONTACT{email}">$CONTACT{email}</a></p>\n      </div>\n};
  $o .= qq{      <nav aria-label="} . esc($ui->{navtitle}) . qq{">\n        <p class="foot__title">} . esc($ui->{navtitle}) . qq{</p>\n        <ul>\n};
  for my $k (0..3) {
    my $href = $SLUGS[$k] eq '' ? "$p$lang/" : "$p$lang/$SLUGS[$k]/";
    $o .= qq{          <li><a href="$href">} . esc($nav->[$k]) . qq{</a></li>\n};
  }
  $o .= qq{        </ul>\n      </nav>\n};
  $o .= qq{      <nav aria-label="} . esc($ui->{legtitle}) . qq{">\n        <p class="foot__title">} . esc($ui->{legtitle}) . qq{</p>\n        <ul>\n};
  $o .= qq{          <li><a href="$p$lang/$SLUGS[$_]/">} . esc($nav->[$_]) . qq{</a></li>\n} for (4,5);
  $o .= qq{        </ul>\n      </nav>\n    </div>\n};
  $o .= qq{    <div class="foot__bottom">\n      <p>&copy; 2026 $CONTACT{company}</p>\n      <p>} . esc($ui->{staging}) . qq{</p>\n    </div>\n  </div>\n</footer>\n\n};
  $o .= qq{<script src="${p}js/main.js?v=2" defer></script>\n</body>\n</html>\n};
  return $o;
}

# ------------------------------------------------------------------ home ----
sub body_home {
  my ($lang,$p) = @_;
  my $h = $T{$lang}{home}; my $a = $T{$lang}{ax};
  my $o = qq{<main id="main">\n\n};

  # hero
  $o .= qq{  <section class="hero">\n    <div class="wrap">\n};
  $o .= qq{      <span class="label">} . esc($h->{eyebrow}) . qq{</span>\n};
  $o .= qq{      <h1 class="hero__title">} . esc($h->{h1}) . qq{</h1>\n};
  $o .= qq{      <p class="hero__lede">} . esc($h->{lede}) . qq{</p>\n};
  $o .= qq{      <div class="hero__actions">\n};
  $o .= qq{        <a class="btn btn--primary" href="$p$lang/kontakt/">} . esc($h->{cta1}) . qq{</a>\n};
  $o .= qq{        <a class="btn btn--secondary" href="$p$lang/maschinenpark/">} . esc($T{$lang}{nav}[2]) . qq{</a>\n      </div>\n\n};
  $o .= qq{      <dl class="factstrip">\n};
  my @facts = (['f1l',"ab 1",'f1u'], ['f2l','5','f2u'], ['f3l','&le; 1','f3u'], ['f4l','8636','f4u']);
  for my $f (@facts) {
    $o .= qq{        <div><dt>} . esc($a->{$f->[0]}) . qq{</dt><dd><span class="stat">$f->[1]</span> <span class="factstrip__unit">} . esc($a->{$f->[2]}) . qq{</span></dd></div>\n};
  }
  $o .= qq{      </dl>\n    </div>\n  </section>\n\n};

  # full-bleed band
  my $hb = $IMG{hero};
  $o .= qq{  <figure class="fig fig--overlay band">\n    };
  $o .= picture(prefix=>$p, file=>$hb->{file}, widths=>[768,1152,1600,1920], src=>1152,
                dim=>'1152x648', alt=>$T{$lang}{alt}{hero}, sizes=>'100vw', priority=>1);
  $o .= qq{\n    <figcaption><b>01</b>&nbsp;&nbsp;} . esc($a->{band}) . qq{</figcaption>\n  </figure>\n\n};

  # services
  $o .= qq{  <section class="section" aria-labelledby="leistungen">\n    <div class="wrap">\n};
  $o .= qq{      <span class="label">} . esc($h->{s1eyebrow}) . qq{</span>\n      <h2 id="leistungen">} . esc($h->{s1h2}) . qq{</h2>\n};
  $o .= qq{      <p class="hero__lede">} . esc($h->{s1lede}) . qq{</p>\n\n      <ul class="cards mt-gap">\n};
  my @svc = (['c1','drehen','c1lab',0], ['c2','fraesen','c2lab',0], ['c3','fem','c3lab',1]);
  my $n = 0;
  for my $c (@svc) {
    $n++;
    my $keep = $c->[3] ? ' fig--keep-colour' : '';
    $o .= qq{        <li class="card">\n          <figure class="fig fig--card$keep">} . img_for($c->[1],$lang,$p,sizes=>$SZ_CARD,lazy=>1) . qq{</figure>\n};
    $o .= qq{          <div class="card__body">\n            <span class="label">0$n / } . esc($a->{$c->[2]}) . qq{</span>\n};
    $o .= qq{            <h3 class="card__name">} . esc($h->{$c->[0].'h'}) . qq{</h3>\n            <p>} . esc($h->{$c->[0].'p'}) . qq{</p>\n          </div>\n        </li>\n};
  }
  $o .= qq{      </ul>\n    </div>\n  </section>\n\n};

  # data grid
  $o .= qq{  <section class="section section--surface" aria-labelledby="zahlen">\n    <div class="wrap">\n};
  $o .= qq{      <span class="label">} . esc($a->{zahlen}) . qq{</span>\n      <h2 id="zahlen">} . esc($a->{zahlenh}) . qq{</h2>\n\n      <div class="bento mt-gap">\n};
  $o .= qq{        <div class="bento__item bento__item--ink bento__item--w6"><span class="label label--invert">} . esc($a->{b1}) . qq{</span><p class="stat">635 × 535 × 460</p><p>} . esc($a->{b1n}) . qq{</p></div>\n};
  $o .= qq{        <div class="bento__item bento__item--accent bento__item--w6"><span class="label">} . esc($a->{b2}) . qq{</span><p class="stat">&le; 1 µm</p><p>} . esc($a->{b2n}) . qq{</p></div>\n};
  $o .= qq{        <div class="bento__item bento__item--w4"><span class="label">} . esc($a->{b3}) . qq{</span><p class="stat">Ø 340</p><p>} . esc($a->{b3n}) . qq{</p></div>\n};
  $o .= qq{        <div class="bento__item bento__item--w4"><span class="label">} . esc($a->{b4}) . qq{</span><p class="stat">15'000</p><p>} . esc($a->{b4n}) . qq{</p></div>\n};
  $o .= qq{        <div class="bento__item bento__item--w4"><span class="label">} . esc($a->{b5}) . qq{</span><p class="stat">9</p><p>} . esc($a->{b5n}) . qq{</p></div>\n};
  $o .= qq{        <div class="bento__item bento__item--w12"><span class="label">} . esc($a->{b6}) . qq{</span><p class="data data--body">} . esc($a->{b6v}) . qq{</p></div>\n};
  $o .= qq{      </div>\n    </div>\n  </section>\n\n};

  # split, dark
  $o .= qq{  <section class="section section--ink" aria-labelledby="idee">\n    <div class="wrap">\n      <div class="split">\n        <div class="split__text">\n};
  $o .= qq{          <span class="label label--invert">} . esc($h->{s2eyebrow}) . qq{</span>\n          <h2 id="idee">} . esc($h->{s2h2}) . qq{</h2>\n};
  $o .= qq{          <p>} . esc($h->{s2p1}) . qq{</p>\n          <p>} . esc($h->{s2p2}) . qq{</p>\n};
  $o .= qq{          <p><a class="btn btn--light" href="$p$lang/kontakt/">} . esc($h->{s2link}) . qq{</a></p>\n        </div>\n};
  $o .= qq{        <div class="split__media"><figure class="fig fig--card">} . img_for('zeichnung',$lang,$p,sizes=>$SZ_MEDIA,lazy=>1) . qq{</figure></div>\n      </div>\n    </div>\n  </section>\n\n};

  # capabilities
  $o .= qq{  <section class="section" aria-labelledby="staerken">\n    <div class="wrap">\n};
  $o .= qq{      <span class="label">} . esc($h->{s3eyebrow}) . qq{</span>\n      <h2 id="staerken">} . esc($h->{s3h2}) . qq{</h2>\n\n      <ul class="cards mt-gap">\n};
  my @feat = (['f1','werkstoffe'], ['f2','automation'], ['f3','messung'], ['f4','lieferung'], ['f5','laser'], ['f6','oberflaeche']);
  for my $i (0..$#feat) {
    my $f = $feat[$i];
    $o .= qq{        <li class="card">\n          <figure class="fig fig--card">} . img_for($f->[1],$lang,$p,sizes=>$SZ_CARD,lazy=>1) . qq{</figure>\n};
    $o .= qq{          <div class="card__body">\n            <span class="label">} . esc($a->{flabs}[$i]) . qq{</span>\n};
    $o .= qq{            <h3 class="card__name">} . esc($h->{$f->[0].'h'}) . qq{</h3>\n            <p>} . esc($h->{$f->[0].'p'}) . qq{</p>\n          </div>\n        </li>\n};
  }
  $o .= qq{      </ul>\n    </div>\n  </section>\n\n};

  # special solutions
  $o .= qq{  <section class="section section--surface" aria-labelledby="sonder">\n    <div class="wrap">\n};
  $o .= qq{      <span class="label">} . esc($h->{s4eyebrow}) . qq{</span>\n      <h2 id="sonder">} . esc($h->{s4h2}) . qq{</h2>\n\n      <ul class="cards mt-gap">\n};
  my @sp = (['d1','roboter'], ['d2','blech'], ['d3','montage']);
  for my $i (0..$#sp) {
    my $d = $sp[$i];
    $o .= qq{        <li class="card">\n          <figure class="fig fig--card">} . img_for($d->[1],$lang,$p,sizes=>$SZ_CARD,lazy=>1) . qq{</figure>\n};
    $o .= qq{          <div class="card__body">\n            <span class="label">} . esc($a->{dlabs}[$i]) . qq{</span>\n};
    $o .= qq{            <h3 class="card__name">} . esc($h->{$d->[0].'h'}) . qq{</h3>\n            <p>} . esc($h->{$d->[0].'p'}) . qq{</p>\n          </div>\n        </li>\n};
  }
  $o .= qq{      </ul>\n    </div>\n  </section>\n\n};

  # sectors
  $o .= qq{  <section class="section" aria-labelledby="branchen">\n    <div class="wrap">\n};
  $o .= qq{      <span class="label">} . esc($h->{s5eyebrow}) . qq{</span>\n      <h2 id="branchen">} . esc($h->{s5h2}) . qq{</h2>\n};
  $o .= qq{      <p class="hero__lede">} . esc($h->{s5lede}) . qq{</p>\n\n      <ul class="sectors mt-gap">\n};
  my $si2 = 0;
  for my $t (@{$h->{tags}}) { $si2++; $o .= sprintf(qq{        <li><span>%02d</span> %s</li>\n}, $si2, esc($t)); }
  $o .= qq{      </ul>\n    </div>\n  </section>\n\n};

  # cta
  $o .= qq{  <section class="cta" aria-labelledby="angebot">\n    <div class="wrap">\n};
  $o .= qq{      <span class="label">} . esc($h->{ctah}) . qq{</span>\n      <h2 id="angebot">} . esc($h->{ctap}) . qq{</h2>\n};
  $o .= qq{      <a class="btn btn--light" href="$p$lang/kontakt/">} . esc($h->{ctab}) . qq{</a>\n    </div>\n  </section>\n\n};

  $o .= qq{</main>\n\n};
  return $o;
}

# -------------------------------------------------------------- showroom ----
# Every tile is a link to the 1200w JPEG, so the gallery works with no script
# at all. main.js upgrades the click into a <dialog> and prefers the WebP
# named in data-full. The description lives in the DOM either way.
sub body_showroom {
  my ($lang,$p) = @_;
  my $s = $T{$lang}{showroom};
  my $lb = $T{$lang}{lb};
  my $o = qq{<main id="main">\n  <section class="section">\n    <div class="wrap">\n};
  $o .= qq{      <span class="label">} . esc($s->{eyebrow}) . qq{</span>\n      <h1>} . esc($s->{h1}) . qq{</h1>\n};
  $o .= qq{      <p class="hero__lede">} . esc($s->{lede}) . qq{</p>\n\n      <ul class="gallery mt-gap">\n};
  my $first = 1;
  for my $im (@SR) {
    my $alt = $ALT{$im->{alt}} ? $ALT{$im->{alt}}{$lang} : $im->{alt};
    my $d = $DESC{$im->{name}} ? $DESC{$im->{name}}{$lang} : '';
    $o .= qq{        <li>\n          <figure class="shot">\n};
    $o .= qq{            <a class="shot__link" href="${p}assets/img/$im->{name}-1200.jpg" data-full="${p}assets/img/$im->{name}-1200.webp">};
    $o .= picture(prefix=>$p, file=>$im->{name}, widths=>$im->{w}, src=>$im->{w}[0],
                  dim=>$im->{dim}, alt=>$alt, sizes=>$SZ_GAL, lazy=>($first?0:1));
    $o .= qq{</a>\n            <figcaption class="shot__cap">} . esc($d) . qq{</figcaption>\n          </figure>\n        </li>\n};
    $first = 0;
  }
  $o .= qq{      </ul>\n    </div>\n  </section>\n\n};

  # the dialog is inert until main.js opens it, and absent from the flow otherwise
  $o .= qq{  <dialog class="lightbox" id="lightbox" aria-label="} . esc($lb->{label}) . qq{">\n};
  $o .= qq{    <div class="lightbox__bar">\n      <p class="lightbox__count">1 / } . scalar(@SR) . qq{</p>\n};
  $o .= qq{      <button class="lightbox__btn" type="button" data-lb="prev">&larr;<span class="visually-hidden"> } . esc($lb->{prev}) . qq{</span></button>\n};
  $o .= qq{      <button class="lightbox__btn" type="button" data-lb="next">&rarr;<span class="visually-hidden"> } . esc($lb->{next}) . qq{</span></button>\n};
  $o .= qq{      <button class="lightbox__btn" type="button" data-lb="close" autofocus>} . esc($lb->{close}) . qq{</button>\n    </div>\n};
  $o .= qq{    <figure class="lightbox__figure">\n      <img class="lightbox__img" alt="" width="1200" height="900">\n    </figure>\n};
  $o .= qq{    <p class="lightbox__desc"></p>\n  </dialog>\n\n};
  $o .= qq{</main>\n\n};
  return $o;
}

# --------------------------------------------------------- maschinenpark ----
sub body_mp {
  my ($lang,$p) = @_;
  my $m = $T{$lang}{mp};
  my $o = qq{<main id="main">\n  <section class="section">\n    <div class="wrap">\n};
  $o .= qq{      <span class="label">} . esc($m->{eyebrow}) . qq{</span>\n      <h1>} . esc($m->{h1}) . qq{</h1>\n};
  $o .= qq{      <p class="hero__lede">} . esc($m->{lede}) . qq{</p>\n\n      <ul class="cards mt-gap">\n};
  my $i = 0;
  for my $mach (@MACHINES) {
    my $im = $MPBY{$mach->{img}} or next;
    $i++;
    $o .= qq{        <li class="card">\n          <figure class="fig fig--card">} . picture(prefix=>$p, file=>$im->{name},
             widths=>$im->{w}, src=>$im->{w}[-1], dim=>$im->{dim}, alt=>$T{$lang}{machalt}{$mach->{key}},
             sizes=>$SZ_CARD, lazy=>($i>1?1:0)) . qq{</figure>\n};
    $o .= qq{          <div class="card__body">\n            <span class="label">} . sprintf('%02d', $i) . qq{ / } . esc($T{$lang}{mach}{$mach->{key}}) . qq{</span>\n};
    my $name = '';
    for my $sp (@{$mach->{specs}}) { if ($sp->[0] eq 'typ') { $name = ref($sp->[1]) eq 'HASH' ? $sp->[1]{$lang} : $sp->[1]; last; } }
    $name = $T{$lang}{mach}{$mach->{key}} unless length $name;
    $o .= qq{            <h3 class="card__name">} . esc($name) . qq{</h3>\n            <dl class="specs">\n};
    for my $sp (@{$mach->{specs}}) {
      next if $sp->[0] eq 'typ';
      my $val = ref($sp->[1]) eq 'HASH' ? $sp->[1]{$lang} : $sp->[1];
      $o .= qq{              <div><dt>} . esc($T{$lang}{spec}{$sp->[0]}) . qq{</dt><dd>} . esc($val) . qq{</dd></div>\n};
    }
    $o .= qq{            </dl>\n          </div>\n        </li>\n};
  }
  $o .= qq{      </ul>\n\n      <h2 class="mt-gap">} . esc($m->{caxh}) . qq{</h2>\n      <div class="bento mt-gap">\n};
  for my $c (@CAX) {
    $o .= qq{        <div class="bento__item bento__item--w4"><span class="label">$c->[0]</span><p class="data data--body">$c->[1]</p></div>\n};
  }
  $o .= qq{      </div>\n    </div>\n  </section>\n</main>\n\n};
  return $o;
}

# --------------------------------------------------------------- kontakt ----
sub body_kontakt {
  my ($lang,$p) = @_;
  my $k = $T{$lang}{kontakt};
  my $o = qq{<main id="main">\n  <section class="section">\n    <div class="wrap">\n};
  $o .= qq{      <span class="label">} . esc($k->{eyebrow}) . qq{</span>\n      <h1>} . esc($k->{h1}) . qq{</h1>\n};
  $o .= qq{      <p class="hero__lede">} . esc($k->{lede}) . qq{</p>\n\n      <div class="contact mt-gap">\n};

  $o .= qq{        <div class="contact__col">\n};
  $o .= qq{          <dl class="contact__row"><dt>} . esc($k->{billing}) . qq{</dt><dd><address>$CONTACT{company}<br>$CONTACT{billing}<br>$CONTACT{billcity}</address></dd></dl>\n};
  $o .= qq{          <dl class="contact__row"><dt>} . esc($k->{delivery}) . qq{</dt><dd><address>$CONTACT{company}<br>$CONTACT{workshop}<br>$CONTACT{workcity}</address></dd></dl>\n};
  $o .= qq{          <dl class="contact__row"><dt>} . esc($k->{vat}) . qq{</dt><dd>$CONTACT{vat}</dd></dl>\n        </div>\n};

  $o .= qq{        <div class="contact__col">\n};
  $o .= qq{          <dl class="contact__row"><dt>} . esc($k->{phone}) . qq{ (} . esc($k->{langs}) . qq{)</dt><dd><a href="tel:$CONTACT{phoneraw}">$CONTACT{phone}</a></dd></dl>\n};
  $o .= qq{          <dl class="contact__row"><dt>} . esc($k->{email}) . qq{</dt><dd><a href="mailto:$CONTACT{email}">$CONTACT{email}</a></dd></dl>\n};
  $o .= qq{          <dl class="contact__row"><dt>} . esc($k->{people}) . qq{</dt><dd>\n            <ul class="people">\n};
  for my $per (@PEOPLE) {
    $o .= qq{              <li><strong>} . esc($per->{name}) . qq{</strong><br><span class="data">} . esc($k->{$per->{role}}) . qq{</span></li>\n};
  }
  $o .= qq{            </ul>\n          </dd></dl>\n        </div>\n      </div>\n\n};

  # mockup form: no action, disabled submit, main.js also cancels submit
  $o .= qq{      <h2 class="mt-gap">} . esc($k->{formh}) . qq{</h2>\n};
  $o .= qq{      <p class="notice mt-gap" id="form-note">} . esc($k->{formnote}) . qq{</p>\n};
  $o .= qq{      <form class="form mt-gap" data-mockup="true" aria-describedby="form-note">\n};
  for my $fld (['company','text','organization'], ['name','text','name'], ['email','email','email']) {
    my ($id,$type,$ac) = @$fld;
    $o .= qq{        <div class="form__field">\n          <label for="f-$id">} . esc($k->{"f_$id"}) . qq{ <span class="form__req" title="} . esc($k->{f_required}) . qq{">*</span></label>\n};
    $o .= qq{          <input id="f-$id" name="$id" type="$type" autocomplete="$ac" required>\n        </div>\n};
  }
  $o .= qq{        <div class="form__field">\n          <label for="f-message">} . esc($k->{f_message}) . qq{ <span class="form__req" title="} . esc($k->{f_required}) . qq{">*</span></label>\n};
  $o .= qq{          <textarea id="f-message" name="message" rows="6" required></textarea>\n        </div>\n};
  $o .= qq{        <p class="form__privacy"><a href="$p$lang/datenschutz/">} . esc($k->{f_privacy}) . qq{</a></p>\n};
  $o .= qq{        <button class="btn btn--primary" type="submit" disabled>} . esc($k->{f_submit}) . qq{</button>\n      </form>\n};
  $o .= qq{    </div>\n  </section>\n</main>\n\n};
  return $o;
}

# --------------------------------------------------------------- impressum ----
# Still a placeholder: the client has not supplied Impressum wording.
sub body_impressum {
  my ($lang,$p) = @_;
  my $g = $T{$lang}{legal};
  my $o = qq{<main id="main">\n  <section class="section">\n    <div class="wrap">\n      <div class="prose">\n};
  $o .= qq{        <span class="label">} . esc($g->{placeholder}) . qq{</span>\n        <h1>} . esc($T{$lang}{nav}[4]) . qq{</h1>\n};
  $o .= qq{        <p class="notice">} . esc($g->{note}) . qq{</p>\n        <p>} . esc($g->{imp_intro}) . qq{</p>\n        <ul class="checklist">\n};
  $o .= qq{          <li>} . esc($_) . qq{</li>\n} for @{$g->{imp_items}};
  $o .= qq{        </ul>\n      </div>\n    </div>\n  </section>\n</main>\n\n};
  return $o;
}

# ------------------------------------------------------------ datenschutz ----
# The client's official wording, supplied 2026-08-22. Paragraphs are trusted
# HTML (several contain links) and are emitted unescaped on purpose.
sub body_datenschutz {
  my ($lang,$p) = @_;
  my $d = $T{$lang}{privacy};
  my $o = qq{<main id="main">\n  <section class="section">\n    <div class="wrap">\n      <div class="prose">\n};
  $o .= qq{        <h1>} . esc($T{$lang}{nav}[5]) . qq{</h1>\n};
  # non-German pages name the German version as the authoritative one
  $o .= qq{        <p class="notice">} . esc($d->{authoritative}) . qq{</p>\n} if $d->{authoritative};
  for my $sec (@{$d->{sections}}) {
    $o .= qq{        <h2>} . esc($sec->{h}) . qq{</h2>\n};
    $o .= qq{        <p>$_</p>\n} for @{$sec->{p}};
  }
  $o .= qq{      </div>\n    </div>\n  </section>\n</main>\n\n};
  return $o;
}

# ------------------------------------------------------------------ main ----
my $count = 0;
for my $lang (@LANGS) {
  for my $si (0..$#SLUGS) {
    my $slug = $SLUGS[$si];
    my ($out,$p) = $slug eq '' ? ("$ROOT/$lang/index.html", '../') : ("$ROOT/$lang/$slug/index.html", '../../');
    my ($title,$desc,$body);
    if    ($si == 0) { $title = $SITE;                       $desc = $T{$lang}{home}{desc};     $body = body_home($lang,$p); }
    elsif ($si == 1) { $title = "$T{$lang}{nav}[1] | $SITE"; $desc = $T{$lang}{showroom}{desc}; $body = body_showroom($lang,$p); }
    elsif ($si == 2) { $title = "$T{$lang}{nav}[2] | $SITE"; $desc = $T{$lang}{mp}{desc};       $body = body_mp($lang,$p); }
    elsif ($si == 3) { $title = "$T{$lang}{nav}[3] | $SITE"; $desc = $T{$lang}{kontakt}{desc};  $body = body_kontakt($lang,$p); }
    elsif ($si == 4) { $title = "$T{$lang}{nav}[4] | $SITE"; $desc = $SITE;                     $body = body_impressum($lang,$p); }
    else             { $title = "$T{$lang}{nav}[5] | $SITE"; $desc = $SITE;                     $body = body_datenschutz($lang,$p); }

    open my $fh, '>:encoding(UTF-8)', $out or die "$out: $!";
    print $fh head_html($lang,$si,$title,$desc,$p), header_html($lang,$si,$p), $body, footer_html($lang,$p);
    close $fh;
    $count++;
  }
}
print "generated $count pages in the Axis language\n";
