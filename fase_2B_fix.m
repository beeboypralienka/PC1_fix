% INPUT:
%--------
% Data "PC1_15_Split_1_2B_Split" -> Data split 2B
% Data "PC1_17_DataFitur_2B"  -> Data training untuk 2B

% ----------------------------------------------------------------------------------------------------------
% Cari jumlah TRUE dan FALSE serta nilai ENTROPY children di Mtraining berdasarkan "PC1_15_Split_1_2B_Split"
% ----------------------------------------------------------------------------------------------------------                        
   
for iKolomCellB = 1 : 21 % Iterasi fitur PC1 ada 21 (exclude kelas)    
%--    
    panjangSplit2B = length(PC1_15_Split_1_2B_Split{1,iKolomCellB}); % Setiap DATA SPLIT diulang sebanyak jumlah DATA TRAINING
    panjangTraining2B = size(PC1_17_DataFitur_2B{1,iKolomCellB},1); % Iterasi data training AGAR MATCH dengan SATU DATA split
    for iBarisSplitB = 1 : panjangSplit2B % data SPLIT 2B          
        
        % ----------------------------------------------------------------------
        % Di-NOL-kan, karena jumlah TRUE dan FALSE setiap data split itu berbeda
        % ----------------------------------------------------------------------
        jmlTrueKurangB = 0;
        jmlFalseKurangB = 0;
        jmlTrueLebihB = 0;
        jmlFalseLebihB = 0;  
                                        
        % -----------------------------
        % Antisipasi kalau split2B = [] <-- Kosong, gada nlainya (Gak perlu update kolom 2-9)
        % -----------------------------                
        dataSplitB = PC1_15_Split_1_2B_Split{1, iKolomCellB}(iBarisSplitB,1); % Data SPLIT 2B
        if length(dataSplitB) ~= 0                   
        %--    
            for iBarisTrainingB = 1 : panjangTraining2B % data TRAINING 2B
                % -----------------------------------------------------------
                % Hitung jumlah TRUE dan FALSE dari kategoti ( <= ) dan ( > )
                % -----------------------------------------------------------
                dataTrainingB = PC1_17_DataFitur_2B{1, iKolomCellB}(iBarisTrainingB,1); % Data training                    
                dataKelasB = PC1_17_DataFitur_2B{1, iKolomCellB}(iBarisTrainingB,2); % Data kelas                                 
                if dataTrainingB <= dataSplitB % ada berapa data training yang ( <= ) data split                                        
                    if  dataKelasB == 1 % Hitung jumlah TRUE pada parameter ( <= )                        
                        jmlTrueKurangB = jmlTrueKurangB + 1; % Hitung jumlah TRUE ( <= )                         
                    else % Hitung jumlah FALSE pada parameter ( <= )                        
                        jmlFalseKurangB = jmlFalseKurangB + 1; % Hitung jumlah FALSE ( <= )
                    end
                else % ada berapa data training yang ( > ) data split
                    if dataKelasB == 1 % Hitung jumlah TRUE dan FALSE pada parameter ( > )                        
                        jmlTrueLebihB = jmlTrueLebihB + 1; % Hitung jumlah TRUE ( > )                        
                    else                        
                        jmlFalseLebihB = jmlFalseLebihB + 1; % Hitung jumlah FALSE ( > )
                    end
                end
            end    
            PC1_15_Split_1_2B_Split{1,iKolomCellB}(iBarisSplitB,2) = jmlTrueKurangB; % Jumlah TRUE dengan parameter ( <= ) disimpan di kolom 2
            PC1_15_Split_1_2B_Split{1,iKolomCellB}(iBarisSplitB,3) = jmlFalseKurangB; % Jumlah FALSE dengan parameter ( <= ) disimpan di kolom 3
            PC1_15_Split_1_2B_Split{1,iKolomCellB}(iBarisSplitB,5) = jmlTrueLebihB; % Jumlah TRUE dengan parameter ( > ) disimpan di kolom 5
            PC1_15_Split_1_2B_Split{1,iKolomCellB}(iBarisSplitB,6) = jmlFalseLebihB; % Jumlah FALSE dengan parameter ( > ) disimpan di kolom 6                                

            % ---------------------------------------------
            % Cari entropy child "2B" dari parameter ( <= )
            % ---------------------------------------------                       
            totalKurangB = jmlTrueKurangB + jmlFalseKurangB; % Total jumlah TRUE dan jumlah FALSE dari parameter ( <= )              
            if totalKurangB ~=0 % Selama total jumlah TRUE dan FALSE bukan NOL pada parameter ( <= )                
                piTrueKurangB(iBarisSplitB,1) = jmlTrueKurangB / (jmlTrueKurangB+jmlFalseKurangB); % Hitung jumlah TRUE ( <= )
                piFalseKurangB(iBarisSplitB,1) = jmlFalseKurangB / (jmlTrueKurangB+jmlFalseKurangB); % Hitung jumlah FALSE ( <= )                
                if piTrueKurangB(iBarisSplitB,1) == 0 || piFalseKurangB(iBarisSplitB,1) == 0 % Jika hasil Pi TRUE atau Pi FALSE itu NOL, dipastikan entropyChild (<=) juga NOL                    
                    entropyChildKurangB(iBarisSplitB,1) = 0; % Entropy child ( <= ) dijadikan NOL
                else % Jika hasil ( <= ) Pi TRUE dan Pi FALSE bukan NOL                                        
                    % ----------------------------
                    % Hitung entropy child ( <= )
                    % ----------------------------
                    entropyChildKurangB = entropyChildrenEBD_fix(piTrueKurangB,piFalseKurangB,iBarisSplitB);
                end                
            else % Jika total jumlah TRUE dan FALSE adalah NOL pada parameter ( <= ), maka dipastikan entropyChild (<=) juga NOL                
                entropyChildKurangB(iBarisSplitB,1) = 0; % Entropy child ( <= ) dijadikan NOL
            end             
            PC1_15_Split_1_2B_Split{1,iKolomCellB}(iBarisSplitB,4) = entropyChildKurangB(iBarisSplitB,1); % Nilai entropy child dari parameter ( <= ) disimpan di kolom 4                          

            % --------------------------------------------
            % Cari entropy child "2B" dari parameter ( > )
            % --------------------------------------------                         
            totalLebihB = jmlTrueLebihB + jmlFalseLebihB; % Total jumlah TRUE dan jumlah FALSE dari parameter ( > )                        
            if totalLebihB ~= 0 % Selama total jumlah TRUE dan FALSE bukan NOL pada parameter ( > )
                piTrueLebihB(iBarisSplitB,1) = jmlTrueLebihB / (jmlTrueLebihB+jmlFalseLebihB); % Hitung jumlah TRUE ( > )
                piFalseLebihB(iBarisSplitB,1) = jmlFalseLebihB / (jmlTrueLebihB+jmlFalseLebihB); % Hitung jumlah FALSE ( > )                
                if piTrueLebihB(iBarisSplitB,1) == 0 || piFalseLebihB(iBarisSplitB,1) == 0 % Jika hasil Pi TRUE atau Pi FALSE itu NOL, dipastikan entropyChild ( > ) juga NOL                   
                    entropyChildLebihB(iBarisSplitB,1) = 0; % Entropy child ( > ) dijadikan NOL
                else % Jika hasil ( > ) Pi TRUE dan Pi FALSE bukan NOL
                    % ---------------------------
                    % Hitung entropy child ( > )
                    % ---------------------------                    
                    entropyChildLebihB = entropyChildrenEBD_fix(piTrueLebihB, piFalseLebihB,iBarisSplitB);                   
                end
            else % Jika total jumlah TRUE dan FALSE adalah NOL pada parameter ( > )
                entropyChildLebihB(iBarisSplitB,1) = 0; % Entropy child ( > ) dijadikan NOL
            end            
            PC1_15_Split_1_2B_Split{1,iKolomCellB}(iBarisSplitB,7) = entropyChildLebihB(iBarisSplitB,1); % Nilai entropy child dari parameter ( > ) disimpan di kolom 7                                                    

            % -----------------------------------------
            % Mencari nilai INFO dari setiap data split
            % -----------------------------------------
            dataChildKurangB = (totalKurangB/jmlData) * PC1_15_Split_1_2B_Split{1, iKolomCellB}(iBarisSplitB,4);
            dataChildLebihB = (totalLebihB/jmlData) * PC1_15_Split_1_2B_Split{1, iKolomCellB}(iBarisSplitB,7);
            INFOsplitB(iBarisSplitB,1) = (dataChildKurangB + dataChildLebihB);
            PC1_15_Split_1_2B_Split{1,iKolomCellB}(iBarisSplitB,8) = INFOsplitB(iBarisSplitB,1); % nilai INFO dari data SPLIT. disimpan di kolom 8

            % ------------------------------------
            % Mencari nilai GAIN dari setiap INFO
            % ------------------------------------
            GAINinfoB(iBarisSplitB,1) = PC1_03_Keterangan(1,4) - INFOsplitB(iBarisSplitB,1);
            PC1_15_Split_1_2B_Split{1,iKolomCellB}(iBarisSplitB,9) = GAINinfoB(iBarisSplitB,1); % nilai INFO dari data SPLIT. disimpan di kolom 9                        

            % ----------------------------------------------------------------------------------------------------------------------------
            % Penyederhanaan variable "PC1_15_Split_1_2B_Split" 
            % [1] Data Split, [2] TRUE(<=), [3] FALSE(<=), [4] entropy(<=), [5] TRUE(>), [6] FALSE(>), [7] entropy(>), [8] INFO, [9] GAIN
            % ----------------------------------------------------------------------------------------------------------------------------                                                                               
        %--    
        end                                                                         
    end     
            
    % -------------------------------------------
    % Kalau gada nilai GAIN-nya, ga usah cari MAX
    % -------------------------------------------
    if length(PC1_15_Split_1_2B_Split{1,iKolomCellB}) ~= 0                                        
        % ---------------------------------------------------------------
        % Mencari nilai best split berdasarkan nilai GAIN tertinggi (max)
        % ---------------------------------------------------------------
        [NilaiB,BarisKeB] = max(PC1_15_Split_1_2B_Split{1,iKolomCellB}(:,9)); % Ambil urutan ke berapa si split terbaik itu dan ambil nilai max gain-nya
        angkaSplitB = PC1_15_Split_1_2B_Split{1, iKolomCellB}(BarisKeB,1); % Angka split terbaik dari daftar urut split
        PC1_19_BEST_Split_2B{1,iKolomCellB} = [BarisKeB angkaSplitB NilaiB]; % nilai max Gain dari data split ke berapa                                                                                                                   
    end            
%--
end              
               
% OUTPUT:
% --------
% Entropy children B ( <= ) dan ( > )
% Nilai INFO dari setiap data split di FITUR dan FOLD tertentu
% Nilai GAIN dari setiap INFO di FITUR dan FOLD tertentu
% "PC1_15_Split_1_2B_Split" dengan total 9 kolom
% Nilai Gain (MAX) sebagai split terbaik "PC1_19_BEST_Split_2B"        
