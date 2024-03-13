"""
author: Shru Kumar
filename: hw3_api.py
description: establishes RedisAPI for node-edge graph functions
"""
import redis

class RedisAPI:
    def __init__(self, host = 'localhost', port = 6379, decode_responses = True):
        self.r = redis.Redis(host = host, port = port, decode_responses = decode_responses)
        self.r.flushall()
        self.r.set('edge_id', 0)

    def close(self):
        self.r.quit()

    def add_node(self, name, type):
        """Add a node to the database of a given name and type
        Parameters:
            name (str): name of node
            type (str): what the node is
        """
        self.r.set(name, type)

    def add_edge(self, name1, name2, type):
        """Add an edge between nodes named name1 and name2. Type is the type of the edge or relationship
        Parameters:
            name1 (str): name of first node
            name2 (str): name of second node
            type (str): relationship
        """
        self.r.incr('edge_id')
        edge_id = self.r.get('edge_id')
        self.r.hset(edge_id, mapping = {'in_node': name1, 'out_node': name2, 'type': type})
        self.r.rpush('edge_ids', edge_id)
        
    def get_adjacent(self, name, node_type=None, edge_type=None):
        """Get the names of all adjacent nodes. User may optionally specify that the adjacent nodes are
        of a given type and/or only consider edges of a given type. 
        Parameters:
            name (str): name of selected node
            node_type (str): which type of nodes to filter for
            edge_type (str): which type of edges to filter for
        Returns:
            adjacent_nodes (ls): list of adjacent nodes matching filters, if any
        """
        adjacent_nodes = []

        # iterating through all edges
        for edge_id in self.r.lrange('edge_ids', 0, -1):
            if self.r.hget(edge_id, 'in_node') == name:
                # storing nodes that are related to target node
                adjacent_node = self.r.hget(edge_id, 'out_node')

                # checking if node matches node and edge type filters, if any
                if ((node_type is None) or (node_type == self.r.get(adjacent_node))) and \
                    ((edge_type is None) or (edge_type == self.r.hget(edge_id, 'type'))):
                        adjacent_nodes.append(adjacent_node)

        return adjacent_nodes
    
    def get_recommendations(self, name):
        """Get all books purchased by people that a given person knows but exclude 
        books already purchased by that person.
        Parameters:
            name (str): name of person to recommend books to
        Returns:
            recommended_books (set): set of unique recommended books
        """

        # getting people target name knows and books they have bought
        friends = self.get_adjacent(name, node_type = 'Person', edge_type = 'knows')
        books = self.get_adjacent(name, node_type = 'Book', edge_type = 'bought')

        # collecting unique books that friends have bought
        friend_books = set()
        for friend in friends:
            for book in self.get_adjacent(friend, node_type = 'Book', edge_type = 'bought'):
                friend_books.add(book)

        # excluding books that target name has already bought
        recommended_books = (friend_books - set(books))

        return recommended_books
            









    

    
