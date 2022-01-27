function [PhiX,extensionMap]=loadGraphTemplateExtension(dataDir)
temp=load(fullfile(dataDir,'templateX')); PhiX=temp.PhiX;
nodeMap=load(fullfile(dataDir,'nodeMap'));
edgeMap=load(fullfile(dataDir,'edgeMap'));
extensionMap.nodes=nodeMap;
extensionMap.edges=edgeMap;