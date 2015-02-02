function paramS = param_set_ogm(calNo)
% Make a struct with possibly calibrated parameters
%{
Used for defaults
Calibrated params are overwritten
%}
% ---------------------------------------

cS = const_ogm(calNo);

paramS.A = 1;
paramS.ddk = cS.ddk;
paramS.beta = cS.beta;



end