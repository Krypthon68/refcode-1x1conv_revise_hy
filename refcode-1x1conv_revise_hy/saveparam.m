function [] = saveparam(feature,weight,bias)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%===========================================================================
ch_in_num = 32;
ch_out_num = 32;
ch_in_parallel = 16;
ch_out_parallel = 16;
% weight������˳��Ϊ[ch_out, 1, 1, ch_in]
feature_H = 56;
feature_W = 56;
%===========================================================================

feature = int8(feature);
weight = int8(weight);
bias = int32(bias);                               %���������ͨ������ͬ������Ϊ32
bias4 = bitand(bitshift(bias,-24),int32(255));    %���ƣ���Ϊ��λ��Ϊ����
bias3 = bitand(bitshift(bias,-16),int32(255));
bias2 = bitand(bitshift(bias,-8),int32(255));
bias1 = bitand(bias,int32(255));





fid = fopen('feature.dat','wb');
for ch_in_block=1:ch_in_num/ch_in_parallel
    for i=1:feature_H
        for j=1:feature_W
            fwrite(fid,feature(i,j,(ch_in_block-1)*ch_in_parallel+1:ch_in_block*ch_in_parallel),'int8');
        end
    end
end
fclose(fid);






fid = fopen('weight.dat','wb');
for ch_out_block=1:ch_out_num/ch_out_parallel
    for ch_in_block=1:ch_in_num/ch_in_parallel
        for ch_in=1:ch_in_parallel
            %�Ƚ�ÿ��������ڿ��ƽ�������ĵ�����Ԫ��д��(�ܹ�32�������)
            fwrite(fid,weight((ch_out_block-1)*ch_out_parallel+1:ch_out_block*ch_out_parallel,1,1,(ch_in_block-1)*ch_in_parallel+ch_in),'int8'); 
        end
        if(ch_in_block==1)
            fwrite(fid,uint8(bias4((ch_out_block-1)*ch_out_parallel+1:ch_out_block*ch_out_parallel)),'uint8');  %��ʱ�õ�32��biasÿ�������8λ
            fwrite(fid,uint8(bias3((ch_out_block-1)*ch_out_parallel+1:ch_out_block*ch_out_parallel)),'uint8');
            fwrite(fid,uint8(bias2((ch_out_block-1)*ch_out_parallel+1:ch_out_block*ch_out_parallel)),'uint8');
            fwrite(fid,uint8(bias1((ch_out_block-1)*ch_out_parallel+1:ch_out_block*ch_out_parallel)),'uint8');  %��ʱ�õ�bias�����8λ
        else
            for k=1:ch_out_parallel
                fwrite(fid,0,'int32'); 
            end
        end
    end
end








            for ch_out_block=1:ch_out_num/ch_out_parallel
                for ch_in_block=1:ch_in_num/ch_in_parallel
                    for ch_in=1:ch_in_parallel
                        %�Ƚ�ÿ��������ڿ��ƽ�������ĵ�����Ԫ��д��(�ܹ�32�������)
                        fwrite(fid,weight((ch_out_block-1)*ch_out_parallel+1:ch_out_block*ch_out_parallel,1,1,(ch_in_block-1)*ch_in_parallel+ch_in),'int8');       
                    end
                    for k=1:ch_out_parallel
                        fwrite(fid,0,'int32');            
                    end
                end
            end
  
fclose(fid);
end

