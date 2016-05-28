#coding: utf-8
module Enumerable
  def stable_sort
    sort_by.with_index { |x, idx| [x, idx] }
  end

  def stable_sort_by
    sort_by.with_index { |x, idx| [yield(x), idx] }
  end
  def stable_sort_by
    self.map.with_index{|x,i|[x,i]}.sort.map(&:first)
  end
  def stable_sort_by
    #sort_by!{|x|x[3..-1]}#x[/(\w\S*)/].downcase}
    self
  end
end

$ab = open('GRE红宝书.txt','r:gbk:utf-8').each_line.map{|line|line.tap(&:chomp!).split("\t")}.inject({}){|h,(k,v)|h[k]=v;h};

case 3
when 1
  $ab = open('wordlist/托福单词.txt','r:utf-8:utf-8').each_line.map{|line|line.tap(&:chomp!).split("\t")}.inject({}){|h,(k,v)|h[k]=v;h};
when 2
  $ab = open('wordlist/kaoyan.txt','r').each_line.inject({}){|hash,line|line.chomp!;hash[line]='';hash}
  $gg = ->(w){"#{w}    [#{$mhyph[w]||w}]"}
else

end
$k = open('10681-index.txt','r:MacRoman').read.scan(/((.+)\n(        .+ \d.*\n)+)/).map{|w,_|
  w.split("\n").map(&:strip)
}
p $k.assoc("abide")

$k.select!{|w|$ab[w.first]}
$my_keys = $k.map(&:first)

$dict = {}
$group = Hash.new{|h,k|h[k]=[]}
$k.each{|line|
  word = line.shift
  line.each{|x|
    $group[x] << word
  }
  $dict[word] = line
}

$count = Hash.new(0)

def gg(w)
  return $gg.(w) if $gg
  $count[w]+=1
  " #{$count[w]==1 ? '+' : '-'} #{w}    #{$ab[w]}    [#{$mhyph[w]||w}]"
end
h = 165.chr.force_encoding('MacRoman').encode('utf-8')
$mhyph = {}&&open('mhyph.txt','r:MacRoman:utf-8').each_line.inject({}){|a,b|b.chomp!;a[b.gsub(h,'')]=b.gsub(h,'-');a}


$text = $group.keys.inject({}){|a,key|
  a[key[/\d+.*$/]] = ->{"***** #{key}\n\n"<<($group[key].map{|w| gg(w)<<""}.stable_sort_by{|x|x[/ (.\.)/]||''}*"\n")}
  a
}

p $text.first
OUT = "output/output_#{$ab.size}_tree.txt"
OUT = "output_6000_tree.txt"
open(OUT,"w:utf-8"){|out|
  out.puts "* Word list / Roget's Thesaurus\n\n\n"

  out.puts(open('outline.txt','r:utf-8').read.gsub("[*]","").gsub("\n","\n\n").gsub(/^\*\*\*\*\* (.+)\. .*$/){|x|
    "#{(t=$text[$~[1]]) && t.() || "#{$~[0].gsub(/(\d\S+)\. (.+$)/,"\\2 \\1")}"}"
  })
  out.puts "\n* \n\n"
  out.puts ($ab.keys-$my_keys).map{|w| gg(w)}
}

p :ok