function [ D ] = erosion( A, B )
  bX=floor(size(B,1)/2)
  bY=floor(size(B,2)/2)
  bSum=sum(B(:));
  C=padarray(A,[bX bY],0); % in Matlab they use ones instead of zeros
  %Intialize the matrix D of size A with zeros
  D=zeros(size(A));
  for i=1:size(C,1)-size(B,1)+1
      for j=1:size(C,2)-size(B,2)+1
        Pr=C(i:i+size(B,1)-1, j:j+size(B,2)-1) .* B;
        tSum=sum(Pr(:));
        if tSum==bSum
            D(i, j)=1;
        end
      end
  end
end

