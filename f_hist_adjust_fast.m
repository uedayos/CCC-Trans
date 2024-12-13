function [ I_out, LUT ] = f_hist_adjust_fast(I, In_hist, Out_hist, weight)
% F_HIST_ADJUST_FAST
%   �q�X�g�O���������̌��ʂ��o�͂���֐�
%

%% �G���[�`�F�b�N
if ndims(I) > 2
    error('����I�ɂ�2�����ȉ��̔z������ĉ�����');
end
if ~isequal(size(In_hist), size(Out_hist))
    error('���͂��ꂽ�q�X�g�O�����̃T�C�Y���قȂ��Ă��܂�');
end

if max(I(:)) <= 1
    I = I*255;
end

if ~exist('weight','var') || isempty(weight)
   weight = 1;
end

%% �O����

I = double(uint8(I));
m = size(I,1);
n = size(I,2);

In_hist = double(In_hist(:));
Out_hist = double(Out_hist(:));

%% ���K���E�ݐϘa
In_hist = In_hist ./ sum(In_hist(:));
Out_hist = Out_hist ./ sum(Out_hist(:));

In_hist_cum = cumsum(In_hist);
if weight == 1
    Mix_hist = Out_hist;
else
    Mix_hist = weight.*Out_hist + (1-weight).*In_hist;
end

Mix_hist_cum = cumsum(Mix_hist);

%% �ϊ��e�[�u���̐���
LUT = zeros(256,1);
id = 1;
for i = 1:256       % i: ����
    for j = id:256   % j: �o��
        id = j;
        if Mix_hist_cum(j) >= In_hist_cum(i)    % �ݐσq�X�g�O�����̓x���̔�r
            break;
        end
    end
    LUT(i) = id;    % ���� i �ɑΉ�����o�� j
end

%% LUT��p�����l�̕ϊ�
% I_out = zeros(m,n); % �C�����ꂽ���͉摜��V����,    m x n�T�C�Y�i�摜�Ɠ����T�C�Y�j
I_out = LUT(I(:)+1)-1;
I_out = reshape(I_out, [m,n]);
% for ii = 1:m
%     for jj = 1:n
%         I_out(ii,jj) = LUT(I(ii,jj)+1)-1;   % �z��̃C���f�b�N�X�̊֌W��1�𑫂�����������肷��
%     end
% end

%%
end
