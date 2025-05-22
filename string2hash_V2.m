function hash2=string2hash_V2(str,k)
    str = double(str);
    hash = 5381;
    for i=1:size(str,2)
        hash = mod(hash * 33 +str(i), 2^32-1);
    end
    hash2 = zeros(1,k);
    for i=1:k
        hash = mod(hash * 33 +i, 2^32-1);
        hash2(i) = hash;
    end
end