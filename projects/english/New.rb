#coding: utf-8
module Enumerable
  def stable_sort_by
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


#load Rogot's
$k = open('10681-index.txt','r:MacRoman:utf-8').read.scan(/((.+)\n(        .+ \d.*\n)+)/).map{|w,_|
  w.split("\n").map(&:strip)
}
p $k.assoc("abide")
$rogot_keys = $k.map(&:first)*"\n"
#def rogot
#  k = $k.map(&:first)
#  d = $k.inject({'a'=>1}){|a,b|a[b[0]]=b;a}
#  k.each{|x|
#    if x[' ']
#      x.split.each{|e|
#        #$k[e] &=  $ unless d[e]
#        if !d[e]
#          $k << [e,*d[x].drop(1)]
#          p [$k.last,e,x]
#          gets
#        end
#      }
#    end
#  }
#end
#rogot
#k2 = $k.select{|w|w.first[' '] && w.first.split.any?{|x|$ab[x]}}

$k.select!{|w|$ab[w.first]} #
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
  out.puts "* Word Tree / Roget's Thesaurus\n\n\n"

  out.puts(open('outline.txt','r:utf-8').read.gsub("[*]","").gsub("\n","\n\n").gsub(/^\*\*\*\*\* (.+)\. .*$/){|x|
    "#{(t=$text[$~[1]]) && t.() || "#{$~[0].gsub(/(\d\S+)\. (.+$)/,"\\2 \\1")}"}"
  })
  out.puts "\n* \n\n"
  out.puts ($ab.keys-$my_keys).map{|w| gg(w)}
}

p :ok

($ab.keys-$my_keys).each{|x|
  t= $rogot_keys.scan /^.*\b#{x}\b.*$/
  p [x,t] if !t.empty?
}

#p k2.size
#k2 = $k.select{|w|w.first[' '] && w.first.split.any?{|x|$ab[x]}}
#k2.each{|key,*value|key.}
#gets
#mores