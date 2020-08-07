function modify_b2ag(grid,input)

% Read the input.dat template
b2ag_text = fileread([input.template_dir,'b2ag.dat.template']);

% Replace all occurances of "NX" and "NY" with their actual values:
tmp = strfind(b2ag_text, '   NX');
for i=1:length(tmp)
    b2ag_text(tmp(i):tmp(i)+4)=sprintf('%5d',grid.nx);
end
tmp = strfind(b2ag_text, '   NY');
for i=1:length(tmp)
    b2ag_text(tmp(i):tmp(i)+4)=sprintf('%5d',grid.ny);
end

% Now write out the b2ag.dat file:
fid = fopen([input.baserun_dir,'/b2ag.dat'],'w');
fprintf(fid,'%s\n',b2ag_text);
fclose(fid);