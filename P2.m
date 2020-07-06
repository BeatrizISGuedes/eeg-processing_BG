%%%% Script for EEG preprocessing - P2
% BEATRIZ GUEDES 

%% limpar
clc
clear all

%% Abrir eeglab
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

%% Upload Runs
%EEG = loadcurry('C:\Users\ASUS\Desktop\ICNAS\testes\P2 GM\run 1.dap', 'CurryLocations', 'False');

numRun=4; %definir número de Runs efetuados
numPart=2; %indicar o número de participantes
for j=1:numPart
     for i=1:numRun
        participante=num2str(j);   
        numero = num2str(i);   
        name1 = strcat('run',numero,'.set');
        if j==1
           EEG = pop_loadset('filename', name1,'filepath','C:\\Users\\ASUS\\Desktop\\ICNAS\\testes\\P1 NM');
           name2=strcat('P',participante,'_',name1,'.set');
           EEG = pop_saveset( EEG, 'filename', name2,'filepath','C:\\Users\\ASUS\\Desktop\\ICNAS\\testes\\P1 NM\\script');
        else
            EEG = pop_loadset('filename', name1,'filepath','C:\\Users\\ASUS\\Desktop\\ICNAS\\testes\\P2 GM\\análise\\');
            name2=strcat('P',participante,'_',name1,'.set');
            EEG = pop_saveset( EEG, 'filename', name2,'filepath','C:\\Users\\ASUS\\Desktop\\ICNAS\\testes\\P2 GM\\script\\');
        end
     end
end
%% Merge
EEG = pop_loadset('filename','run1.set','filepath','C:\\Users\\ASUS\\Desktop\\ICNAS\\testes\\P2 GM\\análise\\');
EEG = pop_loadset('filename','run2.set','filepath','C:\\Users\\ASUS\\Desktop\\ICNAS\\testes\\P2 GM\\análise\\');
EEG = pop_mergeset( ALLEEG, [1  2], 0); %6
EEG = pop_saveset( EEG, 'filename','P2_runs_1_2.set','filepath','C:\\Users\\ASUS\\Desktop\\ICNAS\\testes\\P2 GM\\script\\');

EEG = pop_loadset('filename','run3.set','filepath','C:\\Users\\ASUS\\Desktop\\ICNAS\\testes\\P2 GM\\análise\\');
EEG = pop_loadset('filename','run4.set','filepath','C:\\Users\\ASUS\\Desktop\\ICNAS\\testes\\P2 GM\\análise\\');
EEG = pop_mergeset( ALLEEG, [3  4], 0); %7
EEG = pop_saveset( EEG, 'filename','P2_runs_3_4.set','filepath','C:\\Users\\ASUS\\Desktop\\ICNAS\\testes\\P2 GM\\script\\');

EEG = pop_loadset('filename','P2_runs_1_2.set','filepath','C:\\Users\\ASUS\\Desktop\\ICNAS\\testes\\P2 GM\\script\\');
EEG = pop_loadset('filename','run5.set','filepath','C:\\Users\\ASUS\\Desktop\\ICNAS\\testes\\P2 GM\\análise\\');
EEG = pop_mergeset( ALLEEG, [5  6], 0); %8
EEG = pop_saveset( EEG, 'filename','P2_runs_1_2_5.set','filepath','C:\\Users\\ASUS\\Desktop\\ICNAS\\testes\\P2 GM\\script\\');


EEG = pop_loadset('filename','P2_runs_3_4.set','filepath','C:\\Users\\ASUS\\Desktop\\ICNAS\\testes\\P2 GM\\script\\');
EEG = pop_loadset('filename','P2_runs_1_2_5.set','filepath','C:\\Users\\ASUS\\Desktop\\ICNAS\\testes\\P2 GM\\script\\');
EEG = pop_mergeset( ALLEEG, [7  8], 0); %9
EEG = pop_saveset( EEG, 'filename','P2_All_runs','filepath','C:\\Users\\ASUS\\Desktop\\ICNAS\\testes\\P2 GM\\script\\');

%verificação
EEG = eeg_checkset( EEG );
pop_eegplot( EEG, 1, 1, 1 );

