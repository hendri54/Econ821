function cal_comp_olg2s(calNo)
% Simple minded calibration algorithm
%{
Very inefficient!
%}

%% Set parameters

cS = const_olg2s(calNo);
expNo = cS.expBase;
expS = exp_set_olg2s(expNo);
[paramS, success] = var_load_olg2s(cS.vParams, calNo, expNo);
if success == 0
   paramS = param_set_olg2s(calNo);
end



%% Optimization

guessV = [paramS.A, paramS.beta, paramS.ddk];
lbV = [0.1, 0.4, 0];
ubV = [100, 2, 0.9];

optS = optimset('fminsearch');
[solnV, fVal, exitFlag] = fminsearch(@wrapper, guessV);

% Unpack params
paramS.A = solnV(1);
paramS.beta = solnV(2); 
paramS.ddk = solnV(3);

var_save_olg2s(paramS, cS.vParams, calNo, expNo);

[dev, bgpS] = wrapper(solnV);

var_save_olg2s(bgpS, cS.vBgp, calNo, expNo);


%% Nested: Deviation wrapper
   function [dev, bgpS] = wrapper(guessV)
      if any(guessV < lbV)  ||  any(guessV > ubV)
         dev = 1e8;
         bgpS = [];
         return;
         
      else
         % Unpack guesses
         paramS.A = guessV(1);
         paramS.beta = guessV(2); 
         paramS.ddk = guessV(3);

         [dev, bgpS] = cal_dev_olg2s(paramS, cS, expS);
      end
   end


end