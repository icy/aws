#!/usr/bin/env perl

sub xml2yaml {
  my($result) = "";
  my($rubySymbol) = ":" if $ruby;

  while (<STDIN>) { $result .= $_; }

  $result =~ s#</.*>##g;                            # remove closing tags
  $result =~ s#<([a-z0-9]*).*>#$rubySymbol\1: #gi;  # opening tags -> symbols
  $result =~ s#($rubySymbol[^:]+): (.+)#\1: > \2#g; # opening tags -> symbols
  $result =~ s#:?(.*)/:#\1: nil#g;                  # empty values
  $result =~ s#:?item: #-#gi;                       # array items
  $result =~ s#\t#  #g;                             # tabs -> spaces
  $result =~ s#^[\t :]*\n##mg;                      # remove all empty lines
  $result =~ s#[ ]+$##gm;                           # remove all trailing spaces
  $result =~ s#^[^ \n]+:\n#---\n#;                  # new document indicator
  $result =~ s#^  ##mg;                             # shift left

  $result;
}

print xml2yaml;