%% Remover canais sem interesse
EEG = pop_loadset('filename','P2_All_runs.set','filepath','C:\\Users\\ASUS\\Desktop\\ICNAS\\testes\\P2 GM\\script\\');
EEG = pop_select( EEG, 'nochannel',{'M1' 'M2' 'CB1' 'CB2' 'EKG' 'EMG'});
EEG = pop_saveset( EEG, 'filename','P2_No_channels','filepath','C:\\Users\\ASUS\\Desktop\\ICNAS\\testes\\P2 GM\\script\\');
EEG = eeg_checkset( EEG );
pop_eegplot( EEG, 1, 1, 1 );

%% Filters
EEG = pop_loadset('filename','P2_No_channels.set','filepath','C:\\Users\\ASUS\\Desktop\\ICNAS\\testes\\P2 GM\\script\\');
EEG = pop_eegfiltnew(EEG, 'locutoff',1,'plotfreqz',1);
EEG = pop_eegfiltnew(EEG, 'hicutoff',100,'plotfreqz',1);
EEG = pop_eegfiltnew(EEG, 'locutoff',47.5,'hicutoff',52.5,'revfilt',1,'plotfreqz',1);
EEG = pop_saveset( EEG, 'filename','P2_Filters','filepath','C:\\Users\\ASUS\\Desktop\\ICNAS\\testes\\P2 GM\\script\\');
EEG = eeg_checkset( EEG );
pop_eegplot( EEG, 1, 1, 1);

%% Interpolar
EEG = pop_loadset('filename','P2_Filters.set','filepath','C:\\Users\\ASUS\\Desktop\\ICNAS\\testes\\P2 GM\\script\\');
EEG = pop_interp(EEG, [12  14  21  23  31  32  44], 'spherical'); %7 sinais interpolados
EEG = pop_saveset( EEG, 'filename','P2_Interp','filepath','C:\\Users\\ASUS\\Desktop\\ICNAS\\testes\\P2 GM\\script\\');
EEG = eeg_checkset( EEG );
pop_eegplot( EEG, 1, 1, 1);

%% Re-reference
EEG = pop_loadset('filename','P2_Interp.set','filepath','C:\\Users\\ASUS\\Desktop\\ICNAS\\testes\\P2 GM\\script\\');
EEG = pop_reref( EEG, [],'exclude',[61 62] );
EEG = eeg_checkset( EEG );
EEG = pop_saveset( EEG, 'filename','P2_Re-ref','filepath','C:\\Users\\ASUS\\Desktop\\ICNAS\\testes\\P2 GM\\script\\');
pop_eegplot( EEG, 1, 1, 1);

%% Runs ICA (versão PCA)
EEG = pop_loadset('filename','P2_Re-ref.set','filepath','C:\\Users\\ASUS\\Desktop\\ICNAS\\testes\\P2 GM\\script\\');
EEG = pop_runica(EEG, 'icatype', 'runica', 'pca',53,'interrupt','on'); %62-2OCULARES-N.SINAIS INTERPOLADOS
EEG = eeg_checkset( EEG );
EEG = pop_saveset( EEG, 'filename','P2_ICA','filepath','C:\\Users\\ASUS\\Desktop\\ICNAS\\testes\\P2 GM\\script\\');
pop_eegplot( EEG, 1, 1, 1);
% Remover canais, manualmente


%% Segmentação dos dados - Social
EEG = pop_loadset('filename','P2_ICA_2.set','filepath','C:\\Users\\ASUS\\Desktop\\ICNAS\\testes\\P2 GM\\script\\');
EEG = pop_epoch( EEG, {  '163'  '164'  '165'  '166'  '167'  '168'  }, [-0.2         0.4], 'newname', 'P2_social', 'epochinfo', 'yes');
EEG = pop_rmbase( EEG, [-200 0] ,[]);
EEG = eeg_checkset( EEG );
EEG = pop_saveset( EEG, 'filename','P2_social','filepath','C:\\Users\\ASUS\\Desktop\\ICNAS\\testes\\P2 GM\\script\\');
% check erps 
figure; pop_plottopo(EEG, [1:60] , 'P2_social', 0, 'ydir',1);

%% Segmentação dos dados - Action
EEG = pop_loadset('filename','P2_ICA_2.set','filepath','C:\\Users\\ASUS\\Desktop\\ICNAS\\testes\\P2 GM\\script\\');
EEG = pop_epoch( EEG, {  '55'  }, [-0.2         0.4], 'newname', 'P2_action', 'epochinfo', 'yes');
EEG = pop_rmbase( EEG, [-200 0] ,[]);
EEG = eeg_checkset( EEG );
EEG = pop_saveset( EEG, 'filename','P2_action','filepath','C:\\Users\\ASUS\\Desktop\\ICNAS\\testes\\P2 GM\\script\\');

