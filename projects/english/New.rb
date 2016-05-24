#coding: utf-8
module Enumerable
  def stable_sort
    sort_by.with_index { |x, idx| [x, idx] }
  end

  def stable_sort_by
    sort_by.with_index { |x, idx| [yield(x), idx] }
  end
end

$ab = open('GRE红宝书.txt','r:gbk:utf-8').each_line.map{|line|line.tap(&:chomp!).split("\t")}.inject({}){|h,(k,v)|h[k]=v;h};

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

def gg(w)
  "#{w}    #{$ab[w]}    [#{$mhyph[w]||w}]"
end
h = 165.chr.force_encoding('MacRoman').encode('utf-8')
$mhyph = {}&&open('mhyph.txt','r:MacRoman:utf-8').each_line.inject({}){|a,b|b.chomp!;a[b.gsub(h,'')]=b.gsub(h,'-');a}


$text = $group.keys.inject({}){|a,key|
  a[key[/\d+.*$/]] = "**** #{key}\n\n"<<($group[key].map{|w| gg(w)<<""}.stable_sort_by{|x|x[/ (.\.)/]||''}*"\n")
  a
}

p $text.first
#gets
#out = open("output_6000_tree.txt","w:utf-8")
open("output_6000_tree.txt","w:utf-8"){|out|
#  p open('outline.txt','r:utf-8').read.gsub(/^\*\*\* (.+)\. .*$/){|x|
#    "*** #{$text[$~[1]]}"
##    #$~[1]
##    p $text[$~[1]].encoding;gets
##    "*** #{$~[1]}"
#  }
   out.puts(open('outline.txt','r:utf-8').read.gsub("\n","\n\n").gsub(/^\*\*\*\* (.+)\. .*$/){|x|
     "#{$text[$~[1]]}"
   })
  out.puts "\n* \n"
  out.puts ($ab.keys-$my_keys).map{|w| gg(w)}
}

#out.close

#$group.keys.sort_by{|x|x[/\d+/].to_i}.each{|key|
#  out.puts "\n* #{key}\n===================="
#  out.puts $group[key].map{|w| gg(w)}.stable_sort_by{|x|x[/ (.\.)/]||''}
#}
#out.puts "\n*\n========================"
#out.puts ($ab.keys-$my_keys).map{|w| gg(w)}
#out.close
p :ok