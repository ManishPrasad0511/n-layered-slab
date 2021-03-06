function retval = nlayed(theta,lam0)
degrees = pi/180; 
%lam0=(100:1:130)*1e-9;%free space wavelength 
k0=(2*pi)./lam0;
theta = theta* degrees; %angle of incidence
pte = 1/sqrt(2);
ptm = 1i*pte;
ni=1.0; % incident medium refractive index

ur1 = 1.0; % permeability in the reflection region 
er1 = 1.0; % permittivity in the reflection region 
ur2 = 1.0; % permeability in the transmission region 
er2 = 5.0; % permittivity in the transmission region 
 

 N=10; % number of layers
UR = [ 1 1 1 1 1 1 1 1 1 1]; % array of permeabilities in each layer 
ER = [ 3 1 2 2 1 3 1 4 2 3 ]; % array of permittivities in each layer 
% array of the %thickness of each layer 
L = [ 0.25 0.5 0.2 0.3 0.25 0.1 0.1 0.1 0.1 0.1].*1e-6; 
 
%------------------------------------------------------------------------ 
% IMPLEMENT TRANSFER MATRIX METHOD 
%------------------------------------------------------------------------
Kx=ni*sin(theta);
Ky=0;
Kzh=sqrt(1-(Kx*Kx)-(Ky*Ky));


Wh=eye(2);
Qh=[ Kx*Ky 1-(Kx*Kx) ;(Ky*Ky)-1  -Kx*Ky];
Omh=1i*Kzh*eye(2);
Vh=Qh*(Omh^-1);
%--initialize global scattering matrix
Sg11=zeros(2,2); Sg12=eye(2);Sg21=eye(2);Sg22=zeros(2,2);


    Krz=sqrt(ur1*er1-(Kx*Kx)-(Ky*Ky));
    Pr=(1/er1)*[ Kx*Ky ur1*er1-(Kx*Kx) ;(Ky*Ky)-ur1*er1  -Kx*Ky];
    Qr=(1/ur1)*[ Kx*Ky ur1*er1-(Kx*Kx) ;(Ky*Ky)-ur1*er1  -Kx*Ky];
    Omr=1i*Krz*eye(2);
    Wr=eye(2);
    Vr=Qr*(Omr^-1);
    Ar=eye(2)+(Vh^-1)*Vr;
    Br=eye(2)-(Vh^-1)*Vr;
    
    Sref11=-(Ar^-1)*Br;
    Sref12=2*eye(2)*(Ar^-1);
    Sref21=0.5*eye(2)*(Ar-(Br*(Ar^-1)*Br));
    Sref22=Br*(Ar^-1);
     % updating global scattering matrices by Redheffer star product
    SA11=Sref11;
    SA12=Sref12;
    SA21=Sref21;
    SA22=Sref22;
    
    SB11=Sg11;
    SB12=Sg12;
    SB21=Sg21;
    SB22=Sg22;
    
    SAB11=SA11+(SA12*((eye(2)-(SB11*SA22))^-1)*SB11*SA21);
    SAB12=SA12*((eye(2)-(SB11*SA22))^-1)*SB12;
    SAB21=SB21*((eye(2)-(SA22*SB11))^-1)*SA21;
    SAB22=SB22+(SB21*((eye(2)-(SA22*SB11))^-1)*SA22*SB12);
    
    Sg11=SAB11;
    Sg12=SAB12;
    Sg21=SAB21;
    Sg22=SAB22;
for q=1:length(lam0)  
    
%---updating the scattering matrices for N layers--------------------------
for i=1:N
    Kz=sqrt(UR(i)*ER(i)-(Kx*Kx)-(Ky*Ky));
    Q=(1/UR(i))*[ Kx*Ky UR(i)*ER(i)-(Kx*Kx) ;(Ky*Ky)-UR(i)*ER(i)  -Kx*Ky];
    Om=1i*Kz*eye(2);
    V=Q*(Om^-1);
    A=eye(2)+((V^-1)*Vh);
    B=eye(2)-((V^-1)*Vh);
    X=expm(Om*k0(q)*L(i));
    S11=((A-((X*B*(A^-1)*X*B)))^-1)*((X*B*(A^-1)*X*A)-B);
    S22=S11;
    S12=(((A-((X*(B/A)*X*B)))^-1)*X)*(A-B*(A^-1)*B);
    S21=S12;
    
