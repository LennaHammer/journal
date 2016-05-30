#coding: utf-8

$words = open('GRE红宝书.txt','r:gbk:utf-8').each_line.map{|line|line.tap(&:chomp!).split("\t")}.inject({}){|h,(k,v)|h[k]=v;h};

p $words.size

$index = open('10681-index.txt','r:MacRoman:utf-8').read.scan(/((.+)\n(        .+ \d.*\n)+)/).map{|w,_|
  w.split("\n").map(&:strip)
}
p $index.size
p $index.assoc("abide")
$rogot_keys = $index.map(&:first)*"\n"
#$k1=$index.map(&:first)
$index = $index.inject({}){|a,b|a[b.shift]=b;a}
p $index.size
#$keys = $index2.keys#.map(&:first)
#p $keys.size






$group = $index.each_pair.inject(Hash.new{|h,k|h[k]=[]}){|h,(k,v)|v.each{|x|h[x]<<k};h}


p $group.size
#p $group.first


$index.each_key{|x|
#fail if x=='obsession!'
  if x[/ |!/]
    w = x.scan(/\w+/)-['be','with','to','oneself','at','of','on','the','out']
     if x=='obsession!'
     p x,w
     #gets
     end
    if w.size==1
      w = w[0]
      #p [w,$index[w],x,$index[x]]
      #gets
      if w=='obsession!'#'abut'
        p w,$index[x]
        #gets
              $index[x].each{|group|
      p $group[group] 
       $group[group]|=[w]
      p $group[group]
       gets
      }
      end
      $index[x].each{|group|
        $group[group]|=[w]
      }
    end
  end
}


p $group.size


$count = Hash.new(0)

def gg(w)
  return $gg.(w) if $gg
  $count[w]+=1
  " #{$count[w]==1 ? '+' : '-'} #{w}    #{$words[w]}    [#{$mhyph[w]||w}]"
end

h = 165.chr.force_encoding('MacRoman').encode('utf-8')
$mhyph = {}&&open('mhyph.txt','r:MacRoman:utf-8').each_line.inject({}){|a,b|b.chomp!;a[b.gsub(h,'')]=b.gsub(h,'-');a}


$text = $group.keys.inject({}){|a,key|
  a[key[/\d+.*$/]] = ->{"***** #{key}\n\n"<<($group[key].select{|x|$words[x]}.sort.map{|w| gg(w)<<""}*"\n")}
  a
}

p $text.first
#OUT = "output/output_#{$ab.size}_tree.txt"
OUT = "word_tree_6000.txt"
OUT = "output_6000_tree.txt"
open(OUT,"w:utf-8"){|out|
  out.puts "* Word Tree / Roget's Thesaurus\n\n\n"

  out.puts(open('outline.txt','r:utf-8').read.gsub("[*]","").gsub("\n","\n\n").gsub(/^\*\*\*\*\* (.+)\. .*$/){|x|
    "#{(t=$text[$~[1]]) && t.() || "#{$~[0].gsub(/(\d\S+)\. (.+$)/,"\\2 \\1")}"}"
  })
  out.puts "\n* \n\n"
  $rest = ($words.keys-$count.keys)
  out.puts $rest.map{|w| gg(w)}
  #out.puts ($words.keys-$count.keys).map{|w| gg(w)}
}

p :ok
#p ($words.keys.size)
#p $count.keys.size
$rest.each{|x|
  t= $rogot_keys.scan /^.*\b#{x}\b.*$/

  p [x,t] if !t.empty?
}
p :ok2
gets