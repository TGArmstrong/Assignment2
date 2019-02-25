function [] = A2Laplace1D(nmesh)
%A2Laplace1D This function uses a finite difference method to solve the
%Laplace equation for the case where V=V0 at x=0, and V=0 at x=L. The
%derivative is zero at the upper and lower boundaries. It outputs a plot of
%the voltage in one dimension.
%   nmesh: number of mesh points in each direction

L = 6; % Dimensions of region, m
W = 4;
V0 = 1; % Voltage, V
dx = L/nmesh;
dy = W/nmesh;

n = 0;
nxp = 0;
nxm = 0;
nyp = 0;
nym = 0;
G = spalloc(nmesh*nmesh,nmesh*nmesh,nmesh*nmesh*10);
B = zeros(1,nmesh*nmesh);

for i = 1:nmesh
   for j = 1:nmesh
      n = j + (i-1)*nmesh;
      
      nxp = j + i*nmesh;
      nxm = j + (i-2)*nmesh;
      nyp = (j+1) + (i-1)*nmesh;
      nym = (j-1) + (i-1)*nmesh;
      
      if (i == 1)
         G(n,n) = 1/dx^2;
         B(n) = V0/dx^2;
      elseif (i == nmesh)
         G(n,n) = 1/dx^2;
      elseif (j == 1)
         G(n,n) = 1/dy^2;
         G(n,nyp) = -1/dy^2;
      elseif (j == nmesh)
         G(n,n) = 1/dy^2;
         G(n,nym) = -1/dy^2;
      else
         G(n,n) = -2*(1/dx^2 + 1/dy^2);
         G(n,nxp) = 1/dx^2;
         G(n,nxm) = 1/dx^2;
         G(n,nyp) = 1/dy^2;
         G(n,nym) = 1/dy^2;
      end
   end
end
V = G\B.';
x = linspace(0, L, nmesh*nmesh);
figure(1);
plot(x,V);
title('Voltage plot, 1D finite difference');
xlabel('x (m)');
ylabel('V (V)');

end

