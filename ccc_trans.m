function I_out = ccc_trans(I, grad_norm, norm_hist, hist_mix, out_mix, exact_hist, out_mix_alpha_wk, out_mix_alpha_c)

if ~exist('grad_norm', 'var') || isempty(grad_norm)
    grad_norm = 1;   % 1: use gradient norm weight,  0: do not use
end

if ~exist('norm_hist', 'var') || isempty(norm_hist)
    norm_hist = 1;   % 1: use uniform distribution in sRGB color space,  0: use smoothed original histogram
end

if ~exist('hist_mix', 'var') || isempty(hist_mix)
    hist_mix = 0;    % 1: mix original and target histograms,  0: do not mix
end

if ~exist('out_mix', 'var') || isempty(out_mix)
    out_mix = 1;     % 1: mix original and output histograms,  0: do not mix
end

if ~exist('exact_hist', 'var') || isempty(exact_hist)
    exact_hist = 0;  % 1: use exact histogram specification,   0: do not use
end

if ~exist('out_mix_alpha_wk', 'var') || isempty(out_mix_alpha_wk)
    out_mix_alpha_wk = 0.8;  % specify parameter
end

if ~exist('out_mix_alpha_c', 'var') || isempty(out_mix_alpha_c)
    out_mix_alpha_c  = 0.5;  % specify parameter
end


    
%% calculate pure color 'c'
% c is calculated by (x-x_min)/(x_max-x_min)

I_x_rgb = reshape(I, [], 3);    % HW-by-3 matrix

I_c_rgb = repmat([0, 0, 0], [size(I_x_rgb,1), 1]);   % initialize

I_max = max(I_x_rgb, [], 2);    % x_max
I_min = min(I_x_rgb, [], 2);    % x_min

% indices of chromatic pixels
idx = (I_max ~= I_min);

% calc c for achromatic pix
I_c_rgb(idx,:) = (I_x_rgb(idx,:) - repmat(I_min(idx), [1,3])) ./ repmat(I_max(idx) - I_min(idx), [1,3]);
% fill black (0,0,0) as pure color for achromatic pixels
I_c_rgb(~idx,:) = repmat([0, 0, 0], [sum(~idx), 1]);

%% coefficients of convex combination
w = I_min;          % coeffieicnt of white
k = 1 - I_max;      % coeffieicnt of black
c = I_max - I_min;  % coeffieicnt of pure color

I_wkc = [w, k, c];  % N-by-3 matrix

%% spread coefficient distribution
sigma = [1, 1, 1];    % smoothing degree
I_wkc_out = zeros(size(I_wkc));  % initialize

% for w, k, c
for ite = 1:3   
    coeff_img = reshape(I_wkc(:, ite), [size(I, 1), size(I, 2)]);

    % calc input histogram
    if grad_norm == 0
        % histogram
        Hist_original = imhist(I_wkc(:, ite));
    else % grad_norm == 1
        % weighted histogram
        coeff_grad_norm = f_grad_norm(coeff_img);   % calc. gradient norm

        Hist_original = zeros(256, 1);
        for ii = 1:size(I, 1)
            for jj = 1:size(I, 2)
                Hist_original(round((coeff_img(ii,jj)*255 + 1))) = Hist_original(round((coeff_img(ii,jj)*255 + 1))) + coeff_grad_norm(ii, jj);
            end
        end
    end

    % calc target histogram
    if sigma(ite) == 0
        % raw histogram
        Hist_target = Hist_original;
    else
        if norm_hist == 0
            % smoothing
            Hist_target = imfilter(Hist_original, transpose(f_gaussianfilter(ceil(255 * 3 * sigma(ite)))), 'same', 'symmetric');
        else
            % uniform distribution in sRGB color space
            if ite == 1 || ite == 2
                xx = (0:255)';
                Hist_norm = (256-xx).^3 - (255-xx).^3;
            else
                xx = (0:255)';
                Hist_norm = (256 - xx).*(0.^xx + 6.*xx);
            end
            
            if hist_mix == 1
                % mix histogram
                Hist_target = ((1 - hist_mix_alpha) .* Hist_original ./ sum(Hist_original(:))) + (hist_mix_alpha .* Hist_norm ./ sum(Hist_norm(:)));
            else
                % do not mix histogram
                Hist_target = Hist_norm;
            end
        end
    end
    
    if exact_hist == 1     % exact histogram specification
        if grad_norm == 1
            % gradient norm weighted histogram
            Out = f_match_gray_histogram_weight(Hist_target, size(I, 1), size(I, 2), idx_order, coeff_grad_norm);
        else
            % non weighted histogram
            Out = f_match_gray_histogram(Hist_target, size(I, 1), size(I, 2), idx_order);
        end
    else    % traditional histogram specification
        Out = f_hist_adjust_fast(coeff_img * 255, Hist_original, Hist_target);
    end
    
    Out = Out / 255;    % [0, 255] -> [0, 1]
    
    % mix output
    if out_mix == 1
        if ite == 1 || ite == 2
            Out = (1-out_mix_alpha_wk) .* coeff_img + out_mix_alpha_wk .* Out;
        else
            Out = (1-out_mix_alpha_c) .* coeff_img + out_mix_alpha_c .* Out;
        end
    end
    
    I_wkc_out(:, ite) = Out(:);
end

% for achromatic pix
I_wkc_out(c==0, 3) = 0;

% normalization
I_wkc_out = I_wkc_out ./ repmat(sum(I_wkc_out, 2), [1, 3]);

ww = I_wkc_out(:, 1);
kk = I_wkc_out(:, 2);
cc = I_wkc_out(:, 3);

% reconstruction
I_out_row = (repmat(ww, [1, 3]) * 1) + (repmat(cc, [1, 3]) .* I_c_rgb);
I_out = reshape(I_out_row, size(I));
I_out = double(uint8(I_out * 255)) / 255;   % quantize 8-bit color image [0,1]

% Out = reshape(I_out, [], 3);

end
