%此函数将卷积核按照输入通道维度、输出通道维度全部取出计算，但将宽高维度拆分开；3x3卷积核即需要调用此函数9次
function [out1] = convmxu(weight,feature,bias,index1,index2)    %index1,index2用于定位权重参数在卷积核中的位置
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
%===========================================================================
ch_in_num = 32;
ch_out_num = 32;

% weight的排列顺序为[ch_out, 3, 3, ch_in]
feature_H = 56;
feature_W = 56;
%===========================================================================
out1 = zeros(feature_H,feature_W,ch_out_num);
for i = 1:feature_H
    for j = 1:feature_W
        for k = 1:ch_out_num                %此为输出通道维度
            for c = 1:ch_in_num            %此为输入通道维度
                if(c==1)
                    out1(i,j,k) = bias(k) + weight(k,1,1,c)*feature(i,j,c);
                else
                    out1(i,j,k) = out1(i,j,k) + weight(k,1,1,c)*feature(i,j,c);
                end
            end
        end
    end
end

end

