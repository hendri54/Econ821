function cal_simple_olg2d(calNo)
% Simple minded calibration
%{
Not efficient, but easy to implement

Jointly iterate over endogenous objects (k) and parameters
Minimize deviation from equilibrium conditions and calibration targets jointly
%}
% --------------------------------------

cS = const_olg2d(calNo);
% Baseline experiment
expNo = 1;
expS = exp_set_olg2d(expNo);

fprintf('\nSimple minded calibration:\n');


% Guesses for objects to be found
k = 1;
pBeta = 0.8;
pA = 3;
ddk = 0.4;
guessV = [k, pBeta, pA, ddk];
lbV = [0, 0.1, 0.01, 0];
ubV = [100, 2, 100, 0.9];


dev = dev_wrapper(guessV);
fprintf('Dev with guesses: %.3f \n', dev);


%% Optimization

optS = optimset('fminsearch');

tic
[solnV, fVal, exitFlag] = fminsearch(@dev_wrapper, guessV, optS);
toc

if exitFlag <= 0
   warning('No convergence');
end

fprintf('\nSolution: k = %.3f    beta = %.3f    A = %.3f    ddk = %.3f \n', solnV);

[dev, y, r, wY, aggrS, cY, cO] = dev_wrapper(guessV);

fprintf('Deviation: %.3f \n', dev);


%% Local: Wrapper for deviation
   function [dev, y, r, wY, aggrS, cY, cO] = dev_wrapper(guessV)
      if any(guessV(:) > ubV(:))  ||  any(guessV(:) < lbV(:))
         % Invalid guess
         dev = 1e8;
      else
         % Valid guess
         [dev, y, r, wY, aggrS, cY, cO] = cal_dev(guessV, expS, cS);
      end
   end

end



%% Local: deviation function
function [dev, y, r, wY, aggrS, cY, cO] = cal_dev(guessV, expS, cS)
   % Unpack guesses (not robust)
   k = guessV(1);
   paramS.beta = guessV(2);
   paramS.A = guessV(3);
   paramS.ddk = guessV(4);
   
   % Prepare input structure for bg_dev_olg2d
   inputS.tauR = expS.tauR;
   inputS.tauW = expS.tauW;
   inputS.wOld = cS.tgWageOld;

   % Deviation from bgp conditions (just 1)
   [bgpDev, y, r, wY, aggrS, cY, cO] = bg_dev_olg2d(k, inputS, paramS, cS);
   
   % Deviation from calibration targets
   devV = [bgpDev; (k/y) - cS.tgKY; r - cS.tgIntRate; wY - cS.tgWageYoung];
   dev  = sum(devV .^ 2);
end