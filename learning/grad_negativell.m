function grad_NLL = grad_negativell(param, w, X, Y, map)

grad_NLL = zeros(size(w));


    phi_x = kernelFeatures(param, X, map, param.hilbertmap.kernel);
for i = 1:size(Y, 1) % TODO: vectorize this calculation
    grad_NLL = grad_NLL -Y(i)* phi_x(:, i) / ( 1 + exp(Y(i)*dot(w, phi_x(:, i))));
end
end