%% Segmentação dos dados - Happy
EEG = pop_loadset('filename','P2_ICA_2.set','filepath','C:\\Users\\ASUS\\Desktop\\ICNAS\\testes\\P2 GM\\script\\');
EEG = pop_epoch( EEG, {  '165'  '166'  }, [-0.2         0.4], 'newname', 'P2_happy', 'epochinfo', 'yes');
EEG = pop_rmbase( EEG, [-200 0] ,[]);
EEG = eeg_checkset( EEG );
EEG = pop_saveset( EEG, 'filename','P2_happy','filepath','C:\\Users\\ASUS\\Desktop\\ICNAS\\testes\\P2 GM\\script\\');

%% Segmentação dos dados - Sad
EEG = pop_loadset('filename','P2_ICA_2.set','filepath','C:\\Users\\ASUS\\Desktop\\ICNAS\\testes\\P2 GM\\script\\');
EEG = pop_epoch( EEG, {  '167'  '168'  }, [-0.2         0.4], 'newname', 'P2_sad', 'epochinfo', 'yes');
EEG = pop_rmbase( EEG, [-200 0] ,[]);
EEG = eeg_checkset( EEG );
EEG = pop_saveset( EEG, 'filename','P2_sad','filepath','C:\\Users\\ASUS\\Desktop\\ICNAS\\testes\\P2 GM\\script\\');

%% Segmentação dos dados - Neutral
EEG = pop_loadset('filename','P2_ICA_2.set','filepath','C:\\Users\\ASUS\\Desktop\\ICNAS\\testes\\P2 GM\\script\\');
EEG = pop_epoch( EEG, {  '163'  '164'  }, [-0.2         0.4], 'newname', 'P2_neutral', 'epochinfo', 'yes');
EEG = pop_rmbase( EEG, [-200 0] ,[]);
EEG = eeg_checkset( EEG );
EEG = pop_saveset( EEG, 'filename','P2_neutral','filepath','C:\\Users\\ASUS\\Desktop\\ICNAS\\testes\\P2 GM\\script\\');

%% Segmentação dos dados - Emotions = happy + sad
EEG = pop_loadset('filename','P2_ICA_2.set','filepath','C:\\Users\\ASUS\\Desktop\\ICNAS\\testes\\P2 GM\\script\\');
EEG = pop_epoch( EEG, {  '165'  '166'  '167'  '168'  }, [-0.2         0.4], 'newname', 'P2_emotions', 'epochinfo', 'yes');
EEG = pop_rmbase( EEG, [-200 0] ,[]);
EEG = eeg_checkset( EEG );
EEG = pop_saveset( EEG, 'filename','P2_emotions','filepath','C:\\Users\\ASUS\\Desktop\\ICNAS\\testes\\P2 GM\\script\\');

%% Criação Study - Social + Action
[STUDY ALLEEG] = std_editset( STUDY, [], 'name','P2_social_action','commands',{...
    {'index' 1 'load' 'C:\\Users\\ASUS\\Desktop\\ICNAS\\testes\\P2 GM\\script\\P2_social.set' 'subject' 'P2' 'condition' 'social'}...
    {'index' 2 'load' 'C:\\Users\\ASUS\\Desktop\\ICNAS\\testes\\P2 GM\\script\\P2_action.set' 'subject' 'P2' 'condition' 'action'}},'updatedat','on','rmclust','on' );
[STUDY ALLEEG] = std_checkset(STUDY, ALLEEG);
CURRENTSTUDY = 1; EEG = ALLEEG; CURRENTSET = [1:length(EEG)];
[STUDY ALLEEG] = std_precomp(STUDY, ALLEEG, {},'savetrials','on','interp','on','recompute','on','erp','on','erpparams',{'rmbase' [-200 0] });

STUDY = pop_erpparams(STUDY, 'plotconditions','together');
STUDY = pop_statparams(STUDY, 'condstats','on','mcorrect','fdr','alpha',0.05);
STUDY = std_erpplot(STUDY,ALLEEG,'channels',{'P8'}, 'design', 1); %ERP P8 juntos
STUDY = std_erpplot(STUDY,ALLEEG,'channels',{'P8'}, 'plotsubjects', 'on', 'design', 1 ); %ERP P8 separado