function [] = A2Boxes(nmesh)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

L = 6; % Dimensions of region, m
W = 4;
Lb = 2; % Dimensions of boxes, m
Wb = 1;
dx = L/nmesh;
dy = W/nmesh;
V0 = 1;

% Conductivity as a function of x and y
inBoxes = @(x,y) (x < L/2+Lb & x > L/2-Lb).*~(y > W/2-Wb & y < W/2+Wb);
sigma0 = 1E-2;
sigma = @(x,y) sigma0.*inBoxes(x,y) + ~inBoxes(x,y);

x = linspace(0, L, nmesh);
y = linspace(0, W, nmesh);

for i = 1:nmesh
   for j = 1:nmesh
      n = j + (i-1)*nmesh;
      
      nxp = j + i*nmesh;
      nxm = j + (i-2)*nmesh;
      nyp = (j+1) + (i-1)*nmesh;
      nym = (j-1) + (i-1)*nmesh;
      
      if (i == 1)
         G(n,n) = (1/dx^2);
         B(n) = (V0/dx^2);
      elseif (i == nmesh)
         G(n,n) = (1/dx^2);
         B(n) = (V0/dx^2);
      elseif (j == 1)
         G(n,n) = (1/dy^2);
      elseif (j == nmesh)
         G(n,n) = (1/dy^2);
      else
         G(n,n) = (-2*(1/dx^2 + 1/dy^2))*sigma(x(i),y(j));
         G(n,nxp) = (1/dx^2)*sigma(x(i+1),y(j));
         G(n,nxm) = (1/dx^2)*sigma(x(i-1),y(j));
         G(n,nyp) = (1/dy^2)*sigma(x(i),y(j+1));
         G(n,nym) = (1/dy^2)*sigma(x(i),y(j-1));
      end
   end
end
V = G\B.';

Vplot = zeros(nmesh,nmesh);
sigplot = zeros(nmesh,nmesh);

for i = 1:nmesh 
    for j = 1:nmesh
        n = j + (i-1)*nmesh;
        Vplot(i,j) = V(n);
        sigplot(i,j) = sigma(x(i),y(j));
    end
end

figure(4);
surf(x,y,sigplot);
title('Conductivity plot');
xlabel('x (m)');
ylabel('y (m)');
zlabel('\sigma (1/\Omega)');

figure(5);
surf(x,y,Vplot);
title('Voltage plot, 2D finite element w/ boxes');
xlabel('x (m)');
ylabel('y (m)');
zlabel('V (V)');

figure(6);
[Ex, Ey] = gradient(Vplot);
quiver(x,y,Ex,Ey);
xlim([0 L]);
ylim([0 W]);
title('Electric field plot');
xlabel('x (m)');
ylabel('y (m)');

figure(7);
Jx = zeros(1,nmesh);
Jy = zeros(1,nmesh);
for i = 1:nmesh
   for j = 1:nmesh
       Jx(i) = Ex(i)*sigma(i,j);
       Jy(j) = Ey(j)*sigma(i,j);
   end
end
quiver(x,y,Jx,Jy);
xlim([0 L]);
ylim([0 W]);
title('Current plot');
xlabel('x (m)');
ylabel('y (m)');
Jav = sum(sqrt((Jx.^2)+(Jy.^2)))/nmesh;

%disp(Jav);

end

