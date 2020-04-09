function output_tria(contour,grid,input)

if strcmp(input.wall_scenario,'tight')
    return % tria.in file not needed in tight geometry - no triangles outside B2.5 grid
end
    
% Write the tria.in file:
fid = fopen([input.baserun_dir,'/tria.in'],'w');
fprintf(fid,'%13.5E\n\n\n',input.trisize);
for ic=1:length(contour.tria)
    fprintf(fid,'%12d\n',size(contour.tria{ic},1));
    for i=1:size(contour.tria{ic},1);
        if ~any(any(ismember(grid.rbr,contour.tria{ic}(i,1)) & ismember(grid.zbr,contour.tria{ic}(i,2))))
            % Round non-grid segments to block 3b accuracy:
            fprintf(fid,'%23.14E%23.14E\n',100*str2double(sprintf('%12.5E',contour.tria{ic}(i,1))),100*str2double(sprintf('%12.5E',contour.tria{ic}(i,2))));
        else
            fprintf(fid,'%23.14E%23.14E\n',100*contour.tria{ic}(i,1),100*contour.tria{ic}(i,2));
        end
    end
end

fclose(fid);
