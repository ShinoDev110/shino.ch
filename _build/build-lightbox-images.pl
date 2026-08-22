#!/usr/bin/perl
# 1200w renditions for the showroom lightbox. The grid tiles are 300/600; an
# enlarged view on a 1440px screen needs roughly 960px, so 1200 covers it.
use strict; use warnings; use utf8;
my $SRC = "C:/Repo/WebSites/shino.ch/deico/assets/_src";
my $OUT = "C:/Repo/WebSites/shino.ch/deico/assets/img";
$ENV{PATH} .= ";C:\Program Files\ImageMagick-7.1.2-Q16-HDRI";
open my $in, '<:encoding(UTF-8)', "C:/Repo/WebSites/shino.ch/_build/sr-built.tsv" or die $!;
my ($n, $bytes) = (0, 0);
while (my $l = <$in>) {
  chomp $l; next unless length $l;
  my ($id, $name) = split /\t/, $l;
  my ($f) = glob("$SRC/$id.*");
  next unless $f && -e $f;
  my $natw = `magick identify -format "%w" "$f"`; chomp $natw;
  my $w = $natw < 1200 ? $natw : 1200;
  system(qq{magick "$f" -auto-orient -strip -resize ${w}x -quality 80 -define webp:method=6 "$OUT/$name-1200.webp"});
  system(qq{magick "$f" -auto-orient -strip -resize ${w}x -quality 82 -interlace Plane -sampling-factor 4:2:0 "$OUT/$name-1200.jpg"});
  $bytes += (-s "$OUT/$name-1200.webp") + (-s "$OUT/$name-1200.jpg");
  $n++;
}
close $in;
printf "rendered %d images at 1200w, %d MB total\n", $n, $bytes/1048576;
