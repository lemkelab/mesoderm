function allFeatures = GetEmbryoMorphologicalFeatures(Isurfdist, nuclearSize, eggshelladjustment)
% Samples sections of the embryo to calculates the features: epithelial integrity, furrow depth, ingression
%and maximal cell depth from the array of integrity and distances to
%cellular surface previously generated with
%'GetNucleitoCellSurfaceDistances'
%Takes argument nuclear size in pixel to normalize the distances. 
%eggshelladjustment: optional variable to take into consideration the adjustment to the eggshell outside (e.g. by adding 0.5 nuclear length)
%Saves features in the 'allFeatures' = [internalization,integrity,furrowDepth,maxdepth]
%internalization: gives the percentage of cells internalized in the ROI section.
%integrity: measures for all internalized cells the ratio of cells within the epithelium in percentage from 0 to 100. 
%If nothing is internalized the value of 101 is assigned.
%furrowDepth:gives the distance of the deepest nuclear centroid for the nuclei within the epithelium within the ROI section to
%the eggshell measured in times nuclearsize. 
%maxdepth: gives the distance of the deepest nuclear centroid in the ROI section to
%the eggshell measured in times nuclearsize. 
 
if ~exist('eggshelladjustment','var')
   eggshellthreshold = eggshelladjustment;
else
   eggshellthreshold = 0;
end
 
ALLngression = [];
ALLngressionRatio = [];
ALLintegrityCS = [];
ALLdepthCS = [];
ALLdepthsurfCS = [];

%calculate ventral distances for all and save in same array
for i = 1:length(Isurfdist)
    Isurfdist{1,i}(:,5) = DistanceToGeneralVentralSurface(Isurfdist{1,i}(:,1:3));
end

% Normalize distances
for i = 1:length(Isurfdist)
    Isurfdist{1,i}(:,4) = Isurfdist{1,i}(:,4)/nuclearSize;
    Isurfdist{1,i}(:,5) = Isurfdist{1,i}(:,5)/nuclearSize;

end

sampling = 10;
sampleWidth = 30;

for i = 1:length(Isurfdist)
    
    %Set x,y coords accordingn to embryo orientation
    if range(Isurfdist{1,i}(:,1)) > range(Isurfdist{1,i}(:,2))
        xcoords = 2;
        ycoords = 1;
    else
        xcoords = 1;
        ycoords = 2;
    end
    
    %Define sampling parameters
    start = min(Isurfdist{i}(:,ycoords));
    stepCS = range(Isurfdist{i}(:,ycoords))/sampling;
    CSAN = [];
    integrityCS = [];
    depthCS = [];
    depthsurfCS = [];
    ingressionCS = [];
    internalizationthreshold = 1+eggshellthreshold;
    
    %Sample cross-sections
    for j = 1:sampling-1
        CSs = start + j*stepCS;
        CSe = CSs + sampleWidth;
        CSn = Isurfdist{i}(Isurfdist{i}(:,ycoords)>CSs & Isurfdist{i}(:,ycoords)<CSe,1:5);
        CSAN = [CSAN;CSn];
        
        %Epithelial integrity 
        if ~isempty(CSn(CSn(:,5)> internalizationthreshold))
            integrityICS = length(CSn(CSn(:,4)<=1 & CSn(:,5)> 1))/length(CSn(CSn(:,5)> internalizationthreshold))*100;
        else
        % for non-ingressed cells set integrity level outside the range instead of NA 
            integrityICS = 101;
        end
        
        integrityCS = [integrityCS;integrityICS];
        
        %Ingression
        ingressionratioICS = 100*(length(CSn(CSn(:,5)> internalizationthreshold))/length(CSn));
        ingressionCS =  [ingressionCS;ingressionratioICS];
        
        %Max cell depth
        depthICS = max(Isurfdist{i}(Isurfdist{i}(:,ycoords)>CSs & Isurfdist{i}(:,ycoords)<CSe,5));
        depthCS = [depthCS;depthICS];
        
        %Furrow depth
        if ~isempty(Isurfdist{i}(Isurfdist{i}(:,ycoords)>CSs & Isurfdist{i}(:,ycoords)<CSe & Isurfdist{i}(:,4)<=1,5))
            depthsurfICS = max(Isurfdist{i}(Isurfdist{i}(:,ycoords)>CSs & Isurfdist{i}(:,ycoords)<CSe & Isurfdist{i}(:,4)<=1,5));
        else
            depthsurfICS = 0;
        end
        
        depthsurfCS = [depthsurfCS;depthsurfICS];
    end
     
    ALLintegrityCS{i} = integrityCS;
    ALLdepthCS{i} = depthCS;
    ALLdepthsurfCS{i}= depthsurfCS;
    ALLngressionRatioCS{i} = ingressionCS;

end

integrity = [];
furrowdepth = [];
maxdepth = [];
internalization = [];

for i = 1:length(Isurfdist)   
    integrity = [integrity; ALLintegrityCS{1,i}];
    furrowdepth = [furrowdepth;ALLdepthsurfCS{1,i}];
    maxdepth  = [maxdepth;ALLdepthCS{1,i}];
    internalization = [internalization;ALLngressionRatioCS{1,i}];
end

allFeatures = [integrity furrowdepth internalization maxdepth];

end

