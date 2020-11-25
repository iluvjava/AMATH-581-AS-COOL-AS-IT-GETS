clear variables

Xaxis = linspace(-3, 3, 100); 
Yaxis = Xaxis; 
[Ys, Xs] = EllipticTransform(Xaxis, Yaxis, pi/8, 10);
Zs = exp(-(Ys.^2 + Xs.^2));
[DomainX, DomainY] = meshgrid(Xaxis, Yaxis);
surf(DomainX, DomainY, Zs); shading interp;