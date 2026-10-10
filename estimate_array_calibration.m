function calibration = estimate_array_calibration(params, angles_deg, measured_response)
% Fit combined H from known-angle, complex responses B=H*A.
% Measurements must have their source amplitude/phase removed, with a
% consistent phase reference across directions. This is not blind calibration.
ideal = params;
ideal.array_calibration = struct();
A = array_response(ideal, angles_deg);
assert(isequal(size(measured_response), size(A)), 'Response must be sensors x angles.');
assert(all(isfinite(measured_response(:))), 'Measurements must be finite.');
assert(rank(A) == params.N_Tx, 'Need at least M independent calibration directions.');
assert(cond(A) < 1e6, 'Calibration directions are poorly conditioned.');
calibration = struct('matrix', measured_response / A);
% A fixed H cannot exactly represent unknown direction-dependent position
% or element-pattern errors. Supply measured positions separately instead.
end
