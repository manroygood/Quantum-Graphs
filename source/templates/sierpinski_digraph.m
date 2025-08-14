function G = sierpinski_digraph(N)
    % Create a directed graph approximating the Sierpinski gasket of depth N
    
    % Initialize node counter and storage
    nodeID = 1;
    coords = containers.Map('KeyType','double','ValueType','any');
    edges = [];

    % Initial triangle vertices
    A = [0, 0];
    B = [1, 0];
    C = [0.5, sqrt(3)/2];
    
    % Recursively subdivide triangle
    function add_triangle(a, b, c, depth)
        
        if depth == 0
            % Store edges as directed a->b, b->c, c->a
            idA = get_node_id(a);
            idB = get_node_id(b);
            idC = get_node_id(c);
            edges = [edges; idA, idB; idB, idC; idC, idA];
        else
            ab = midpoint(a, b);
            bc = midpoint(b, c);
            ca = midpoint(c, a);
            
            % Recurse on 3 corner triangles
            add_triangle(a, ab, ca, depth-1);
            add_triangle(ab, b, bc, depth-1);
            add_triangle(ca, bc, c, depth-1);
        end
    end

    % Helper: get or assign a unique ID for a coordinate
    function id = get_node_id(pt)
        key = round(pt(1)*1e6) + round(pt(2)*1e6)*1e6;
        if isKey(coords, key)
            id = coords(key).id;
        else
            id = nodeID;
            coords(key) = struct('id', nodeID, 'coord', pt);
            nodeID = nodeID + 1;
        end
    end

    % Helper: compute midpoint of two points
    function m = midpoint(p1, p2)
        m = (p1 + p2)/2;
    end

    % Start recursive construction
    add_triangle(A, B, C, N);
    
    % Extract node coordinates
    numNodes = coords.Count;
    XY = zeros(numNodes, 2);
    keys = coords.keys;
    for i = 1:numNodes
        XY(i, :) = coords(keys{i}).coord;
    end

    % Create directed graph
    G = digraph(edges(:,1), edges(:,2));
    
    % Plot the graph
    figure;
    plot(G, 'XData', XY(:,1), 'YData', XY(:,2), 'ArrowSize', 5);
    title(['Sierpinski Gasket Approximation (Depth = ', num2str(N), ')']);
end
