"""
author: Shru Kumar
filename: hw3_recommend.py
description: functions that the RedisAPI can perform
"""

from hw3_api import RedisAPI

def main():
    # establishing API connection
    api = RedisAPI()
    api.r.flushall()

    # adding nodes
    api.add_node('Emily', 'Person')
    api.add_node('Spencer', 'Person')
    api.add_node('Brendan', 'Person')
    api.add_node('Trevor', 'Person')
    api.add_node('Paxton', 'Person')
    api.add_node('Cosmos', 'Book')
    api.add_node('Database Design', 'Book')
    api.add_node('The Life of Cronkite', 'Book')
    api.add_node('DNA and you', 'Book')

    # adding edges
    api.add_edge('Emily', 'Database Design', 'bought')
    api.add_edge('Spencer', 'Cosmos', 'bought')
    api.add_edge('Spencer', 'Database Design', 'bought')
    api.add_edge('Brendan', 'Database Design', 'bought')
    api.add_edge('Brendan', 'DNA and you', 'bought')
    api.add_edge('Trevor', 'Cosmos', 'bought')
    api.add_edge('Trevor', 'Database Design', 'bought')
    api.add_edge('Paxton', 'Database Design', 'bought')
    api.add_edge('Paxton', 'DNA and you', 'bought')
    api.add_edge('Emily', 'Spencer', 'knows')
    api.add_edge('Spencer', 'Emily', 'knows')
    api.add_edge('Spencer', 'Brendan', 'knows')

    # getting recommendations for spencer
    spencer_recommended = api.get_recommendations('Spencer')
    print(spencer_recommended)

if __name__ == '__main__':
    main()