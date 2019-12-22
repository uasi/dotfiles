#!/usr/bin/env perl

use 5.010;
use strict;
use warnings;

use File::Basename;

open my $fh, '>', $ENV{HOME} . '/.local/share/vim/vimrc_tags';

for my $path (glob('~/.vim/plugin/plugged/*.vim')) {
    my $tag = basename $path;
    $tag =~ s/\.vim$//;
    $tag =~ s/[^a-zA-Z0-9_]/_/g;
    $tag = lc $tag;
    say $fh "${tag}\t${path}\t:1";
}
