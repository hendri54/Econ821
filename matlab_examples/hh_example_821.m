function hh_example_821(y, z, R, bb, sig)
% Solve 2 period hh problem
    % Set up range of c values
    ng = 50;
    cGridV = linspace(0, y, ng);
    % Calculate deviation for each grid point
    devV = zeros(1,ng);
    for ig = 1 : ng
        devV(ig) = ee_dev_x1(cGridV(ig),y,z,R,bb,sig);
    end
    % Pick the smallest deviation
    [devMin, idxMin] = min(abs(devV));
    disp(sprintf('c = %f   Dev = %f', cGridV(idxMin), devMin));
end

%% EE deviation
function dev = ee_dev_x1(c, y, z, R, bb, sig)
% Get s, g from budget constraints
    s = y - c;
    g = z + R .* s;
    if g <= 0
        % c not feasible
        dev = 1e8;
    else
        [uc, ug] = ces_util_x1(c, g, bb, sig);
        dev = uc - ug .* R;
    end
end

%% CES marginal utility when young, old
function [ucM, ugM] = ces_util_x1(cM, gM, bb, sig)
    uM = (cM .^ (1-sig) + bb .* gM .^ (1-sig)) ./ (1-sig);
    ucM = (1-sig) .* uM ./ cM;
    ugM = (1-sig) .* uM ./ gM;
end