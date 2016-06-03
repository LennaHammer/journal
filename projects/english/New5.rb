#coding: utf-8
puts "BEGIN>"
$words = open('wordlist/gre3000.txt','r:utf-8').each_line.inject({}){|hash,line|line.chomp!;hash[line]='';hash}

OUT = "output/gre_3000_lite.txt"


$index = open('10681-index.txt','r:MacRoman:utf-8').read.scan(/((.+)\n(        .+ \d.*\n)+)/).map{|w,_|
  w.split("\n").map(&:strip)
}.inject({}){|a,b|a[b.shift]=b;a}



$index['cliche'] = $index.delete("clich_\u00A8")
$words.each_key{|x|
  if x["é"]
    y = x.gsub("é","e")
    fail "#{x},#{y},#{$index[x]}" if $index[x]
    $index[x] = $index.delete(y) if $index[y]
  end
}
#p $index['abut on']
$index.keys.each{|x|
  if x[/ |!/]
    w = x.scan(/\w+/)-['be','with','to','oneself','at','of','on','the','out','against','after']
    if w.size==1
      w = w[0]
       $index[w] = ($index[w]||[])|$index[x]
#      $index[x].dup.each{|group|
#      fail group unless group.is_a? String
#        $index[w]|=[group]
#        #$group[group]|=[w]
#      }
      #p [x,w,$index[w],$index[x]];gets;
    end
  end
}

$full_list = $index.keys
$rogot_keys = $index.keys.sort*"\n"

$rogot = $index.each_pair.inject(Hash.new{|h,k|h[k]=[]}){|h,(k,v)|v.each{|x|h[x]<<k};h}

$group = Hash.new{|h,k|h[k]=[]}


$mobythes = open('mobythes.aur','r:ascii').each_line("\r").map{|line|
  line.tap(&:chomp!).split(",")
}
$mobythes.concat open('userthes.txt','r:ascii').each_line("\n").map{|line|
  line.tap(&:chomp!).split(",")
}

def ex
  g = Hash.new{|h,k|h[k]={}}
  puts "UP..."
  $mobythes.each{|xs|
    a = xs.first
    xs.each{|b|
      g[a][b] = true
      g[b][a] = true
    }
  }
  $rogot.each_value{|x|
    x.combination(2){|a,b|
      g[a][b] = true
      g[b][a] = true      
    }
  }
  g.each_key{|x|
    g[x][x]=true
  }
  puts "DOWN..."
  $words.keys.each{|x|
    topics = g[x.gsub("é","e")].keys.flat_map{|x|$index[x]||[]}.group_by{|x|x}.sort_by{|k,v|v.size}.map{|k,v|k}.reverse.take(2)
    #fail "#{topics}" unless topics.size==1
    topics.each{|g|$group[g]|=[x]}
  }
end
ex

$count = Hash.new(0)

def gg(w)
  $count[w]+=1
  sprintf(" %s %-16s[%s]",($count[w]==1 ? '+' : '-'),w,$mhyph[w]||w)
end

h = 165.chr.force_encoding('MacRoman').encode('utf-8')
$mhyph = open('mhyph.txt','r:MacRoman:utf-8').each_line.inject({}){|a,b|b.chomp!;a[b.gsub(h,'')]=b.gsub(h,'-');a}


$text = $group.keys.inject({}){|a,key|
  a[key[/\d+.*$/]] = ->{"***** #{key}\n\n"<<($group[key].select{|x|$words[x]}.sort.map{|w| gg(w)<<""}*"\n")}
  a
}

open(OUT,"w:utf-8"){|out|
  out.puts "* Word Tree / Roget's Thesaurus\n\n\n"
  out.puts(open('outline.txt','r:utf-8').read.gsub("[*]","").gsub("\n","\n\n").gsub(/^\*\*\*\*\* (.+)\. .*$/){|x|
    "#{(t=$text[$~[1]]) && t.() || "#{$~[0].gsub(/(\d\S+)\. (.+$)/,"\\2 \\1")}"}"
  })
  out.puts "\n* \n\n"
  $rest = ($words.keys-$count.keys)
  out.puts $rest.map{|w|gg(w)}
}

p :ok

$rest.each{|x|
  p x
  t = $rogot_keys.scan /^.*\b#{x}\b.*$/

  p [x,t] if !t.empty?

}
p "END"
gets