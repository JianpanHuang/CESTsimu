function y = lorentz1pool(p, x)
% One-pool Lorentzian function
% Jianpan Huang   Email: jianpanhuang@outlook.com

y = p(1) - p(2)*p(3)^2/4./(p(3)^2/4+(x-p(4)).^2) ;