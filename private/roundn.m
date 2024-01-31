function y = roundn(A,n)
y = round(A./10.^n).*10.^n;
