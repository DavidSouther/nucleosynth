import networkx as nx

def walk(stars):
	G = build_graph(stars)

	for a, A in stars.iteritems():
		N = []
		for b, B in G[a].iteritems():
			N.append({"name": b, "distance": B["distance"]})
		N = sorted(N, key = lambda link: link["distance"])
		N = prune(N)
		for n in N:
			G.remove_edge(a, n['name'])

	return G.edges()

def prune(edges):
	edges = edges[3:]
	return edges

def build_graph(stars):
	G = nx.Graph()
	G.add_nodes_from(stars)

	for a, A in stars.iteritems():
		for b, B in stars.iteritems():
			if a is b:
				break
			G.add_edge(a, b, distance = A.distance(B))

	return G