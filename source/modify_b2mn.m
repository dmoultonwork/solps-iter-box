function modify_b2mn(grid,input)

% Read the b2mn.dat template
b2mn_text = fileread([input.template_dir,'b2mn.dat']);

% Replace all occurances of "JSEP" with this grid's separatrix y index
tmp = strfind(b2mn_text, 'JSEP');
b2mn_text(tmp:tmp+3)=sprintf('%4d',grid.iysep-3);

% Now write out the b2mn.dat file:
fid = fopen([input.ref_dir,'/b2mn.dat'],'w');
fprintf(fid,'%s\n',b2mn_text);
fclose(fid);