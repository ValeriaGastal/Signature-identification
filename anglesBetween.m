function [z] = anglesBetween(c, p, q)
    u=p-c;  %primer vector
    v=q-c;  %segundo vector
    z = acosd(dot(u,v) / (norm(u) * norm(v))); %formula para calcular angulo entre dos vectores con el coseno
    if(z<0)
        z=0.00001;
    end
    if (z>180)
        z=360-z;
    end
end