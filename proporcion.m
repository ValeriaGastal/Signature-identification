function D =proporcion(c,p,q)

    u=p-c;  %primer vector
    v=q-c;  %segundo vector
    D= norm(u)/norm(v);
    if(D>1)
        D= 1/D;
    end   
end