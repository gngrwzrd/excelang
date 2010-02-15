#!/usr/bin/env ruby
require "rubygems"
require "fileutils"
require "optparse"
require "CGI"
require "hpricot"
OPTIONS={}
OPTIONS[:run]=true
opts=OptionParser.new do |opts|
  opts.on("-i", "--in=file", "The input file; please see excelang.codeendeavor.com for more usage instructions.") do |i|
    OPTIONS[:i]=i if i != nil
  end
  opts.on_tail("-h", "--help", "Show this usage statement.") do |h|
    puts opts
    OPTIONS[:run]=false
  end
end
begin
  opts.parse!(ARGV)
rescue Exception => e
  puts e, "", opts
  exit
end
if not OPTIONS[:run] then exit(0) end
if not OPTIONS[:i]
  puts "No input file specified, run excelang -h for help."
  exit 0
end
class File
  def self.write(filename,contents)
    File.open(filename,"w") do |f|
      f.puts contents
    end
  end
  def self.rm_rf_then_write(filename,contents)
    FileUtils.rm_rf(filename)
    File.write(filename,contents)
  end
end
if OPTIONS[:i].match(/\.xml/)
  require "spreadsheet/excel"
  include Spreadsheet
  workbook=Excel.new("output.xls")
  sheet=workbook.add_worksheet("languages")
  sheet.write(0,0,"text id")
  files=OPTIONS[:i].split(",")
  puts "FILES: #{files.inspect}"
  finaldata={}
  files.each do |f|
    xml=File.read(f)
    x=Hpricot::XML(xml)
    (x/:text).each do |item|
      id=item.attributes["id"]
      value=item.inner_html
      value.gsub!(/\<\!\[CDATA\[/,"")
      value.gsub!(/\]\]\>/,"")
      if not finaldata[id] then finaldata[id]=[] end
      finaldata[id]<<{:title=>f,:value=>value}
    end
  end
  columnindexesByKey={}
  columnindex=1
  row=1
  finaldata.each do |k,v|
    sheet.write(row,0,k)
    v.each do |v1|
      if not columnindexesByKey[v1[:title]]
        columnindexesByKey[v1[:title]]=columnindex
        sheet.write(0,columnindex,v1[:title].split(".")[0])
        columnindex+=1
      end
      sheet.write(row,columnindexesByKey[v1[:title]],v1[:value])
    end
    row+=1
  end
  puts columnindexesByKey.inspect
  workbook.close
else
  require "roo"
  if OPTIONS[:i].match(/xlsx/) then e=Excelx.new(OPTIONS[:i])
  else e=Excel.new(OPTIONS[:i]) end
  e.default_sheet = e.sheets.first
  id=""
  lang=""
  content={}
  2.upto(e.last_row) do |row|
    id=e.cell(row,"A")
    if not content[id] then content[id]={} end
    2.upto(e.last_column) do |column|
      lang=e.cell(1,column)
      if not content[id][lang] then content[id][lang]={} end
      content[id][lang]=e.cell(row,column)
    end
  end
  files={}
  content.each do |k,v|
    id=k
    v.each do |j,l|
      lang=j
      copy=l
      if not copy or copy == "" then next end
      if not files[j]
        files[j]="<?xml version='1.0' encoding='utf-8'?>\n"
        files[j]<<"<content>\n"
      end
      files[j]<<"\t<text id=\"#{id}\"><![CDATA[#{copy}]]></text>\n"
    end
  end
  files.each do |k,v|
    fc=v.dup+"</content>"
    specialchartext=CGI.escape(fc)
    #puts specialchartext.inspect
    specialchartext.gsub!(/%u201C/,"\"") #ms word left qoute
    specialchartext.gsub!(/%u201D/,"\"") #ms word right qoute
    specialchartext.gsub!(/%E2%80%9C/,"\"") # ms word, left quote
    specialchartext.gsub!(/%E2%80%9D/,"\"") # ms word, right quote
    specialchartext.gsub!(/%E2%80%93/,"&mdash;") #ms word mdash
    specialchartext.gsub!(/%u2018/,"'") #ms word left single quote
    specialchartext.gsub!(/%u2019/,"'") #ms word right sinle quote
    specialchartext.gsub!(/%E2%80%98/,"'") #ms word left single quote
    specialchartext.gsub!(/%E2%80%99/,"'") #ms word right single quote
    specialchartext.gsub!(/%u2026/,"...") #ms word ellipse
    specialchartext.gsub!(/%u2013/,"&ndash;") #ms word ndash
    specialchartext.gsub!(/%u2014/,"&mdash;") #ms word mdash
    specialchartext.gsub!(/%A9/,"&copy;") #ms word copyright
    specialchartext.gsub!(/%AE/,"&reg;") #ms word registered
    specialchartext.gsub!(/%u2122/,"&trade;") #ms word trademark
    fdata=CGI.unescape(specialchartext)
    File.write(k.dup.downcase+".xml",fdata)
  end
end