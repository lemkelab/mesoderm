function GetVentralMeshSide(embryoNodes,embryoNodesROIFaces,embryoname)
% Separates surface objects from the inputep volumetric mesh and keeps the most ventral
% one. Images with all the found meshes are stored as control.

display('Getting ventral mesh...')

    facecell=finddisconnsurf(embryoNodesROIFaces);    
    downfaceROI = [];
    
    if length(facecell) > 1
        figure
        downfaceROI = facecell{1};
        df = 1;
        for j = 1:length(facecell)-1
            %find the downsurface with the lowest values in z = the down surface
            if  mean(embryoNodes(facecell{j+1}(:,3),3)) < mean(embryoNodes(downfaceROI(:,3),3))
                downfaceROI = facecell{j+1};
                df = j+1;
            end
        end
        for j = 1:length(facecell)
            subplot(1,length(facecell),j)
            plotmesh(embryoNodes,facecell{j},'FaceAlpha',0.9,'EdgeAlpha',0.0001)
            view([0 90])
            axis off
            h = gcf;
            if df == j
                figtitle = char(strcat('downfaceROI'));
            else
                figtitle = char(strcat('facecell no. ', int2str(j)));
            end
            title(figtitle);
        end
        namedr = char(strcat(embryoname(1), 'downROI.eps'));
        saveas(h,namedr,'epsc')
        close(gcf)
        roiname = char(strcat(embryoname(1), 'ROI'));
        
        save(char(roiname),'embryoNodes','facecell','embryoNodesROIFaces', 'downfaceROI')
        display('Ventral surface found!')

    else
        display('Error: no ventral surface found. Further surface separation needed')

    end

end

