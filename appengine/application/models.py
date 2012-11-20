from google.appengine.ext import db

class HealthVis(db.Model):
    type = db.StringProperty(required=True)
    title = db.StringProperty(required=True)
    var_type = db.StringListProperty(required=True)
    var_names = db.StringListProperty(required=True)
    var_list = db.StringProperty(required=True)
    d3params = db.TextProperty(required=True)
    timestamp = db.DateTimeProperty(auto_now_add=True)
    saved = db.BooleanProperty(default=False)