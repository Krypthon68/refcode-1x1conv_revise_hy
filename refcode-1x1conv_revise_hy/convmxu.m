%�˺���������˰�������ͨ��ά�ȡ����ͨ��ά��ȫ��ȡ�����㣬�������ά�Ȳ�ֿ���3x3����˼���Ҫ���ô˺���9��
function [out1] = convmxu(weight,feature,bias,index1,index2)    %index1,index2���ڶ�λȨ�ز����ھ�����е�λ��
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
%===========================================================================
ch_in_num = 32;
ch_out_num = 32;

% weight������˳��Ϊ[ch_out, 3, 3, ch_in]
feature_H = 56;
feature_W = 56;
%===========================================================================
out1 = zeros(feature_H,feature_W,ch_out_num);
for i = 1:feature_H
    for j = 1:feature_W
        for k = 1:ch_out_num                %��Ϊ���ͨ��ά��
            for c = 1:ch_in_num            %��Ϊ����ͨ��ά��
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

