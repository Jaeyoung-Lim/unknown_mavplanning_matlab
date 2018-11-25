function grad_NLL = grad_negativell(param, w, X, Y, map)


phi_x = kernelFeatures(param, X, map, param.hilbertmap.kernel);
grad_NLL = zeros(size(w));
for i = 1:size(Y, 1) % TODO: vectorize this calculation
    grad_NLL = grad_NLL -Y(i)* phi_x(:, i) / ( 1 + exp(Y(i)*dot(w, phi_x(:, i))));
end

% Vectorized above calculation, but slower :(
% grad_NLL_stretch =  phi_x * diag((Y ./ (1+exp(diag(Y)*(w'*phi_x)'))));
% grad_NLL =  -1.0 * sum(grad_NLL_stretch, 2);

end