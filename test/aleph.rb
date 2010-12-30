# encoding: UTF-8

require "cutest"
require "nokogiri"

require_relative "../lib/aleph"

test "splits comments and code" do
  result = Aleph.process(<<-EOS)
<!--
This is the intro
-->

<!--
Boilerplate
-->
<!DOCTYPE html>
<html>
  <body>
    <!--
    This is the header.

    We use the HTML5 element.
    -->
    <header>
    </header>

    <!--
    This is the footer
    -->
    <footer>
    </footer>
  </body>
</html>
  EOS

  table = Nokogiri::HTML(result).at_xpath("./html/body").children.first

  assert table.at("./tr[1]/td[1]").text =~ %r{This is the intro}
  assert table.at("./tr[1]/td[2]/pre/code").text.strip.empty?

  assert table.at("./tr[2]/td[1]/p").text =~ /Boilerplate/
  assert table.at("./tr[2]/td[2]/pre/code").content =~ /<!DOCTYPE html>.*<html>.*<body>/m

  assert table.at("./tr[3]/td[1]/p[1]").text =~ %r{This is the header}
  assert table.at("./tr[3]/td[1]/p[2]").text =~ %r{We use the HTML5 element}
  assert table.at("./tr[3]/td[2]/pre/code").content =~ /<header>.*<\/header>/m
end

test "filters comments through Markdown" do
  result = Aleph.process(<<-EOS)
  <!--
  This is **the** intro.

  Additional paragraphs here.

  Aló.
  -->
  <!DOCTYPE html>
  <html>
    <body>
    </body>
  </html>
  EOS

  table = Nokogiri::HTML(result).at_xpath("./html/body").children.first

  assert table.at("./tr[1]/td[1]/p[1]").inner_html =~ %r{This is <strong>the</strong> intro}
  assert table.at("./tr[1]/td[1]/p[2]").inner_html =~ %r{Additional paragraphs here}
  assert table.at("./tr[1]/td[1]/p[3]").inner_html =~ %r{Aló}
end

test "embedded JavaScript" do
  result = Aleph.process(<<-EOS)
  <!--
  This is the intro
  -->
  <!DOCTYPE html>
  <html>
    <body>
      <!--
      This is the header.
      -->
      <header>
      </header>

      <script type="text/javascript">
        /*
        Initialize everything.
        */
        function initialize() {
        }
      </script>
    </body>
  </html>
  EOS

  table = Nokogiri::HTML(result).at_xpath("./html/body").children.first

  assert table.at("./tr[1]/td[1]").text =~ %r{This is the intro}

  assert table.at("./tr[3]/td[1]/p[1]").text =~ %r{Initialize everything}
end
