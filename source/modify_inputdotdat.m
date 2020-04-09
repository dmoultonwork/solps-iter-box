function modify_inputdotdat(contour,input)

% Read the input.dat template
input_text = fileread([input.template_dir,'input.dat.template']);

% Replace all occurances of "NX", "NX+1", "NY" and "NY+1" with their actual
% values:
tmp = strfind(input_text, '    NX');
for i=1:length(tmp)
    input_text(tmp(i):tmp(i)+5)=sprintf('%6d',input.nx+input.makekink*input.kink_nx);
end
tmp = strfind(input_text, '  NX+1');
for i=1:length(tmp)
    input_text(tmp(i):tmp(i)+5)=sprintf('%6d',input.nx+input.makekink*input.kink_nx+1);
end
tmp = strfind(input_text, '    NY');
for i=1:length(tmp)
    input_text(tmp(i):tmp(i)+5)=sprintf('%6d',input.ny);
end
tmp = strfind(input_text, '  NY+1');
for i=1:length(tmp)
    input_text(tmp(i):tmp(i)+5)=sprintf('%6d',input.ny+1);
end

% Set the ILIIN values for the inner and outer sides in block 3a (define
% the type of surface):
tmp = strfind(input_text, ' ILIIN');
for i=1:length(tmp)
    if strcmp(input.wall_scenario,'tight')
        input_text(tmp(i):tmp(i)+5)=sprintf('%6d',1);
    else
        input_text(tmp(i):tmp(i)+5)=sprintf('%6d',-3);
    end
end

% Create block 3b text containing wall and pump segments, and insert it into 
% input.dat:
block3b = sprintf('%6d\n',size(contour.seg,1)+size(contour.pump,1));
il = 1;
for iseg = 1:size(contour.seg,1)
    block3b = [block3b,sprintf('*%4d :%4d\n',il,il)];
    block3b = [block3b,sprintf(' 2.00000E+00 1.00000E+00 1.00000E+00 1.00000E-05\n')];
    block3b = [block3b,sprintf('     1     1     0     0     0     1     0     0     0    -1\n')];
    block3b = [block3b,sprintf('%12.5E%12.5E%12.5E%12.5E%12.5E%12.5E\n',100*contour.seg(iseg,1),100*contour.seg(iseg,2),-1E20,100*contour.seg(iseg,3),100*contour.seg(iseg,4),1E20)];
    block3b = [block3b,sprintf('SURFMOD_PFC\n')];
    il = il+1;
end
for iseg = 1:size(contour.pump,1)
    block3b = [block3b,sprintf('**%4d :%4d Pumping surface\n',il,il)];    
    block3b = [block3b,sprintf(' 2.00000E+00 1.00000E+00 1.00000E+00 1.00000E-05\n')];
    block3b = [block3b,sprintf('     1     1     0     0     0     1     0     0     0    -1\n')];
    block3b = [block3b,sprintf('%12.5E%12.5E%12.5E%12.5E%12.5E%12.5E\n',100*contour.pump(iseg,1),100*contour.pump(iseg,2),-1E20,100*contour.pump(iseg,3),100*contour.pump(iseg,4),1E20)];
    block3b = [block3b,sprintf('SURFMOD_PUMP\n')];
    il = il+1;
end
tmp = strfind(input_text, '*** 4');
input_text = [input_text(1:tmp-1),block3b,input_text(tmp:end)];

% Set the wall temperature:
tmp = strfind(input_text, '       EWALL');
for i=1:length(tmp)
    input_text(tmp(i):tmp(i)+11)=['-',sprintf('%11.5E',input.walltemp)];
end

% Set the pumping albedo:
pump_area = 0;
for i=1:size(contour.pump,1)
    pump_area = pump_area+sqrt((contour.pump(i,1)-contour.pump(i,3))^2+(contour.pump(i,2)-contour.pump(i,4))^2)*2*pi*0.5*(contour.pump(i,1)+contour.pump(i,3));
end
tmp = strfind(input_text, '     RECYCT');
input_text(tmp(i):tmp(i)+10)=sprintf('%11.5E',1-input.pumpspeed/pump_area/(0.25*sqrt(8*1.38064852E-23/pi/1.6726219e-27))/sqrt(11604.51812*input.walltemp/4));

% Now write out the input.dat file:
fid = fopen([input.ref_dir,'/input.dat'],'w');
fprintf(fid,'%s\n',input_text);
fclose(fid);


