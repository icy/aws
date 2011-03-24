#!/usr/bin/env perl

# This function is copied from the main source 'aws'
sub xml2yaml {
  my($rubySymbol) = "";
  $rubySymbol = ":" if $ruby;
  while (<STDIN>) { $result .= $_; }

  $result =~ s#\n# #g;
  $result =~ s#> #>\n#g;                            # remove all '\n's
  $result =~ s#</.*>##g;                            # remove closing tags
  $result =~ s#<([a-z0-9:]*).*>#$rubySymbol\1: #gi; # opening tags -> symbols
  $result =~ s#($rubySymbol[^:]+): (.+)#\1: > \2#g; # opening tags -> symbols
  $result =~ s#:?(.*)/:#\1:#g;                      # empty values
  $result =~ s#:?(item|bucket|member): #- #gi;      # array items
  $result =~ s#\t#  #g;                             # tabs -> spaces
  $result =~ s#^[ :]*\n##mg;                        # remove all empty lines
  $result =~ s#[ ]+$##gm;                           # remove all trailing spaces
  $result =~ s#^[^ \n]+:\n#---\n#;                  # new document indicator
  $result =~ s#^  ##mg;                             # shift left

  $result;
}

print xml2yaml;
