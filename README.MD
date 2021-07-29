This is a simple implementation of Dijkstra's algorithm in Ruby, written by following the definition and pseudocode on <a href="https://en.wikipedia.org/wiki/Dijkstra%27s_algorithm">Wikipedia</a>.
Relevant excerpt:
<ol>
  <li>Mark all nodes unvisited. Create a set of all the unvisited nodes called the unvisited set.</li>
  <li>Assign to every node a tentative distance value: set it to zero for our initial node and to infinity for all other nodes. Set the initial node as current.</li>
  <li>For the current node, consider all of its unvisited neighbours and calculate their tentative distances through the current node. Compare the newly calculated tentative distance to the current assigned value and assign the smaller one. For example, if the current node A is marked with a distance of 6, and the edge connecting it with a neighbour B has length 2, then the distance to B through A will be 6 + 2 = 8. If B was previously marked with a distance greater than 8 then change it to 8. Otherwise, the current value will be kept.</li>
  <li>When we are done considering all of the unvisited neighbours of the current node, mark the current node as visited and remove it from the unvisited set. A visited node will never be checked again.</li>
  <li>If the destination node has been marked visited (when planning a route between two specific nodes) or if the smallest tentative distance among the nodes in the unvisited set is infinity (when planning a complete traversal; occurs when there is no connection between the initial node and remaining unvisited nodes), then stop. The algorithm has finished.</li>
  <li>Otherwise, select the unvisited node that is marked with the smallest tentative distance, set it as the new "current node", and go back to step 3.</li>
</ol>

Algorithm is implemented in a service that takes the graph definition in an adjacency matrix stored in a 2D array, as well as the source and destination nodes.
Service returns the result in a form of hash that contains the minimum distance as well as minimum path expressed as an array of nodes.

Basic parameter checking is added (that the data is present and valid, that the matrix is square, source and destination nodes are valid, etc.).

Tests are written using rspec and rubocop is used as linter. Test coverage includes checks if the parameters are valid as well as a few relevant cases (all roads/edges are bidirectional, some are unidirectional, and no possible path).

Visualisations of test cases can be found in spec/fixtures folder. Visualisation and example generation were done with the help of <a href="https://graphonline.ru/en/">Graph Online</a> tool.


To fetch the necessary gems:
<code>bundle install</code>

To run the tests and rubocop:
<code>rspec -I . && rubocop</code>