% updating global scattering matrices by Redheffer star product
    SA11=Sg11;
    SA12=Sg12;
    SA21=Sg21;
    SA22=Sg22;
    
    SB11=S11;
    SB12=S12;
    SB21=S21;
    SB22=S22;
    
    SAB11=SA11+(SA12*((eye(2)-(SB11*SA22))^-1)*SB11*SA21);
    SAB12=SA12*((eye(2)-(SB11*SA22))^-1)*SB12;
    SAB21=SB21*((eye(2)-(SA22*SB11))^-1)*SA21;
    SAB22=SB22+(SB21*((eye(2)-(SA22*SB11))^-1)*SA22*SB12);
    
    Sg11=SAB11;
    Sg12=SAB12;
    Sg21=SAB21;
    Sg22=SAB22;
end


    Ktz=sqrt(ur2*er2-(Kx*Kx)-(Ky*Ky));
    Pt=(1/er2)*[ Kx*Ky ur2*er2-(Kx*Kx) ;(Ky*Ky)-ur2*er2  -Kx*Ky];
    Qt=(1/ur2)*[ Kx*Ky ur2*er2-(Kx*Kx) ;(Ky*Ky)-ur2*er2  -Kx*Ky];
    Omt=1i*Ktz*eye(2);
    Wt=eye(2);
    Vt=Qt*(Omt^-1);
    At=eye(2)+(Vh^-1)*Vt;
    Bt=eye(2)-(Vh^-1)*Vt;
    
    St11=Bt*(At^-1);
    St12=0.5*eye(2)*(At-(Bt*(At^-1)*Bt));
    St21=2*(At^-1);
    St22=-(At^-1)*Bt;
    
   % updating global scattering matrices by Redheffer star product
    SA11=Sg11;
    SA12=Sg12;
    SA21=Sg21;
    SA22=Sg22;
    
    SB11=St11;
    SB12=St12;
    SB21=St21;
    SB22=St22;
    
    SAB11=SA11+(SA12*((eye(2)-(SB11*SA22))^-1)*SB11*SA21);
    SAB12=SA12*((eye(2)-(SB11*SA22))^-1)*SB12;
    SAB21=SB21*((eye(2)-(SA22*SB11))^-1)*SA21;
    SAB22=SB22+(SB21*((eye(2)-(SA22*SB11))^-1)*SA22*SB12);
    
    Sf11=SAB11;
    Sf12=SAB12;
    Sf21=SAB21;
    Sf22=SAB22;
    
    
    Kinc=k0(q)*ni*[sin(theta) 0 cos(theta)];
    nsn=[0 0 -1]; % surface normal
    
    if (theta==0)
     aTE=[0 1 0];
    else
     aTE=cross(Kinc,nsn)./norm(cross(Kinc,nsn));
    end
    
    aTM=cross(aTE,Kinc)./norm(cross(aTE,Kinc));
    
    P=pte*aTE+ptm*aTM;
    
    cinc=[P(1); P(2)];
    Er=Sf11*cinc;
    Et=Sf21*cinc;
    Erx=Er(1);
    Ery=Er(2);
    Etx=Et(1);
    Ety=Et(2);
    
    Erz=-(Kx*Erx+Ky*Ery)/Krz;
    Etz=-(Kx*Etx+Ky*Ety)/Ktz;
    
    Er=[Erx;Ery;Erz];
    Et=[Etx;Ety;Etz];
    
    R=abs(Erx)^2+abs(Ery)^2+abs(Erz)^2;
    
    Rx(q)=abs(R);
    
end
%--------------------------------------------------------------------------
retval = Rx;
  
  %------------------------------------------------------------------------
end