#!/usr/bin/env ruby

require 'cgi'

code = nil

STDIN.read.scan(%r#Response.*<pre.*programlisting">(.*)</pre>#m) do |k|
  code = k.first
end

puts CGI.unescapeHTML(code) if code
