function [ D ] = dilation( A, B )
  bX=floor(size(B,1)/2);
  bY=floor(size(B,2)/2);
  C=padarray(A,[bX bY],0);
  %Intialize the matrix D of size A with zeros
  D=zeros(size(A));
  for i=1:size(C,1)-size(B,1)+1
      for j=1:size(C,2)-size(B,2)+1
        Pr=C(i:i+size(B,1)-1, j:j+size(B,2)-1) .* B;
        tSum=sum(Pr(:));
        if tSum>0
            D(i, j)=1;
        end
      end
  end
end
