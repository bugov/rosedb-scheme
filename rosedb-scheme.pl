#! /usr/bin/perl

use strict;
use warnings;
sub say { print STDERR "@_\n"; } # use say;
use Data::Dumper;

print STDERR (<<"USAGE") && exit unless my $path = pop;
perl ./get_sql [-iINC_PATH1;INC_PATH2] PATH
USAGE

# Parse params
while (my $opt = pop) {
  unshift @INC, split(';', $1) if $opt =~ /^-i(.*)$/;
}

my @files;

# Prepare $path
$path =~ s/\/$//;
if (-d $path) {
  say "Looking for Rose::DB classes into directory $path...";
  # Get all files from this dir. Wanna __SUB__...
  my $f; $f = sub { -f $_ ? push @files, $_ : -d $_ && $f->($_) for <$_[0]/*> }; $f->($path);
}
elsif (-f $path) {
  say "Looking for Rose::DB classes into file $path...";
  push @files, $path;
}
else {
  say "$path is not file or directory! Stopping...";
  exit;
}

# Load 'em all!
for my $f (@files) {
  say "Load file $f\n";
  eval { require $f } or say $!;
}

say Dumper \%INC;