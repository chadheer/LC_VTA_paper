%Perform a fourier transform on data and normalize psd
%Chad Heer

%INPUTS 
% data = struct with F from axon analysis
%planes = number of planes
%frames = frame numbers to use 

%OUTPUT 
%data = data struct with normalized psdx appended

function[data] = find_axon_norm_psdx(data, planes, frames)

data.F = data.F(frames,:);

N = length(data.F);
fs = 30.98/planes;

xdft = fft(data.F);
xdft = xdft(1:N/2+1,:);
psdx = (1/(fs*N)) * abs(xdft).^2;
psdx(2:end-1) = 2*psdx(2:end-1);
data.freq = 0:fs/length(data.F):fs/2;

data.normalized_psdx = psdx./nanmean(psdx(data.freq >= 1 & data.freq <= 3,:));