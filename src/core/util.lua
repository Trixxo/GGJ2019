function equals(a, b)
    local equal = true
    for k, v in pairs(a) do
        if v ~= b[k] then
            equal = false
            break
        end
    end
    return equal
end

