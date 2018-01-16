function AssetDataMerge = mergeCOMAssetData(AssetData,collist)
%��AssetData�е���Ʒ�ϲ�����
    comdata = AssetData(1,collist);
    ncom = size(comdata,2);
    nt = size(comdata{1,1},1) - 1;
    pnl_h = zeros(nt,1);
    pnl_t = zeros(nt,1);
    Asset_deposit = zeros(nt,1);
    Asset_all = zeros(nt,1);
    Asset_cash = zeros(nt,1);

    %�ϲ�������
    for i = 1:ncom
        pnl_h = pnl_h + cell2mat(comdata{1,i}(2:end,3));
        pnl_t = pnl_t + cell2mat(comdata{1,i}(2:end,4)); 
        Asset_deposit = Asset_deposit + cell2mat(comdata{1,i}(2:end,5));
        Asset_all = Asset_all + cell2mat(comdata{1,i}(2:end,6));
        Asset_cash = Asset_cash + cell2mat(comdata{1,i}(2:end,7));
    end
    %�ϲ���Ʒ���ݸ�ֵ
    AssetCOM = comdata{1,1};
    AssetCOM(2:end,2) = {'NH0100.NHF'};
    AssetCOM(2:end,3) = num2cell(pnl_h);
    AssetCOM(2:end,4) = num2cell(pnl_t);
    AssetCOM(2:end,5) = num2cell(Asset_deposit);
    AssetCOM(2:end,6) = num2cell(Asset_all);
    AssetCOM(2:end,7) = num2cell(Asset_cash);
    %�ü�������õ�����Ʒ�ʲ�,Ȼ����AssetCOM�ϲ�
    ndata = size(AssetData,2);
    C = setdiff((1:ndata),collist);
    %AssetData(1,C)
    %�ϲ�
    AssetDataMerge = cell(1,length(C)+1);
    AssetDataMerge(C) = AssetData(1,C);
    AssetDataMerge{1,end} = AssetCOM;
end