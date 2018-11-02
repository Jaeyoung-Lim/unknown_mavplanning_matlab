function [videoObj] = plot_fft(param, fullmap, partialmap, mavpath, mavpose, videoObj)
    
    subplot(2, 2, 1);
    show(fullmap);
    subplot(2, 2, 2);
    show(partialmap);
    subplot(2, 2, 3);
    run_fft(fullmap);
    subplot(2, 2, 4);
    run_fft(partialmap);
    drawnow
end

function run_fft(map)
    X = fft2(1-map.occupancyMatrix);
    imagesc(abs(fftshift(X)))
end