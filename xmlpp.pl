#!/usr/bin/env perl

sub xmlpp
{
    my($xml) = "";
    my($indent, @path, $defer, @defer, $result) = "\t";

    while (<STDIN>) { $xml .= $_; }

    for ($xml =~ /<.*?>|[^<]*/sg)
    {
	if (/^<\/(\w+)/ || /^<(!\[endif)/)		# </... or <!--[endif]
	{
	    my($tag) = ($1);
	    $tag = $path[$#path] if $tag eq "![endif";
	    push @path, @defer;
	    while (@path)
	    {
		my $pop = pop @path;
		last if $pop eq $tag;
	    }
            $result .= "@{[$indent x @path]}@{[$defer =~ /^\s*(.*?)\s*$/s]}$_\n" if $defer || $_;
            $defer = "";
	    @defer = ();
 	}

	elsif (/[\/\?]\s*\>$/)				# .../> or ...?>
	{
            $result .= "@{[$indent x @path]}@{[$defer =~ /^\s*(.*?)\s*$/s]}\n" if $defer;
	    push @path, @defer;
            $result .= "@{[$indent x @path]}@{[/^\s*(.*?)\s*$/s]}\n" if $_;
            $defer = "";
	    @defer = ();
	}

	elsif (/^(?:[^<]|<!(?:[^-]|--[^\[]))/)		# (not <) or (< then not -) or (<!-- then not [)
	{
	    if (!/^\s*$/)
	    {
		if ($defer)
		{
        my ($tmp) = $_;
        $tmp =~ s/\n/ /g;
		    $defer .= $tmp;
		}
		else
		{
		    $result .= "@{[$indent x @path]}@{[/^\s*(.*?)\s*$/s]}\n";
		}
	    }
	}

	else						# <...
	{
	    $result .= "@{[$indent x @path]}@{[$defer =~ /^\s*(.*?)\s*$/s]}\n" if $defer;
	    push @path, @defer;
	    $defer = $_;
	    @defer = /^<([^<>\s]+)/;
	}
    }

    $result .= "@{[$indent x @path]}@{[$defer =~ /^\s*(.*?)\s*$/s]}\n" if $defer;

    $result;
}

print xmlpp;
