class Cache:
    def __init__(self):
        self.cache = {}
        self.size = 0

    def get(self, key):
        if key in self.cache:
            return self.cache[key]
        return None

    def set(self, key, value):
        if key in self.cache:
            self.cache[key] = value
        else:
            self.cache[key] = value
            self.size += 1

    def delete(self, key):
        if key in self.cache:
            del self.cache[key]
            self.size -= 1

    def clear(self):
        self.cache = {}
        self.size = 0

    def has(self, key):
        return key in self.cache

    def keys(self):
        return list(self.cache.keys())

    def values(self):
        return list(self.cache.values())

    def items(self):
        return list(self.cache.items())

    def __str__(self):
        return str(self.cache)

class LRUCache:
    def __init__(self, capacity):
        self.capacity = capacity
        self.cache = {}
        self.keys = []

    def get(self, key):
        if key in self.cache:
            value = self.cache[key]
            self.keys.remove(key)
            self.keys.append(key)
            return value
        return None

    def set(self, key, value):
        if key in self.cache:
            self.cache[key] = value
            self.keys.remove(key)
            self.keys.append(key)
        elif len(self.cache) < self.capacity:
            self.cache[key] = value
            self.keys.append(key)
        else:
            oldest_key = self.keys.pop(0)
            del self.cache[oldest_key]
            self.cache[key] = value
            self.keys.append(key)

    def delete(self, key):
        if key in self.cache:
            del self.cache[key]
            self.keys.remove(key)

    def clear(self):
        self.cache = {}
        self.keys = []

def main():
    cache = Cache()
    cache.set('key1', 'value1')
    cache.set('key2', 'value2')
    print(cache.get('key1'))
    print(cache.get('key2'))
    cache.delete('key1')
    print(cache.get('key1'))
    print(cache.get('key2'))
    print(cache.keys())
    print(cache.values())
    print(cache.items())

    lru_cache = LRUCache(2)
    lru_cache.set('key1', 'value1')
    lru_cache.set('key2', 'value2')
    print(lru_cache.get('key1'))
    lru_cache.set('key3', 'value3')
    print(lru_cache.get('key2'))

if __name__ == '__main__':
    main()