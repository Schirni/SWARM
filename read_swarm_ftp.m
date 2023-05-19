function [d]=read_swarm_ftp(swarmdate)
% Author:  Chr. Schirninger
% Purpose: read swarm ftp, 50 Hz high res data
% Example: d_struct=read_swarm_ftp('*20131201*');
% Date:    May 2023

% SAT_A
ftpobj = ftp('swarm-diss.eo.esa.int'); binary(ftpobj);
cd(ftpobj,'Level1b/Latest_baselines/MAGx_HR/Sat_A/');
swarmdate_name=dir(ftpobj,swarmdate);         %
mget(ftpobj,swarmdate_name.name);             %
listing=dir([swarmdate,'.zip']);
switch isempty(listing)
  case 1
    fprintf('%s %s\n','No File on SWARM A server for that day:',swarmdate);  
  case 0
    unzip(listing.name);
    listing2=dir([swarmdate,'MDR_MAG_HR.cdf']);  % 50 Hz high-res data
    d.A=read_swarm_cdf_data(listing2.name);
    fprintf('%s\n',listing2.name);
    delete SW_OPER*
end
close(ftpobj);

% SAT_B
ftpobj = ftp('swarm-diss.eo.esa.int'); binary(ftpobj);
cd(ftpobj,'Level1b/Latest_baselines/MAGx_HR/Sat_B/');%
swarmdate_name=dir(ftpobj,swarmdate);         %
mget(ftpobj,swarmdate_name.name);             %
listing=dir([swarmdate,'.zip']);
switch isempty(listing)
  case 1
    fprintf('%s %s\n','No File on SWARM B server for that day:',swarmdate);  
  case 0
    unzip(listing.name);
    listing2=dir([swarmdate,'MDR_MAG_HR.cdf']);  % 50 Hz high-res data
    d.B=read_swarm_cdf_data(listing2.name);
    fprintf('%s\n',listing2.name);
    delete SW_OPER*
end
close(ftpobj);

% SAT_C
ftpobj = ftp('swarm-diss.eo.esa.int'); binary(ftpobj);
cd(ftpobj,'Level1b/Latest_baselines/MAGx_HR/Sat_C/');
swarmdate_name=dir(ftpobj,swarmdate);         %
mget(ftpobj,swarmdate_name.name);             %
listing=dir([swarmdate,'.zip']);
switch isempty(listing)
  case 1
    fprintf('%s %s\n','No File on SWARM C server for that day:',swarmdate);  
  case 0
    unzip(listing.name);
    listing2=dir([swarmdate,'MDR_MAG_HR.cdf']);  % 50 Hz high-res data
    d.C=read_swarm_cdf_data(listing2.name);
    fprintf('%s\n',listing2.name);
    delete SW_OPER*
end
close(ftpobj);