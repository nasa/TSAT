function install_TSAT()
% This subroutine installs TSAT

% TSATver and date must remain in the listed form for the ver command to work
% properly.
TSATver = '1.0.0';
TSATdate = '22Feb-2018';

TSATInstallmsg = 'Install TSAT matlab toolbox? Note: Installation will add MATLAB paths';
POp = filesep;

switch questdlg(TSATInstallmsg, 'TSAT Library','Temporary Install', 'Install', 'Cancel', 'Cancel');
    case 'Temporary Install'
        InstallType = 'Install';
        PermInstall = 0;
    case 'Install'
        InstallType = 'Install';
        PermInstall = 1;
    case 'Cancel'
        InstallType = 'Cancel';
        PermInstall = 0;
end
% check if TSAT_Library is in the path
switch InstallType
    case 'Install',
        p = path;                               % current path
        CurrDir = pwd;                          % current directory
        % define new paths
        Pth{1} = strcat(pwd,POp,'TSAT_Library');
        Pth{2} = strcat(pwd,POp,'TSAT_Library',POp,'TSAT_Support');
        Pth{3} = strcat(pwd,POp,'TSAT_Tools');
        Pth{4} = strcat(pwd,POp,'TSAT_Tools',POp,'Tools');
        Pth{5} = strcat(pwd,POp,'TSAT_Library',POp,'MATLAB_Scripts');
        
        perm = zeros( 1 , length(Pth));         % allocate memory for perm
        for i = 1: length(Pth)
            
            perm(i) = isempty(strfind(pathdef,strcat( Pth{i} , ';' )));  % determine if path is already defined
            
            if perm(i)                               % for each path if it is not defined,  define it
                path(pathdef);
                addpath(Pth{i});
                if PermInstall == 1;
                    SP = savepath;
                    if SP==0
                        disp(sprintf(' %s has been saved to the permanent Path structure.',Pth{i}));
                    else
                        error = 1;
                        disp(sprintf('Error: %s has not been added to the permanent Path structure. To use TSAT blocks Install_TSAT.m will need to be run each time MATLAB is opened.',Pth{i}));
                    end
                else
                    disp(sprintf(' %s has been added to the Path structure.',Pth{i}));
                end
            else
                disp (sprintf('%s is already defined in the path structure',Pth{i}));
            end
        end
        
        
        % return to current path.
        path(p);
        for i = 1:length(Pth)
            addpath(Pth{i});
        end
        
        if PermInstall == 1
            cd( 'TSAT_Library')
            disp('Building Contents.m file');
            fid = fopen('Contents.m','w');
            fprintf(fid,'%% TSAT.\n');
            fprintf(fid,['%% Version',' ',TSATver,' ',TSATdate,'\n%%\n%% Files\n']);
            fprintf(fid,'%%   Install_TSAT   - This subroutine installs TSAT\n');
            fprintf(fid,'%%   Uninstall_TSAT - This subroutine uninstalls TSAT\n');
            fclose(fid);
            eval(['cd ' CurrDir]);
        end
        
                
	disp('Refreshing Simulink Browser...');
	LB = LibraryBrowser.LibraryBrowser2;
        LB.refresh;
        
        disp('TSAT Simulink library installation complete.');

    case 'Cancel',
        disp('TSAT installation aborted.');
end

