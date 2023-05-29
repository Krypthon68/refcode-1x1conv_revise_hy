%===========================================================================
ch_in_num = 32;
ch_out_num = 32;
ch_in_parallel = 16;
ch_out_parallel = 16;
feature_H = 56;
feature_W = 56;
%===========================================================================
rng(0);
feature = randi([-128,127],feature_H,feature_W,ch_in_num);      %��������ͼ��߾�Ϊ56��ͨ����Ϊ32
weight = randi([-128,127],ch_out_num,1,1,ch_in_num);            %����˿�߾�Ϊ1����32���������ͨ����Ϊ32
bias = randi([-1024,1023],1,ch_out_num);                        %ƫ�ò���
output = zeros(feature_H,feature_W,ch_out_num);                 %�������ͼ��״
feature(:,:,4:32) = 0;
weight(:,:,:,4:32) = 0;
%===========================================================================
saveparam(feature,weight,bias)

out1 = convmxu(weight,feature,bias,1,1);                        %��������2��2�ĳ�1��1��
%out2 = convmxu(weight,feature,zeros(1,ch_out_num),1,1);  �������������out2
%out3 = convmxu(weight,feature,zeros(1,ch_out_num),1,2);
%out4 = convmxu(weight,feature,zeros(1,ch_out_num),1,3);
%out5 = convmxu(weight,feature,zeros(1,ch_out_num),2,1);
%out6 = convmxu(weight,feature,zeros(1,ch_out_num),2,3);
%out7 = convmxu(weight,feature,zeros(1,ch_out_num),3,1);
%out8 = convmxu(weight,feature,zeros(1,ch_out_num),3,2);
%out9 = convmxu(weight,feature,zeros(1,ch_out_num),3,3);

output = out1;
%output����������Ϊ��ά�ȡ���ά�ȡ�ͨ��ά��
%output(2:end,2:end,:) = output(2:end,2:end,:) + out2(1:end-1,1:end-1,:);
%output(2:end,:,:) = output(2:end,:,:) + out3(1:end-1,:,:);
%output(2:end,1:end-1,:) = output(2:end,1:end-1,:) + out4(1:end-1,2:end,:);
%output(:,2:end,:) = output(:,2:end,:) + out5(:,1:end-1,:);
%output(:,1:end-1,:) = output(:,1:end-1,:) + out6(:,2:end,:);
%output(1:end-1,2:end,:) = output(1:end-1,2:end,:) + out7(2:end,1:end-1,:);
%output(1:end-1,:,:) = output(1:end-1,:,:) + out8(2:end,:,:);
%output(1:end-1,1:end-1,:) = output(1:end-1,1:end-1,:) + out9(2:end,2:end,:);








%һ��Ϊgolden
golden = zeros(feature_H,feature_W,ch_out_num);
for k = 1:ch_out_num
   wk = reshape(weight(k,:,:,:),1,1,ch_in_num);
   wk = wk(end:-1:1,end:-1:1,end:-1:1);
   tmp = convn(feature,wk,'same');
   golden(:,:,k) = tmp(:,:,ch_in_num/2)+bias(k);
end
golden = int32(golden);
fid = fopen('golden.dat','wb');
for ch_out_block=1:ch_out_num/ch_out_parallel
    for i=1:feature_H
        for j=1:feature_W
            fwrite(fid,output(i,j,(ch_out_block-1)*ch_out_parallel+1:ch_out_block*ch_out_parallel),'int32');
        end
    end
end
fclose(fid);








%����Ϊ����output��golden�Ƿ���ȫ��ͬ
err = 0;
for ch_out=1:ch_out_num
    for i=1:feature_H
        for j=1:feature_W
            if output(i,j,ch_out)~=golden(i,j,ch_out)
                err=err+1;
            end
        end
    end
end
fprintf("error num: %d\n",err);
