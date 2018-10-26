#!/usr/bin/env perl

use 5.010;
use strict;
use warnings;

my $vimrc = $ENV{HOME} . '/.vimrc';
my $vimrctags = $ENV{HOME} . '/.vimrc.tags';

open my $vimrc_fh, '<', $vimrc;

my %tag_index;
my $n = 1;

# Scan tag defs
while (my $line = <$vimrc_fh>) {
    if ($line =~ /\*(\w+)\*/) {
        $tag_index{$1} = $n;
    }
    $n++;
}

seek $vimrc_fh, 0, 0;
$n = 1;

my @tag_entries;

# Scan tags
while (my $line = <$vimrc_fh>) {
    if ($line =~ /\|(\w+)\|/ && exists $tag_index{$1}) {
        push @tag_entries, "$1\t$vimrc\t:$tag_index{$1}";
    }
}

open my $vimrctags_fh, '>', $vimrctags;
say $vimrctags_fh $_ for @tag_entries;
