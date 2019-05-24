function [pz pdz pwz pzdw] = plsa(X,k)
% function [pz pdz pwz pzdw]=plsa(X,k)
% Return pLSA probability matrix p of m*n matrix X
% X is the document-word co-occurence matrix
% k is the number of the topics--z
% (m)word--rows, (n)document--collums

error = 0.0001;
x = X; 
[m n] = size(x)  %Size of matrix
pz=rand(1,k);  
pz2=pz;
% Update pz
pz2(1)=pz2(1)+2*error;

pdz=rand(k,n);  % Init P(d|z)
pwz=rand(k,m);  % Init P(w|z)
pzdw=rand(m,n,k);    %Init p(z/d,w)

deno=zeros(1,k);        % denominator of p(d/z) and p(w/z) -> p(z)
denopzdw=zeros(m,n);       % denominator of p(z/d,w) -> p(d,w)
numepdz=zeros(k,n);        % numerator of p(d/z) -> p(d,z)
numepwz=zeros(k,m);        % numerator of p(w/z) -> p(w,z)
R=sum(sum(x));  % Sum of document-word

%p(z) = sum(w) sum(d) n(d,w) p(z|d,w)
for ki=1:k
    for i=1:m
        for j=1:n
            deno(ki)=deno(ki)+x(i,j)*pzdw(i,j,ki); 
        end
    end
end

% p(d|z)
% P(d,z) = sum(w) n(d,w) * p(z|d,w)
for ki=1:k
    for j=1:n
        for i=1:m
            numepdz(ki,j)=numepdz(ki,j)+x(i,j)*pzdw(i,j,ki); 
        end
        pdz(ki,j)=numepdz(ki,j)/deno(ki);  % 
    end
end
% disp(pdz);

% pwz = p(w|z) = p(w,z)/p(z)
% P(w,z) = sum(d) n(d,w) * p(z|d,w)
for ki=1:k
    for i=1:m
        for j=1:n
            numepwz(ki,i)=numepwz(ki,i)+x(i,j)*pzdw(i,j,ki);
        end
        pwz(ki,i)=numepwz(ki,i)/deno(ki);
    end
end
% disp(pwz);

% p(z)
for ki=1:k
    pz(ki)=deno(ki)./R;  
end

%denominator of p(z|d,w) -> p(z,d,w)
for i=1:m
    for j=1:n
        for ki=1:k
            % element in this matrix is the probability of z
            denopzdw(i,j)=denopzdw(i,j)+pz(ki)*pdz(ki,j)*pwz(ki,i);
        end
    end
end
% p(z|d,w) = p(z) * p(d|z) * p(w|z) / p(d,w) 
for i=1:m
     for j=1:n
         for ki=1:k
             pzdw(i,j,ki)=pz(ki)*pdz(ki,j)*pwz(ki,i)/denopzdw(i,j);
         end
     end
end
% fprintf('p(z/d,w)=\n');
% disp(pzdw)

%  iteration 
iteration=0;
fprintf('iteration:\n');

while notConverged(pz, pz2, k, error)
    iteration=iteration+1;  
    deno=zeros(1,k);        %denominator of p(d/z) and p(w/z)
    denopzdw=zeros(m,n);       %denominator of p(z/d,w)
    numepdz=zeros(k,n);        %numerator of p(d/z)
    numepwz=zeros(k,m);        % numerator of p(w/z)
    fprintf('iteration %d:\n',iteration);
    
    for ki=1:k
        for i=1:m
            for j=1:n
                deno(ki)=deno(ki)+x(i,j)*pzdw(i,j,ki);
            end
        end
    end
% p(d/z)
    for ki=1:k
        for j=1:n
            for i=1:m
                numepdz(ki,j)=numepdz(ki,j)+x(i,j)*pzdw(i,j,ki); 
            end
            pdz(ki,j)=numepdz(ki,j)/deno(ki);
        end
    end
    fprintf('p(d/z)=\n');
    disp(pdz)
    % p(w/z)
    for ki=1:k
        for i=1:m
            for j=1:n
                numepwz(ki,i)=numepwz(ki,i)+x(i,j)*pzdw(i,j,ki);
            end
            pwz(ki,i)=numepwz(ki,i)/deno(ki);
        end
    end
    fprintf('p(w/z)=\n');
    disp(pwz)

    % p(z)
    pz=pz2;
    for ki=1:k
        pz2(ki)=deno(ki)./R;
    end
    fprintf('p(z)=\n');
    disp(pz2)
    %denominator of p(z/d,w)
    for i=1:m
        for j=1:n
            for ki=1:k
                denopzdw(i,j)=denopzdw(i,j)+pz2(ki)*pdz(ki,j)*pwz(ki,i);
            end
        end
    end
    % p(z/d,w)
    for i=1:m
         for j=1:n
             for ki=1:k
                 pzdw(i,j,ki)=pz2(ki)*pdz(ki,j)*pwz(ki,i)/(denopzdw(i,j)+eps);
             end
         end
    end
end  %end while

return;