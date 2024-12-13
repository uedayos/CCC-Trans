function [ W ] = f_grad_norm( In )
% F_GRAD_NORM Œù”zƒmƒ‹ƒ€‚ğŒvZ‚µCƒmƒ‹ƒ€‚Ìs—ñ‚ğ•Ô‚·ŠÖ”
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
    
    % L ‚É‚Â‚¢‚Ä‚ÌŒù”zƒmƒ‹ƒ€
    % c‚Ì‘O•û·•ª
    Dvf = zeros(m,n);
    Dvf(1:m-1,:) = L(2:m,:) - L(1:m-1,:);

    % c‚ÌŒã•û·•ª
    Dvb = zeros(m,n);
    Dvb(2:m,:) = L(2:m,:) - L(1:m-1,:);

    % ‰¡‚Ì‘O•û·•ª
    Dhf = zeros(m,n);
    Dhf(:,1:n-1) = L(:,2:n) - L(:,1:n-1);

    % ‰¡‚ÌŒã•û·•ª
    Dhb = zeros(m,n);
    Dhb(:,2:n) = L(:,2:n) - L(:,1:n-1);

    % c•ûŒü‚Ì·•ª dv ‚ÌŒˆ’è: Dvf ‚Æ Dvb ‚ğ”äŠr‚µ‚ÄCâ‘Î’l‚Ì‘å‚«‚¢•û‚ğ dv ‚ÉŠi”[
    Dv = Dvf;
    Dv(abs(Dv)<abs(Dvb)) = Dvb(abs(Dv)<abs(Dvb));

    % ‰¡•ûŒü‚Ì·•ª dh ‚ÌŒˆ’è: Dhf ‚Æ Dhb ‚ğ”äŠr‚µ‚ÄCâ‘Î’l‚Ì‘å‚«‚¢•û‚ğ dh ‚ÉŠi”[
    Dh = Dhf;
    Dh(abs(Dh)<abs(Dhb)) = Dhb(abs(Dh)<abs(Dhb));
    
    L_grad = sqrt(Dv.^2 + Dh.^2);
    
    
    % a ‚É‚Â‚¢‚Ä‚ÌŒù”zƒmƒ‹ƒ€
    % c‚Ì‘O•û·•ª
    Dvf = zeros(m,n);
    Dvf(1:m-1,:) = a(2:m,:) - a(1:m-1,:);

    % c‚ÌŒã•û·•ª
    Dvb = zeros(m,n);
    Dvb(2:m,:) = a(2:m,:) - a(1:m-1,:);

    % ‰¡‚Ì‘O•û·•ª
    Dhf = zeros(m,n);
    Dhf(:,1:n-1) = a(:,2:n) - a(:,1:n-1);

    % ‰¡‚ÌŒã•û·•ª
    Dhb = zeros(m,n);
    Dhb(:,2:n) = a(:,2:n) - a(:,1:n-1);

    % c•ûŒü‚Ì·•ª dv ‚ÌŒˆ’è: Dvf ‚Æ Dvb ‚ğ”äŠr‚µ‚ÄCâ‘Î’l‚Ì‘å‚«‚¢•û‚ğ dv ‚ÉŠi”[
    Dv = Dvf;
    Dv(abs(Dv)<abs(Dvb)) = Dvb(abs(Dv)<abs(Dvb));

    % ‰¡•ûŒü‚Ì·•ª dh ‚ÌŒˆ’è: Dhf ‚Æ Dhb ‚ğ”äŠr‚µ‚ÄCâ‘Î’l‚Ì‘å‚«‚¢•û‚ğ dh ‚ÉŠi”[
    Dh = Dhf;
    Dh(abs(Dh)<abs(Dhb)) = Dhb(abs(Dh)<abs(Dhb));

    a_grad = sqrt(Dv.^2 + Dh.^2);
    
    
    % b ‚É‚Â‚¢‚Ä‚ÌŒù”zƒmƒ‹ƒ€
    % c‚Ì‘O•û·•ª
    Dvf = zeros(m,n);
    Dvf(1:m-1,:) = b(2:m,:) - b(1:m-1,:);

    % c‚ÌŒã•û·•ª
    Dvb = zeros(m,n);
    Dvb(2:m,:) = b(2:m,:) - b(1:m-1,:);

    % ‰¡‚Ì‘O•û·•ª
    Dhf = zeros(m,n);
    Dhf(:,1:n-1) = b(:,2:n) - b(:,1:n-1);

    % ‰¡‚ÌŒã•û·•ª
    Dhb = zeros(m,n);
    Dhb(:,2:n) = b(:,2:n) - b(:,1:n-1);

    % c•ûŒü‚Ì·•ª dv ‚ÌŒˆ’è: Dvf ‚Æ Dvb ‚ğ”äŠr‚µ‚ÄCâ‘Î’l‚Ì‘å‚«‚¢•û‚ğ dv ‚ÉŠi”[
    Dv = Dvf;
    Dv(abs(Dv)<abs(Dvb)) = Dvb(abs(Dv)<abs(Dvb));

    % ‰¡•ûŒü‚Ì·•ª dh ‚ÌŒˆ’è: Dhf ‚Æ Dhb ‚ğ”äŠr‚µ‚ÄCâ‘Î’l‚Ì‘å‚«‚¢•û‚ğ dh ‚ÉŠi”[
    Dh = Dhf;
    Dh(abs(Dh)<abs(Dhb)) = Dhb(abs(Dh)<abs(Dhb));

    b_grad = sqrt(Dv.^2 + Dh.^2);
    
    W = L_grad .^ 2 + a_grad .^ 2 + b_grad .^ 2;
    W = sqrt(W);
    
else
    I = double(I);

    % c‚Ì‘O•û·•ª
    Dvf = zeros(m,n);
    Dvf(1:m-1,:) = I(2:m,:) - I(1:m-1,:);

    % c‚ÌŒã•û·•ª
    Dvb = zeros(m,n);
    Dvb(2:m,:) = I(2:m,:) - I(1:m-1,:);

    % ‰¡‚Ì‘O•û·•ª
    Dhf = zeros(m,n);
    Dhf(:,1:n-1) = I(:,2:n) - I(:,1:n-1);

    % ‰¡‚ÌŒã•û·•ª
    Dhb = zeros(m,n);
    Dhb(:,2:n) = I(:,2:n) - I(:,1:n-1);

    % c•ûŒü‚Ì·•ª dv ‚ÌŒˆ’è: Dvf ‚Æ Dvb ‚ğ”äŠr‚µ‚ÄCâ‘Î’l‚Ì‘å‚«‚¢•û‚ğ dv ‚ÉŠi”[
    Dv = Dvf;
    Dv(abs(Dv)<abs(Dvb)) = Dvb(abs(Dv)<abs(Dvb));

    % ‰¡•ûŒü‚Ì·•ª dh ‚ÌŒˆ’è: Dhf ‚Æ Dhb ‚ğ”äŠr‚µ‚ÄCâ‘Î’l‚Ì‘å‚«‚¢•û‚ğ dh ‚ÉŠi”[
    Dh = Dhf;
    Dh(abs(Dh)<abs(Dhb)) = Dhb(abs(Dh)<abs(Dhb));

    % Œù”zƒmƒ‹ƒ€ w ‚ÌZo
    W = sqrt(Dv.^2 + Dh.^2);

end

end
