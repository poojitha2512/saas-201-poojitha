def get_command_line_argument
  
  if ARGV.empty?
    puts "Usage: ruby lookup.rb <domain>"
    exit
  end
  ARGV.first
end

# `domain` contains the domain name we have to look up.
domain = get_command_line_argument


dns_raw = File.readlines("zone.txt")



def parse_dns(dns_raw)
	#craeting a list of hashes
	k=[]
	k[0]={}
	k[1]={}
	dns_raw.each do |i|
		 
		i=i.split(", ")
		if(i[0]=='A')
			k[0].merge!({i[1]=>i[2].rstrip})	#merging into the hash 
			
		else
			k[1].merge!({i[1]=>i[2].rstrip})
	
		end
	end
	 k
end
def resolve(dns_rec, lookup_chain, domain)
	temp=domain
	r=dns_rec[0]
	#first checking, if the given domain present is a A type record 
		 if r.has_key?(domain)	
			temp=r[domain]
			lookup_chain.push(temp)		
			return lookup_chain
		else
		r=dns_rec[1]
		#checking in the CNAME record
			if r.has_key?(domain)	
				temp=r[domain]
				lookup_chain.push(temp)
				lookup_chain=resolve(dns_rec, lookup_chain, temp)
		 	else
			      puts "Error: record not found for #{domain}"
				lookup_chain
				
			end
		end
end




dns_records = parse_dns(dns_raw)
lookup_chain = [domain]
lookup_chain = resolve(dns_records, lookup_chain, domain)
puts lookup_chain.join(" => ") if lookup_chain.length()>1

