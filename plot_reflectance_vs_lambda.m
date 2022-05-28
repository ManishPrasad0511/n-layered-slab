theta = input("Enter the value of angle of incidence ");
lam=(100:1:130)*1e-9;

reflectance = nlayed(theta,lam);

plot(lam,reflectance);
xlabel('Wavelength','fontsize',24);
ylabel('Reflectance','fontsize',24);