from datetime import datetime

#from google.appengine.ext import db

#class HealthVis(db.Model):
#    type = db.StringProperty(required=True)
#    title = db.StringProperty(required=True)
#    var_type = db.StringListProperty(required=True)
#    var_names = db.StringListProperty(required=True)
#    var_list = db.StringProperty(required=True)
#    d3params = db.TextProperty(required=True)
#    timestamp = db.DateTimeProperty(auto_now_add=True)
#    saved = db.BooleanProperty(default=False)

class Query(object):
    def __init__(self, store):
        self.store=store

class Key(object):
    def __init__(self, id):
        self.id = id

    def __call__(self):
        return self

    def id(self):
        return self.id


class HealthVis(object):
    store = {}
    next_key = 0


    def __init__(self, type, title, var_type, var_names, var_list, d3params, timestamp=datetime.now(), saved=False):
        self.type = type
        self.title = title
        self.var_type = var_type
        self.var_names = var_names
        self.var_list = var_list
        self.d3params = d3params
        self.timestamp = timestamp
        self.saved = saved

        self.key=HealthVis.get_next_key()

    def key(self):
        return self.key

    def put(self):
        HealthVis.store[self.key()] = self

    @classmethod
    def get_next_key(cls):
        curKey = cls.next_key
        cls.next_key += 1
        return curKey

    @classmethod
    def get_by_id(cls,id):
        return cls.store[id]

    @classmethod
    def all(cls):
        return Query(cls.store)