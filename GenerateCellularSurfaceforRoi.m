% Processes all tiff stacks in Folder to surfaces and defines ROI
% Needs external library: isomesh

Files = dir('*-Bin.tif');

for ii = 1:numel(Files) 
    display(['##### Processing Stack ',num2str(ii),' of ',num2str(length(Files))])
    
    NameSplit = strsplit(Files(ii).name,'Bin');
    embryoName = NameSplit(1);
    [finalImage] = ReadTifStack(Files(ii).name);
    [embryoNodes,embryoFaces] = GenerateEmbryoMesh(finalImage, 0.1, 20);
    PlotEmbryoMesh(embryoNodes,embryoFaces, 0.9, embryoName)
    
    % Define ROI for Mesh
    [embryoNodesROI] = DefineROIforPointsInEmbryo(embryoNodes, 50, 30, 50, 0.5);
    embryoNodesROIindex = [];   
    for jj = 1:length(embryoNodesROI)
        if embryoNodesROI(jj,4) == 1
            embryoNodesROIindex = [embryoNodesROIindex;jj];
        end
    end
    embryoFacesROI = [];
    for kk = 1:length(embryoFaces)
        if ismember(embryoFaces(kk,1:3),embryoNodesROIindex)
            embryoFacesROI = [embryoFacesROI;embryoFaces(kk,1:3)];
        end
    end
    
    GetVentralMeshSide(embryoNodes,embryoFacesROI,embryoName);
    
end