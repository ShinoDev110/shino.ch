#!/usr/bin/perl
# Resolves every relative reference in deico/ the way a server rooted at the
# repo root would, then checks the target against the real on-disk path set
# with EXACT case.
#
# The case check cannot be delegated to a container: a Windows bind mount stays
# case-insensitive even inside Linux, so nginx happily serves /deico/DE/.
# GitHub Pages will not. This compares strings instead of asking the filesystem.
use strict; use warnings;
use File::Basename;

# Real paths, in the case the filesystem actually stores them.
my %real;
for my $p (`find deico -type f`) {
  chomp $p;
  $p =~ s{\\}{/}g;
  $real{$p} = 1;
}

my @files = grep { /\.html$/ } keys %real;
my ($checked, $missing, $casebad) = (0, 0, 0);

for my $f (sort @files) {
  my $dir = dirname($f);
  open my $fh, "<", $f or next;
  local $/ = undef;
  my $h = <$fh>;
  close $fh;

  my @refs;
  while ($h =~ /(?:href|src)="([^"#][^"]*)"/g) { push @refs, $1; }
  while ($h =~ /srcset="([^"]*)"/g) {
    for my $cand (split /\s*,\s*/, $1) {
      $cand =~ s{\s+\d+w\s*$}{};
      $cand =~ s{^\s+|\s+$}{}g;
      push @refs, $cand if length $cand;
    }
  }

  for my $r (@refs) {
    next if $r =~ m{^(https?:|mailto:|tel:|#|data:|javascript:)};
    my $t = $r;
    $t =~ s{[?#].*$}{};
    next unless length $t;

    my $p = "$dir/$t";
    $p =~ s{\\}{/}g;
    $p =~ s{/\./}{/}g;
    1 while $p =~ s{[^/]+/\.\./}{};
    $p =~ s{//+}{/}g;
    my $target = ($t =~ m{/$}) ? $p . "index.html" : $p;

    $checked++;

    if ($real{$target}) { next; }             # exact case match, fine

    if (-e $target) {                          # exists, but only case-insensitively
      $casebad++;
      print "  CASE MISMATCH in $f\n     ref: $r\n     -> $target\n";
    } else {
      $missing++;
      print "  BROKEN in $f\n     ref: $r\n     -> $target\n";
    }
  }
}

print "checked $checked references: $missing missing, $casebad case mismatches\n";
exit(($missing + $casebad) ? 1 : 0);
