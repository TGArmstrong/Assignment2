function [] = A2Analytical(nmesh)
%A2Analytical: For the case where V=V0 at x=0 and x=L, and V=0 at y=0 and
%y=W, this function calculates the voltage over the region using the
%analytical series solution for this potential.
%   nmesh: number of mesh points in each direction

V0 = 1;
L = 6;
W = 4;
kmax = 100; % Number of terms in the series
V = zeros(nmesh,nmesh);
x = linspace(-L/2, L/2, nmesh);
y = linspace(0, W, nmesh);

for i = 1:nmesh
   for j = 1:nmesh
      for k = 0:kmax
         V(i,j) = V(i,j) + (sin((2*k+1)*pi*y(j)/W)*cosh((2*k+1)*pi*x(i)/W)/cosh((2*k+1)*pi*(L/2)/W))/(2*k+1); 
      end
   end
end
V = V.*4*V0/pi;
figure(3);
surf(x,y,V);
title('Voltage plot, 2D analytical series');
xlabel('x (m)');
ylabel('y (m)');
zlabel('V (V)');

end

