# refcode-1x1conv_revise_hy
卷积核是1*1的滑窗

把refcode-3x3conv做了如下改变
1、卷积核从3*3改成1*1（对应很多细节或大块地方都做了修改）
2、输入通道从32改为3        feature(:,:,4:32) = 0;
