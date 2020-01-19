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
	#creating a array of hashes
	record_array=[]
	#index 0 for class "A" records
	record_array[0]={}
	#index 1 for class "CNAME" records
	record_array[1]={}
	dns_raw.each do |record|
		 
		record=record.strip.split(", ")
		if(record[0]=='A')
			#inserting record into the hash containg class "A" records 
			record_array[0][record[1]]=record[2].rstrip
			
		else
			#inserting record into the hash containg class "CNAME" records
			record_array[1][record[1]]=record[2].rstrip
	
		end
	end
	record_array
end
def resolve(dns_records, lookup_chain, domain)
	
	record_hash=dns_records[0]
	#first checking, if the given domain present is a class A type record 
		 if record_hash.has_key?(domain)	
			
			lookup_chain.push(record_hash[domain])		
			return lookup_chain
		else
		record_hash=dns_records[1]
		#checking in the CNAME record
			if record_hash.has_key?(domain)	
				
				lookup_chain.push(record_hash[domain])
				lookup_chain=resolve(dns_records, lookup_chain,record_hash[domain])
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

