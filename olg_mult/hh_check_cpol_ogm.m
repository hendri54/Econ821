function hh_check_cpol_ogm(cPolM, kPolM, R, paramS, cS)
% Check that consumption policy satisfies properties such
% as monotonicity
%{
Shows that solution is quite inaccurate when using EE deviations

Problem:
Cannot check monotonicity when k' hits upper grid point
%}
% --------------------------------------------------------

validateattributes(cPolM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>=', cS.cFloor, ...
   'size', [cS.nk, cS.nw, cS.aD]});


% Is c increasing in wealth?
strict = 1;
result = matrix_lh.is_monotonic(cPolM, 1, strict, 1, cS.dbg);
if result ~= 1
   warning('cPolM not increasing in k');
   diffM = diff(cPolM, 1);
   fprintf('min c change: %f \n',  min(diffM(:)));
end

% Is k' increasing in wealth?
strict = 0;
result = matrix_lh.is_monotonic(kPolM, 1, strict, 1, cS.dbg);
if result ~= 1
   warning('kPolM not increasing in k');
   diffM = diff(kPolM, 1);
   fprintf('min kPrime change: %f \n',  min(diffM(:)));
end

% Is c increasing in labor endowments during working life?
strict = 0;
result = matrix_lh.is_monotonic(cPolM(:,:,1 : cS.aR), 2, strict, 1, cS.dbg);
if result ~= 1
   warning('cPolM not increasing in e');
   diffM = diff(cPolM, 2);
   fprintf('min c change: %f \n',  min(diffM(:)));
end


% Is c indpendent of labor endowments during retirement?
retireAgeV = cS.aR+1 : cS.aD;
dcPolM = cPolM(:, 2 : cS.nw, retireAgeV) - cPolM(:, 1 : cS.nw - 1, retireAgeV);
dcMax = max(abs(dcPolM(:)));
if dcMax > 1e-3
   warning('cPolM not independent of e during retirement');
   fprintf('dcMax = %f \n', dcMax);
end


%% Directly check Euler equation
% Need to account for possibility that hh chooses a "corner"
% where the next higher k grid point is not feasible
if 01
   for a = 1 : (cS.aD-1)
      for ie = 1 : cS.nw
         for ik = 1 : cS.nk
            kPrime = kPolM(ik,ie,a);
            cY = cPolM(ik,ie,a);
            % c(t+1) by e(t+1)
            cPrime_eV = nan([cS.nw, 1]);
            for iePrime = 1 : cS.nw
               cPrime_eV(iePrime) = interp1(paramS.kGridV, cPolM(:,iePrime,a+1), kPrime, 'linear');
            end
            
            eeDev = hh_ee_direct_ogm(cY, cPrime_eV, ie, R, paramS, cS);
            
            % corner?
            if kPrime < (cS.kMin + 1e-6)
               % Borrowing constrained
               if eeDev < -1e-2
                  warning('EE dev < 0 with borrowing constraint');
                  keyboard;
               end
            elseif kPrime > (paramS.kGridV(cS.nk) - 1e-6)  ||  cY < (cS.cFloor + 1e-6)
               if eeDev > 1e-2
                  warning('EE dev > 0 with upper grid reached');
                  keyboard;
               end
            else
               if abs(eeDev) > 3e-2
                  warning('EE dev should be 0');
                  keyboard;
               end
            end
         end
      end
   end
end

end