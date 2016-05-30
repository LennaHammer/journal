#coding: utf-8

$words = open('GRE红宝书.txt','r:gbk:utf-8').each_line.map{|line|line.tap(&:chomp!).split("\t")}.inject({}){|h,(k,v)|h[k]=v;h};

p $words.size
#if false
#  $words = open('wordlist/gre3000.txt','r:utf-8').each_line.inject({}){|hash,line|line.chomp!;hash[line]='';hash}
#  OUT = "output/output_#{$words.size}_tree.txt"
#  p OUT
#  #gets
#end
case 0
when 1
  $words = open('wordlist/托福单词.txt','r:utf-8:utf-8').each_line.map{|line|line.tap(&:chomp!).split("\t")}.inject({}){|h,(k,v)|h[k]=v;h};
  OUT = "output/output_#{$words.size}_tree.txt"
when 2
  $words = open('wordlist/kaoyan.txt','r').each_line.inject({}){|hash,line|line.chomp!;hash[line]='';hash}
  $gg = ->(w){"#{w}    [#{$mhyph[w]||w}]"}
  OUT = "output/output_#{$words.size}_tree.txt"
when 3
  $words = open('wordlist/gre3000.txt','r:utf-8').each_line.inject({}){|hash,line|line.chomp!;hash[line]='';hash}
  OUT = "output/output_#{$words.size}_tree.txt"
end

$index = open('10681-index.txt','r:MacRoman:utf-8').read.scan(/((.+)\n(        .+ \d.*\n)+)/).map{|w,_|
  w.split("\n").map(&:strip)
}
p $index.size
p $index.assoc("abide")
p $index.assoc("abut on")
#p $index.assoc('felon');gets;
$rogot_keys = $index.map(&:first)*"\n"
#$k1=$index.map(&:first)
$index = $index.inject({}){|a,b|a[b.shift]=b;a}
p $index.size
#p $index['felon'];gets
#$keys = $index2.keys#.map(&:first)
#p $keys.size
$full_list = $index.keys






$group = $index.each_pair.inject(Hash.new{|h,k|h[k]=[]}){|h,(k,v)|v.each{|x|h[x]<<k};h}


p $group.size
#p $group['bad man 949'];gets
#p $group.first


$index.each_key{|x|
  #fail if x=='obsession!'
  if x[/ |!/]
    w = x.scan(/\w+/)-['be','with','to','oneself','at','of','on','the','out','against','after']
    if x=='obsession!'
      p x,w
      #gets
    end
    if w.size==1
      w = w[0]
      #p [w,$index[w],x,$index[x]]
      #gets
#      if w=='obsession!'#'abut'
#        p w,$index[x]
#        #gets
#        $index[x].each{|group|
#          p $group[group]
#          $group[group]|=[w]
#          p $group[group]
#          gets
#        }
#      end
      $index[x].each{|group|
        $group[group]|=[w]
      }
      $full_list << w
    end
  end
}
$mobythes ||= open('mobythes.aur','r:ascii').each_line("\r").map{|line|
  line.tap(&:chomp!).split(",")
};
def ex
  g = Hash.new{|h,k|h[k]={}}
  #$gr = Hash.new{|h,k|h[k]={}}
  p :slow
  $mobythes.each{|xs|
    a = xs.first
    xs.each{|b|
      g[a][b] = true
      g[b][a] = true
    }
  }
  p :fast
  #p $words.keys-$full_list
  ($words.keys-$full_list).each{|x|
  topics = g[x].keys.flat_map{|x|$index[x]||[]}.group_by{|x|x}.sort_by{|k,v|v.size}.map{|k,v|k}.reverse.take(2)
  topics.each{|g|$group[g]|=[x]}
}
end
ex
p $words.keys-$full_list
($words.keys-$full_list).each{|x|
  topics = ($mobythes.assoc(x)||[]).flat_map{|x|$index[x]||[]}.group_by{|x|x}.sort_by{|k,v|v.size}.map{|k,v|k}.reverse.take(2)
  topics.each{|g|$group[g]|=[x]}
}
#gets
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
  if key == 'bad man 949'
    p key[/\d+.*$/];
    p a[key[/\d+.*$/]]#.()
    #gets
  end
  a
}

p $text.first
#OUT = "output/output_#{$ab.size}_tree.txt"
#OUT = "word_tree_6000.txt"
OUT ||= "output_6000_tree.txt"
open(OUT,"w:utf-8"){|out|
  out.puts "* Word Tree / Roget's Thesaurus\n\n\n"

  out.puts(open('outline.txt','r:utf-8').read.gsub("[*]","").gsub("\n","\n\n").gsub(/^\*\*\*\*\* (.+)\. .*$/){|x|
    #fail if $~[1]=='949'
    # p $~[1];gets
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


$mobythes ||= open('mobythes.aur','r:ascii').each_line("\r").map{|line|
  line.tap(&:chomp!).split(",")
};
def dfdfd
$x = open('mobythes.aur','r:ascii').each_line("\r").map{|line|
  line.tap(&:chomp!).split(",")
};

p $x.assoc("abase")
$g = Hash.new{|h,k|h[k]={}}
#$gr = Hash.new{|h,k|h[k]={}}
$x.each{|xs|
  a = xs.shift
  xs.each{|b|
    $g[a][b] = true
    $g[b][a] = true
  }
}
end
#dfdfd
$rest.each{|x|
p x
  # p $g[x].keys.sort
 p $mobythes.assoc(x)
#p $group.each_pair.select{|k,v|(v&($mobythes.assoc(x)||[])).size>3}.map{|k,v|k}
p ($mobythes.assoc(x)||[]).flat_map{|x|$index[x]||[]}.group_by{|x|x}.sort_by{|k,v|v.size}.map{|k,v|k}.reverse#.take(3)
   gets
  t= $rogot_keys.scan /^.*\b#{x}\b.*$/

   if !t.empty?
   p [x,t]

   end
}
p :ok2
gets