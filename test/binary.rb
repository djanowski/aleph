require "cutest"

require_relative "../lib/aleph"

BINARY = File.expand_path("../bin/aleph", File.dirname(__FILE__))

test "parses the given file" do
  result = `ruby #{BINARY} test/simple.html`

  assert !result.empty?

  table = Nokogiri::HTML(result).at_xpath("./html/body").children.first

  assert table.at("./tr[1]/td[1]/h1").text =~ %r{Welcome to Aleph}
  assert table.at("./tr[1]/td[1]/p").text =~ %r{This is the introduction}
  assert table.at("./tr[1]/td[2]/pre/code").text.strip.empty?

  assert_equal "", table.at("./tr[2]/td[1]").text.strip
  assert table.at("./tr[2]/td[2]/pre/code").content =~ /<!DOCTYPE html>.*<html>.*<body>/m

  assert table.at("./tr[3]/td[1]/p").content =~ %r{We'll use the <header> element for the website's header.}
  assert table.at("./tr[3]/td[2]/pre/code").content =~ %r{<header>.*Welcome.*</header>}m
end
