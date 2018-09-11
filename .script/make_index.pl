use strict;
use warnings;
use utf8;

my $template = "./README.template.md";
my $output = "./README.md";
my $placeholder = "<!-- autogenerate -->";

open (IN, $template) or die "$!";
open (OUT, ">$output") or die "$!";

while (<IN>) {
    if ($_ eq "$placeholder\n") {
        opendir(DIR, "./") or die "$!";
        my @list = readdir(DIR);
        closedir(DIR);
        my $file;
        print OUT "## Category\n\n";
        foreach $file (@list) {
            if ($file =~ ('\A' . quotemeta(".")) or -f $file) {
                next;
            }
            my $title = $file;
            print OUT "- [$title](#$file)\n";
        }
        print OUT "\n";
        print OUT "## Index\n\n";
        foreach $file (@list) {
            if ($file =~ ('\A' . quotemeta(".")) or -f $file) {
                next;
            }
            my $header = ucfirst $file;
            print OUT "### $header\n\n";
            opendir(DIR, "$file") or die "$!";
            my @chlid_list = readdir(DIR);
            closedir(DIR);
            my $child_file;
            foreach $child_file (@chlid_list) {
                if ($child_file =~ ('\A' . quotemeta(".")) or -d $child_file) {
                    next;
                }
                open(MD, "$file/$child_file");
                my $title = <MD>;
                close(MD);
                $title =~ s/^#+\s(.*?)\s*$/$1/;
                print OUT "- [$title]($file/$child_file)\n";
            }
            print OUT "\n";
        }
    } else {
        print OUT "$_";
    }
}

close (IN);
close (OUT);
