function [ I_out, LUT ] = f_hist_adjust_fast(I, In_hist, Out_hist, weight)
% F_HIST_ADJUST_FAST
%   ヒストグラム調整の結果を出力する関数
%

%% エラーチェック
if ndims(I) > 2
    error('入力Iには2次元以下の配列を入れて下さい');
end
if ~isequal(size(In_hist), size(Out_hist))
    error('入力されたヒストグラムのサイズが異なっています');
end

if max(I(:)) <= 1
    I = I*255;
end

if ~exist('weight','var') || isempty(weight)
   weight = 1;
end

%% 前処理

I = double(uint8(I));
m = size(I,1);
n = size(I,2);

In_hist = double(In_hist(:));
Out_hist = double(Out_hist(:));

%% 正規化・累積和
In_hist = In_hist ./ sum(In_hist(:));
Out_hist = Out_hist ./ sum(Out_hist(:));

In_hist_cum = cumsum(In_hist);
if weight == 1
    Mix_hist = Out_hist;
else
    Mix_hist = weight.*Out_hist + (1-weight).*In_hist;
end

Mix_hist_cum = cumsum(Mix_hist);

%% 変換テーブルの生成
LUT = zeros(256,1);
id = 1;
for i = 1:256       % i: 入力
    for j = id:256   % j: 出力
        id = j;
        if Mix_hist_cum(j) >= In_hist_cum(i)    % 累積ヒストグラムの度数の比較
            break;
        end
    end
    LUT(i) = id;    % 入力 i に対応する出力 j
end

%% LUTを用いた値の変換
% I_out = zeros(m,n); % 修正された入力画像のV成分,    m x nサイズ（画像と同じサイズ）
I_out = LUT(I(:)+1)-1;
I_out = reshape(I_out, [m,n]);
% for ii = 1:m
%     for jj = 1:n
%         I_out(ii,jj) = LUT(I(ii,jj)+1)-1;   % 配列のインデックスの関係で1を足したり引いたりする
%     end
% end

%%
end
