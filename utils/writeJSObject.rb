def write_js_object(ruby_hash)
    formatted = "{"
    ruby_hash.each { |k, v|
        val = v

        if val
           val = "'#{val.gsub(/\n/, ',').gsub("'", '‘')}'"
        else
            val = 'null'
        end

        formatted = formatted + " #{k}: #{val},"
    }

    formatted[0..-2] + ' },'
end