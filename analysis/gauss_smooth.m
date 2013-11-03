function g_all = gaussSmooth(v_all,sigma)


g_all = zeros(size(v_all));

for i = 1:size(v_all,2)
    v = v_all(:,i);
    
    len = 2*round(sigma*4)+1;
    
    f = gausswin(len,len/sigma);
    f = f/sum(f);
    
    g = conv(v,f,'same');
    
    g_all(:,i) = g;
end