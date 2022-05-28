lam = input("Enter the value of wavelength in nano meters ")
lam = lam*1e-9

thetas = linspace(1,89,1000);
reflectance = [];
    
for i = 1:1:1000
  reflectance(i) = nlayed(thetas(i),lam);
end

plot(thetas,reflectance);
xlabel('angle of incidence','fontsize',24);
ylabel('Reflectance','fontsize',24);