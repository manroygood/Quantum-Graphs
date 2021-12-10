function tests = qgTest
tests = functiontests(localfunctions);
end

%% basic setup with scalar L
function scalarTest(testCase)
s= [1 1 1 2];
t= [1 2 3 2];
L1 = 1; 
G=quantumGraph(s,t,L1);

import matlab.unittest.constraints.IsEqualTo
import matlab.unittest.constraints.IsTrue
import matlab.unittest.TestCase 

testCase.verifyThat(G.numedges,IsEqualTo(4)) 
testCase.verifyThat(G.numnodes,IsEqualTo(3)) 
testCase.verifyClass(G,'quantumGraph') 

disc=G.discretization;
flag = strcmp(disc,'Uniform') || strcmp(disc,'Chebyshev') || strcmp(disc,'None');
verifyThat(testCase,flag,IsTrue);
end

%%  Throws errors when inputs are of incompatible lengths
function vectorErrorTest(testCase)
s= [1 1 1 2];
t= [1 2 3 2];
% L1 broken
L1 = ones(1,3);
verifyError(testCase,@()quantumGraph(s,t,L1),'quantumGraph:LMismatch');
% fix L1,  break weights
L1=ones(1,4); weight=ones(1,5);
verifyError(testCase,@()quantumGraph(s,t,L1,'Weight',weight),'quantumGraph:WeightMismatch');
% break robin coefficientse
robinCoeff=zeros(1,3);
G=quantumGraph(s,t,L1,'robinCoeff',robinCoeff); %#ok<NASGU> 
robinCoeff=ones(1,4);
verifyError(testCase,@()quantumGraph(s,t,L1,'RobinCoeff',robinCoeff),'quantumGraph:robinMismatch');
% break t
t=[1 2 3];
verifyError(testCase,@()quantumGraph(s,t,L1),'quantumGraph:sourceTargetMismatch');
end

%% basic setup with vector L
function vectorTest(testCase)
s= [1 1 1 2];
t= [1 2 3 2];

L1 = ones(1,4); 
G=quantumGraph(s,t,L1);

import matlab.unittest.constraints.IsEqualTo
verifyThat(testCase,G.numedges,IsEqualTo(4));
verifyThat(testCase,G.numnodes,IsEqualTo(3));
verifyClass(testCase,G,'quantumGraph')
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Test various things about leaf nodes
% function leafTest(testCase)
% s=[2, 3, 4];t=[1,1,1];L=10;robinCoeff=[nan, nan, nan, 0];
% verifyError(testCase,@()quantumGraph(s,t,L,'robinCoeff',robinCoeff),'quantumGraph:dirichletNotLeaf');
% s=[1,1,1];t=[2, 3, 4];robinCoeff=[0,nan, nan, nan];
% G=quantumGraph(s,t,L,'robinCoeff',robinCoeff);  % should work
% % now test that node 1 returns false, nodes 2,3,4 return true
% import matlab.unittest.constraints.IsTrue
% import matlab.unittest.constraints.IsFalse
% 
% verifyThat(testCase,isLeaf(G,1),IsFalse)
% verifyThat(testCase,isLeaf(G,2),IsTrue)
% verifyThat(testCase,isLeaf(G,3),IsTrue)
% verifyThat(testCase,isLeaf(G,4),IsTrue)
% % Test that returns an error when edge points from leaf (instead of to it)
% s=[1 1 4];t=[2 3 1];robinCoeff=[0 0 0 nan];
% verifyError(testCase,@()quantumGraph(s,t,L,'robinCoeff',robinCoeff),'quantumGraph:leafDirection');
% 
% % Test that if a k nodes dirichlet it must be the last 
% s=[1 1 1]; t = [2 3 4]; robinCoeff=[0 nan 0 0];
% verifyError(testCase,@()quantumGraph(s,t,L,'robinCoeff',robinCoeff),'quantumGraph:leafNotLast');
% end
% 
% % The following graph definition does not include a node 4. Test that an
% % error is thrown
% function dumbNodeTest(testCase)
% s=[1 1 1]; t = [2 3 5]; % note no node 4
% L=10;
% verifyError(testCase,@()quantumGraph(s,t,L),'quantumGraph:nodesMissing');
% end

%% Test that it responds appropriately when multigraph entered
function versionMultiGraphTest(testCase)
    s=[1 1]; t=[2 2];L=10;
if verLessThan('matlab','9.4')
    verifyError(testCase,@()quantumGraph(s,t,L),'quantumGraph:multigraphVersion'); % fails
else
    G = quantumGraph(s,t,L); %#ok<NASGU> % works
end
end

%% Tests various functions in the main quantumGraph.m file return what they should
function returnTest(testCase)
s=[1 1 1 3 3]; 
t=[2 3 4 2 3]; 
L=[5 4 3 2 1]; 
robinCoeff=[0 2 1 nan];
weight = 3*(1:5);
G=quantumGraph(s,t,L,'RobinCoeff',robinCoeff,'Weight',weight);

import matlab.unittest.constraints.IsEqualTo
for j=1:numedges(G)
    
    verifyThat(testCase,G.L(j),IsEqualTo(L(j)));
    verifyThat(testCase,G.weight(j),IsEqualTo(weight(j)));
    EN = G.EndNodes(j);
    verifyThat(testCase,EN(1),IsEqualTo(s(j)));
    verifyThat(testCase,EN(2),IsEqualTo(t(j)));
    EN = G.EndNodes(j,1);
    verifyThat(testCase,EN,IsEqualTo(s(j)));
    EN = G.EndNodes(j,2);
    verifyThat(testCase,EN,IsEqualTo(t(j)));
end

for j=1:numnodes(G)
    verifyThat(testCase,G.robinCoeff(j),IsEqualTo(robinCoeff(j)));
end
end
    
%% Test Secular Determinant
function secularDetTest(testCase)
import matlab.unittest.constraints.IsEqualTo
x=sym('x');

s=[1 1 1];t=[2 3 4];
L = pi;
robinCoeff=[0 0 0 0];
G=quantumGraph(s,t,L,'robinCoeff',robinCoeff);
f=G.secularDet;
g=8*sin(pi*x)*(sin(pi*x) - 1)*(sin(pi*x) + 1);
check = simplify(f/g);
verifyTrue(testCase,isempty(symvar(check)) && imag(check) == 0);
end

%% Test the assertion that L should be the same length as source and target
function vectorAssertionTest(testCase)
s= [1 1 1 2];
t= [1 2 3 2];
L1 = ones(1,3);
verifyError(testCase,@()quantumGraph(s,t,L1),'quantumGraph:LMismatch');
end

%% Test the discretization works
function discretizationTest(testCase)
s = [1 1 2];
t= [1 2 2];
L= [2*pi 2 2*pi];
nx = [63 20 63];
g=quantumGraph(s,t,L,'nxVec',nx);
gnx=g.nx;
import matlab.unittest.constraints.IsEqualTo
verifyThat(testCase,gnx,IsEqualTo(nx(:)))
end