function B = array_response(params, angles_deg, mode)
% Spatial response; position errors are in wavelengths at the carrier.
% x = diag(gain .* exp(1i*phase)) * coupling * a(theta) * s + n.
% mode='truth' is only for simulation; default uses supplied calibration.
if nargin < 3, mode = 'calibration'; end
M = params.N_Tx;
config = struct();
field = ['array_' mode];
if isfield(params, field), config = params.(field); end
positions = (0:M-1)' * params.antenna_distance;
if isfield(config, 'position_error_lambda')
    v = config.position_error_lambda(:);
    assert(numel(v) == M && all(isfinite(v)), 'Invalid position errors.');
    positions = positions + v;
end
A = exp(1i * 2*pi * positions * sind(angles_deg(:)'));
gain = ones(M, 1); phase = zeros(M, 1); C = eye(M);
if isfield(config, 'gain'), gain = config.gain(:); end
if isfield(config, 'phase_deg'), phase = config.phase_deg(:); end
if isfield(config, 'coupling'), C = config.coupling; end
assert(numel(gain)==M && all(isfinite(gain)) && all(gain>0), 'Invalid gains.');
assert(numel(phase)==M && all(isfinite(phase)), 'Invalid phases.');
assert(isequal(size(C), [M M]) && all(isfinite(C(:))), 'Invalid coupling matrix.');
H = diag(gain .* exp(1i*pi/180*phase)) * C;
if isfield(config, 'matrix')
    H = config.matrix; % Combined measured gain/phase and coupling response.
    assert(isequal(size(H), [M M]) && all(isfinite(H(:))), 'Invalid calibration matrix.');
end
B = H * A;
assert(all(sum(abs(B).^2,1)>0), 'Array response cannot be zero.');
end
