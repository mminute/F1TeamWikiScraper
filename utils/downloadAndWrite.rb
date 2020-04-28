require 'open-uri'

def downloadAndWrite(url, filename)
    doc = open(url).read
    File.write(filename, doc)
    puts "Downloaded #{url}"
    return doc
end
