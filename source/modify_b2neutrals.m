function modify_b2neutrals(grid,input)

% Read the input.dat template
b2neut_text = fileread([input.template_dir,'b2.neutrals.parameters.template']);

% Replace all occurances of "'TARDIR'" with "'E'" when target is at the right end of grid, otherwise with "'W'":
tmp = strfind(b2neut_text, '''TARDIR''');
if input.targetendright
    b2neut_text(tmp:tmp+7)='     ''E''';
else
    b2neut_text(tmp:tmp+7)='     ''W''';
end
% Replace all occurences of "TARIX" with nx when target is at the right end of
% the grid, otherwise with -1
tmp = strfind(b2neut_text, 'TARIX');
if input.targetendright
    b2neut_text(tmp:tmp+4)=sprintf('%5d',grid.nx);
else
    b2neut_text(tmp:tmp+4)=sprintf('%5d',-1);
end
% Replace all occurences of "NY" with its actual value:
tmp = strfind(b2neut_text, ' NY-1');
b2neut_text(tmp:tmp+4)=sprintf('%5d',grid.ny-1);
% Replace all occurences of LTNS with the eirene target surface index in
% block 3a:
tmp = strfind(b2neut_text, 'LTNS');
if input.targetendright
    b2neut_text(tmp:tmp+3)=sprintf('%4d',3);
else
    b2neut_text(tmp:tmp+3)=sprintf('%4d',4);
end

% Now write out the b2ag.dat file:
fid = fopen([input.ref_dir,'/b2.neutrals.parameters'],'w');
fprintf(fid,'%s\n',b2neut_text);
fclose(fid);