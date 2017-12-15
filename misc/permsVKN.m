function Y=permsVKN(V,K,N)
%permutations of set V
%that don't contain K
%of length N

x=setdiff(V,K);
if N==1
    Y=x';
else
    Y=[];
    for i=1:length(x)
        u=permsVKN(V,x(i),N-1);
        U=[repmat(x(i),size(u,1),1) u];
        Y=[Y; U];
    end
end