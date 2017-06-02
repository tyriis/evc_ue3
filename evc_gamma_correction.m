%
% Copyright 2017 Vienna University of Technology.
% Institute of Computer Graphics and Algorithms.
%

function [result, fnc_compute_brightness, fnc_compute_chromaticity, fnc_gamma_correct, fnc_reconstruct] = evc_gamma_correction(input, gamma, saturate)
% This function is our main function. It executes all functions, that
% were implemented by you, in the correct order.

% ATTENTION: You are not allowed to change this function!
     
    fnc_compute_brightness      = @(input) evc_compute_brightness(input);
    fnc_compute_chromaticity    = @(input, brightness) evc_compute_chromaticity(input, brightness);
    fnc_gamma_correct           = @(input, gamma) evc_gamma_correct(input, gamma);
    fnc_reconstruct             = @(corrected_brightness, chromaticity) evc_reconstruct(corrected_brightness, chromaticity);    
    
    if (saturate)
        brightness              = evc_compute_brightness(input);
        chromaticity            = evc_compute_chromaticity(input, brightness);
        brightness_gamma        = evc_gamma_correct(brightness, gamma);
        result                  = evc_reconstruct(brightness_gamma, chromaticity);
    else            
        result                  = evc_gamma_correct(input, gamma);
    end
end

function [brightness] = evc_compute_brightness(input)
%evc_compute_brightness calculates the brightness of the input image.
% First the image is normalized by multiplying it with the reciprocal of
% the maximum value of all three color channels. The brightness is then 
% retrieved by computing a gray-scale image. Afterwards the result
% is multiplied by the maximum value.

%   INPUT
%   input...        image

%   OUTPUT
%   brightness...   brightness of the image

    %HINT: 	The function 'rgb2gray' might be useful.

    max_value = max(input(:));
    normalized = input * (1/max_value);
    brightness = rgb2gray(normalized) * max_value;
end

function [chromaticity] = evc_compute_chromaticity(input, brightness)
%evc_compute_chromaticity calculates the chromaticity of the 'input' image 
% using the 'brightness' values. Therefore the color channels of the input
% image are individually divided by the brightness values.

%   INPUT
%   input...            image
%   brightness...       brightness value

%   OUTPUT
%   chromaticity...     chromaticity of the image
    % error message pointet to rdivide
    
    chromaticity = rdivide(input, repmat(brightness, [1 1 3]));
end

function [corrected] = evc_gamma_correct(input, gamma)
%evc_gamma_correct performs gamma correction on the 'input' image.
% This is done by raising it to the power of the reciprocal value of gamma
% (gamma^-1).

%   INPUT
%   input...        image
%   gamma...        gamma value

%   OUTPUT
%   corrected...    image after gamma correction
    
    if gamma == 0
        gamma = 0.0000000001;
    end
    corrected = times(input, gamma^-1);
end

function [result] = evc_reconstruct(brightness_gamma, chromaticity)
%evc_reconstruct reconstructs the color values by multiplying the corrected 
% brightness with the chromaticity.

%   INPUT
%   brightness_gamma...     gamma-corrected brightness values
%   chromaticity...         chromaticity

%   OUTPUT
%   result...               reconstructed image

    %NOTE:  The following line can be removed. It prevents the framework
    %       from crashing.
    
	%TODO:  Implement this function.
    
    % Inputs must be 2-D, or at least one input must be scalar.
    % To compute elementwise TIMES, use TIMES (.*) instead.
    brightness_gamma = repmat(brightness_gamma, [1 1 3]);
    result = times(brightness_gamma, chromaticity);
end


