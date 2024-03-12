import redis

class RedisAPI:
    def __init__(self, host = 'localhost', port = 6379, decode_responses = True):
        self.r = redis.Redis(host = host, port = port, decode_responses = decode_responses)
        self.r.flushall()

    def close(self):
        self.r.quit()

    def add_node(self, name, type):
        self.r.lpush()