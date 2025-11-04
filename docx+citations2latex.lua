-- Extract citation keys from Cite elements and format as LaTeX citations
function Cite(cite)
    -- Extract citation keys from the text content
    local keys = {}
    local text = ""
    
    -- Concatenate all the text inside the Cite element
    for _, inline in ipairs(cite.content) do
        if inline.t == "Str" then
            text = text .. inline.text
        elseif inline.t == "Space" then
            text = text .. " "
        end
    end
    
    -- Use pattern matching to extract citation keys
    -- Pattern matches anything between @ and ] or , or ;
    for key in text:gmatch("@([%w_%-%.]+)") do
        table.insert(keys, key)
    end
    
    -- If no keys were found, look at the citation IDs as fallback
    if #keys == 0 then
        for _, citation in ipairs(cite.citations) do
            table.insert(keys, citation.citationId)
        end
    end
    
    -- Join keys with commas for LaTeX \cite command
    local keysString = table.concat(keys, ",")
    
    -- Return a LaTeX \cite command
    return pandoc.RawInline("latex", "\\cite{" .. keysString .. "}")
end