
function Isurfdist = GetNucleitoCellSurfaceDistances
% Match nuclei and cellular surface of all embryos in a folder
% Loads ROI ventral surfaces previously generated with 'GenerateCellularSurfaceforRoi'
% Loads nuclei centroids from the nuclei segmentation stored in ilp files
% Calculates distances and saves a new cell array with one cell per embryo containing
% x,y,z coordinates and distances 

MatFiles = dir('*ROI.mat');
ILPFiles = dir('*.ilp');
Names = [];
Stacknames = [];

for ii = 1:numel(MatFiles)
    thename = strsplit(MatFiles(ii).name,'-ROI.mat');
    stack = char(thename(1));
    Stacknames = [Stacknames;stack];
    simplename = strrep(stack,'-DAPI-', '-');
    simplename = strrep(simplename,'-ventral-stack-', '-');
    thename = strrep(simplename,'-.mat', '');
    Names = [Names;thename];
end

%go through all stacks
Isurfdist = {};
for ii = 1:length(Stacknames(:,1))
    display(['##### Processing Stack ',num2str(ii),' of ',num2str(length(MatFiles))])
    
    % find the ilp file
    for j = 1:numel(ILPFiles)
        if ~isempty(strfind(ILPFiles(j).name,Stacknames(ii,:)))
            
            %load coordinates from the ilp file
            n = strsplit(ILPFiles(j).name,'.ilp');
            n = strsplit(char(n(1)),'_');
            datapath = n(3);
            nucleiCoordinates = Readh5ObjectsFile(ILPFiles(j).name,char(datapath));
            nucleiCoordinates = FixEmbryoOrientation(nucleiCoordinates);
            nucleiCoordinates = DefineROIforPointsInEmbryo(nucleiCoordinates, 50, 30, 50, 0.5);
            
            %load meshes from .mat file
            load(strcat(Stacknames(ii,:),'-ROI.mat'))
            embryoNodes = FixEmbryoOrientation(embryoNodes);
            
            figure
            PlotEmbryo(nucleiCoordinates,1,1)
            hold on
            plot3(nucleiCoordinates(nucleiCoordinates(:,4) == 1,1), nucleiCoordinates(nucleiCoordinates(:,4) == 1,2),nucleiCoordinates(nucleiCoordinates(:,4) == 1,3),'.','MarkerEdgeColor',[0.7 0 0.3] ,'MarkerSize', 15);
            plotmesh(embryoNodes,downfaceROI,'FaceAlpha',0.9,'EdgeAlpha',0.0001);
            
            view([90 90])
            axis off
            h = gcf;
            namedr = char(strcat(Stacknames(ii,:), '-surfpoints.eps'));
            saveas(h,namedr,'epsc')
            close(gcf)
            distancesImageSurf = DistanceToANYSurface(nucleiCoordinates(nucleiCoordinates(:,4) == 1,1:3),embryoNodes,downfaceROI);
            Isurfdist{ii} =  distancesImageSurf;
        end
    end
end
display('Done!')
end























