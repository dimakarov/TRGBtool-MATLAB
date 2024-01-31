function [c,b,s] = photerrors(mag,fake)
mag(mag<fake.mag(1)) = fake.mag(1);
mag(mag>fake.mag(end)) = fake.mag(end);
c = ppval(mag,mkpp(fake.mag,fake.completeness));
b = ppval(mag,mkpp(fake.mag,fake.bias));
s = ppval(mag,mkpp(fake.mag,fake.std));
% Sometimes complex numbers appear. It is just crazy solution
if ~all(isreal(s))
    s=real(s);
end;
