function [ W ] = f_grad_norm( In )
% F_GRAD_NORM 勾配ノルムを計算し，ノルムの行列を返す関数
%

% I = double(In);
I = In;
m = size(I,1);
n = size(I,2);

if size(I,3) == 3
    I = uint8(I);

    red   = I(:,:,1);
    green = I(:,:,2);
    blue  = I(:,:,3);

    RGB = [ red(:), green(:), blue(:) ];
    LAB = f_rgb2lsasbs(RGB);

    L = reshape(LAB(:,1), [m,n]);
    a = reshape(LAB(:,2), [m,n]);
    b = reshape(LAB(:,3), [m,n]);

    L = double(L);
    a = double(a);
    b = double(b);
    
    % L についての勾配ノルム
    % 縦の前方差分
    Dvf = zeros(m,n);
    Dvf(1:m-1,:) = L(2:m,:) - L(1:m-1,:);

    % 縦の後方差分
    Dvb = zeros(m,n);
    Dvb(2:m,:) = L(2:m,:) - L(1:m-1,:);

    % 横の前方差分
    Dhf = zeros(m,n);
    Dhf(:,1:n-1) = L(:,2:n) - L(:,1:n-1);

    % 横の後方差分
    Dhb = zeros(m,n);
    Dhb(:,2:n) = L(:,2:n) - L(:,1:n-1);

    % 縦方向の差分 dv の決定: Dvf と Dvb を比較して，絶対値の大きい方を dv に格納
    Dv = Dvf;
    Dv(abs(Dv)<abs(Dvb)) = Dvb(abs(Dv)<abs(Dvb));

    % 横方向の差分 dh の決定: Dhf と Dhb を比較して，絶対値の大きい方を dh に格納
    Dh = Dhf;
    Dh(abs(Dh)<abs(Dhb)) = Dhb(abs(Dh)<abs(Dhb));
    
    L_grad = sqrt(Dv.^2 + Dh.^2);
    
    
    % a についての勾配ノルム
    % 縦の前方差分
    Dvf = zeros(m,n);
    Dvf(1:m-1,:) = a(2:m,:) - a(1:m-1,:);

    % 縦の後方差分
    Dvb = zeros(m,n);
    Dvb(2:m,:) = a(2:m,:) - a(1:m-1,:);

    % 横の前方差分
    Dhf = zeros(m,n);
    Dhf(:,1:n-1) = a(:,2:n) - a(:,1:n-1);

    % 横の後方差分
    Dhb = zeros(m,n);
    Dhb(:,2:n) = a(:,2:n) - a(:,1:n-1);

    % 縦方向の差分 dv の決定: Dvf と Dvb を比較して，絶対値の大きい方を dv に格納
    Dv = Dvf;
    Dv(abs(Dv)<abs(Dvb)) = Dvb(abs(Dv)<abs(Dvb));

    % 横方向の差分 dh の決定: Dhf と Dhb を比較して，絶対値の大きい方を dh に格納
    Dh = Dhf;
    Dh(abs(Dh)<abs(Dhb)) = Dhb(abs(Dh)<abs(Dhb));

    a_grad = sqrt(Dv.^2 + Dh.^2);
    
    
    % b についての勾配ノルム
    % 縦の前方差分
    Dvf = zeros(m,n);
    Dvf(1:m-1,:) = b(2:m,:) - b(1:m-1,:);

    % 縦の後方差分
    Dvb = zeros(m,n);
    Dvb(2:m,:) = b(2:m,:) - b(1:m-1,:);

    % 横の前方差分
    Dhf = zeros(m,n);
    Dhf(:,1:n-1) = b(:,2:n) - b(:,1:n-1);

    % 横の後方差分
    Dhb = zeros(m,n);
    Dhb(:,2:n) = b(:,2:n) - b(:,1:n-1);

    % 縦方向の差分 dv の決定: Dvf と Dvb を比較して，絶対値の大きい方を dv に格納
    Dv = Dvf;
    Dv(abs(Dv)<abs(Dvb)) = Dvb(abs(Dv)<abs(Dvb));

    % 横方向の差分 dh の決定: Dhf と Dhb を比較して，絶対値の大きい方を dh に格納
    Dh = Dhf;
    Dh(abs(Dh)<abs(Dhb)) = Dhb(abs(Dh)<abs(Dhb));

    b_grad = sqrt(Dv.^2 + Dh.^2);
    
    W = L_grad .^ 2 + a_grad .^ 2 + b_grad .^ 2;
    W = sqrt(W);
    
else
    I = double(I);

    % 縦の前方差分
    Dvf = zeros(m,n);
    Dvf(1:m-1,:) = I(2:m,:) - I(1:m-1,:);

    % 縦の後方差分
    Dvb = zeros(m,n);
    Dvb(2:m,:) = I(2:m,:) - I(1:m-1,:);

    % 横の前方差分
    Dhf = zeros(m,n);
    Dhf(:,1:n-1) = I(:,2:n) - I(:,1:n-1);

    % 横の後方差分
    Dhb = zeros(m,n);
    Dhb(:,2:n) = I(:,2:n) - I(:,1:n-1);

    % 縦方向の差分 dv の決定: Dvf と Dvb を比較して，絶対値の大きい方を dv に格納
    Dv = Dvf;
    Dv(abs(Dv)<abs(Dvb)) = Dvb(abs(Dv)<abs(Dvb));

    % 横方向の差分 dh の決定: Dhf と Dhb を比較して，絶対値の大きい方を dh に格納
    Dh = Dhf;
    Dh(abs(Dh)<abs(Dhb)) = Dhb(abs(Dh)<abs(Dhb));

    % 勾配ノルム w の算出
    W = sqrt(Dv.^2 + Dh.^2);

end

end
