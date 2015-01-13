function [bandwidth,density,xmesh]=kde(data,n,MIN,MAX)
% Reliable and extremely fast kernel density estimator for 1 dimensional data;
%        Gaussian kernel is assumed and the bandwidth is chosen automatically;
%
% INPUTS:
%     data    - a vector of data from which the density estimate is constructed;
%   MIN, MAX  - defines the interval [MIN,MAX] on which the density estimate is constructed;
%               the default values of MIN and MAX are: 
%               MIN=min(data)-Range/100 and MAX=max(data)+Range/100, where Range=max(data)-min(data);   
%          n  - the number of mesh points used in the uniform discretization of the
%               interval [MIN, MAX]; n has to be a power of two; if n is not a power of two, then
%               n is rounded up to the next power of two, i.e., n is set to n=2^ceil(log2(n));
%               the default value of n is n=2^12;
% OUTPUTS:
%   bandwidth - the optimal bandwidth (Gaussian kernel assumed);
%     density - column vector of length 'n' with the values of the density
%               estimate at the grid points;
%     xmesh   - the grid over which the density estimate is computed;
%  Reference: Botev, Z. I.,
%             "A Novel Nonparametric Density Estimator",Technical Report,The University of Queensland
%             http://espace.library.uq.edu.au/view.php?pid=UQ:12535
%
%  Example:
%    data=randn(1000,1); 
%    [bandwidth,density,xmesh]=kde(data,2^12,min(data)-1,max(data)+1);
%    plot(xmesh,density)

data=data(:); %make data a column vector
if nargin<2 % if n is not supplied switch to the default
    n=2^12;
end
n=2^ceil(log2(n)); % round up n to the next power of 2;

if nargin<4 %define the default  interval [MIN,MAX]
    minimum=min(data); maximum=max(data);
    Range=maximum-minimum;
    MIN=minimum-Range/10; MAX=maximum+Range/10;
end
% set up the grid over which the density estimate is computed;
R=MAX-MIN; dx=R/(n-1); xmesh=MIN+[0:dx:R]; N=length(data);
%bin the data uniformly using the grid define above;
initial_data=histc(data,xmesh)/N;
a=dct1d(initial_data); % discrete cosine transform of initial data
% now compute the optimal bandwidth^2 using the GCE method
t_star=gce(a,n,N);
% smooth the discrete cosine transform of initial data using t_star
a_t=a.*exp(-[0:n-1]'.^2*pi^2*t_star/2);
% now apply the inverse discrete cosine transform
  if nargout>1
    density=idct1d(a_t)/R;
  end
bandwidth=sqrt(t_star)*R;
end
function t_star=gce(a,n,N)
a=a(2:end)/2;
I=[1:n-1]'.^2;
a2=a.^2;
Var_a=zeros(n-1,1);
Var_a(1:n/2-1)=(1/2+1/2*a(2:2:n-1)-a2(1:n/2-1))/N;

t_star=fzero(@mise,[0,1]);
NORM=2*pi^4*sum(I.^2.*a2.*exp(-I*pi^2*t_star));
%NORM=.5*pi^4*sum([1:n-1]'.^4.*a_t(2:end).^2)/R^5;
t_star=[2*N*sqrt(pi)*NORM]^(-2/5);
    function  out=mise(t)

        out=sum((a2+Var_a).*(1-exp(-I*pi^2*t/2)).^2./I)+...
            sqrt(t/pi)/N*(pi^2/2)-sum(Var_a./I);
    end
end

function data=dct1d(data)
% computes the discrete cosine transform of the column vector data
[nrows,ncols]= size(data);
% Compute weights to multiply DFT coefficients
weight = [1;2*(exp(-i*(1:nrows-1)*pi/(2*nrows))).'];
% Re-order the elements of the columns of x
data = [ data(1:2:end,:); data(end:-2:2,:) ];
% Multiply FFT by weights:
data= real(weight.* fft(data));
end
function out = idct1d(data)
% computes the inverse discrete cosine transform
[nrows,ncols]=size(data);
% Compute weights
weights = nrows*exp(i*(0:nrows-1)*pi/(2*nrows)).';
% Compute x tilde using equation (5.93) in Jain
data = real(ifft(weights.*data));
% Re-order elements of each column according to equations (5.93) and
% (5.94) in Jain
out = zeros(nrows,1);
out(1:2:nrows) = data(1:nrows/2);
out(2:2:nrows) = data(nrows:-1:nrows/2+1);
%   Reference: 
%      A. K. Jain, "Fundamentals of Digital Image
%      Processing", pp. 150-153.
end

