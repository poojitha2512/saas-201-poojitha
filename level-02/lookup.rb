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
  #creating a hashe of hashes

  dns_records = { :a => {}, :cname => {} }
  dns_raw.each do |record|
    record = record.strip.split(", ")
    if (record[0] == "A")
      #inserting record into the hash containg class "A" records
      dns_records[:a][record[1]] = record[2].rstrip
    else
      #inserting record into the hash containg class "CNAME" records
      dns_records[:cname][record[1]] = record[2].rstrip
    end
  end
  dns_records
end

def resolve(dns_records, lookup_chain, domain)
  record_hash = dns_records[:a]
  #first checking, if the given domain present is a class A type record
  if record_hash.has_key?(domain)
    lookup_chain.push(record_hash[domain])
    return lookup_chain
  else
    record_hash = dns_records[:cname]
    #checking in the CNAME record
    if record_hash.has_key?(domain)
      lookup_chain.push(record_hash[domain])
      lookup_chain = resolve(dns_records, lookup_chain, record_hash[domain])
    else
      puts "Error: record not found for #{domain}"
      lookup_chain
    end
  end
end

dns_records = parse_dns(dns_raw)
lookup_chain = [domain]
lookup_chain = resolve(dns_records, lookup_chain, domain)
puts lookup_chain.join(" => ") if lookup_chain.length() > 1
