# encoding: UTF-8

require "nokogiri"
require "rdiscount"

class Aleph
  VERSION = "0.0.1"

  def self.process(source)
    new(source).process
  end

  def initialize(source)
    @source = source

    @doc = Nokogiri::HTML("<meta http-equiv='content-type' content='text/html; charset=utf-8'><table class='aleph'></table>")
  end

  def process
    comments = nil

    @source.each_line do |line|
      if line =~ %r{^\s*(<!--|/\*)\s*$}
        comments = ""
      elsif line =~ %r{^\s*(-->|\*/)\s*$}
        new_row
        comment(unindent(comments))
        comments = nil
      else
        if comments
          comments << line
        else
          code(line)
        end
      end
    end

    table.to_s
  end

protected

  def table
    @table ||= @doc.at_xpath("//table")
  end

  def row
    table.children.last
  end

  def new_row
    table << "<tr><td></td><td><pre><code></code></pre></td></tr>"
  end

  def unindent(text)
    spaces = 0

    spaces = $1.size - 1 if text =~ /\A(\s+)/

    lines = text.split("\n").map do |line|
      line[spaces..-1]
    end.join("\n")
  end

  def comment(text)
    filtered = RDiscount.new(text.strip).to_html
    row.at_xpath("./td[1]").inner_html = filtered
  end

  def code(text)
    row.at_xpath("./td[2]/pre/code").content += text
  end
end
