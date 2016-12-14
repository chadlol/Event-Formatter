require 'docx'
require_relative 'formating_func.rb'

class Event
  attr_accessor(:name, :loc, :date, :time, :desc, :spons)
  def initialize(name, loc, date, time, desc, spons)
    @name = name
    @loc = loc
    @date = date
    @time = time
    @desc = desc
    @spons = spons
  end
end

# location_names = {
#     :MON => "Monroe Hall"
#     # TODO add on campus building names to this list...
# }

# days = [['Monday', []], ['Tuesday', []], ['Wednesday', []], ['Thursday', []], ['Friday', []], ['Saturday', []], ['Sunday', []]]
# day = 0
# month = 11

# Create a Docx::Document object for our existing docx file
doc = Docx::Document.open('oct31.docx') #Specify the DOCX file you wish to convert

events_raw = []

doc.paragraphs.each do |p|
  p.to_html
  events_raw << p.text.split(/\r?\n/)
end

events_raw.shift(9) #This value offsets the unwanted text at the top of the document. This value can change depending on document formatting.
events_raw.pop

events = []
name, loc, date, time, desc, spons = ''
count = 0

events_raw.each do |x|

  if count == 0
    name, loc, date, time, desc, spons = ''
  end

    case count
      when 0
        name = x[0].remove_bad_characters
      when 1
        loc = x[0].remove_bad_characters
      when 2
        date = x[0].remove_bad_characters
      when 3
        time = x[0].remove_bad_characters.time_format
      when 4
        desc = x[0].remove_bad_characters
      when 5
        spons = x[0].remove_bad_characters.sponsors_format
        else
    end
    count += 1

  if count > 5
    # puts time.inspect
    events << Event.new(name, loc, date, time, desc, spons)
    count = 0
  end
end

html = ""

events.each do |e|
  html += "<p>\n\t<strong>#{e.name}</strong>\n\t<br/>#{e.time} | #{e.loc}<br/>\n\t<em>#{e.desc}</em>
    Sponsors:
    "

  spons_size = e.spons.size
  i = 0

  e.spons.each do |s|
    html += "<a href='#'>#{s}</a>"
    i += 1
    if i != spons_size
      html += ",
    "
    end
  end

  html += "\n</p>\n"
end

# puts html

# open and write to a file with ruby
open('events.html', 'w') { |f|
  f.puts html
}
