use strict;
use warnings;

use File::Slurp 'read_file';

my $text = read_file(shift);
my $last = 0;

while ($text =~ /^\d+c\d+\s*?\n <\s+"time":\s*".*?"\s*\n ---\s*\n >\s+"time":\s*".*?"\s*\n/gx) {
    print substr($text, $last, pos($text) - $last - length($1));
    $last = pos($text);
}
print substr($text, $last);
