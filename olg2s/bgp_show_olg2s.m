function bgp_show_olg2s(calNo, expNo)
% Show bgp results
% --------------------------------------

cS = const_olg2s(calNo);
bgpS = var_load_olg2s(cS.vBgp, calNo, expNo);


%% Table
if 1
   disp(' ');
   disp(sprintf('Steady state. calNo = %i.  expNo = %i.',  calNo, expNo));
   disp(sprintf('k = %5.3f.    y = %5.3f.', bgpS.k, bgpS.y));
   disp(sprintf('r = %5.3f.    w = %5.3f.', bgpS.r, bgpS.w));
   disp(sprintf('cY/wY = %5.3f.    s/y = %5.3f', bgpS.aggrCY / bgpS.aggrWY, bgpS.aggrS / bgpS.y));
   disp(sprintf('Deviation = %f', bgpS.bgDev));
end


end